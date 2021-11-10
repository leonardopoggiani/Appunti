package net.floodlightcontroller.unipi;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentSkipListSet;

import org.projectfloodlight.openflow.protocol.OFFlowAdd;
import org.projectfloodlight.openflow.protocol.OFFlowMod;
import org.projectfloodlight.openflow.protocol.OFMatchBmap;
import org.projectfloodlight.openflow.protocol.OFMessage;
import org.projectfloodlight.openflow.protocol.OFPacketIn;
import org.projectfloodlight.openflow.protocol.OFPacketOut;
import org.projectfloodlight.openflow.protocol.OFType;
import org.projectfloodlight.openflow.protocol.OFVersion;
import org.projectfloodlight.openflow.protocol.action.OFAction;
import org.projectfloodlight.openflow.protocol.action.OFActionOutput;
import org.projectfloodlight.openflow.protocol.action.OFActionSetDlDst;
import org.projectfloodlight.openflow.protocol.action.OFActionSetField;
import org.projectfloodlight.openflow.protocol.action.OFActions;
import org.projectfloodlight.openflow.protocol.match.Match;
import org.projectfloodlight.openflow.protocol.match.MatchField;
import org.projectfloodlight.openflow.protocol.oxm.OFOxms;
import org.projectfloodlight.openflow.types.EthType;
import org.projectfloodlight.openflow.types.IPv4Address;
import org.projectfloodlight.openflow.types.IpProtocol;
import org.projectfloodlight.openflow.types.MacAddress;
import org.projectfloodlight.openflow.types.OFBufferId;
import org.projectfloodlight.openflow.types.OFPort;
import org.projectfloodlight.openflow.types.U64;
import org.projectfloodlight.openflow.util.HexString;
import org.python.constantine.platform.darwin.IPProto;

import net.floodlightcontroller.core.FloodlightContext;
import net.floodlightcontroller.core.IFloodlightProviderService;
import net.floodlightcontroller.core.IOFMessageListener;
import net.floodlightcontroller.core.IOFSwitch;
import net.floodlightcontroller.core.module.FloodlightModuleContext;
import net.floodlightcontroller.core.module.FloodlightModuleException;
import net.floodlightcontroller.core.module.IFloodlightModule;
import net.floodlightcontroller.core.module.IFloodlightService;
import net.floodlightcontroller.packet.ARP;
import net.floodlightcontroller.packet.Ethernet;
import net.floodlightcontroller.packet.ICMP;
import net.floodlightcontroller.packet.IPacket;
import net.floodlightcontroller.packet.IPv4;
import net.floodlightcontroller.util.FlowModUtils;

public class LoadBalancer implements IOFMessageListener, IFloodlightModule {
	
	protected IFloodlightProviderService floodlightProvider; // Reference to the provider
	
	// IP and MAC address for our logical load balancer
	private final static IPv4Address LOAD_BALANCER_IP = IPv4Address.of("8.8.8.8");
	private final static MacAddress LOAD_BALANCER_MAC =  MacAddress.of("00:00:00:00:00:FE");
	
	// Rule timeouts
	private final static short IDLE_TIMEOUT = 10; // in seconds
	private final static short HARD_TIMEOUT = 20; // every 20 seconds drop the entry
	
	// Backend servers data
	
	final static String[] SERVERS_MAC = {
			"00:00:00:00:00:02",
			"00:00:00:00:00:03"
	};
		
	final static String[] SERVERS_IP = {
			"10.0.0.2",
			"10.0.0.3"
	};
		
	final static int[] SERVERS_PORT = {
			2,
			3
	};
	
	// Current Selected server
	static int last_server = 0;
	
	// Counter
	static int counter = 0;
	
	// Set of MacAddresses seen
	protected Set macAddresses;

	@Override
	public String getName() {
		return LoadBalancer.class.getSimpleName();
	}

	@Override
	public boolean isCallbackOrderingPrereq(OFType type, String name) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isCallbackOrderingPostreq(OFType type, String name) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public Collection<Class<? extends IFloodlightService>> getModuleServices() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Map<Class<? extends IFloodlightService>, IFloodlightService> getServiceImpls() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Class<? extends IFloodlightService>> getModuleDependencies() {
		Collection<Class<? extends IFloodlightService>> l = new ArrayList<Class<? extends IFloodlightService>>();
	    l.add(IFloodlightProviderService.class);
	    return l;
	}

	@Override
	public void init(FloodlightModuleContext context) throws FloodlightModuleException {
		// TODO Auto-generated method stub
		floodlightProvider = context.getServiceImpl(IFloodlightProviderService.class);
		
	    // Create an empty MacAddresses set
	    macAddresses = new ConcurrentSkipListSet<Long>();
	}

	@Override
	public void startUp(FloodlightModuleContext context) throws FloodlightModuleException {
		floodlightProvider.addOFMessageListener(OFType.PACKET_IN, this);
	}

	@Override
	public net.floodlightcontroller.core.IListener.Command receive(IOFSwitch sw, OFMessage msg,
			FloodlightContext cntx) {
			
			Ethernet eth = IFloodlightProviderService.bcStore.get(cntx,
                IFloodlightProviderService.CONTEXT_PI_PAYLOAD);
			
			IPacket pkt = eth.getPayload();

			// Print the source MAC address
			Long sourceMACHash = Ethernet.toLong(eth.getSourceMACAddress().getBytes());
			System.out.printf("MAC Address: {%s} seen on switch: {%s}\n",
			HexString.toHexString(sourceMACHash),
			sw.getId());
			
			// Cast to Packet-In
			OFPacketIn pi = (OFPacketIn) msg;

	        // Dissect Packet included in Packet-In
			if (eth.isBroadcast() || eth.isMulticast()) {
				if (pkt instanceof ARP) {
					
					System.out.printf("Processing ARP request\n");
					
					ARP arpRequest = (ARP) eth.getPayload();
					
					if( arpRequest.getTargetProtocolAddress().compareTo(LOAD_BALANCER_IP) == 0 ){
					
						// Process ARP request
						handleARPRequest(sw, pi, cntx);
						
						// Interrupt the chain
						return Command.STOP;
					}
				}
			} else {
				if (pkt instanceof IPv4) {
					
					System.out.printf("Processing IPv4 packet\n");
					
					IPv4 ip_pkt = (IPv4) pkt;
					
					
					handleIPPacket(sw, pi, cntx);
						
					// Interrupt the chain
					return Command.STOP;
				}
			}
			
			// Interrupt the chain
			return Command.CONTINUE;

	}
	
	private void handleARPRequest(IOFSwitch sw, OFPacketIn pi,
			FloodlightContext cntx) {

		// Double check that the payload is ARP
		Ethernet eth = IFloodlightProviderService.bcStore.get(cntx,
				IFloodlightProviderService.CONTEXT_PI_PAYLOAD);
		
		if (! (eth.getPayload() instanceof ARP))
			return;
		
		// Cast the ARP request
		ARP arpRequest = (ARP) eth.getPayload();
						
		// Generate ARP reply
		IPacket arpReply = new Ethernet()
			.setSourceMACAddress(LOAD_BALANCER_MAC)
			.setDestinationMACAddress(eth.getSourceMACAddress())
			.setEtherType(EthType.ARP)
			.setPriorityCode(eth.getPriorityCode())
			.setPayload(
				new ARP()
				.setHardwareType(ARP.HW_TYPE_ETHERNET)
				.setProtocolType(ARP.PROTO_TYPE_IP)
				.setHardwareAddressLength((byte) 6)
				.setProtocolAddressLength((byte) 4)
				.setOpCode(ARP.OP_REPLY)
				.setSenderHardwareAddress(LOAD_BALANCER_MAC) // Set my MAC address
				.setSenderProtocolAddress(LOAD_BALANCER_IP) // Set my IP address
				.setTargetHardwareAddress(arpRequest.getSenderHardwareAddress())
				.setTargetProtocolAddress(arpRequest.getSenderProtocolAddress()));
		
		// Create the Packet-Out and set basic data for it (buffer id and in port)
		OFPacketOut.Builder pob = sw.getOFFactory().buildPacketOut();
		pob.setBufferId(OFBufferId.NO_BUFFER);
		pob.setInPort(OFPort.ANY);
		
		// Create action -> send the packet back from the source port
		OFActionOutput.Builder actionBuilder = sw.getOFFactory().actions().buildOutput();
		OFPort inPort =  pi.getMatch().get(MatchField.IN_PORT);
        actionBuilder.setPort(inPort);  
		
		// Assign the action
		pob.setActions(Collections.singletonList((OFAction) actionBuilder.build()));
		
		// Set the ARP reply as packet data 
		byte[] packetData = arpReply.serialize();
		pob.setData(packetData);
		
		System.out.printf("Sending out ARP reply\n");
		
		sw.write(pob.build());
		
	}

	private void handleIPPacket(IOFSwitch sw, OFPacketIn pi,
			FloodlightContext cntx) {

		// Double check that the payload is IPv4
		Ethernet eth = IFloodlightProviderService.bcStore.get(cntx,
				IFloodlightProviderService.CONTEXT_PI_PAYLOAD);
		if (! (eth.getPayload() instanceof IPv4))
			return;
		
		// Cast the IP packet
		IPv4 ipv4 = (IPv4) eth.getPayload();
		
		// Change Server
		last_server = ( last_server + 1 ) % 2;

		// Create a flow table modification message to add a rule
		OFFlowAdd.Builder fmb = sw.getOFFactory().buildFlowAdd();
		
        fmb.setIdleTimeout(IDLE_TIMEOUT);
        fmb.setHardTimeout(HARD_TIMEOUT);
        fmb.setBufferId(OFBufferId.NO_BUFFER);
        fmb.setOutPort(OFPort.ANY);
        fmb.setCookie(U64.of(0));
        fmb.setPriority(FlowModUtils.PRIORITY_MAX);

        // Create the match structure  
        Match.Builder mb = sw.getOFFactory().buildMatch();
        mb.setExact(MatchField.ETH_TYPE, EthType.IPv4)
        .setExact(MatchField.IPV4_DST, LOAD_BALANCER_IP)
        .setExact(MatchField.ETH_DST, LOAD_BALANCER_MAC);
        
        OFActions actions = sw.getOFFactory().actions();
        // Create the actions (Change DST mac and IP addresses and set the out-port)
        ArrayList<OFAction> actionList = new ArrayList<OFAction>();
        
        OFOxms oxms = sw.getOFFactory().oxms();

        OFActionSetField setDlDst = actions.buildSetField()
        	    .setField(
        	        oxms.buildEthDst()
        	        .setValue(MacAddress.of(SERVERS_MAC[last_server]))
        	        .build()
        	    )
        	    .build();
        actionList.add(setDlDst);

        OFActionSetField setNwDst = actions.buildSetField()
        	    .setField(
        	        oxms.buildIpv4Dst()
        	        .setValue(IPv4Address.of(SERVERS_IP[last_server]))
        	        .build()
        	    ).build();
        actionList.add(setNwDst);
        
        OFActionOutput output = actions.buildOutput()
        	    .setMaxLen(0xFFffFFff)
        	    .setPort(OFPort.of(SERVERS_PORT[last_server]))
        	    .build();
        actionList.add(output);
        
        
        fmb.setActions(actionList);
        fmb.setMatch(mb.build());

        sw.write(fmb.build());
        
        // Reverse Rule to change the source address and mask the action of the controller
        
		// Create a flow table modification message to add a rule
		OFFlowAdd.Builder fmbRev = sw.getOFFactory().buildFlowAdd();
		
		fmbRev.setIdleTimeout(IDLE_TIMEOUT);
		fmbRev.setHardTimeout(HARD_TIMEOUT);
		fmbRev.setBufferId(OFBufferId.NO_BUFFER);
		fmbRev.setOutPort(OFPort.CONTROLLER);
		fmbRev.setCookie(U64.of(0));
		fmbRev.setPriority(FlowModUtils.PRIORITY_MAX);

        Match.Builder mbRev = sw.getOFFactory().buildMatch();
        mbRev.setExact(MatchField.ETH_TYPE, EthType.IPv4)
        .setExact(MatchField.IPV4_SRC, IPv4Address.of(SERVERS_IP[last_server]))
        .setExact(MatchField.ETH_SRC, MacAddress.of(SERVERS_MAC[last_server]));
        
        ArrayList<OFAction> actionListRev = new ArrayList<OFAction>();
        
        OFActionSetField setDlDstRev = actions.buildSetField()
        	    .setField(
        	        oxms.buildEthSrc()
        	        .setValue(LOAD_BALANCER_MAC)
        	        .build()
        	    )
        	    .build();
        actionListRev.add(setDlDstRev);

        OFActionSetField setNwDstRev = actions.buildSetField()
        	    .setField(
        	        oxms.buildIpv4Src()
        	        .setValue(LOAD_BALANCER_IP)
        	        .build()
        	    ).build();
        actionListRev.add(setNwDstRev);
        
        OFActionOutput outputRev = actions.buildOutput()
        	    .setMaxLen(0xFFffFFff)
        	    .setPort(OFPort.of(1))
        	    .build();
        actionListRev.add(outputRev);
        
        fmbRev.setActions(actionListRev);
        fmbRev.setMatch(mbRev.build());
        
        sw.write(fmbRev.build());

        // If we do not apply the same action to the packet we have received and we send it back the first packet will be lost
        
		// Create the Packet-Out and set basic data for it (buffer id and in port)
		OFPacketOut.Builder pob = sw.getOFFactory().buildPacketOut();
		pob.setBufferId(pi.getBufferId());
		pob.setInPort(OFPort.ANY);
		
		// Assign the action
		pob.setActions(actionList);
		
		// Packet might be buffered in the switch or encapsulated in Packet-In 
		// If the packet is encapsulated in Packet-In sent it back
		if (pi.getBufferId() == OFBufferId.NO_BUFFER) {
			// Packet-In buffer-id is none, the packet is encapsulated -> send it back
            byte[] packetData = pi.getData();
            pob.setData(packetData);
            
		} 
				
		sw.write(pob.build());
		
	}

}

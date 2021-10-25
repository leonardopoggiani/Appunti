---
title: Advanced networks
created: '2021-10-25T08:47:56.562Z'
modified: '2021-10-25T09:29:25.856Z'
---

# Advanced networks

## SDN

Inizialmente i protocolli erano pensati per recuperare e resistere a disastri della portata di bombardamenti o distruzione di molteplici device.

Come si puo' ridurre la necessita' di configurazione manuale? 
Protocolli complessi per distribuire informazioni tra router, necessita' di coordinazione e questo porta necessariamente a una maggiore latenza. 
*30-50 secondi di convergenza*

**Control plane** e **data plane**

*control plane*: dove vengono prese le decisioni del device (routing protocol) che vengono applicate nel *data plane*. Requirements: **flexibility** **find optimal solutions**
*data plane*: applica le decisioni prese dal control plane e si occupa del forwarding. Requirements: **speed**

Tutto questo e' implementato nello stesso device.

Inizialmente era tutto implementato in software, nel corso degli anni sono state aumentate il numero di cose implementate in hardware tutto portato principalmente dalla nascita dei datacenter.

Datacenter tradizionali organizzati in modo gerarchico, datacenter moderni organizzati in modo piatto ('flat') usando la virtualizzazione di tutte le risorse bare metal.

Nei datacenter moderni la maggior parte della comunicazione non e' *south-north* ovvero in arrivo o indirizzata all'esterno del datacenter, ma *east-west*, ovver localmente all'interno del datacenter.

Bisogni di un datacenter:

- automation -> ho milioni di host all'interno di un datacenter, non posso configurarli manualmente.
- scalability -> potenzialmente ho 20 milioni di host, non posso mandare messaggi broadcast o richieste ARP. Non posso immagazzinare milioni di MAC address, devo separare le reti e renderle scalabili.
- multi pathing -> aggiungere connessioni ridondanti tra i rack perche' posso ancora avere guasti ma anche dal punto di vista del load-balancing. 
- multi tenancy -> sullo stesso datacenter ho molti clienti (non end-users ma coloro che offrono servizi) che vogliono fornire servizi. I *tenants* che usano il datacenter vogliono sfruttarlo in maniera isolata e esclusiva sia per quanto riguarda la sicurezza che per le performance.

**SDN**: separare il *control plane* dal *data plane* dal punto di vista logico ma soprattutto **fisico**.
Il *control plane* viene spostato in un meccanismo separato e **centralizzato**, quindi i device mantengono solo l'operazione di forwarding che puo' essere effettuata molto efficientemente in hardware. 

Dispositivo centralizzato (**controller**) esegue un *network OS* che gestisce i dispositivi fisici in maniera centralizzata.
In questo caso non tutte le operazioni vengono svolte sullo stesso device. 
Devo scrivere nuovi algoritmi, nuovi protocolli non posso usare IS-IS, OSPF o BGP cosi' come sono.

Attraverso **SDN** rende i router dei dispositivi che si occupano semplicemente di *forwarding* (quindi praticamente degli switch) perche' del resto si occupera' il *controller*.





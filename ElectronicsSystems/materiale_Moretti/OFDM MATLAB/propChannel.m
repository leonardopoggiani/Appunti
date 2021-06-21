function [channel,meanExcessDelay,RMSDelaySpread] = propChannel(L,chan)

if chan == 1 
    % Gaussian channel
    channel = 1;
    meanExcessDelay = 0
    RMSDelaySpread = 0;

else 
    % multipath channel
    % L is number of taps of the channel
    delays = (0:L-1).';
    
    % channel power profile (normalized to 1)
    chanPower = exp(-delays/2)/sum(exp(-delays/2));
    
    %% Channel parameters
    % mean excess delay normalized to T
    meanExcessDelay = chanPower.'*delays;
    % RMS delay spread normalized to T
    RMSDelaySpread = sqrt(chanPower.'*((delays-meanExcessDelay).^2));
    
    %% Complex channel gains
    % Generate the complex channel gains
    channel = chanPower/2.*(randn(L,1)+1i*randn(L,1));
end
end
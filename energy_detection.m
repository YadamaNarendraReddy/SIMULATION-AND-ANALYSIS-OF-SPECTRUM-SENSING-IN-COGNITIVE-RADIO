
clc;
close all;
snrdb = -16:0.5:-4; 

%%
% We are using BPSK modulation for test.
M = 2;                  % modulation index for psk
bpsk = comm.PSKModulator('ModulationOrder',M,...
    'BitInput',false,...
    'PhaseOffset',0);   % M-psk modulator

%% 
% we are performing 1000 simulation in which a primary signal will be
% transmitted for each snr value. Number of times signal detected will be
% divide by 1000 to get the value of Pd.

nSample = input('enter the number of samples n: ');         % samples in signal
pde = zeros(1,numel(snrdb)); % array for Pd
L = numel(snrdb);

% Loop for SNR
bWait = waitbar(0,'please wait...');
for i = 1:L  % for all snr values
    d = 0;              % detection counter set to zeros
    % Loop for 1000 tests
    for j = 1:1000      % 1000 simulations
        infoSignal = randi(M,nSample,1)-1;  % random binary signal  (bits = log2(M))
        txSignal = step(bpsk,infoSignal);   % M-psk signal
        rxSignal = awgn(txSignal,snrdb(i)); % AWGN channel
        pf = 0.01;      % probabity of false detection
        snr = 10^(snrdb(i)/20);
        nvar = 1/snr;   % noise variance
        thresh = sqrt(2*nSample*nvar^4)*qfuncinv(pf)+nSample*nvar^2; % threshold value
        energy = sum(abs(rxSignal).^2);     % energy of signal
        if energy > thresh % if energy is greater than threshold then signal is present
            d = d+1;
        end
    end
    pde(i) = d/1000; % avg over 1000 simulation
    waitbar(i/L,bWait);
end
close(bWait);
%% 
% Plot result  (SNR Vs Pd)
figure()
plot(snrdb,pde,'b');
xlabel('SNR (dB)');
ylabel('P_d');
title('ROC curve for SNR vs probability of detection for pf=0.01');
grid on;

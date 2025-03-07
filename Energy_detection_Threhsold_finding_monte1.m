
clc
close all
clear all
L = 1000; % Number of samples to be taken
iter = input('enter the number of iterations: '); % Number of iterations
Pf = 0.01:0.01:1; % Probability of False Alarm
for tt = 1:length(Pf)
    
for kk=1:iter % Number of Monte Carlo Simulations

 n=(randn(1,L)+1i*randn(1,L))./(sqrt(2)); % Primary User Gaussian Signal

 y = n; % Received signal at the secondary user
 energy = abs(y).^2; % Energy of received signal over L samples
 energy_fin(kk) =(1/L).*sum(energy); % Test Statistic of the energy detection

end
 energy_desc = sort(energy_fin,'descend'); % Arrange values in descending order
 thresh(tt) = energy_desc(ceil(Pf(tt)*iter)); % Threshold obtained by simulations; the first 'Pf' fraction of values lie above the threshold
end
plot(thresh, Pf);
xlabel('thresold');
ylabel('pf');
grid on;
hold on;

%%
thresh1 = (qfuncinv(Pf)./sqrt(L))+ 1; % Theroretical value of threshold
plot(thresh1, Pf, 'r');
xlabel('thresold');
ylabel('pf');
title("calculate the threhsold in energy detection ");
grid on;
hold on;




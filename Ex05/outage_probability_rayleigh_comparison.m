close all;
clear all;


gamma_bar = linspace(1, 100, 1000);

% Outage com Rayleigh
PFR_RB1 = (2^1 - 1) ./ gamma_bar;
PFR_RB4 = (2^4 - 1) ./ gamma_bar;

figure;
loglog(gamma_bar, PFR_RB1);hold on;
loglog(gamma_bar, PFR_RB4);

grid on;

xlabel('Razão sinal ruído média');
ylabel('Probabilidade de outage');
title('Probabilidade de outage vs. SNR médio');
legend('R/B = 1', 'R/B = 4');

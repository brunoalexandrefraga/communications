gamma_bar = linspace(1, 100, 1000);

% Outage com Nakagami-m
PFNm1_RB2 = gammainc(1*(2^2 - 1) ./ gamma_bar, 1);
PFNm3_RB2 = gammainc(3*(2^2 - 1) ./ gamma_bar, 3);
PFNm6_RB2 = gammainc(6*(2^2 - 1) ./ gamma_bar, 6);


figure;
loglog(gamma_bar, PFNm1_RB2);hold on;
loglog(gamma_bar, PFNm3_RB2);
loglog(gamma_bar, PFNm6_RB2);

grid on;

xlabel('Razão sinal ruído média');
ylabel('Probabilidade de outage');
title('Probabilidade de outage vs. SNR médio');
legend('m = 1', 'm = 3', 'm = 6');

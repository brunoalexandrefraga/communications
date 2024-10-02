m = 9;
r = 6;
n = 4;


di_d0 = [1/2,1/2]; % Relaçoes de distância

% Verifica se a soma é diferente de 1
if sum(di_d0) ~= 1
    error('A soma da razão dos percursos é diferente de 1');
end

Lplus1 = length(di_d0);

gamma_bar = linspace(1, 100000, 1000000);


PFNm = zeros(Lplus1, length(gamma_bar));
PFR = zeros(Lplus1, length(gamma_bar));


for i = 1:Lplus1
    gamma_bar_i = gamma_bar * (1/di_d0(i))^n;
    
    % Outage com Nakagami-m
    PFNm(i,:) = gammainc(m*(2^(Lplus1*r) - 1) ./ gamma_bar_i, m);

    % Outage com Rayleigh
    PFR(i,:) = 1-exp(-(2^(Lplus1*r) - 1) ./ gamma_bar_i);
end

P_F_Nm = 1 - prod(1 - PFNm, 1);
P_F_R = 1 - prod(1 - PFR, 1);

figure;
loglog(gamma_bar, P_F_Nm(1,:));hold on;
loglog(gamma_bar, P_F_R(1,:));

grid on;

xlabel('Razão sinal ruído média');
ylabel('Probabilidade de outage');
title('Probabilidade de outage vs. SNR médio');
legend('Nakagami-m', 'Rayleigh');
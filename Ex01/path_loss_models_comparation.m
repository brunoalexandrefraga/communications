
Pt = 1*10^3;
f = 1800*10^6;
c = 3e8;
lambda = c/f;
Gt = 1;
Gr = 1;
L = 1;
d0 = 1e3;
n1 = 3;
n2 = 4;

d = linspace(1e3, 20e3, 100);

% Espaço livre
Pr_d0 = Pt * Gt * Gr * (lambda / (4 * pi * d0))^2 / L;
Pr_free = Pt * Gt * Gr * (lambda ./ (4 * pi * d)).^2 / L;


% Log-distância com espaço livre
Pr_log_distance_n1_free = Pr_d0 * (d0 ./ d).^n1;
Pr_log_distance_n2_free = Pr_d0 * (d0 ./ d).^n2;




% Hata estendido
a_hr = (1.1*log10(freq/1e6) - 0.7)*hr - (1.56*log10(freq/1e6) - 0.8); % Fator de correção para hr (em m)
L_hata = 46.3 + 33.9*log10(freq/1e6) - 13.82*log10(ht) - a_hr + (44.9 - 6.55*log10(ht))*log10(d/1e3); % Atenuação
Pr_hata = Pt ./ (10.^(L_hata / 10));



% Log-distância com hata estentido
L_hata_d0 = 46.3 + 33.9*log10(freq/1e6) - 13.82*log10(ht) - a_hr + (44.9 - 6.55*log10(ht))*log10(d0/1e3);
Pr_d0_hata = Pt / (10^(L_hata_d0 / 10));
Pr_log_distance_n1_hata = Pr_d0_hata * (d0 ./ d).^n1; % n = 3, Hata
Pr_log_distance_n2_hata = Pr_d0_hata * (d0 ./ d).^n2; % n = 4, Hata


figure;
loglog(d, Pr_free);hold on;
loglog(d, Pr_log_distance_n1_free);
loglog(d, Pr_log_distance_n2_free);
loglog(d, Pr_hata);
loglog(d, Pr_log_distance_n1_hata);
loglog(d, Pr_log_distance_n2_hata);

grid on;

xlabel('Distância (km)');
ylabel('Potência Recebida');
title('Potência Recebida vs. Distância');


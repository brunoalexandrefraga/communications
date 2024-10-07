close all;
clear all;

rand('state', 0); % Reinicializa sementes de geradores de números aleatórios
randn('state', 0);

bits = 1e6; % Número de bits transmitidos
M = 2; % BPSK, dois símbolos possíveis na modulação
b = rand(1, bits) > 0.5; % Gera 0s e 1s
x = 2*b - 1; % Gera símbolos com energia unitária (+1 ou -1)

N0 = 1; % Neste exemplo N0 é fixado em 1

EbN0dB = 0:2:20; % Valores de Eb/N0 em dB para o loop
ber_simulada = zeros(1, length(EbN0dB)); % Prealocação do vetor de BER simulada
ber_teorica = zeros(1, length(EbN0dB)); % Prealocação do vetor de BER teórica

for i = 1:length(EbN0dB)
    EbN0 = 10^(EbN0dB(i)/10); % Converte Eb/N0 de dB para linear
    Eb = EbN0 * N0; % Cálculo de Eb
    Es = Eb * log2(M); % Cálculo de Es

    % Coeficiente de desvanecimento Rayleigh (somente magnitude)
    h = sqrt(0.5) * (randn(1, bits).^2 + randn(1, bits).^2).^0.5;

    % Sinal com o desvanecimento aplicado
    y = h .* (sqrt(Es) * x) + randn(1, bits) * sqrt(N0/2); % y = h * sqrt(Es) * x + n

    % Decisor para BPSK com canal Rayleigh (somente magnitude)
    b_est = y > 0;

    % Cálculo da BER simulada
    erros = sum(b ~= b_est); % Contagem dos bits em erro
    ber_simulada(i) = erros / bits; % Cálculo da BER simulada

    % Cálculo da BER teórica para canal Rayleigh
    ber_teorica(i) = 0.5 * (1 - sqrt(EbN0 / (EbN0 + 1))); % Fórmula teórica para BER em canal Rayleigh
end

% Impressão dos resultados
fprintf('Eb/N0 (dB) | Simulado | Teórico\n');
for i = 1:length(EbN0dB)
    fprintf('%9.2f | %8.5g | %8.5g\n', EbN0dB(i), ber_simulada(i), ber_teorica(i));
end

% Gráfico
figure;
semilogy(EbN0dB, ber_simulada, 'bo-', 'LineWidth', 1.5);
hold on;
semilogy(EbN0dB, ber_teorica, 'r*-', 'LineWidth', 1.5);
xlabel('E_b/N_0 (dB)');
ylabel('BER');
legend('Simulada', 'Teórica');
grid on;
title('BER para BPSK no Canal Rayleigh');

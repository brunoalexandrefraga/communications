close all;
clear all;

rand('state', 0); % Reinicializa sementes de geradores de números aleatórios
randn('state', 0);

bits = 1e6; % Número de bits transmitidos
M = 2; % BPSK, dois símbolos possíveis na modulação.
b = rand(1, bits) > 0.5; % Gera 0s e 1s
x = 2*b-1; % Gera símbolos com energia unitária (note que os símbolos pertencem aos Reais)
N0 = 1; % Neste exemplo N0 é fixada em 1

EbN0dB = 0:2:20; % Variação de Eb/N0 em dB
ber_simulada = zeros(1, length(EbN0dB)); % Vetor para armazenar os valores da BER simulada
ber_teorica = zeros(1, length(EbN0dB)); % Vetor para armazenar os valores da BER teórica

m = 2; % Parâmetro do canal Nakagami-m

for i = 1:length(EbN0dB)
    EbN0 = 10^(EbN0dB(i)/10); % Converte dB para linear
    Eb = EbN0 * N0;
    Es = Eb * log2(M); % Energia do símbolo
    n = randn(1, bits) * sqrt(N0/2); % Ruído AWGN com variância N0/2

    % Geração do desvanecimento Nakagami-m
    % h = sqrt((1/m)* (chi1^2 + chi2^2)), onde chi1 e chi2 são variáveis gaussianas N(0, m).
    h = sqrt((randn(1, bits).^2 + randn(1, bits).^2) / 2);

    % Sinal recebido com desvanecimento e ruído
    y = h .* (sqrt(Es) * x) + n;

    % Decisor no receptor
    b_est = y > 0;
    erros = sum(b ~= b_est); % Contagem de erros de bit
    ber_simulada(i) = erros / bits; % Cálculo da BER simulada

    % Cálculo da BER teórica para Nakagami-m com m=2
    ber_teorica(i) = (1 / 2) * (1 - sqrt(EbN0 / (EbN0 + 2))); % Aproximação para m=2
end

% Exibe resultados
fprintf('Eb/N0 (dB) | Simulado | Teórico\n');
for i = 1:length(EbN0dB)
    fprintf('%10.1f | %9.5f | %9.5f\n', EbN0dB(i), ber_simulada(i), ber_teorica(i));
end

% Plotando resultados
semilogy(EbN0dB, ber_simulada, 'o-', 'LineWidth', 1.5);
hold on;
semilogy(EbN0dB, ber_teorica, 'r-', 'LineWidth', 1.5);
xlabel('Eb/N0 (dB)');
ylabel('BER');
legend('Simulado', 'Teórico');
title('BER para BPSK no Canal Nakagami-m (m=2)');
grid on;

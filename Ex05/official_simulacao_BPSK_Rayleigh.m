% BER para BPSK no canal Rayleigh

% Repare que não simulamos formas de onda. Simulamos um modelo discreto
%banda base, equivalente do sistema de comunicação digital banda passante, 
%onde dado que foi transmitido um bit 1 ou 0 geramos o sinal correspondente 
%na saída amostrada do filtro casado no receptor.

% A resposta ao impulso do filtro casado é considerada de energia unitária
% Os símbolos 'x' são gerados inicialmente como +1 e -1, com energia unitária.
% Neste exemplo N0 é mantido fixo e a amplitude dos símbolos é variada em função de Eb/N0. 
% Outra alternativa é manter a amplitude dos símbolos fixa e variar N0 em função de Eb/N0. 


close all;
clear all;

% Reinicializa sementes de geradores de números aleatórios
rand('state', 0);
randn('state', 0);

% Número de bits transmitidos
bits = 1e6;

% BPSK, dois símbolos possíveis na modulação.
M = 2;

% Gera 0s e 1s
b = rand(1, bits) > 0.5; 

% Gera símbolos com energia unitária (note que os símbolos pertencem aos Reais)
x = 2*b-1;

% Neste exemplo N0 é fixada em 1
N0 = 1;

% Ruído base com variancia N0/2. Geramos só a parte real, 
%pois BPSK tem símbolos reais (no modulador QAM usamos só o ramo que modula o coseno da portadora), 
%se fosse uma modulação com símbolos complexos, teríamos que gerar também uma parte imaginária do ruído, com variância N0/2
n = randn(1, bits) * sqrt(N0/2);

% Faixa de valores de Eb/N0 em dB
EbN0dB = 0:1:30;

ber_simulada_rayleigh = zeros(1, length(EbN0dB));
ber_teorica_rayleigh = zeros(1, length(EbN0dB));

for i = 1:length(EbN0dB)

    % Valor de Eb/N0 em linear
    EbN0 = 10^(EbN0dB(i)/10); 
    
    % Cálculo de Eb
    Eb = EbN0*N0; 
    
    % Cálculo de Es, a Energia de Símbolo
    Es = Eb*log2(M); 
    
    % Coeficiente de desvanecimento Rayleigh (somente magnitude)
    h = sqrt(0.5) * (randn(1, bits).^2 + randn(1, bits).^2).^0.5;

    % Saída amostrada do filtro casado no receptor, onde o sinal sqrt(Es)*x tem a energia média Es já que a energia inicial de x era 1.
    y = h .* sqrt(Es) .* x+n; 
    
    % Decisor no receptor, modulação BPSK. Se a saída do filtro casado for >1 decide por bit 1, caso contrário, decide por bit 0.
    b_est = y>0;
    
    % Contagem de erros de bit
    erros = sum(b~=b_est);
    
    %Cálculo da BER simulada
    ber_simulada_rayleigh(i) = erros/bits;
    
    %Cálculo da BER teórica
    ber_teorica_rayleigh(i) = 1/2 * (1 - sqrt(EbN0 / (EbN0 + 1))); % Goldsmith Eq. (6.57), p. 197

    %Pb=qfunc(sqrt(2*EbN0));


    fprintf('%d\t\t%g\t\t%g\n', EbN0dB(i), ber_simulada_rayleigh(i), ber_teorica_rayleigh(i));
end


% Plotando os resultados
semilogy(EbN0dB, ber_simulada_rayleigh, 'b-o', 'LineWidth', 2);
hold on;
semilogy(EbN0dB, ber_teorica_rayleigh, 'r-s', 'LineWidth', 2);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('BER');
legend('Simulação', 'Teórica');
title('BER para BPSK no Canal Rayleigh');
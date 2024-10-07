% BER para BPSK no canal AWGN

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

rand('state', 0); % Reinicializa sementes de geradores de números aleatórios
randn('state', 0);

bits = 1e6; % Número de bits transmitidos

M = 2; % BPSK, dois símbolos possíveis na modulação.

b = rand(1, bits) > 0.5; % Gera 0s e 1s

x = 2*b-1; % Gera símbolos com energia unitária (note que os símbolos pertencem aos Reais)

N0 = 1; % Neste exemplo N0 é fixada em 1

n = randn(1, bits) * sqrt(N0/2); % Ruído base com variancia N0/2. Geramos só a parte real, 
%pois BPSK tem símbolos reais (no modulador QAM usamos só o ramo que modula o coseno da portadora), 
%se fosse uma modulação com símbolos complexos, teríamos que gerar também uma parte imaginária do ruído, com variância N0/2


EbN0dB = 0:1:20; % Faixa de valores de Eb/N0 em dB



ber_simulada = zeros(1, length(EbN0dB));
ber_teorica = zeros(1, length(EbN0dB));

for i = 1:length(EbN0dB)
    EbN0 = 10^(EbN0dB(i)/10); % Valor de Eb/N0 em linear
    
    Eb = EbN0*N0; % Cálculo de Eb
    
    Es = Eb*log2(M); %Cálculo de Es, a Energia de Símbolo
    
    y = sqrt(Es)*x+n; %Saída amostrada do filtro casado no receptor, onde o sinal sqrt(Es)*x tem a energia média Es já que a energia inicial de x era 1.
    
    b_est = y>0; %Decisor no receptor, modulação BPSK. Se a saída do filtro casado for >1 decide por bit 1, caso contrário, decide por bit 0.
    
    erros = sum(b~=b_est); %Contagem de erros de bit
    
    %Cálculo da BER simulada
    ber_simulada(i) = erros/bits;
    
    %Cálculo da BER teórica
    ber_teorica(i) = 0.5*erfc(sqrt(EbN0));
    %Pb=qfunc(sqrt(2*EbN0));


    fprintf('%d\t\t%g\t\t%g\n', EbN0dB(i), ber_simulada(i), ber_teorica(i));
end

%fprintf('Simulado: %g | Teórico: %g\n', ber, Pb) %Impressão do resultado na tela


% Plotando os resultados
semilogy(EbN0dB, ber_simulada, 'b-o', 'LineWidth', 2);
hold on;
semilogy(EbN0dB, ber_teorica, 'r-s', 'LineWidth', 2);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('BER');
legend('Simulação', 'Teórica');
title('BER para BPSK no Canal Rayleigh');

% Agora transforme este exemplo em um script que calcula a BER simulada e a
%BER teórica para diferentes valores de Eb/N0 e gere um gráfico com o 
%resultado. Faça isso para o canal AWGN e o canal Rayleigh (opcionalmente para o Nakagami-m também).

% Ainda opcionalmente, estenda para uma modulação M-ária, complexa, como QPSK ou 16-QAM.


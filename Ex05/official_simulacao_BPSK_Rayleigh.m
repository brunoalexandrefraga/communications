% BER para BPSK no canal Rayleigh

% Repare que n�o simulamos formas de onda. Simulamos um modelo discreto
%banda base, equivalente do sistema de comunica��o digital banda passante, 
%onde dado que foi transmitido um bit 1 ou 0 geramos o sinal correspondente 
%na sa�da amostrada do filtro casado no receptor.

% A resposta ao impulso do filtro casado � considerada de energia unit�ria
% Os s�mbolos 'x' s�o gerados inicialmente como +1 e -1, com energia unit�ria.
% Neste exemplo N0 � mantido fixo e a amplitude dos s�mbolos � variada em fun��o de Eb/N0. 
% Outra alternativa � manter a amplitude dos s�mbolos fixa e variar N0 em fun��o de Eb/N0. 


close all;
clear all;

% Reinicializa sementes de geradores de n�meros aleat�rios
rand('state', 0);
randn('state', 0);

% N�mero de bits transmitidos
bits = 1e6;

% BPSK, dois s�mbolos poss�veis na modula��o.
M = 2;

% Gera 0s e 1s
b = rand(1, bits) > 0.5; 

% Gera s�mbolos com energia unit�ria (note que os s�mbolos pertencem aos Reais)
x = 2*b-1;

% Neste exemplo N0 � fixada em 1
N0 = 1;

% Ru�do base com variancia N0/2. Geramos s� a parte real, 
%pois BPSK tem s�mbolos reais (no modulador QAM usamos s� o ramo que modula o coseno da portadora), 
%se fosse uma modula��o com s�mbolos complexos, ter�amos que gerar tamb�m uma parte imagin�ria do ru�do, com vari�ncia N0/2
n = randn(1, bits) * sqrt(N0/2);

% Faixa de valores de Eb/N0 em dB
EbN0dB = 0:1:30;

ber_simulada_rayleigh = zeros(1, length(EbN0dB));
ber_teorica_rayleigh = zeros(1, length(EbN0dB));

for i = 1:length(EbN0dB)

    % Valor de Eb/N0 em linear
    EbN0 = 10^(EbN0dB(i)/10); 
    
    % C�lculo de Eb
    Eb = EbN0*N0; 
    
    % C�lculo de Es, a Energia de S�mbolo
    Es = Eb*log2(M); 
    
    % Coeficiente de desvanecimento Rayleigh (somente magnitude)
    h = sqrt(0.5) * (randn(1, bits).^2 + randn(1, bits).^2).^0.5;

    % Sa�da amostrada do filtro casado no receptor, onde o sinal sqrt(Es)*x tem a energia m�dia Es j� que a energia inicial de x era 1.
    y = h .* sqrt(Es) .* x+n; 
    
    % Decisor no receptor, modula��o BPSK. Se a sa�da do filtro casado for >1 decide por bit 1, caso contr�rio, decide por bit 0.
    b_est = y>0;
    
    % Contagem de erros de bit
    erros = sum(b~=b_est);
    
    %C�lculo da BER simulada
    ber_simulada_rayleigh(i) = erros/bits;
    
    %C�lculo da BER te�rica
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
legend('Simula��o', 'Te�rica');
title('BER para BPSK no Canal Rayleigh');
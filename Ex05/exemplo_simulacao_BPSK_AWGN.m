% BER para BPSK no canal AWGN

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

rand('state', 0); % Reinicializa sementes de geradores de n�meros aleat�rios
randn('state', 0);

bits = 1e6; % N�mero de bits transmitidos

M = 2; % BPSK, dois s�mbolos poss�veis na modula��o.

b = rand(1, bits) > 0.5; % Gera 0s e 1s

x = 2*b-1; % Gera s�mbolos com energia unit�ria (note que os s�mbolos pertencem aos Reais)

N0 = 1; % Neste exemplo N0 � fixada em 1

n = randn(1, bits) * sqrt(N0/2); % Ru�do base com variancia N0/2. Geramos s� a parte real, 
%pois BPSK tem s�mbolos reais (no modulador QAM usamos s� o ramo que modula o coseno da portadora), 
%se fosse uma modula��o com s�mbolos complexos, ter�amos que gerar tamb�m uma parte imagin�ria do ru�do, com vari�ncia N0/2


EbN0dB = 0:1:20; % Faixa de valores de Eb/N0 em dB



ber_simulada = zeros(1, length(EbN0dB));
ber_teorica = zeros(1, length(EbN0dB));

for i = 1:length(EbN0dB)
    EbN0 = 10^(EbN0dB(i)/10); % Valor de Eb/N0 em linear
    
    Eb = EbN0*N0; % C�lculo de Eb
    
    Es = Eb*log2(M); %C�lculo de Es, a Energia de S�mbolo
    
    y = sqrt(Es)*x+n; %Sa�da amostrada do filtro casado no receptor, onde o sinal sqrt(Es)*x tem a energia m�dia Es j� que a energia inicial de x era 1.
    
    b_est = y>0; %Decisor no receptor, modula��o BPSK. Se a sa�da do filtro casado for >1 decide por bit 1, caso contr�rio, decide por bit 0.
    
    erros = sum(b~=b_est); %Contagem de erros de bit
    
    %C�lculo da BER simulada
    ber_simulada(i) = erros/bits;
    
    %C�lculo da BER te�rica
    ber_teorica(i) = 0.5*erfc(sqrt(EbN0));
    %Pb=qfunc(sqrt(2*EbN0));


    fprintf('%d\t\t%g\t\t%g\n', EbN0dB(i), ber_simulada(i), ber_teorica(i));
end

%fprintf('Simulado: %g | Te�rico: %g\n', ber, Pb) %Impress�o do resultado na tela


% Plotando os resultados
semilogy(EbN0dB, ber_simulada, 'b-o', 'LineWidth', 2);
hold on;
semilogy(EbN0dB, ber_teorica, 'r-s', 'LineWidth', 2);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('BER');
legend('Simula��o', 'Te�rica');
title('BER para BPSK no Canal Rayleigh');

% Agora transforme este exemplo em um script que calcula a BER simulada e a
%BER te�rica para diferentes valores de Eb/N0 e gere um gr�fico com o 
%resultado. Fa�a isso para o canal AWGN e o canal Rayleigh (opcionalmente para o Nakagami-m tamb�m).

% Ainda opcionalmente, estenda para uma modula��o M-�ria, complexa, como QPSK ou 16-QAM.


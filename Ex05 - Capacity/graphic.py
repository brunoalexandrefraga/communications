import numpy as np
import matplotlib.pyplot as plt
from scipy.special import gammainc

# Parâmetros
m = 1
r = 6
n = 4

di_d0 = np.array([1/2, 1/2])  # Relações de distância

# Verifica se a soma é diferente de 1
if np.sum(di_d0) != 1:
    raise ValueError('A soma da razão dos percursos é diferente de 1')

Lplus1 = len(di_d0)

gamma_bar = np.linspace(1, 10000, 1000000)

PFNm = np.zeros((Lplus1, len(gamma_bar)))
PFR = np.zeros((Lplus1, len(gamma_bar)))

for i in range(Lplus1):
    gamma_bar_i = gamma_bar * (1 / di_d0[i]) ** n
    
    # Outage com Nakagami-m
    PFNm[i, :] = gammainc(m * (1 ** (Lplus1 * r) - 1) / gamma_bar_i, m)

    # Outage com Rayleigh
    PFR[i, :] = 1 - np.exp(-(2 ** (Lplus1 * r) - 1) / gamma_bar_i)

P_F_Nm = 1 - np.prod(1 - PFNm, axis=0)
P_F_R = 1 - np.prod(1 - PFR, axis=0)

# Plot
plt.figure()
plt.loglog(gamma_bar, P_F_Nm, label='Nakagami-m')
plt.loglog(gamma_bar, P_F_R, label='Rayleigh')

plt.grid(True)
plt.xlabel('Razão sinal ruído média')
plt.ylabel('Probabilidade de outage')
plt.title('Probabilidade de outage vs. SNR médio')
plt.legend()
plt.show()

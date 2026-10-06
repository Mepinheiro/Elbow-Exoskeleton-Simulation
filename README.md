# Desenvolvimento, Controle e Simulação de um Exoesqueleto Robótico para Membros Superiores com Elo Elástico em Série e Controle H∞

Repositório público associado ao projeto de pesquisa “Desenvolvimento, Controle e Simulação de um Exoesqueleto Robótico para Membros Superiores com Elo Elástico em série e Controle H∞”, financiado pela Fundação de Amparo à Pesquisa do Estado de São Paulo (FAPESP), processo 2024/09583-3.
O projeto aborda o desenvolvimento e a simulação de um exoesqueleto robótico de 1 grau de liberdade para reabilitação do movimento de flexão-extensão do cotovelo, considerando a utilização de um elo elástico em série e estratégias de controle baseadas em controle H∞.
Este repositório disponibiliza os códigos MATLAB utilizados no projeto, os controladores desenvolvidos, dados necessários para as simulações, resultados obtidos numericamente e o modelo CAD do protótipo.

# Objetivos
Os principais objetivos do projeto são:
- desenvolver um modelo dinâmico de um exoesqueleto para reabilitação do cotovelo;
- incorporar um elemento elástico em série entre o atuador e o elo de saída;
- desenvolver estratégias de controle robusto baseadas em H∞;
- avaliar o comportamento do sistema considerando diferentes estratégias de controle;
- analisar o desempenho de rastreamento de trajetória, sensibilidade e impedância;
- desenvolver e avaliar um protótipo físico do sistema.

# Sistema desenvolvido
O sistema considerado possui um grau de liberdade associado ao movimento de flexão-extensão do cotovelo.
O modelo considera a dinâmica do atuador, o elo elástico e a interação com o membro superior. O atuador utilizado como referência no projeto é o CubeMars AK45-36, com redução de 36:1.
O elemento elástico é representado por uma rigidez equivalente Ks, permitindo modelar a diferença entre a posição do motor e a posição do elo de saída.
A estrutura básica do modelo pode ser representada como:

```text
Referência
    │
    ▼
Controlador
    │
    ▼
Atuador ─── Elo Elástico ─── Membro superior
    │                           │
    └──────── realimentação ────┘
```
# Estratégias de controle
Foram consideradas quatro configurações principais de controle:
1. PD não robusto
2. K1
3. K1 + K2
4. K1 + K2 + K3

Os controladores K1, K2 e K3 foram obtidos por meio de síntese H∞.
De forma geral:

- K1: associado ao controle de sensibilidade e robustez do sistema;
- K2: associado ao controle da impedância;
- K3: associado ao rastreamento da trajetória.
- 
Os controladores são disponibilizados nos arquivos:

```text
controllers/
├── controladores.mat
└── controladores_discretos.mat
```
O arquivo controladores_discretos.mat contém as versões discretizadas dos controladores utilizadas diretamente nas simulações.

Nota: o procedimento original utilizado para gerar as versões discretas foi fornecido no contexto do projeto juntamente com os arquivos dos controladores. O presente repositório disponibiliza os arquivos utilizados nas simulações, sem reproduzir uma etapa de discretização que não faça parte dos scripts disponibilizados.

# Estrutura do repositório
```text
├── code/
│   ├── simulation/
│   └── control_design/
│
├── controllers/
│
├── results/
│
├── prototype/
│
└── figures/
```
(COLOCAR ARQUIVO - code/simulation/)

Contém os scripts utilizados para configuração, execução e visualização das simulações.

| Arquivo | Descrição |
|---|---|
| `interface_elbow.m` | Interface gráfica para configuração da simulação |
| `main_elbow.m` | Rotina principal de simulação |
| `elbow_model.m` | Modelo dinâmico do sistema |
| `modelParameters_elbow.m` | Parâmetros mecânicos e do atuador |
| `anim_elbow_init.m` | Inicialização da animação do movimento |
| `anim_elbow_meio.m` | Atualização da animação durante a simulação |

(COLOCAR ARQUIVO - code/control_design/)
Contém os scripts relacionados à modelagem utilizada na síntese e ao projeto dos controladores H∞.

| Arquivo | Descrição |
|---|---|
| `modelo_simulacao_G1_G2.m` | Construção dos modelos equivalentes utilizados na síntese |
| `proj_hinf.m` | Projeto dos controladores H∞ K1, K2 e K3 |

(COLOCAR ARQUIVO - controllers/)
Contém os arquivos .mat com os controladores utilizados no projeto.
- controladores.mat
- controladores_discretos.mat

(COLOCAR ARQUIVO - results/)
Contém os resultados das simulações numéricas realizadas para comparação das estratégias de controle.
As principais comparações consideradas são:
- PD × K1
- PD × K1 com incertezas
- K1 × K1+K2
- K1+K2 × K1+K2+K3

Esses arquivos correspondem a resultados de simulação numérica, não a dados experimentais.

(COLOCAR ARQUIVO - prototype/)
Contém o modelo CAD do protótipo desenvolvido.
- modelo_prototipo.step

O arquivo está no formato STEP e foi exportado a partir do modelo CAD desenvolvido no projeto.

(COLOCAR ARQUIVO - figures/)
Contém figuras utilizadas para documentação do projeto, incluindo registros do protótipo físico.


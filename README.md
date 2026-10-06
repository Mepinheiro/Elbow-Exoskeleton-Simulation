# Desenvolvimento, Controle e Simulação de um Exoesqueleto Robótico para Membros Superiores com Elo Elástico em Série e Controle H∞

Repositório associado ao projeto de pesquisa “Desenvolvimento, Controle e Simulação de um Exoesqueleto Robótico para Membros Superiores com Elo Elástico em série e Controle H∞”, financiado pela Fundação de Amparo à Pesquisa do Estado de São Paulo (FAPESP), processo 2024/09583-3.
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
O arquivo controladores_discretos.mat contém os controladores discretos utilizados nas simulações. 

O procedimento original de discretização não está disponível neste repositório; portanto, essa etapa não é reproduzida aqui.

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

# Modelo matemático
O modelo dinâmico utilizado nas simulações considera quatro estados:

$$
x =
\begin{bmatrix}
q_m & \dot{q}_m & q_l & \dot{q}_l
\end{bmatrix}^{T}
$$

onde:
- $q_m$ — posição angular do motor;
- $dq_m$ — velocidade angular do motor;
- $q_l$ — posição angular do elo de saída;
- $dq_l$ — velocidade angular do elo de saída.

A dinâmica do sistema considera a inércia do motor refletida pela transmissão, o amortecimento, a rigidez do elo elástico e o torque associado ao membro superior. O modelo também considera a dinâmica equivalente utilizada no projeto dos controladores H∞.

# Modelo utilizado na síntese H∞
O arquivo modelo_simulacao_G1_G2.m constrói duas representações da dinâmica:

- G1: dinâmica principal do atuador;
- G2: efeito associado ao elo elástico em série.

Esses modelos são combinados para formar a representação da planta utilizada no projeto dos controladores.

A síntese dos controladores é realizada no arquivo:
(COLOCAR ARQUIVO - code/control_design/proj_hinf.m)

Nesse processo são obtidos os controladores K1, K2 e K3.

# Execução
- Requisitos
- 
Para executar os scripts, recomenda-se utilizar:
- MATLAB;
- ferramentas MATLAB necessárias para modelagem e controle;
- arquivos .mat disponibilizados neste repositório.

Os scripts utilizam funções relacionadas à modelagem em espaço de estados, funções de transferência e síntese de controle H∞.
  
# Simulação
Para executar uma simulação utilizando a interface gráfica:
- interface_elbow
  
A interface permite configurar parâmetros do paciente, parâmetros do robô e selecionar a estratégia de controle.
As opções disponíveis são:
- PD (Non-robust)
- K1
- K1+K2
- K1+K2+K3

  A simulação é executada pela rotina main_elbow.m.

# Referência de trajetória
As simulações utilizam uma trajetória de referência variável no tempo para avaliar o desempenho de rastreamento do sistema.
A referência é construída a partir de um sinal chirp com offset angular, permitindo avaliar o comportamento do controlador em diferentes frequências.

# Métricas de desempenho
  Durante as simulações são calculadas métricas para avaliação do desempenho do sistema, incluindo:
  - erro RMS de rastreamento;
  - erro máximo de rastreamento;
  - torque máximo do atuador.
Essas métricas permitem comparar quantitativamente as diferentes estratégias de controle.

# Resultados
  
Os resultados disponibilizados neste repositório correspondem às simulações realizadas durante o desenvolvimento do projeto.

As principais análises incluem:

- PD × K1
Comparação entre o controlador PD convencional e o controlador robusto K1.

- PD × K1 com incertezas
Avaliação do comportamento dos controladores considerando incertezas nos parâmetros do sistema.

- K1 × K1+K2
Avaliação da inclusão do controlador associado ao controle de impedância.

- K1+K2 × K1+K2+K3
Avaliação da inclusão do controlador associado ao rastreamento da trajetória.

As figuras e arquivos de resultados correspondentes podem ser encontrados no diretório:

(COLOCAR ARQUIVO - results/)

# Protótipo
O projeto também contempla o desenvolvimento de um protótipo físico do exoesqueleto.
O modelo CAD disponibilizado em prototype/ permite visualizar a geometria do sistema desenvolvido.
Fotos do protótipo podem ser encontradas em:

(COLOCAR ARQUIVO - results/)figures/prototype/

# Reprodução das simulações

Para reproduzir as simulações principais:
1. Clone ou faça o download deste repositório.
2. Abra o MATLAB.
3. Adicione o diretório do projeto ao MATLAB path.
4. Certifique-se de que os arquivos da pasta controllers/ estejam disponíveis.
5. Execute:
interface_elbow
6. Selecione os parâmetros desejados.
7. Selecione o controlador.
8. Execute a simulação.

Para realizar novamente a síntese dos controladores H∞, utilize:
proj_hinf

O procedimento de síntese gera os controladores contínuos utilizados no projeto.

 # Organização dos arquivos
 ```text
elbow-exoskeleton-hinf/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── code/
│   ├── simulation/
│   │   ├── interface_elbow.m
│   │   ├── main_elbow.m
│   │   ├── elbow_model.m
│   │   ├── modelParameters_elbow.m
│   │   ├── anim_elbow_init.m
│   │   └── anim_elbow_meio.m
│   │
│   └── control_design/
│       ├── modelo_simulacao_G1_G2.m
│       └── proj_hinf.m
│
├── controllers/
│   ├── controladores.mat
│   └── controladores_discretos.mat
│
├── results/
│   ├── PD_vs_K1/
│   ├── PD_vs_K1_uncertainty/
│   ├── K1_vs_K1K2/
│   └── K1K2_vs_K1K2K3/
│
├── prototype/
│   └── modelo_prototipo.step
│
└── figures/
    └── prototype/
 ```
 # Financiamento
 Este trabalho foi desenvolvido com apoio da Fundação de Amparo à Pesquisa do Estado de São Paulo (FAPESP), por meio do processo: FAPESP 2024/09583-3

 # Como citar
Caso este repositório ou os materiais disponibilizados sejam utilizados em trabalhos acadêmicos, recomenda-se citar o projeto de pesquisa e o respectivo repositório.
 
Projeto:
Desenvolvimento, Controle e Simulação de um Exoesqueleto Robótico para Membros Superiores com Elo Elástico em série e Controle H∞.
FAPESP: Processo 2024/09583-3.

Licença
Consulte o arquivo LICENSE para informações sobre as condições de uso e redistribuição dos materiais disponibilizados neste repositório.
 

  
  

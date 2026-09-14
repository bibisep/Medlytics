<div align="center">

<img src="assets/medlytics%20logo.jpeg" width="420" alt="Medlytics Logo">

<br>

# 🏥 MEDLYTICS

### Painel Inteligente de Acesso Hospitalar e Perfil de Atendimento

**Transformando dados de saúde em informação para apoiar decisões.**

<br>

![FIAP](https://img.shields.io/badge/FIAP-Data%20Science-ED145B?style=for-the-badge)
![Oracle](https://img.shields.io/badge/Oracle-Autonomous%20AI%20Database-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Analytics-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-Data%20Engineering-3776AB?style=for-the-badge&logo=python&logoColor=white)

<br>

**Challenge Oracle + FIAP | Data Science | 2026**

</div>

---

## 📌 Sobre o projeto

O **Medlytics** é uma solução de inteligência de dados desenvolvida para apoiar a análise da estrutura hospitalar e do perfil de atendimento do Sistema Único de Saúde (SUS).

O projeto integra diferentes fontes de dados da área da saúde, realiza o tratamento e a organização dessas informações por meio de um pipeline de dados e disponibiliza indicadores em dashboards interativos.

A solução permite analisar aspectos como distribuição de estabelecimentos, leitos, estrutura de UTIs, internações, diagnósticos, CIDs e diferenças estruturais entre regiões.

> **Dados dispersos → Dados tratados → Informação → Análise → Apoio à decisão**

---

# 🎯 O Problema

O sistema público de saúde gera grandes volumes de dados provenientes de diferentes fontes e sistemas.

Quando essas informações permanecem distribuídas entre bases distintas, a análise integrada da infraestrutura hospitalar e do perfil de atendimento se torna mais complexa.

O Medlytics busca reduzir essa fragmentação por meio de uma solução capaz de consolidar, tratar e transformar esses dados em informações analíticas.

Entre os principais pontos analisados estão:

- distribuição de estabelecimentos hospitalares;
- quantidade de leitos existentes;
- quantidade de leitos destinados ao SUS;
- estrutura de leitos de UTI;
- diferenças estruturais entre municípios e regiões;
- volume de internações;
- principais diagnósticos e CIDs;
- governança e rastreabilidade dos dados.

---

# 💡 A Solução

O Medlytics foi estruturado em diferentes componentes que trabalham em conjunto durante o ciclo dos dados.

| Componente | Função |
|---|---|
| 🗃️ **Fontes de Dados** | Dados hospitalares, estruturais e de internações |
| ⚙️ **Engenharia de Dados** | Ingestão, tratamento e transformação |
| 🥉🥈🥇 **Medallion Architecture** | Organização em Bronze, Silver e Gold |
| 🌬️ **Apache Airflow** | Orquestração do pipeline |
| 🐳 **Docker** | Execução e isolamento do ambiente Airflow |
| 🗄️ **Oracle** | Armazenamento e consultas aos dados |
| 📊 **Power BI** | Dashboards e indicadores |
| 🤖 **Aly** | Interação com dados em linguagem natural |
| 🛡️ **Governança** | Qualidade, ética, segurança e rastreabilidade |

---

# 🏗️ Arquitetura

<div align="center">

<img src="assets/arquitetura.png" width="100%" alt="Arquitetura da solução Medlytics">

</div>

---

# 🔄 Pipeline de Dados

O pipeline do Medlytics foi desenvolvido para organizar o processamento dos dados desde sua forma bruta até a disponibilização para análises.

A estrutura segue o conceito de **Medallion Architecture**, dividindo o processamento em três camadas.

### 🥉 Bronze

A camada **Bronze** preserva os dados próximos ao formato original da fonte.

Nela são armazenados os dados brutos antes da aplicação das principais transformações.

### 🥈 Silver

A camada **Silver** contém os dados após processos de limpeza e preparação.

Entre os tratamentos realizados estão:

- padronização;
- conversão de tipos;
- tratamento de dados;
- validação dos registros;
- preparação dos atributos;
- criação de informações necessárias às análises.

### 🥇 Gold

A camada **Gold** contém os dados preparados para consumo analítico.

Essa camada é utilizada como uma das bases para os indicadores e visualizações desenvolvidos no projeto.

Entre os atributos analíticos preparados durante o processamento estão informações relacionadas a:

- estabelecimentos;
- municípios;
- regiões;
- leitos existentes;
- leitos SUS;
- UTIs;
- percentual de leitos SUS;
- presença de estrutura de UTI.

---

# 🌬️ Apache Airflow

O **Apache Airflow** foi utilizado para orquestrar o pipeline de dados do Medlytics.

A DAG desenvolvida no projeto organiza as etapas de processamento e permite acompanhar a execução das tarefas responsáveis pela transformação dos dados.

O ambiente do Airflow foi executado com **Docker**, permitindo organizar os serviços necessários para execução do pipeline em containers.

A implementação utilizada no projeto pode ser encontrada em:

```text
medlytics-airflow/
    ├── dags/
    │   └── medlytics_pipeline.py
    └── docker-compose.yaml
```

---

# 🗃️ Fontes de Dados

## 🏥 CNES

O **Cadastro Nacional de Estabelecimentos de Saúde (CNES)** fornece informações relacionadas à infraestrutura dos estabelecimentos de saúde.

No Medlytics são utilizados atributos relacionados a:

- estabelecimentos;
- municípios;
- regiões;
- tipo de gestão;
- leitos existentes;
- leitos SUS;
- UTIs;
- características dos estabelecimentos.

## 📋 SIH/SUS

O **Sistema de Informações Hospitalares do SUS (SIH/SUS)** compõe a frente de análise das internações hospitalares.

Esses dados permitem explorar informações relacionadas a:

- internações;
- diagnósticos;
- doenças;
- códigos CID;
- distribuição regional;
- indicadores relacionados às internações.

## 🗺️ Dados geográficos

O projeto também utiliza dados geográficos para construção das análises territoriais, incluindo as **Regiões Administrativas do Estado de São Paulo**.

Esses dados permitem relacionar municípios às respectivas regiões e construir as visualizações geográficas utilizadas no Power BI.

---

# 🗄️ Oracle Autonomous AI Database

O **Oracle Autonomous AI Database** faz parte da arquitetura de dados do Medlytics.

O ambiente Oracle foi utilizado para estruturar e trabalhar com dados relacionados ao projeto, incluindo tabelas hospitalares e consultas SQL.

O repositório também disponibiliza os **scripts DDL e DML** utilizados para representar a estrutura das tabelas.

```text
database/
└── sql/
    └── ddl/
    └── dml/
```

---

# ✨ Oracle Select AI

O projeto também explorou recursos do **Oracle Select AI**, permitindo trabalhar com consultas em linguagem natural sobre informações armazenadas no ambiente Oracle.

Os scripts relacionados ao Select AI utilizados durante o desenvolvimento estão disponíveis em:

```text
database/
    └── select-ai/
```

Essa frente representa uma das possibilidades de evolução da interação inteligente com os dados dentro da arquitetura do Medlytics.

---

# 📊 Power BI

O **Power BI** representa a camada de visualização e análise do Medlytics.

O dashboard foi desenvolvido seguindo a identidade visual do projeto e reúne indicadores, mapas, rankings, filtros e análises relacionadas à estrutura hospitalar e às internações.

### Principais análises

- 🏥 estabelecimentos hospitalares;
- 🛏️ leitos existentes;
- 💚 leitos destinados ao SUS;
- 🚑 estrutura de UTIs;
- 🗺️ distribuição regional;
- ⚠️ risco estrutural relativo;
- 🦠 internações por doença;
- 🧬 análises por CID;
- 📍 comparações entre regiões e municípios.

O arquivo final do projeto está disponível no diretório:

```text
power-bi/
└── Medlytics_bifinal.pbix
```

---

# 📈 Dashboard Geral

O **Dashboard Geral** oferece uma visão consolidada dos principais indicadores analisados pelo Medlytics.

A página reúne informações sobre a infraestrutura hospitalar e permite visualizar rapidamente indicadores relacionados a estabelecimentos, leitos SUS e estrutura de UTI.

Também são apresentadas análises relacionadas ao risco estrutural regional e ao volume de internações por doença.

---

# 🗺️ Mapa de Risco Estrutural

O mapa permite comparar a estrutura hospitalar entre as diferentes **Regiões Administrativas do Estado de São Paulo**.

A classificação utiliza três níveis visuais:

🔴 **Crítico**

🟠 **Atenção**

🟢 **Estável**

O indicador representa uma **classificação estrutural relativa**, construída a partir dos dados disponíveis no projeto.

Ele não representa risco clínico ou disponibilidade hospitalar em tempo real.

---

# 🧬 Internações por CID

A área de internações permite analisar o perfil dos diagnósticos presentes nos dados utilizados pelo projeto.

Entre as informações analisadas estão:

- total de internações;
- principais doenças;
- códigos CID;
- distribuição por região;
- variação dos indicadores disponíveis na base.

---

# 🤖 Aly

<div align="center">

### Dados complexos. Perguntas simples.

</div>

A **Aly** é a interface de interação em linguagem natural desenvolvida para a experiência do Medlytics.

Em vez de depender exclusivamente da navegação entre diferentes páginas e gráficos, o gestor pode realizar perguntas diretamente sobre os dados.

Exemplos:

> 💬 **Quantos leitos existem em Campinas?**

> 💬 **Qual região possui maior número de internações?**

> 💬 **Quais são os CIDs mais frequentes?**

Na demonstração final do projeto, a experiência interativa utiliza o recurso de **Perguntas e Respostas (Q&A) do Power BI**, conectado ao modelo semântico utilizado pelo dashboard.

Isso permite transformar perguntas em linguagem natural em respostas e visualizações analíticas.

---

# 🔍 Rastreabilidade

O Medlytics possui uma área dedicada às **Fontes de Dados**, permitindo apresentar a origem das informações utilizadas na solução.

Essa camada contribui para a transparência e rastreabilidade das análises.

A proposta é permitir que o usuário não apenas visualize os indicadores, mas também compreenda quais dados sustentam as informações apresentadas.

---

# 🛡️ Governança, Ética e Segurança

A governança foi considerada como parte da arquitetura do Medlytics.

O projeto aborda conceitos relacionados a:

- **COBIT 2019**;
- qualidade dos dados;
- rastreabilidade;
- segurança da informação;
- controle de acesso;
- LGPD;
- monitoramento;
- conformidade;
- ética aplicada ao uso de dados e IA;
- proposta do **Oracle Ethics Shield (OES)**.

O objetivo é incorporar transparência, responsabilidade e segurança ao ciclo de utilização dos dados.

---

# 🧰 Tecnologias

<div align="center">

### Data & Analytics

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-336791?style=for-the-badge)
![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)

### Data Engineering

![Apache Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=apacheairflow&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

### Business Intelligence

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-00C896?style=for-the-badge)

### Cloud & Database

![Oracle Cloud](https://img.shields.io/badge/Oracle%20Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)

</div>

---

# 🧪 Qualidade dos Dados

Durante o desenvolvimento do pipeline foram realizadas etapas de tratamento e validação.

Entre elas:

- verificação de duplicidades;
- tratamento de tipos;
- padronização das informações;
- validação de registros;
- transformação dos dados;
- criação de atributos analíticos;
- separação entre dados brutos, tratados e preparados para análise.

Essas etapas permitem estruturar uma camada Gold adequada ao consumo analítico.

---

# 🚀 Evolução do Projeto

O Medlytics foi desenvolvido de forma incremental ao longo das quatro Sprints do Challenge.

| Sprint | Etapa | Objetivo |
|:---:|---|---|
| **Sprint 1** | 💡 Concepção | Definição do problema, proposta e ideia inicial do Medlytics |
| **Sprint 2** | 🏗️ Arquitetura | Desenvolvimento e definição da arquitetura da solução |
| **Sprint 3** | ⚙️ Desenvolvimento | Implementação técnica e entregas específicas das disciplinas |
| **Sprint 4** | 🚀 Entrega Final | Consolidação da solução, Power BI, apresentação e Pitch |

---

# 📁 Estrutura do Repositório

```text
Medlytics/
│
├── assets/
│   ├── medlytics-logo.jpeg
│   └── arquitetura.png
│
│├── medlytics-airflow/
│    ├── dags/
│    │   └── medlytics_pipeline.py
│    └── docker-compose.yaml
│
├── medlytics-pipeline/
│   └── data/
│       ├── bronze/
│       │   └── Leitos_2026.csv
│       ├── silver/
│       │   └── leitos_tratado.csv
│       └── gold/
│           └── RM572357.csv
│
├── database/
│   └── sql/
│       ├── ddl/
│       │   └── 1tscpv_script_ddl_medlytics.sql
│       │   └── ddl_medlytics.sql
|       |── dml/
│       │   └── 1tscpv_script_dml_medlytics.sql
│       │   └── dml_medlytics.sql
│   └── select-ai/
│       └── select_ia.sql
│
├── power-bi/
│   └── Medlytics.pbix

└── README.md
```

---

# ⚠️ Limitações

O Medlytics foi desenvolvido como uma solução acadêmica de **análise e apoio à tomada de decisão**.

Algumas limitações devem ser consideradas:

- leitos cadastrados não significam leitos disponíveis em tempo real;
- percentual de leitos SUS não representa taxa de ocupação;
- o risco apresentado nas análises geográficas é um **indicador estrutural relativo**;
- os dados utilizados não representam necessariamente a situação hospitalar em tempo real;
- a solução não substitui sistemas oficiais de regulação hospitalar;
- os indicadores não devem ser utilizados isoladamente para decisões clínicas.

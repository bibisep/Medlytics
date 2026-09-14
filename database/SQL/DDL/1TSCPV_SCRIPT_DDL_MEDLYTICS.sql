/*
===============================================================================
MEDLYTICS - SCRIPT DDL

INTEGRANTES:
GABRIELA MARI / RM572357
JULIA GOMES / RM572494
MARIA EDUARDA CAMPOS / RM569546
===============================================================================
*/

SET DEFINE OFF;

/*

DROP VIEW VW_RESUMO_INTERNACOES_HOSPITAL;
DROP VIEW VW_OCUPACAO_UTI;

DROP TABLE TB_INTERNACOES CASCADE CONSTRAINTS;
DROP TABLE TB_LEITOS CASCADE CONSTRAINTS;
DROP TABLE TB_HOSPITAIS CASCADE CONSTRAINTS;

*/

-------------------------------------------------------------------------------
-- 1. TABELA DE HOSPITAIS
-------------------------------------------------------------------------------

CREATE TABLE TB_HOSPITAIS (
    CO_CNES          VARCHAR2(10)  NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Codigo CNES', BUSINESS_KEY),
    CO_UNIDADE       VARCHAR2(20)  NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Identificador da unidade', KEY_ROLE 'PRIMARY_KEY'),
    CO_UF            NUMBER(2)     NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Codigo da UF'),
    NO_UF            VARCHAR2(2)   NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Sigla da UF'),
    NO_MUNICIPIO     VARCHAR2(100) NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Municipio'),
    CO_IBGE          NUMBER(7)     NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Codigo IBGE do municipio'),
    NO_RAZAO_SOCIAL  VARCHAR2(255),
    NO_FANTASIA      VARCHAR2(255) NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Nome fantasia'),
    CO_CEP           VARCHAR2(8),
    NO_LOGRADOURO    VARCHAR2(255),
    NU_ENDERECO      VARCHAR2(20),
    NO_BAIRRO        VARCHAR2(150),
    NU_TELEFONE      VARCHAR2(30),
    NO_EMAIL         VARCHAR2(260),

    CONSTRAINT PK_HOSPITAIS
        PRIMARY KEY (CO_UNIDADE),

    CONSTRAINT UK_HOSPITAIS_CNES
        UNIQUE (CO_CNES)
)
ANNOTATIONS (
    DISPLAY_NAME     'Hospitais',
    BUSINESS_PURPOSE 'Cadastro dos estabelecimentos de saude utilizados nas analises do MedLytics',
    DATA_SOURCE      'CNES - Cadastro Nacional de Estabelecimentos de Saude'
);

-------------------------------------------------------------------------------
-- 2. TABELA DE LEITOS DE UTI
-------------------------------------------------------------------------------

CREATE TABLE TB_LEITOS (
    CO_UNIDADE                VARCHAR2(20) NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Identificador da unidade', KEY_ROLE 'PRIMARY_KEY_FOREIGN_KEY'),

    UTI_ADULTA_TOTAL          NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Total de leitos UTI adulta'),
    UTI_ADULTA_OCUPADA        NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Leitos UTI adulta ocupados'),
    UTI_ADULTA_DISPONIVEL     NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Leitos UTI adulta disponiveis'),

    UTI_PEDIATRICA_TOTAL      NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Total de leitos UTI pediatrica'),
    UTI_PEDIATRICA_OCUPADA    NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Leitos UTI pediatrica ocupados'),
    UTI_PEDIATRICA_DISPONIVEL NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Leitos UTI pediatrica disponiveis'),

    UTI_NEONATAL_TOTAL        NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Total de leitos UTI neonatal'),
    UTI_NEONATAL_OCUPADA      NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Leitos UTI neonatal ocupados'),
    UTI_NEONATAL_DISPONIVEL   NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Leitos UTI neonatal disponiveis'),

    UTI_QUEIMADOS_TOTAL       NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Total de leitos UTI queimados'),
    UTI_QUEIMADOS_OCUPADA     NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Leitos UTI queimados ocupados'),
    UTI_QUEIMADOS_DISPONIVEL  NUMBER(3) DEFAULT 0 NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Leitos UTI queimados disponiveis'),

    DATA_ULTIMA_ATUALIZACAO   DATE NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Data da ultima atualizacao'),

    CONSTRAINT PK_LEITOS
        PRIMARY KEY (CO_UNIDADE),

    CONSTRAINT FK_LEITOS_HOSPITAIS
        FOREIGN KEY (CO_UNIDADE)
        REFERENCES TB_HOSPITAIS (CO_UNIDADE),

    CONSTRAINT CK_LEITOS_ADULTA
        CHECK (
            UTI_ADULTA_TOTAL >= 0
            AND UTI_ADULTA_OCUPADA >= 0
            AND UTI_ADULTA_DISPONIVEL >= 0
            AND UTI_ADULTA_OCUPADA + UTI_ADULTA_DISPONIVEL = UTI_ADULTA_TOTAL
        ),

    CONSTRAINT CK_LEITOS_PEDIATRICA
        CHECK (
            UTI_PEDIATRICA_TOTAL >= 0
            AND UTI_PEDIATRICA_OCUPADA >= 0
            AND UTI_PEDIATRICA_DISPONIVEL >= 0
            AND UTI_PEDIATRICA_OCUPADA + UTI_PEDIATRICA_DISPONIVEL = UTI_PEDIATRICA_TOTAL
        ),

    CONSTRAINT CK_LEITOS_NEONATAL
        CHECK (
            UTI_NEONATAL_TOTAL >= 0
            AND UTI_NEONATAL_OCUPADA >= 0
            AND UTI_NEONATAL_DISPONIVEL >= 0
            AND UTI_NEONATAL_OCUPADA + UTI_NEONATAL_DISPONIVEL = UTI_NEONATAL_TOTAL
        ),

    CONSTRAINT CK_LEITOS_QUEIMADOS
        CHECK (
            UTI_QUEIMADOS_TOTAL >= 0
            AND UTI_QUEIMADOS_OCUPADA >= 0
            AND UTI_QUEIMADOS_DISPONIVEL >= 0
            AND UTI_QUEIMADOS_OCUPADA + UTI_QUEIMADOS_DISPONIVEL = UTI_QUEIMADOS_TOTAL
        )
)
ANNOTATIONS (
    DISPLAY_NAME     'Leitos de UTI',
    BUSINESS_PURPOSE 'Capacidade, ocupacao e disponibilidade de leitos de UTI por unidade hospitalar',
    DATA_DOMAIN      'Capacidade hospitalar'
);

-------------------------------------------------------------------------------
-- 3. TABELA DE INTERNACOES
-------------------------------------------------------------------------------

CREATE TABLE TB_INTERNACOES (
    ID_INTERNACAO       NUMBER(3)    NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Identificador da internacao', KEY_ROLE 'PRIMARY_KEY'),
    CO_UNIDADE          VARCHAR2(20) NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Unidade hospitalar', KEY_ROLE 'FOREIGN_KEY'),
    DATA_INTERNACAO     DATE         NOT NULL
        ANNOTATIONS (DISPLAY_NAME 'Data da internacao'),
    DATA_ALTA           DATE
        ANNOTATIONS (DISPLAY_NAME 'Data da alta'),
    TEMPO_PERMANENCIA   NUMBER(3)
        ANNOTATIONS (DISPLAY_NAME 'Tempo de permanencia em dias', UNIT 'dias'),
    CID                 VARCHAR2(26)
        ANNOTATIONS (DISPLAY_NAME 'Codigo CID'),
    DOENCA              VARCHAR2(200)
        ANNOTATIONS (DISPLAY_NAME 'Doenca ou condicao clinica'),
    TIPO_ATENDIMENTO    VARCHAR2(20)
        ANNOTATIONS (DISPLAY_NAME 'Tipo de atendimento'),
    FAIXA_ETARIA        VARCHAR2(15)
        ANNOTATIONS (DISPLAY_NAME 'Faixa etaria'),
    STATUS              VARCHAR2(15)
        ANNOTATIONS (DISPLAY_NAME 'Status da internacao'),

    CONSTRAINT PK_INTERNACOES
        PRIMARY KEY (ID_INTERNACAO),

    CONSTRAINT FK_INTERNACOES_HOSPITAIS
        FOREIGN KEY (CO_UNIDADE)
        REFERENCES TB_HOSPITAIS (CO_UNIDADE),

    CONSTRAINT CK_INTERNACOES_PERMANENCIA
        CHECK (
            TEMPO_PERMANENCIA IS NULL
            OR TEMPO_PERMANENCIA >= 0
        ),

    CONSTRAINT CK_INTERNACOES_DATAS
        CHECK (
            DATA_ALTA IS NULL
            OR DATA_ALTA >= DATA_INTERNACAO
        ),

    CONSTRAINT CK_INTERNACOES_ATENDIMENTO
        CHECK (
            TIPO_ATENDIMENTO IS NULL
            OR TIPO_ATENDIMENTO IN ('URGÊNCIA', 'EMERGÊNCIA', 'ELETIVO')
        ),

    CONSTRAINT CK_INTERNACOES_FAIXA_ETARIA
        CHECK (
            FAIXA_ETARIA IS NULL
            OR FAIXA_ETARIA IN ('CRIANÇA', 'ADULTO', 'IDOSO')
        )
)
ANNOTATIONS (
    DISPLAY_NAME     'Internacoes',
    BUSINESS_PURPOSE 'Registros de internacoes utilizados para analises assistenciais do MedLytics',
    DATA_SOURCE      'DATASUS - SIH'
);

-------------------------------------------------------------------------------
-- 4. COMMENTS - DOCUMENTACAO DAS TABELAS E COLUNAS
-------------------------------------------------------------------------------

COMMENT ON TABLE TB_HOSPITAIS IS
    'Cadastro das unidades hospitalares utilizadas pelo MedLytics, incluindo identificacao, localizacao e dados de contato.';

COMMENT ON COLUMN TB_HOSPITAIS.CO_CNES IS
    'Codigo CNES do estabelecimento de saude.';
COMMENT ON COLUMN TB_HOSPITAIS.CO_UNIDADE IS
    'Identificador unico da unidade hospitalar utilizado nos relacionamentos com leitos e internacoes.';
COMMENT ON COLUMN TB_HOSPITAIS.CO_UF IS
    'Codigo numerico da Unidade da Federacao.';
COMMENT ON COLUMN TB_HOSPITAIS.NO_UF IS
    'Sigla da Unidade da Federacao.';
COMMENT ON COLUMN TB_HOSPITAIS.NO_MUNICIPIO IS
    'Nome do municipio onde a unidade esta localizada.';
COMMENT ON COLUMN TB_HOSPITAIS.CO_IBGE IS
    'Codigo IBGE associado ao municipio da unidade hospitalar.';
COMMENT ON COLUMN TB_HOSPITAIS.NO_RAZAO_SOCIAL IS
    'Razao social da instituicao responsavel pelo estabelecimento.';
COMMENT ON COLUMN TB_HOSPITAIS.NO_FANTASIA IS
    'Nome fantasia do estabelecimento de saude.';
COMMENT ON COLUMN TB_HOSPITAIS.CO_CEP IS
    'CEP do estabelecimento.';
COMMENT ON COLUMN TB_HOSPITAIS.NO_LOGRADOURO IS
    'Logradouro do estabelecimento.';
COMMENT ON COLUMN TB_HOSPITAIS.NU_ENDERECO IS
    'Numero do endereco do estabelecimento.';
COMMENT ON COLUMN TB_HOSPITAIS.NO_BAIRRO IS
    'Bairro onde o estabelecimento esta localizado.';
COMMENT ON COLUMN TB_HOSPITAIS.NU_TELEFONE IS
    'Telefone de contato da unidade hospitalar.';
COMMENT ON COLUMN TB_HOSPITAIS.NO_EMAIL IS
    'Endereco de e-mail de contato da unidade hospitalar.';

COMMENT ON TABLE TB_LEITOS IS
    'Armazena quantidades totais, ocupadas e disponiveis de leitos de UTI por unidade hospitalar e tipo de UTI.';

COMMENT ON COLUMN TB_LEITOS.CO_UNIDADE IS
    'Identificador da unidade hospitalar a que os dados de leitos pertencem.';
COMMENT ON COLUMN TB_LEITOS.UTI_ADULTA_TOTAL IS
    'Quantidade total de leitos de UTI adulta.';
COMMENT ON COLUMN TB_LEITOS.UTI_ADULTA_OCUPADA IS
    'Quantidade de leitos de UTI adulta ocupados.';
COMMENT ON COLUMN TB_LEITOS.UTI_ADULTA_DISPONIVEL IS
    'Quantidade de leitos de UTI adulta disponiveis.';
COMMENT ON COLUMN TB_LEITOS.UTI_PEDIATRICA_TOTAL IS
    'Quantidade total de leitos de UTI pediatrica.';
COMMENT ON COLUMN TB_LEITOS.UTI_PEDIATRICA_OCUPADA IS
    'Quantidade de leitos de UTI pediatrica ocupados.';
COMMENT ON COLUMN TB_LEITOS.UTI_PEDIATRICA_DISPONIVEL IS
    'Quantidade de leitos de UTI pediatrica disponiveis.';
COMMENT ON COLUMN TB_LEITOS.UTI_NEONATAL_TOTAL IS
    'Quantidade total de leitos de UTI neonatal.';
COMMENT ON COLUMN TB_LEITOS.UTI_NEONATAL_OCUPADA IS
    'Quantidade de leitos de UTI neonatal ocupados.';
COMMENT ON COLUMN TB_LEITOS.UTI_NEONATAL_DISPONIVEL IS
    'Quantidade de leitos de UTI neonatal disponiveis.';
COMMENT ON COLUMN TB_LEITOS.UTI_QUEIMADOS_TOTAL IS
    'Quantidade total de leitos de UTI destinados a queimados.';
COMMENT ON COLUMN TB_LEITOS.UTI_QUEIMADOS_OCUPADA IS
    'Quantidade de leitos de UTI para queimados ocupados.';
COMMENT ON COLUMN TB_LEITOS.UTI_QUEIMADOS_DISPONIVEL IS
    'Quantidade de leitos de UTI para queimados disponiveis.';
COMMENT ON COLUMN TB_LEITOS.DATA_ULTIMA_ATUALIZACAO IS
    'Data de referencia da ultima atualizacao dos dados de leitos.';

COMMENT ON TABLE TB_INTERNACOES IS
    'Registros de internacoes hospitalares com datas, diagnostico, tipo de atendimento, faixa etaria e situacao.';

COMMENT ON COLUMN TB_INTERNACOES.ID_INTERNACAO IS
    'Identificador unico da internacao.';
COMMENT ON COLUMN TB_INTERNACOES.CO_UNIDADE IS
    'Identificador da unidade hospitalar responsavel pela internacao.';
COMMENT ON COLUMN TB_INTERNACOES.DATA_INTERNACAO IS
    'Data de inicio da internacao.';
COMMENT ON COLUMN TB_INTERNACOES.DATA_ALTA IS
    'Data de alta ou encerramento da internacao.';
COMMENT ON COLUMN TB_INTERNACOES.TEMPO_PERMANENCIA IS
    'Quantidade de dias de permanencia do paciente.';
COMMENT ON COLUMN TB_INTERNACOES.CID IS
    'Codigo da Classificacao Internacional de Doencas associado ao registro.';
COMMENT ON COLUMN TB_INTERNACOES.DOENCA IS
    'Descricao da doenca ou condicao clinica associada a internacao.';
COMMENT ON COLUMN TB_INTERNACOES.TIPO_ATENDIMENTO IS
    'Classificacao do atendimento: urgencia, emergencia ou eletivo.';
COMMENT ON COLUMN TB_INTERNACOES.FAIXA_ETARIA IS
    'Faixa etaria usada para caracterizar o paciente: crianca, adulto ou idoso.';
COMMENT ON COLUMN TB_INTERNACOES.STATUS IS
    'Situacao registrada para a internacao.';

-------------------------------------------------------------------------------
-- 5. VIEWS ANALITICAS
-------------------------------------------------------------------------------

CREATE OR REPLACE VIEW VW_OCUPACAO_UTI
ANNOTATIONS (
    DISPLAY_NAME     'Ocupacao de UTI por hospital',
    BUSINESS_PURPOSE 'Facilitar analises de capacidade e taxa de ocupacao dos leitos de UTI'
)
AS
SELECT
    H.CO_UNIDADE,
    H.CO_CNES,
    H.NO_FANTASIA,
    H.NO_UF,
    H.NO_MUNICIPIO,
    L.UTI_ADULTA_TOTAL,
    L.UTI_ADULTA_OCUPADA,
    L.UTI_ADULTA_DISPONIVEL,
    CASE
        WHEN L.UTI_ADULTA_TOTAL > 0
            THEN ROUND((L.UTI_ADULTA_OCUPADA / L.UTI_ADULTA_TOTAL) * 100, 2)
        ELSE NULL
    END AS TX_OCUPACAO_UTI_ADULTA,
    L.UTI_PEDIATRICA_TOTAL,
    L.UTI_PEDIATRICA_OCUPADA,
    L.UTI_PEDIATRICA_DISPONIVEL,
    CASE
        WHEN L.UTI_PEDIATRICA_TOTAL > 0
            THEN ROUND((L.UTI_PEDIATRICA_OCUPADA / L.UTI_PEDIATRICA_TOTAL) * 100, 2)
        ELSE NULL
    END AS TX_OCUPACAO_UTI_PEDIATRICA,
    L.UTI_NEONATAL_TOTAL,
    L.UTI_NEONATAL_OCUPADA,
    L.UTI_NEONATAL_DISPONIVEL,
    CASE
        WHEN L.UTI_NEONATAL_TOTAL > 0
            THEN ROUND((L.UTI_NEONATAL_OCUPADA / L.UTI_NEONATAL_TOTAL) * 100, 2)
        ELSE NULL
    END AS TX_OCUPACAO_UTI_NEONATAL,
    L.UTI_QUEIMADOS_TOTAL,
    L.UTI_QUEIMADOS_OCUPADA,
    L.UTI_QUEIMADOS_DISPONIVEL,
    CASE
        WHEN L.UTI_QUEIMADOS_TOTAL > 0
            THEN ROUND((L.UTI_QUEIMADOS_OCUPADA / L.UTI_QUEIMADOS_TOTAL) * 100, 2)
        ELSE NULL
    END AS TX_OCUPACAO_UTI_QUEIMADOS,
    L.DATA_ULTIMA_ATUALIZACAO
FROM TB_HOSPITAIS H
JOIN TB_LEITOS L
    ON H.CO_UNIDADE = L.CO_UNIDADE;

COMMENT ON TABLE VW_OCUPACAO_UTI IS
    'View analitica com capacidade, disponibilidade e taxas de ocupacao dos diferentes tipos de UTI por hospital.';


CREATE OR REPLACE VIEW VW_RESUMO_INTERNACOES_HOSPITAL
ANNOTATIONS (
    DISPLAY_NAME     'Resumo de internacoes por hospital',
    BUSINESS_PURPOSE 'Consolidar quantidade de internacoes e tempo medio de permanencia por unidade'
)
AS
SELECT
    H.CO_UNIDADE,
    H.CO_CNES,
    H.NO_FANTASIA,
    H.NO_UF,
    H.NO_MUNICIPIO,
    COUNT(I.ID_INTERNACAO) AS TOTAL_INTERNACOES,
    ROUND(AVG(I.TEMPO_PERMANENCIA), 2) AS TEMPO_MEDIO_PERMANENCIA,
    MIN(I.DATA_INTERNACAO) AS PRIMEIRA_INTERNACAO,
    MAX(I.DATA_INTERNACAO) AS ULTIMA_INTERNACAO
FROM TB_HOSPITAIS H
LEFT JOIN TB_INTERNACOES I
    ON H.CO_UNIDADE = I.CO_UNIDADE
GROUP BY
    H.CO_UNIDADE,
    H.CO_CNES,
    H.NO_FANTASIA,
    H.NO_UF,
    H.NO_MUNICIPIO;

COMMENT ON TABLE VW_RESUMO_INTERNACOES_HOSPITAL IS
    'View de resumo assistencial com total de internacoes e tempo medio de permanencia por hospital.';

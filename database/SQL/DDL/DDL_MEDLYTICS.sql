/*
RELACIONAMENTOS:

TB_REGIOES      1:N TB_UFS
TB_UFS          1:N TB_MUNICIPIOS
TB_MUNICIPIOS   1:N TB_HOSPITAIS
TB_HOSPITAIS    1:1 TB_LEITOS
TB_HOSPITAIS    1:N TB_INTERNACOES
*/

/*
DROP TABLE

DROP VIEW VW_OCUPACAO_LEITOS;
DROP TABLE TB_INTERNACOES CASCADE CONSTRAINTS;
DROP TABLE TB_LEITOS CASCADE CONSTRAINTS;
DROP TABLE TB_HOSPITAIS CASCADE CONSTRAINTS;
DROP TABLE TB_MUNICIPIOS CASCADE CONSTRAINTS;
DROP TABLE TB_UFS CASCADE CONSTRAINTS;
DROP TABLE TB_REGIOES CASCADE CONSTRAINTS;
*/



-- 1. REGIÕES


CREATE TABLE TB_REGIOES (

    ID_REGIAO NUMBER(1) NOT NULL,
    NO_REGIAO VARCHAR2(20) NOT NULL,

    CONSTRAINT PK_REGIOES
        PRIMARY KEY (ID_REGIAO),

    CONSTRAINT UK_REGIOES_NOME
        UNIQUE (NO_REGIAO),

    CONSTRAINT CK_REGIOES_NOME
        CHECK (
            NO_REGIAO IN (
                'NORTE',
                'NORDESTE',
                'CENTRO-OESTE',
                'SUDESTE',
                'SUL'
            )
        )
);



-- 2. UNIDADES DA FEDERAÇÃO

CREATE TABLE TB_UFS (

    CO_UF NUMBER(2) NOT NULL,
    SG_UF CHAR(2) NOT NULL,
    ID_REGIAO NUMBER(1) NOT NULL,

    CONSTRAINT PK_UFS
        PRIMARY KEY (CO_UF),

    CONSTRAINT UK_UFS_SIGLA
        UNIQUE (SG_UF),

    CONSTRAINT FK_UFS_REGIOES
        FOREIGN KEY (ID_REGIAO)
        REFERENCES TB_REGIOES (ID_REGIAO)
);


-- 3. MUNICÍPIOS


CREATE TABLE TB_MUNICIPIOS (

    CO_IBGE NUMBER(7) NOT NULL,
    NO_MUNICIPIO VARCHAR2(100) NOT NULL,
    CO_UF NUMBER(2) NOT NULL,

    CONSTRAINT PK_MUNICIPIOS
        PRIMARY KEY (CO_IBGE),

    CONSTRAINT FK_MUNICIPIOS_UFS
        FOREIGN KEY (CO_UF)
        REFERENCES TB_UFS (CO_UF)
);


-- 4. HOSPITAIS


CREATE TABLE TB_HOSPITAIS (

    CO_CNES VARCHAR2(10) NOT NULL,
    CO_UNIDADE VARCHAR2(20) NOT NULL,
    CO_IBGE NUMBER(7) NOT NULL,

    NO_RAZAO_SOCIAL VARCHAR2(255),
    NO_FANTASIA VARCHAR2(255) NOT NULL,

    CO_CEP VARCHAR2(8),
    NO_LOGRADOURO VARCHAR2(255),
    NU_ENDERECO VARCHAR2(20),
    NO_BAIRRO VARCHAR2(150),
    NU_TELEFONE VARCHAR2(30),
    NO_EMAIL VARCHAR2(260),

    CONSTRAINT PK_HOSPITAIS
        PRIMARY KEY (CO_UNIDADE),

    CONSTRAINT UK_HOSPITAIS_CNES
        UNIQUE (CO_CNES),

    CONSTRAINT FK_HOSPITAIS_MUNICIPIOS
        FOREIGN KEY (CO_IBGE)
        REFERENCES TB_MUNICIPIOS (CO_IBGE)
);


-- 5. LEITOS


CREATE TABLE TB_LEITOS (

    CO_UNIDADE VARCHAR2(20) NOT NULL,

    UTI_ADULTA_TOTAL NUMBER(3) DEFAULT 0 NOT NULL,
    UTI_ADULTA_OCUPADA NUMBER(3) DEFAULT 0 NOT NULL,
    UTI_ADULTA_DISPONIVEL NUMBER(3) DEFAULT 0 NOT NULL,

    UTI_PEDIATRICA_TOTAL NUMBER(3) DEFAULT 0 NOT NULL,
    UTI_PEDIATRICA_OCUPADA NUMBER(3) DEFAULT 0 NOT NULL,
    UTI_PEDIATRICA_DISPONIVEL NUMBER(3) DEFAULT 0 NOT NULL,

    UTI_NEONATAL_TOTAL NUMBER(3) DEFAULT 0 NOT NULL,
    UTI_NEONATAL_OCUPADA NUMBER(3) DEFAULT 0 NOT NULL,
    UTI_NEONATAL_DISPONIVEL NUMBER(3) DEFAULT 0 NOT NULL,

    UTI_QUEIMADOS_TOTAL NUMBER(3) DEFAULT 0 NOT NULL,
    UTI_QUEIMADOS_OCUPADA NUMBER(3) DEFAULT 0 NOT NULL,
    UTI_QUEIMADOS_DISPONIVEL NUMBER(3) DEFAULT 0 NOT NULL,

    DATA_ULTIMA_ATUALIZACAO DATE NOT NULL,

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
            AND UTI_ADULTA_OCUPADA
                + UTI_ADULTA_DISPONIVEL
                = UTI_ADULTA_TOTAL
        ),

    CONSTRAINT CK_LEITOS_PEDIATRICA
        CHECK (
            UTI_PEDIATRICA_TOTAL >= 0
            AND UTI_PEDIATRICA_OCUPADA >= 0
            AND UTI_PEDIATRICA_DISPONIVEL >= 0
            AND UTI_PEDIATRICA_OCUPADA
                + UTI_PEDIATRICA_DISPONIVEL
                = UTI_PEDIATRICA_TOTAL
        ),

    CONSTRAINT CK_LEITOS_NEONATAL
        CHECK (
            UTI_NEONATAL_TOTAL >= 0
            AND UTI_NEONATAL_OCUPADA >= 0
            AND UTI_NEONATAL_DISPONIVEL >= 0
            AND UTI_NEONATAL_OCUPADA
                + UTI_NEONATAL_DISPONIVEL
                = UTI_NEONATAL_TOTAL
        ),

    CONSTRAINT CK_LEITOS_QUEIMADOS
        CHECK (
            UTI_QUEIMADOS_TOTAL >= 0
            AND UTI_QUEIMADOS_OCUPADA >= 0
            AND UTI_QUEIMADOS_DISPONIVEL >= 0
            AND UTI_QUEIMADOS_OCUPADA
                + UTI_QUEIMADOS_DISPONIVEL
                = UTI_QUEIMADOS_TOTAL
        )
);



-- 6. INTERNAÇÕES


CREATE TABLE TB_INTERNACOES (

    ID_INTERNACAO NUMBER(3) NOT NULL,
    CO_UNIDADE VARCHAR2(20) NOT NULL,

    DATA_INTERNACAO DATE NOT NULL,
    DATA_ALTA DATE,

    TEMPO_PERMANENCIA NUMBER(3),

    CID VARCHAR2(26),
    DOENCA VARCHAR2(200),

    TIPO_ATENDIMENTO VARCHAR2(20),
    FAIXA_ETARIA VARCHAR2(15),
    STATUS VARCHAR2(15),

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
            OR TIPO_ATENDIMENTO IN (
                'URGÊNCIA',
                'EMERGÊNCIA',
                'ELETIVO'
            )
        ),

    CONSTRAINT CK_INTERNACOES_FAIXA
        CHECK (
            FAIXA_ETARIA IS NULL
            OR FAIXA_ETARIA IN (
                'CRIANÇA',
                'ADULTO',
                'IDOSO'
            )
        )
);

-- 7. VIEW DE TAXAS DE OCUPAÇÃO DE LEITOS

CREATE OR REPLACE VIEW VW_OCUPACAO_LEITOS AS
SELECT
    H.CO_UNIDADE,
    H.NO_FANTASIA,

    ROUND(
        L.UTI_ADULTA_OCUPADA /
        NULLIF(L.UTI_ADULTA_TOTAL, 0) * 100,
        2
    ) AS TAXA_OCUPACAO_ADULTA,

    ROUND(
        L.UTI_PEDIATRICA_OCUPADA /
        NULLIF(L.UTI_PEDIATRICA_TOTAL, 0) * 100,
        2
    ) AS TAXA_OCUPACAO_PEDIATRICA,

    ROUND(
        L.UTI_NEONATAL_OCUPADA /
        NULLIF(L.UTI_NEONATAL_TOTAL, 0) * 100,
        2
    ) AS TAXA_OCUPACAO_NEONATAL,

    ROUND(
        L.UTI_QUEIMADOS_OCUPADA /
        NULLIF(L.UTI_QUEIMADOS_TOTAL, 0) * 100,
        2
    ) AS TAXA_OCUPACAO_QUEIMADOS

FROM TB_HOSPITAIS H
JOIN TB_LEITOS L
    ON H.CO_UNIDADE = L.CO_UNIDADE;



-- COMMENT ON TABLE (VIEW)


COMMENT ON TABLE VW_OCUPACAO_LEITOS IS
'Calcula as taxas de ocupação de UTI (adulta, pediátrica, neonatal e queimados) por unidade hospitalar, evitando erro de divisão por zero quando o hospital não possui leitos daquele tipo.';



-- COMMENT ON COLUMN (VIEW)

COMMENT ON TABLE VW_OCUPACAO_LEITOS IS
'Calcula as taxas de ocupação de UTI (adulta, pediátrica, neonatal e queimados) por unidade hospitalar, evitando erro de divisão por zero quando o hospital não possui leitos daquele tipo.';

COMMENT ON COLUMN VW_OCUPACAO_LEITOS.CO_UNIDADE IS
'Identificador da unidade hospitalar associada às taxas de ocupação.';

COMMENT ON COLUMN VW_OCUPACAO_LEITOS.NO_FANTASIA IS
'Nome fantasia da unidade hospitalar.';

COMMENT ON COLUMN VW_OCUPACAO_LEITOS.TAXA_OCUPACAO_ADULTA IS
'Percentual de ocupação dos leitos de UTI adulta. Retorna NULO quando o hospital não possui leitos desse tipo.';

COMMENT ON COLUMN VW_OCUPACAO_LEITOS.TAXA_OCUPACAO_PEDIATRICA IS
'Percentual de ocupação dos leitos de UTI pediátrica. Retorna NULO quando o hospital não possui leitos desse tipo.';

COMMENT ON COLUMN VW_OCUPACAO_LEITOS.TAXA_OCUPACAO_NEONATAL IS
'Percentual de ocupação dos leitos de UTI neonatal. Retorna NULO quando o hospital não possui leitos desse tipo.';

COMMENT ON COLUMN VW_OCUPACAO_LEITOS.TAXA_OCUPACAO_QUEIMADOS IS
'Percentual de ocupação dos leitos de UTI para queimados. Retorna NULO quando o hospital não possui leitos desse tipo.';


-- COMMENT ON TABLE

COMMENT ON TABLE TB_REGIOES IS
'Armazena as regiões geográficas brasileiras utilizadas nas análises territoriais do MedLytics.';

COMMENT ON TABLE TB_UFS IS
'Armazena as Unidades da Federação e sua associação com as regiões geográficas brasileiras.';

COMMENT ON TABLE TB_MUNICIPIOS IS
'Armazena os municípios e sua associação com as respectivas Unidades da Federação.';

COMMENT ON TABLE TB_HOSPITAIS IS
'Armazena o cadastro das unidades hospitalares e sua localização municipal.';

COMMENT ON TABLE TB_LEITOS IS
'Armazena a capacidade, ocupação e disponibilidade de leitos de UTI por unidade hospitalar.';

COMMENT ON TABLE TB_INTERNACOES IS
'Armazena registros de internações hospitalares, incluindo período, diagnóstico, perfil etário e tipo de atendimento.';



-- COMMENT ON COLUMN - REGIÕES


COMMENT ON COLUMN TB_REGIOES.ID_REGIAO IS
'Identificador único da região geográfica brasileira.';

COMMENT ON COLUMN TB_REGIOES.NO_REGIAO IS
'Nome da região geográfica: Norte, Nordeste, Centro-Oeste, Sudeste ou Sul.';



-- COMMENT ON COLUMN - UFS


COMMENT ON COLUMN TB_UFS.CO_UF IS
'Código numérico da Unidade da Federação.';

COMMENT ON COLUMN TB_UFS.SG_UF IS
'Sigla de duas letras da Unidade da Federação.';

COMMENT ON COLUMN TB_UFS.ID_REGIAO IS
'Identificador da região geográfica à qual a Unidade da Federação pertence.';


-- COMMENT ON COLUMN - MUNICÍPIOS


COMMENT ON COLUMN TB_MUNICIPIOS.CO_IBGE IS
'Código IBGE utilizado como identificador único do município.';

COMMENT ON COLUMN TB_MUNICIPIOS.NO_MUNICIPIO IS
'Nome do município.';

COMMENT ON COLUMN TB_MUNICIPIOS.CO_UF IS
'Código da Unidade da Federação à qual o município pertence.';


-- COMMENT ON COLUMN - HOSPITAIS

COMMENT ON COLUMN TB_HOSPITAIS.CO_CNES IS
'Código CNES do estabelecimento de saúde.';

COMMENT ON COLUMN TB_HOSPITAIS.CO_UNIDADE IS
'Identificador único da unidade hospitalar.';

COMMENT ON COLUMN TB_HOSPITAIS.CO_IBGE IS
'Código IBGE do município onde está localizada a unidade hospitalar.';

COMMENT ON COLUMN TB_HOSPITAIS.NO_RAZAO_SOCIAL IS
'Razão social da instituição responsável pela unidade de saúde.';

COMMENT ON COLUMN TB_HOSPITAIS.NO_FANTASIA IS
'Nome fantasia da unidade hospitalar utilizado em consultas e relatórios.';

COMMENT ON COLUMN TB_HOSPITAIS.CO_CEP IS
'Código de Endereçamento Postal da unidade hospitalar.';

COMMENT ON COLUMN TB_HOSPITAIS.NO_LOGRADOURO IS
'Nome do logradouro da unidade hospitalar.';

COMMENT ON COLUMN TB_HOSPITAIS.NU_ENDERECO IS
'Número do endereço da unidade hospitalar.';

COMMENT ON COLUMN TB_HOSPITAIS.NO_BAIRRO IS
'Bairro onde está localizada a unidade hospitalar.';

COMMENT ON COLUMN TB_HOSPITAIS.NU_TELEFONE IS
'Número de telefone para contato com a unidade hospitalar.';

COMMENT ON COLUMN TB_HOSPITAIS.NO_EMAIL IS
'Endereço de e-mail para contato com a unidade hospitalar.';


-- COMMENT ON COLUMN - LEITOS

COMMENT ON COLUMN TB_LEITOS.CO_UNIDADE IS
'Identificador da unidade hospitalar associada às informações de leitos.';

COMMENT ON COLUMN TB_LEITOS.UTI_ADULTA_TOTAL IS
'Quantidade total de leitos de UTI adulta.';

COMMENT ON COLUMN TB_LEITOS.UTI_ADULTA_OCUPADA IS
'Quantidade de leitos de UTI adulta ocupados.';

COMMENT ON COLUMN TB_LEITOS.UTI_ADULTA_DISPONIVEL IS
'Quantidade de leitos de UTI adulta disponíveis.';

COMMENT ON COLUMN TB_LEITOS.UTI_PEDIATRICA_TOTAL IS
'Quantidade total de leitos de UTI pediátrica.';

COMMENT ON COLUMN TB_LEITOS.UTI_PEDIATRICA_OCUPADA IS
'Quantidade de leitos de UTI pediátrica ocupados.';

COMMENT ON COLUMN TB_LEITOS.UTI_PEDIATRICA_DISPONIVEL IS
'Quantidade de leitos de UTI pediátrica disponíveis.';

COMMENT ON COLUMN TB_LEITOS.UTI_NEONATAL_TOTAL IS
'Quantidade total de leitos de UTI neonatal.';

COMMENT ON COLUMN TB_LEITOS.UTI_NEONATAL_OCUPADA IS
'Quantidade de leitos de UTI neonatal ocupados.';

COMMENT ON COLUMN TB_LEITOS.UTI_NEONATAL_DISPONIVEL IS
'Quantidade de leitos de UTI neonatal disponíveis.';

COMMENT ON COLUMN TB_LEITOS.UTI_QUEIMADOS_TOTAL IS
'Quantidade total de leitos de UTI para queimados.';

COMMENT ON COLUMN TB_LEITOS.UTI_QUEIMADOS_OCUPADA IS
'Quantidade de leitos de UTI para queimados ocupados.';

COMMENT ON COLUMN TB_LEITOS.UTI_QUEIMADOS_DISPONIVEL IS
'Quantidade de leitos de UTI para queimados disponíveis.';

COMMENT ON COLUMN TB_LEITOS.DATA_ULTIMA_ATUALIZACAO IS
'Data de referência da última atualização das informações de capacidade e ocupação dos leitos.';


-- COMMENT ON COLUMN - INTERNAÇÕES


COMMENT ON COLUMN TB_INTERNACOES.ID_INTERNACAO IS
'Identificador único do registro de internação hospitalar.';

COMMENT ON COLUMN TB_INTERNACOES.CO_UNIDADE IS
'Identificador da unidade hospitalar responsável pela internação.';

COMMENT ON COLUMN TB_INTERNACOES.DATA_INTERNACAO IS
'Data de início da internação hospitalar.';

COMMENT ON COLUMN TB_INTERNACOES.DATA_ALTA IS
'Data da alta ou encerramento da internação.';

COMMENT ON COLUMN TB_INTERNACOES.TEMPO_PERMANENCIA IS
'Quantidade de dias de permanência do paciente durante a internação.';

COMMENT ON COLUMN TB_INTERNACOES.CID IS
'Código da Classificação Internacional de Doenças associado à internação.';

COMMENT ON COLUMN TB_INTERNACOES.DOENCA IS
'Descrição da doença ou condição clínica associada à internação.';

COMMENT ON COLUMN TB_INTERNACOES.TIPO_ATENDIMENTO IS
'Classificação do atendimento hospitalar: urgência, emergência ou eletivo.';

COMMENT ON COLUMN TB_INTERNACOES.FAIXA_ETARIA IS
'Faixa etária utilizada para caracterizar o perfil do paciente.';

COMMENT ON COLUMN TB_INTERNACOES.STATUS IS
'Situação registrada para a internação hospitalar.';
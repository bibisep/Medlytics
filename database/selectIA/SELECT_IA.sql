-- Define o profile de IA (Select AI) a ser usado na sessão atual.
EXEC DBMS_CLOUD_AI.SET_PROFILE('MEDLYTICS_IA');

-- 1
SELECT AI SHOWSQL
Quais são os 3 hospitais com maior tempo médio de permanência dos pacientes;

-- 2
SELECT AI SHOWSQL
Qual doença possui o maior número de internações;

-- 3
SELECT AI SHOWSQL
Qual doença apresenta o maior tempo médio de permanência hospitalar;

-- 4
SELECT AI SHOWSQL
Qual região do Brasil apresentou o maior número de internações;

-- 5
SELECT AI SHOWSQL
Quais são os 3 hospitais com maior taxa de ocupação de UTI pediátrica;

-- 6
SELECT AI SHOWSQL
Qual foi o crescimento mensal no número de internações por região do Brasil ao longo de 2026;

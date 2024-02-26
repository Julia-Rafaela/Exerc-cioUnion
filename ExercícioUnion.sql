CREATE DATABASE Ex_union
GO
USE Ex_union

GO
CREATE TABLE curso(
	cod          		INT		NOT NULL,
	nome_curso  		        VARCHAR(70) 	NOT NULL,
	sigla 		        VARCHAR(10) 	NOT NULL,
	PRIMARY KEY (cod)
)
GO
CREATE TABLE aluno(
	ra 		    CHAR(07)		NOT NULL,
	nome_aluno 	VARCHAR(250) 	NOT NULL,
	cod_curso 	INT         NOT NULL,
	PRIMARY KEY (ra),
	FOREIGN KEY (cod_curso) REFERENCES curso (cod)
)
GO
CREATE TABLE palestrante(
	cod 		       INT		NOT NULL,
	nome_palestrante   VARCHAR(250) 	NOT NULL,
	empresa 	       VARCHAR(100)          NOT NULL,
	PRIMARY KEY (cod)
)
GO
CREATE TABLE palestra(
	cod 	        INT		NOT NULL,
	titulo	        VARCHAR(MAX) 	NOT NULL,
	carga_horaria 	INT		NOT NULL,
	data_palestra 	DATE 	NULL,
	cod_palestrante INT		NOT NULL
	PRIMARY KEY (cod)
	FOREIGN KEY (cod_palestrante) REFERENCES palestrante (cod)
)
GO
CREATE TABLE alunos_inscritos(
	ra_aluno 	  CHAR(07)		NOT NULL,
	cod_palestra  INT		NOT NULL   
	PRIMARY KEY (ra_aluno, cod_palestra),
	FOREIGN KEY (cod_palestra) REFERENCES palestra (cod),
	FOREIGN KEY (ra_aluno) REFERENCES aluno (ra)
)
GO
CREATE TABLE nao_alunos(
	RG	           VARCHAR(09)		NOT NULL,
    orgao_exp      CHAR(05)		NOT NULL,
	nome_nao_aluno VARCHAR(250) 	NOT NULL
	PRIMARY KEY (RG,  orgao_exp )
)
GO
CREATE TABLE nao_alunos_inscritos(
	RG      	  VARCHAR(09)		NOT NULL,
	cod_palestra  INT		NOT NULL,  
	orgao_exp     CHAR(05)		NOT NULL
	PRIMARY KEY (RG, cod_palestra, orgao_exp),
	FOREIGN KEY (RG,orgao_exp ) REFERENCES nao_alunos (RG,orgao_exp),
	FOREIGN KEY (cod_palestra) REFERENCES palestra (cod)
)
--O problema está no momento de gerar a lista de presença. A lista de presença deverá vir de uma 
--consulta que retorna (Num_Documento, Nome_Pessoa, Titulo_Palestra, Nome_Palestrante, 
--Carga_Horária e Data). A lista deverá ser uma só, por palestra (A condição da consulta é o código 
--da palestra) e contemplar alunos e não alunos (O Num_Documento se referencia ao RA para 
--alunos e RG + Orgao_Exp para não alunos) e estar ordenada pelo Nome_Pessoa.
--Fazer uma view de select que fornaça a saída conforme se pede.

CREATE VIEW	v_lista_presenca
AS 
SELECT a.ra AS Num_Documento, a.nome_aluno AS Nome_Pessoa, na.RG +' ' + na.orgao_exp AS  Num_Documento_NaoAlunos,
       nome_nao_aluno AS Nome__NaoAluno, ai.cod_palestra AS Cod_Palestra
FROM aluno a
INNER JOIN alunos_inscritos ai ON a.ra = ai.ra_aluno
INNER JOIN nao_alunos_inscritos nai ON ai.cod_palestra = nai.cod_palestra
INNER JOIN nao_alunos na ON na.RG = nai.RG
UNION 
SELECT p.titulo + ' ' + p.cod AS Titulo_Palestra, pa.nome_palestrante AS Nome_Palestrante,
       p.carga_horaria AS Carga_Horaria, p.data_palestra AS DATA_Palestra, p.cod AS Cod_Palestra

FROM palestra p 
INNER JOIN palestrante pa ON pa.cod = p.cod_palestrante 

SELECT * FROM v_lista_presenca
ORDER BY  Nome_Pessoa, Nome__NaoAluno, Cod_Palestra


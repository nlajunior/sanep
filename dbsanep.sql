USE [dbsap_teste]
GO
/****** Object:  User [sap]    Script Date: 12/10/2013 15:43:55 ******/
CREATE USER [sap] FOR LOGIN [sap] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[tb_grupo]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_grupo](
	[id_grup] [smallint] IDENTITY(1,1) NOT NULL,
	[nome_grup] [varchar](30) NOT NULL
) ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[tb_grupo] ADD [ativo_grup] [varchar](1) NOT NULL
ALTER TABLE [dbo].[tb_grupo] ADD  CONSTRAINT [PK_GRUPO] PRIMARY KEY CLUSTERED 
(
	[id_grup] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_feriado]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tb_feriado](
	[id_feri] [int] IDENTITY(1,1) NOT NULL,
	[nome_feri] [varchar](255) NULL,
	[data_feri] [datetime] NOT NULL,
	[ativo_feri] [varchar](1) NULL,
 CONSTRAINT [PK_FERIADO] PRIMARY KEY CLUSTERED 
(
	[id_feri] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_disciplina]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_disciplina](
	[id_disc] [int] IDENTITY(1,1) NOT NULL,
	[nome_disc] [varchar](50) NOT NULL,
	[ch_disc] [smallint] NOT NULL,
	[ativo_disc] [varchar](1) NOT NULL,
 CONSTRAINT [PK_DISCIPLINA] PRIMARY KEY CLUSTERED 
(
	[id_disc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_data]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_data](
	[id_data] [int] IDENTITY(1,1) NOT NULL,
	[data_data] [datetime] NOT NULL,
 CONSTRAINT [PK_DATA] PRIMARY KEY CLUSTERED 
(
	[id_data] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tb_modalidade]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_modalidade](
	[id_mod] [smallint] IDENTITY(1,1) NOT NULL,
	[nome_mod] [varchar](40) NOT NULL,
	[ativo_mod] [varchar](1) NOT NULL,
	[cor_mod] [varchar](7) NULL,
	[sigla_mod] [varchar](3) NULL,
 CONSTRAINT [PK_MODALIDADE] PRIMARY KEY CLUSTERED 
(
	[id_mod] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_class_amb]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_class_amb](
	[id_class] [smallint] IDENTITY(1,1) NOT NULL,
	[nome_class] [varchar](30) NOT NULL,
	[ativo_class] [varchar](1) NOT NULL,
 CONSTRAINT [PK_CLASS_AMB] PRIMARY KEY CLUSTERED 
(
	[id_class] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[FNSomaDiasUteis]    Script Date: 12/10/2013 15:43:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FNSomaDiasUteis] (@DtInicial DATETIME, @DtFinal DATETIME) 
RETURNS DATETIME 
AS 
BEGIN 
-- Variaveis 
DECLARE @QtDias INT 
DECLARE @DtRetorno DATETIME 
DECLARE @Idx INT 

-- Apura quantos dias entre a data inicio e fim 
SELECT @QtDias = DATEDIFF(DAY, @DtInicial, @DtFinal) 

-- Controle do loop e inicializacao 
SELECT @Idx = 0 
SELECT @DtRetorno = @DtInicial 

-- Loop 
WHILE @Idx < @QtDias 
BEGIN 
-- Incrementa 1 dia, sempre 
SELECT @DtRetorno = DATEADD(DAY, 1, @DtRetorno) 

-- Somente incrementa o controle do loop quando for dia util 
IF DATEPART(DW, @DtRetorno) IN (2,3,4,5,6) 
BEGIN 
-- Verifica se nao esta na tabela de feriados 
--IF NOT EXISTS (SELECT * 
--FROM Feriados 
--WHERE DtFeriado = @DtRetorno) 
BEGIN 
SELECT @Idx = @Idx + 1 
END 
END 
END 

RETURN @DtRetorno 
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetWokDays]    Script Date: 12/10/2013 15:43:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FN_GetWokDays] (@DateStart smalldatetime , @DateEnd Datetime)  
RETURNS Int  
AS  
BEGIN  
 Declare @Count Int  
 Select @Count = 0
 While @DateStart <= @DateEnd  
 Begin  
  If DatePart(WeekDay, @DateStart) Not In (7,1)-- And @DateStart Not In ( Select Holiday_Date from Holiday )  -- para os feriados tem que ter uma tabela
      Select @Count = @Count + 1 

    Select @DateStart = Dateadd(day,1,@DateStart)
 End  
 RETURN  @Count 
END
GO
/****** Object:  View [dbo].[financeiroporeventov]    Script Date: 12/10/2013 15:43:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[financeiroporeventov]
  AS
    SELECT 
  
      ac.id_acao,
      ac.titulo_acao, 
      ac.ch_acao,
      ac.vl_acao,
      
      lot.matricula_tec AS matricula, 
      tec.nome_tec AS nome,
      tec.vlhora_tec,
      at.vht_ati, 
      at.id_ati AS id,
      
      
      CONVERT(VARCHAR(10),at.dexecucao_ati, 103) AS data,
      at.horainicio_ati, 
      at.horafinal_ati,
      CONVERT(VARCHAR(10),at.dexecucao_ati, 103) AS executado,
      --CONVERT(VARCHAR(5), at.horainicio_ati,108) AS horainicio_ati,
      --CONVERT(VARCHAR(5), at.horafinal_ati,108) AS horafinal_ati,
      
      (DATEDIFF(MINUTE,at.horainicio_ati,at.horafinal_ati)*tec.vlhora_tec)/60 AS valor,
      --CONVERT(VARCHAR(5),(at.horafinal_ati-at.horainicio_ati),108) AS horas
      DATEDIFF(MINUTE,at.horainicio_ati,at.horafinal_ati) AS minutos
 
    FROM tb_atividade at 
  
    INNER JOIN tb_acao ac
    ON at.id_acao=ac.id_acao
    INNER JOIN tb_lotacao lot
    ON at.id_lotacao=lot.id_lotacao
  
    INNER JOIN tb_tecnico tec
    ON lot.matricula_tec=tec.matricula_tec
GO
/****** Object:  Table [dbo].[tb_turno]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tb_turno](
	[id_turn] [smallint] IDENTITY(1,1) NOT NULL,
	[nome_turn] [varchar](20) NOT NULL,
 CONSTRAINT [PK_TURNO] PRIMARY KEY CLUSTERED 
(
	[id_turn] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[viewteste]    Script Date: 12/10/2013 15:43:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewteste]
  AS
  SELECT 
  atividade.id_taref,
  atividade.id_proj,
  acao.valor_acao2,
  DATEDIFF(MINUTE, acao.hinicio_acao2, acao.hfinal_acao2) as tempo,
  tecnico.nome_tec
FROM tb_tarefa atividade    
  
  INNER JOIN tb_acao2 acao
  ON atividade.id_taref=acao.id_taref   
  
  INNER JOIN tb_lotacao lotacao
  ON acao.id_lotacao=lotacao.id_lotacao
  
  INNER JOIN tb_tecnico tecnico
  ON lotacao.matricula_tec=tecnico.matricula_tec
GO
/****** Object:  View [dbo].[teste]    Script Date: 12/10/2013 15:43:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[teste] as
 
 SELECT  
         --lotacao.id_cr AS 'ID CR de Origem',
         cro.codigo_cr AS 'cro',
         cro.nome_cr AS 'nomeCRorigem',
         --lota.matricula_tec AS 'Matricula',
         
         --cre.id_cr AS 'ID CR Evento', 
         cre.codigo_cr as 'cre', 
         cre.nome_cr AS 'nomeCRevento', 
         
         --area.nome_area AS 'Área', 
         --ac.titulo_acao AS 'Evento', 
         --atv.desc_ati AS 'Atividade',
         
         atividade.vht_ati,
         --CONVERT(VARCHAR(5),(atividade.horafinal_ati-atividade.horainicio_ati),108) AS 'Horas',
         atividade.horainicio_ati,
         atividade.horafinal_ati,
         atividade.dexecucao_ati AS 'data'
         --atv.id_lotacao
         
  FROM tb_atividade atividade
  
  INNER JOIN tb_acao evento
  ON atividade.id_acao=evento.id_acao
    
  INNER JOIN tb_curso_area area 
  ON evento.id_area=area.id_area
 
  INNER JOIN tb_cr cre
  ON area.id_cr=cre.id_cr 
  
  INNER JOIN tb_lotacao lotacao
  ON atividade.id_lotacao=lotacao.id_lotacao
  
  INNER JOIN tb_cr cro
  ON lotacao.id_cr=cro.id_cr   
  
  WHERE cre.id_cr!=lotacao.id_cr
GO
/****** Object:  Table [dbo].[tb_usuario]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_usuario](
	[id_usu] [int] IDENTITY(1,1) NOT NULL,
	[nome_usu] [varchar](50) NOT NULL,
	[cpf_usu] [varchar](14) NOT NULL,
	[login_usu] [varchar](30) NULL,
	[email_usu] [varchar](40) NULL,
	[senha_usu] [varchar](200) NULL,
	[id_grup] [smallint] NULL,
	[ativo_usu] [varchar](1) NOT NULL,
	[class_usu] [varchar](4) NULL,
 CONSTRAINT [PK_USUARIO] PRIMARY KEY CLUSTERED 
(
	[id_usu] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_ambiente]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tb_ambiente](
	[id_ambi] [int] IDENTITY(1,1) NOT NULL,
	[nome_ambi] [varchar](40) NOT NULL,
	[id_class] [smallint] NOT NULL,
	[pai_ambi] [int] NULL,
	[capacidade_ambi] [smallint] NULL,
	[ativo_ambi] [varchar](1) NOT NULL,
 CONSTRAINT [PK_AMBIENTE] PRIMARY KEY CLUSTERED 
(
	[id_ambi] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_curso]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_curso](
	[id_curs] [int] IDENTITY(1,1) NOT NULL,
	[nome_curs] [varchar](80) NOT NULL,
	[ch_curs] [smallint] NULL,
	[id_mod] [smallint] NOT NULL,
	[ativo_curs] [varchar](1) NOT NULL,
 CONSTRAINT [PK_CURSO] PRIMARY KEY CLUSTERED 
(
	[id_curs] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_permissao]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_permissao](
	[id_permi] [smallint] IDENTITY(1,1) NOT NULL,
	[tipo_permi] [smallint] NOT NULL,
	[pagina_permi] [varchar](40) NOT NULL,
	[id_grup] [smallint] NOT NULL,
	[ativo_permi] [varchar](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_permi] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_horario]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_horario](
	[id_hor] [smallint] IDENTITY(1,1) NOT NULL,
	[letra_hor] [varchar](10) NOT NULL,
	[inicio_hor] [datetime] NOT NULL,
	[fim_hor] [datetime] NOT NULL,
	[id_turn] [smallint] NOT NULL,
	[ativo_hor] [varchar](1) NOT NULL,
 CONSTRAINT [PK_HORARIO] PRIMARY KEY CLUSTERED 
(
	[id_hor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_curso_disciplina]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_curso_disciplina](
	[id_curs] [int] NOT NULL,
	[id_disc] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tb_turma]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_turma](
	[id_turm] [int] IDENTITY(1,1) NOT NULL,
	[nome_turm] [varchar](80) NOT NULL,
	[sem_turm] [varchar](6) NOT NULL,
	[qt_alunos_turm] [smallint] NULL,
	[id_curs] [int] NOT NULL,
	[id_clien] [int] NULL,
	[turn_turm] [varchar](1) NULL,
	[ativo_turm] [varchar](1) NOT NULL,
 CONSTRAINT [PK_TURMA] PRIMARY KEY CLUSTERED 
(
	[id_turm] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_turma_turno]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_turma_turno](
	[id_turm] [int] NOT NULL,
	[id_turn] [smallint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tb_calendario]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tb_calendario](
	[id_calen] [int] IDENTITY(1,1) NOT NULL,
	[id_usu] [int] NOT NULL,
	[id_ambi] [int] NOT NULL,
	[id_disc] [int] NOT NULL,
	[id_turm] [int] NOT NULL,
	[dl_calen] [smallint] NULL,
	[inicio_calen] [datetime] NOT NULL,
	[final_calen] [datetime] NOT NULL,
	[ativo_calen] [varchar](1) NOT NULL,
 CONSTRAINT [PK_CALENDARIO] PRIMARY KEY CLUSTERED 
(
	[id_calen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_calendario_dia_hora]    Script Date: 12/10/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_calendario_dia_hora](
	[id_dia_hora] [int] IDENTITY(1,1) NOT NULL,
	[id_hor] [smallint] NOT NULL,
	[id_data] [int] NOT NULL,
	[id_calen] [int] NOT NULL,
 CONSTRAINT [PK_CALENDARIODATA] PRIMARY KEY CLUSTERED 
(
	[id_dia_hora] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Default [DF__tb_ambien__ativo__59511E61]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_ambiente] ADD  DEFAULT ('S') FOR [ativo_ambi]
GO
/****** Object:  Default [DF__tb_calend__ativo__61E66462]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_calendario] ADD  DEFAULT ('S') FOR [ativo_calen]
GO
/****** Object:  Default [DF__tb_class___ativo__4A0EDAD1]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_class_amb] ADD  DEFAULT ('S') FOR [ativo_class]
GO
/****** Object:  Default [DF__tb_curso__ativo___7C9A5A9E]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_curso] ADD  DEFAULT ('S') FOR [ativo_curs]
GO
/****** Object:  Default [DF__tb_discip__ativo__78C9C9BA]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_disciplina] ADD  DEFAULT ('S') FOR [ativo_disc]
GO
/****** Object:  Default [DF__tb_feriad__ativo__51AFFC99]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_feriado] ADD  DEFAULT ('S') FOR [ativo_feri]
GO
/****** Object:  Default [DF__tb_grupo__ativo___4ED38FEE]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_grupo] ADD  DEFAULT ('S') FOR [ativo_grup]
GO
/****** Object:  Default [DF__tb_horari__ativo__015F0FBB]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_horario] ADD  DEFAULT ('S') FOR [ativo_hor]
GO
/****** Object:  Default [DF__tb_modali__ativo__47326E26]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_modalidade] ADD  DEFAULT ('S') FOR [ativo_mod]
GO
/****** Object:  Default [DF__tb_permis__ativo__1B1EE1BE]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_permissao] ADD  DEFAULT ('S') FOR [ativo_permi]
GO
/****** Object:  Default [DF__tb_turma__ativo___0BDC9E2E]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_turma] ADD  DEFAULT ('S') FOR [ativo_turm]
GO
/****** Object:  Default [DF__tb_usuari__ativo__6C63F2D5]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_usuario] ADD  DEFAULT ('S') FOR [ativo_usu]
GO
/****** Object:  Default [DF__tb_usuari__class__6D58170E]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_usuario] ADD  DEFAULT ('U') FOR [class_usu]
GO
/****** Object:  ForeignKey [fk_tb_ambiente_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_ambiente]  WITH CHECK ADD  CONSTRAINT [fk_tb_ambiente_01] FOREIGN KEY([id_class])
REFERENCES [dbo].[tb_class_amb] ([id_class])
GO
ALTER TABLE [dbo].[tb_ambiente] CHECK CONSTRAINT [fk_tb_ambiente_01]
GO
/****** Object:  ForeignKey [fk_tb_ambiente_02]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_ambiente]  WITH CHECK ADD  CONSTRAINT [fk_tb_ambiente_02] FOREIGN KEY([pai_ambi])
REFERENCES [dbo].[tb_ambiente] ([id_ambi])
GO
ALTER TABLE [dbo].[tb_ambiente] CHECK CONSTRAINT [fk_tb_ambiente_02]
GO
/****** Object:  ForeignKey [fk_tb_calendario_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_calendario]  WITH CHECK ADD  CONSTRAINT [fk_tb_calendario_01] FOREIGN KEY([id_usu])
REFERENCES [dbo].[tb_usuario] ([id_usu])
GO
ALTER TABLE [dbo].[tb_calendario] CHECK CONSTRAINT [fk_tb_calendario_01]
GO
/****** Object:  ForeignKey [fk_tb_calendario_02]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_calendario]  WITH CHECK ADD  CONSTRAINT [fk_tb_calendario_02] FOREIGN KEY([id_ambi])
REFERENCES [dbo].[tb_ambiente] ([id_ambi])
GO
ALTER TABLE [dbo].[tb_calendario] CHECK CONSTRAINT [fk_tb_calendario_02]
GO
/****** Object:  ForeignKey [fk_tb_calendario_03]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_calendario]  WITH CHECK ADD  CONSTRAINT [fk_tb_calendario_03] FOREIGN KEY([id_disc])
REFERENCES [dbo].[tb_disciplina] ([id_disc])
GO
ALTER TABLE [dbo].[tb_calendario] CHECK CONSTRAINT [fk_tb_calendario_03]
GO
/****** Object:  ForeignKey [fk_tb_calendario_04]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_calendario]  WITH CHECK ADD  CONSTRAINT [fk_tb_calendario_04] FOREIGN KEY([id_turm])
REFERENCES [dbo].[tb_turma] ([id_turm])
GO
ALTER TABLE [dbo].[tb_calendario] CHECK CONSTRAINT [fk_tb_calendario_04]
GO
/****** Object:  ForeignKey [fk_tb_calendario_data_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_calendario_dia_hora]  WITH CHECK ADD  CONSTRAINT [fk_tb_calendario_data_01] FOREIGN KEY([id_data])
REFERENCES [dbo].[tb_data] ([id_data])
GO
ALTER TABLE [dbo].[tb_calendario_dia_hora] CHECK CONSTRAINT [fk_tb_calendario_data_01]
GO
/****** Object:  ForeignKey [fk_tb_calendario_data_02]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_calendario_dia_hora]  WITH CHECK ADD  CONSTRAINT [fk_tb_calendario_data_02] FOREIGN KEY([id_hor])
REFERENCES [dbo].[tb_horario] ([id_hor])
GO
ALTER TABLE [dbo].[tb_calendario_dia_hora] CHECK CONSTRAINT [fk_tb_calendario_data_02]
GO
/****** Object:  ForeignKey [fk_tb_calendario_data_03]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_calendario_dia_hora]  WITH CHECK ADD  CONSTRAINT [fk_tb_calendario_data_03] FOREIGN KEY([id_calen])
REFERENCES [dbo].[tb_calendario] ([id_calen])
GO
ALTER TABLE [dbo].[tb_calendario_dia_hora] CHECK CONSTRAINT [fk_tb_calendario_data_03]
GO
/****** Object:  ForeignKey [fk_tb_curso_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_curso]  WITH CHECK ADD  CONSTRAINT [fk_tb_curso_01] FOREIGN KEY([id_mod])
REFERENCES [dbo].[tb_modalidade] ([id_mod])
GO
ALTER TABLE [dbo].[tb_curso] CHECK CONSTRAINT [fk_tb_curso_01]
GO
/****** Object:  ForeignKey [fk_tb_curso_disciplina_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_curso_disciplina]  WITH CHECK ADD  CONSTRAINT [fk_tb_curso_disciplina_01] FOREIGN KEY([id_curs])
REFERENCES [dbo].[tb_curso] ([id_curs])
GO
ALTER TABLE [dbo].[tb_curso_disciplina] CHECK CONSTRAINT [fk_tb_curso_disciplina_01]
GO
/****** Object:  ForeignKey [fk_tb_curso_disciplina_02]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_curso_disciplina]  WITH CHECK ADD  CONSTRAINT [fk_tb_curso_disciplina_02] FOREIGN KEY([id_disc])
REFERENCES [dbo].[tb_disciplina] ([id_disc])
GO
ALTER TABLE [dbo].[tb_curso_disciplina] CHECK CONSTRAINT [fk_tb_curso_disciplina_02]
GO
/****** Object:  ForeignKey [fk_tb_horario_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_horario]  WITH CHECK ADD  CONSTRAINT [fk_tb_horario_01] FOREIGN KEY([id_turn])
REFERENCES [dbo].[tb_turno] ([id_turn])
GO
ALTER TABLE [dbo].[tb_horario] CHECK CONSTRAINT [fk_tb_horario_01]
GO
/****** Object:  ForeignKey [fk_tb_permissao_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_permissao]  WITH CHECK ADD  CONSTRAINT [fk_tb_permissao_01] FOREIGN KEY([id_grup])
REFERENCES [dbo].[tb_grupo] ([id_grup])
GO
ALTER TABLE [dbo].[tb_permissao] CHECK CONSTRAINT [fk_tb_permissao_01]
GO
/****** Object:  ForeignKey [fk_tb_turma_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_turma]  WITH CHECK ADD  CONSTRAINT [fk_tb_turma_01] FOREIGN KEY([id_curs])
REFERENCES [dbo].[tb_curso] ([id_curs])
GO
ALTER TABLE [dbo].[tb_turma] CHECK CONSTRAINT [fk_tb_turma_01]
GO
/****** Object:  ForeignKey [fk_tb_turma_turno_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_turma_turno]  WITH CHECK ADD  CONSTRAINT [fk_tb_turma_turno_01] FOREIGN KEY([id_turn])
REFERENCES [dbo].[tb_turno] ([id_turn])
GO
ALTER TABLE [dbo].[tb_turma_turno] CHECK CONSTRAINT [fk_tb_turma_turno_01]
GO
/****** Object:  ForeignKey [fk_tb_turma_turno_02]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_turma_turno]  WITH CHECK ADD  CONSTRAINT [fk_tb_turma_turno_02] FOREIGN KEY([id_turm])
REFERENCES [dbo].[tb_turma] ([id_turm])
GO
ALTER TABLE [dbo].[tb_turma_turno] CHECK CONSTRAINT [fk_tb_turma_turno_02]
GO
/****** Object:  ForeignKey [fk_tb_usuario_01]    Script Date: 12/10/2013 15:43:54 ******/
ALTER TABLE [dbo].[tb_usuario]  WITH CHECK ADD  CONSTRAINT [fk_tb_usuario_01] FOREIGN KEY([id_grup])
REFERENCES [dbo].[tb_grupo] ([id_grup])
GO
ALTER TABLE [dbo].[tb_usuario] CHECK CONSTRAINT [fk_tb_usuario_01]
GO

USE [master]
GO
/****** Object:  Database [HomeCareProBD]    Script Date: 28/6/2024 19:42:19 ******/
CREATE DATABASE [HomeCareProBD]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HomeCareProBD', FILENAME = N'D:\Programas\MSSQL14.SQLEXPRESS\MSSQL\DATA\HomeCareProBD.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HomeCareProBD_log', FILENAME = N'D:\Programas\MSSQL14.SQLEXPRESS\MSSQL\DATA\HomeCareProBD_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [HomeCareProBD] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HomeCareProBD].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HomeCareProBD] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HomeCareProBD] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HomeCareProBD] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HomeCareProBD] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HomeCareProBD] SET ARITHABORT OFF 
GO
ALTER DATABASE [HomeCareProBD] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HomeCareProBD] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HomeCareProBD] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HomeCareProBD] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HomeCareProBD] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HomeCareProBD] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HomeCareProBD] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HomeCareProBD] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HomeCareProBD] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HomeCareProBD] SET  DISABLE_BROKER 
GO
ALTER DATABASE [HomeCareProBD] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HomeCareProBD] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HomeCareProBD] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HomeCareProBD] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HomeCareProBD] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HomeCareProBD] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HomeCareProBD] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HomeCareProBD] SET RECOVERY FULL 
GO
ALTER DATABASE [HomeCareProBD] SET  MULTI_USER 
GO
ALTER DATABASE [HomeCareProBD] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HomeCareProBD] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HomeCareProBD] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HomeCareProBD] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HomeCareProBD] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [HomeCareProBD] SET QUERY_STORE = OFF
GO
USE [HomeCareProBD]
GO
/****** Object:  User [santiagopalma]    Script Date: 28/6/2024 19:42:19 ******/
CREATE USER [santiagopalma] FOR LOGIN [santiagopalma] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [santiagopalma]
GO
/****** Object:  Table [dbo].[Caso]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Caso](
	[IdCaso] [int] IDENTITY(1,1) NOT NULL,
	[IdPaciente] [int] NOT NULL,
	[IdPrestador] [int] NOT NULL,
	[IdPrestacion] [int] NOT NULL,
	[FechaOcurrencia] [date] NOT NULL,
	[FechaSolicitud] [date] NOT NULL,
	[Diagnostico] [varchar](50) NOT NULL,
	[CantDias] [int] NOT NULL,
	[CantHorasDias] [int] NOT NULL,
	[EnCurso] [bit] NULL,
 CONSTRAINT [PK_Caso] PRIMARY KEY CLUSTERED 
(
	[IdCaso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Especialidad]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Especialidad](
	[IdEspecialidad] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Especialidad] PRIMARY KEY CLUSTERED 
(
	[IdEspecialidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InformeDia]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InformeDia](
	[IdInformeDia] [int] IDENTITY(1,1) NOT NULL,
	[IdCaso] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_InformeDia] PRIMARY KEY CLUSTERED 
(
	[IdInformeDia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Insumo]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Insumo](
	[IdInsumo] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Precio] [int] NOT NULL,
 CONSTRAINT [PK_Insumo] PRIMARY KEY CLUSTERED 
(
	[IdInsumo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsumoXCaso]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsumoXCaso](
	[IdInsumoXCaso] [int] IDENTITY(1,1) NOT NULL,
	[IdInsumo] [int] NOT NULL,
	[IdCaso] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
 CONSTRAINT [PK_InsumoXCaso] PRIMARY KEY CLUSTERED 
(
	[IdInsumoXCaso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paciente]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Paciente](
	[IdPaciente] [int] IDENTITY(1,1) NOT NULL,
	[Dni] [int] NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Apellido] [varchar](50) NOT NULL,
	[Direccion] [varchar](50) NOT NULL,
	[Localidad] [varchar](50) NOT NULL,
	[Telefono] [int] NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
 CONSTRAINT [PK_Paciente] PRIMARY KEY CLUSTERED 
(
	[IdPaciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prestacion]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prestacion](
	[IdPrestacion] [int] IDENTITY(1,1) NOT NULL,
	[IdEspecialidad] [int] NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[ValorHora] [int] NOT NULL,
 CONSTRAINT [PK_Prestacion] PRIMARY KEY CLUSTERED 
(
	[IdPrestacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prestador]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prestador](
	[IdPrestador] [int] IDENTITY(1,1) NOT NULL,
	[IdEspecialidad] [int] NOT NULL,
	[Dni] [int] NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Apellido] [varchar](50) NOT NULL,
	[Direccion] [varchar](50) NOT NULL,
	[Localidad] [varchar](50) NOT NULL,
	[Telefono] [int] NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Genero] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Prestador] PRIMARY KEY CLUSTERED 
(
	[IdPrestador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Especialidad] ON 

INSERT [dbo].[Especialidad] ([IdEspecialidad], [Nombre]) VALUES (1, N'Enfermero')
INSERT [dbo].[Especialidad] ([IdEspecialidad], [Nombre]) VALUES (2, N'Kinesiologo')
INSERT [dbo].[Especialidad] ([IdEspecialidad], [Nombre]) VALUES (3, N'Clínica Médica')
INSERT [dbo].[Especialidad] ([IdEspecialidad], [Nombre]) VALUES (4, N'Pediatría')
INSERT [dbo].[Especialidad] ([IdEspecialidad], [Nombre]) VALUES (5, N'Cardiología')
INSERT [dbo].[Especialidad] ([IdEspecialidad], [Nombre]) VALUES (6, N'Neurología')
INSERT [dbo].[Especialidad] ([IdEspecialidad], [Nombre]) VALUES (7, N'Oftalmología')
SET IDENTITY_INSERT [dbo].[Especialidad] OFF
GO
SET IDENTITY_INSERT [dbo].[Insumo] ON 

INSERT [dbo].[Insumo] ([IdInsumo], [Nombre], [Precio]) VALUES (1, N'Jeringas', 50)
INSERT [dbo].[Insumo] ([IdInsumo], [Nombre], [Precio]) VALUES (2, N'Gasas', 30)
INSERT [dbo].[Insumo] ([IdInsumo], [Nombre], [Precio]) VALUES (3, N'Medicamentos', 200)
INSERT [dbo].[Insumo] ([IdInsumo], [Nombre], [Precio]) VALUES (4, N'Vendas', 40)
INSERT [dbo].[Insumo] ([IdInsumo], [Nombre], [Precio]) VALUES (5, N'Guantes', 20)
SET IDENTITY_INSERT [dbo].[Insumo] OFF
GO
SET IDENTITY_INSERT [dbo].[Paciente] ON 

INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (1, 12345678, N'Juan', N'Pérez', N'Av. Libertador 123', N'Buenos Aires', 1122334455, CAST(N'1980-05-10' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (2, 23456789, N'María', N'González', N'Calle Rivadavia 456', N'Córdoba', 1122334466, CAST(N'1990-07-15' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (3, 34567890, N'Carlos', N'López', N'Av. San Martín 789', N'Rosario', 1122334477, CAST(N'1985-03-20' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (4, 45678901, N'Laura', N'Martínez', N'Calle Belgrano 234', N'Mendoza', 1122334488, CAST(N'1995-01-25' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (5, 56789012, N'Pedro', N'Sánchez', N'Av. 9 de Julio 567', N'Salta', 1122334499, CAST(N'1982-11-05' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (6, 12345678, N'Juan', N'Pérez', N'Av. Libertador 123', N'Buenos Aires', 1122334455, CAST(N'1980-05-10' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (7, 23456789, N'María', N'González', N'Calle Rivadavia 456', N'Córdoba', 1122334466, CAST(N'1990-07-15' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (8, 34567890, N'Carlos', N'López', N'Av. San Martín 789', N'Rosario', 1122334477, CAST(N'1985-03-20' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (9, 45678901, N'Laura', N'Martínez', N'Calle Belgrano 234', N'Mendoza', 1122334488, CAST(N'1995-01-25' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (10, 56789012, N'Pedro', N'Sánchez', N'Av. 9 de Julio 567', N'Salta', 1122334499, CAST(N'1982-11-05' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (11, 12345678, N'Juan', N'Pérez', N'Av. Libertador 123', N'Buenos Aires', 1122334455, CAST(N'1980-05-10' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (12, 23456789, N'María', N'González', N'Calle Rivadavia 456', N'Córdoba', 1122334455, CAST(N'1990-07-15' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (13, 34567890, N'Carlos', N'López', N'Av. San Martín 789', N'Rosario', 1122334455, CAST(N'1985-03-20' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (14, 45678901, N'Laura', N'Martínez', N'Calle Belgrano 234', N'Mendoza', 1122334455, CAST(N'1995-01-25' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (15, 56789012, N'Pedro', N'Sánchez', N'Av. 9 de Julio 567', N'Salta', 1122334455, CAST(N'1982-11-05' AS Date))
SET IDENTITY_INSERT [dbo].[Paciente] OFF
GO
SET IDENTITY_INSERT [dbo].[Prestacion] ON 

INSERT [dbo].[Prestacion] ([IdPrestacion], [IdEspecialidad], [Nombre], [ValorHora]) VALUES (1, 1, N'Consulta General', 300)
INSERT [dbo].[Prestacion] ([IdPrestacion], [IdEspecialidad], [Nombre], [ValorHora]) VALUES (2, 1, N'Control de Rutina', 250)
INSERT [dbo].[Prestacion] ([IdPrestacion], [IdEspecialidad], [Nombre], [ValorHora]) VALUES (3, 2, N'Pediatría General', 280)
INSERT [dbo].[Prestacion] ([IdPrestacion], [IdEspecialidad], [Nombre], [ValorHora]) VALUES (4, 3, N'Evaluación Cardíaca', 400)
INSERT [dbo].[Prestacion] ([IdPrestacion], [IdEspecialidad], [Nombre], [ValorHora]) VALUES (5, 4, N'Consulta Neurológica', 350)
SET IDENTITY_INSERT [dbo].[Prestacion] OFF
GO
ALTER TABLE [dbo].[Caso]  WITH CHECK ADD  CONSTRAINT [FK_Caso_Paciente] FOREIGN KEY([IdPaciente])
REFERENCES [dbo].[Paciente] ([IdPaciente])
GO
ALTER TABLE [dbo].[Caso] CHECK CONSTRAINT [FK_Caso_Paciente]
GO
ALTER TABLE [dbo].[Caso]  WITH CHECK ADD  CONSTRAINT [FK_Caso_Prestacion] FOREIGN KEY([IdPrestacion])
REFERENCES [dbo].[Prestacion] ([IdPrestacion])
GO
ALTER TABLE [dbo].[Caso] CHECK CONSTRAINT [FK_Caso_Prestacion]
GO
ALTER TABLE [dbo].[Caso]  WITH CHECK ADD  CONSTRAINT [FK_Caso_Prestador] FOREIGN KEY([IdPrestador])
REFERENCES [dbo].[Prestador] ([IdPrestador])
GO
ALTER TABLE [dbo].[Caso] CHECK CONSTRAINT [FK_Caso_Prestador]
GO
ALTER TABLE [dbo].[InformeDia]  WITH CHECK ADD  CONSTRAINT [FK_InformeDia_Caso] FOREIGN KEY([IdCaso])
REFERENCES [dbo].[Caso] ([IdCaso])
GO
ALTER TABLE [dbo].[InformeDia] CHECK CONSTRAINT [FK_InformeDia_Caso]
GO
ALTER TABLE [dbo].[InsumoXCaso]  WITH CHECK ADD  CONSTRAINT [FK_InsumoXCaso_Caso] FOREIGN KEY([IdCaso])
REFERENCES [dbo].[Caso] ([IdCaso])
GO
ALTER TABLE [dbo].[InsumoXCaso] CHECK CONSTRAINT [FK_InsumoXCaso_Caso]
GO
ALTER TABLE [dbo].[InsumoXCaso]  WITH CHECK ADD  CONSTRAINT [FK_InsumoXCaso_Insumo] FOREIGN KEY([IdInsumo])
REFERENCES [dbo].[Insumo] ([IdInsumo])
GO
ALTER TABLE [dbo].[InsumoXCaso] CHECK CONSTRAINT [FK_InsumoXCaso_Insumo]
GO
ALTER TABLE [dbo].[Prestacion]  WITH CHECK ADD  CONSTRAINT [FK_Prestacion_Especialidad] FOREIGN KEY([IdEspecialidad])
REFERENCES [dbo].[Especialidad] ([IdEspecialidad])
GO
ALTER TABLE [dbo].[Prestacion] CHECK CONSTRAINT [FK_Prestacion_Especialidad]
GO
ALTER TABLE [dbo].[Prestador]  WITH CHECK ADD  CONSTRAINT [FK_Prestador_Especialidad] FOREIGN KEY([IdEspecialidad])
REFERENCES [dbo].[Especialidad] ([IdEspecialidad])
GO
ALTER TABLE [dbo].[Prestador] CHECK CONSTRAINT [FK_Prestador_Especialidad]
GO
/****** Object:  StoredProcedure [dbo].[asistenciasEnCurso]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[asistenciasEnCurso]
@estado bit
as
begin
select Paciente.Nombre, Paciente.Apellido 
from Caso 
inner join Paciente on Caso.IdPaciente = Paciente.IdPaciente
where Caso.EnCurso = @estado
end
GO
/****** Object:  StoredProcedure [dbo].[datosPacienteYMedico]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[datosPacienteYMedico]
@pacienteId int
as
begin
select Paciente.Nombre, Paciente.Apellido, Paciente.Dni, Paciente.Direccion, Paciente.Telefono, Paciente.FechaNacimiento, Prestador. Nombre as "Nombre Medico", Prestador.Apellido as "Apellido Medico", Prestador.Dni as "Dni Medico", Prestador.Telefono as "Telefono Medico", Prestador.Email as "Email Medico"
from Caso 
inner join Paciente on Caso.IdPaciente = Paciente.IdPaciente
inner join Prestador on Caso.IdPrestador = Prestador.IdPrestador

where Paciente.IdPaciente = @pacienteID
end
GO
/****** Object:  StoredProcedure [dbo].[procesoPaciente]    Script Date: 28/6/2024 19:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[procesoPaciente]
@paciente int
as
begin
select InformeDia.Fecha, InformeDia.Descripcion 
from Caso 
inner join InformeDia on Caso.IdCaso = InformeDia.IdCaso
inner join Paciente on Caso.IdPaciente = Paciente.IdPaciente
where Paciente.IdPaciente = @paciente
end
GO
USE [master]
GO
ALTER DATABASE [HomeCareProBD] SET  READ_WRITE 
GO

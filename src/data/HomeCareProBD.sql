USE [master]
GO
/****** Object:  Database [HomeCareProBD]    Script Date: 23/9/2024 09:06:42 ******/
CREATE DATABASE [HomeCareProBD]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HomeCareProBD', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\HomeCareProBD.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HomeCareProBD_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\HomeCareProBD_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
EXEC sys.sp_db_vardecimal_storage_format N'HomeCareProBD', N'ON'
GO
ALTER DATABASE [HomeCareProBD] SET QUERY_STORE = OFF
GO
USE [HomeCareProBD]
GO
/****** Object:  User [alumno]    Script Date: 23/9/2024 09:06:42 ******/
CREATE USER [alumno] FOR LOGIN [alumno] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Caso]    Script Date: 23/9/2024 09:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Caso](
	[IdCaso] [int] IDENTITY(1,1) NOT NULL,
	[IdPaciente] [int] NOT NULL,
	[IdPrestador] [int] NULL,
	[IdPrestacion] [int] NULL,
	[FechaOcurrencia] [date] NULL,
	[FechaSolicitud] [date] NOT NULL,
	[Diagnostico] [varchar](50) NOT NULL,
	[CantDias] [int] NOT NULL,
	[CantHorasDias] [int] NOT NULL,
	[EnCurso] [bit] NULL,
	[IdSituacion] [int] NULL,
 CONSTRAINT [PK_Caso] PRIMARY KEY CLUSTERED 
(
	[IdCaso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Especialidad]    Script Date: 23/9/2024 09:06:42 ******/
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
/****** Object:  Table [dbo].[InformeDia]    Script Date: 23/9/2024 09:06:42 ******/
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
/****** Object:  Table [dbo].[Insumo]    Script Date: 23/9/2024 09:06:42 ******/
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
/****** Object:  Table [dbo].[InsumoXCaso]    Script Date: 23/9/2024 09:06:42 ******/
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
/****** Object:  Table [dbo].[Paciente]    Script Date: 23/9/2024 09:06:42 ******/
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
/****** Object:  Table [dbo].[Prestacion]    Script Date: 23/9/2024 09:06:42 ******/
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
/****** Object:  Table [dbo].[Prestador]    Script Date: 23/9/2024 09:06:42 ******/
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
	[Telefono] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Genero] [varchar](50) NOT NULL,
	[Contraseña] [varchar](50) NULL,
 CONSTRAINT [PK_Prestador] PRIMARY KEY CLUSTERED 
(
	[IdPrestador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Situacion]    Script Date: 23/9/2024 09:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Situacion](
	[IdSituacion] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NULL,
 CONSTRAINT [PK_Situacion] PRIMARY KEY CLUSTERED 
(
	[IdSituacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Caso] ON 

INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (3, 1, 1, 1, CAST(N'2024-06-01' AS Date), CAST(N'2024-06-02' AS Date), N'Gripe', 5, 6, 1, 2)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (4, 2, 2, 2, CAST(N'2024-06-03' AS Date), CAST(N'2024-06-04' AS Date), N'Control Pediátrico', 3, 4, 1, 1)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (5, 3, 3, 3, CAST(N'2024-06-05' AS Date), CAST(N'2024-06-06' AS Date), N'Arritmia', 2, 3, 0, 2)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (6, 4, 4, 4, CAST(N'2024-06-07' AS Date), CAST(N'2024-06-08' AS Date), N'Migraña', 4, 5, 1, 2)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (7, 5, 5, 5, CAST(N'2024-06-09' AS Date), CAST(N'2024-06-10' AS Date), N'Cataratas', 1, 2, 0, 3)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (8, 16, 5, 4, NULL, CAST(N'2024-08-12' AS Date), N'se siente mal', 2, 3, 0, 2)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (9, 16, 3, 2, NULL, CAST(N'2024-08-12' AS Date), N'se siente mal', 2, 3, 0, 2)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (10, 16, 1, 2, CAST(N'3333-03-03' AS Date), CAST(N'2024-08-12' AS Date), N'le duele la garganta', 6, 1, 0, 2)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (11, 16, 5, 3, CAST(N'2024-07-12' AS Date), CAST(N'2024-08-12' AS Date), N'se siente mal', 2, 3, 0, 3)
INSERT [dbo].[Caso] ([IdCaso], [IdPaciente], [IdPrestador], [IdPrestacion], [FechaOcurrencia], [FechaSolicitud], [Diagnostico], [CantDias], [CantHorasDias], [EnCurso], [IdSituacion]) VALUES (13, 5, 2, 4, CAST(N'3333-06-09' AS Date), CAST(N'2004-04-04' AS Date), N'dffff', 4, 4, 0, 2)
SET IDENTITY_INSERT [dbo].[Caso] OFF
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
SET IDENTITY_INSERT [dbo].[InformeDia] ON 

INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (1, 3, CAST(N'2024-07-01' AS Date), N'El paciente tiene mejoria')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (2, 4, CAST(N'2024-08-12' AS Date), N'dddd')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (3, 4, CAST(N'2024-08-12' AS Date), N'dddd')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (4, 3, CAST(N'2024-08-12' AS Date), N'dddd')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (5, 3, CAST(N'2024-08-12' AS Date), N'dddd')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (6, 3, CAST(N'2024-08-12' AS Date), N'esta mejor')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (7, 10, CAST(N'2024-08-12' AS Date), N'esta mejor')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (8, 10, CAST(N'2024-08-12' AS Date), N'holaaaaaaaa')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (9, 3, CAST(N'2024-08-12' AS Date), N'cccccccccc')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (10, 3, CAST(N'2024-08-12' AS Date), N'dddd')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (11, 10, CAST(N'2024-08-12' AS Date), N'jjjjjjjjjj')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (12, 3, CAST(N'2024-08-12' AS Date), N'dddddd')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (13, 3, CAST(N'2024-08-12' AS Date), N'rrrrrrrrrrrrrrrrrrrrrrrrrrr')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (14, 10, CAST(N'2024-08-12' AS Date), N'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (15, 3, CAST(N'2024-08-12' AS Date), N'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (16, 3, CAST(N'2024-08-12' AS Date), N'u')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (17, 3, CAST(N'2024-08-12' AS Date), N'l')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (18, 3, CAST(N'2024-08-12' AS Date), N'f')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (19, 3, CAST(N'2024-08-12' AS Date), N'fff')
INSERT [dbo].[InformeDia] ([IdInformeDia], [IdCaso], [Fecha], [Descripcion]) VALUES (20, 3, CAST(N'2024-08-12' AS Date), N'dd')
SET IDENTITY_INSERT [dbo].[InformeDia] OFF
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
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (16, 2222, N'marcos', N'Pasquale', N'jdjdndn33', N'caba', 18222222, CAST(N'2024-03-04' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (17, 2222, N'marcos', N'Pasquale', N'jdjdndn33', N'caba', 18222222, CAST(N'2024-03-04' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (18, 2222, N'marcos', N'Pasquale', N'jdjdndn33', N'caba', 18222222, CAST(N'2024-03-04' AS Date))
INSERT [dbo].[Paciente] ([IdPaciente], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [FechaNacimiento]) VALUES (19, 2222, N'marcos', N'Pasquale', N'jdjdndn33', N'caba', 18222222, CAST(N'2024-03-04' AS Date))
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
SET IDENTITY_INSERT [dbo].[Prestador] ON 

INSERT [dbo].[Prestador] ([IdPrestador], [IdEspecialidad], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [Email], [Genero], [Contraseña]) VALUES (1, 1, 98765432, N'Ana', N'Rodríguez', N'Av. Rivadavia 890', N'Buenos Aires', N'2233445566', N'ana.rodriguez@email.com', N'Femenino', N'hola')
INSERT [dbo].[Prestador] ([IdPrestador], [IdEspecialidad], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [Email], [Genero], [Contraseña]) VALUES (2, 2, 87654321, N'Juan', N'Gómez', N'Calle San Martín 567', N'Córdoba', N'2233445577', N'juan.gomez@email.com', N'Masculino', N'222')
INSERT [dbo].[Prestador] ([IdPrestador], [IdEspecialidad], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [Email], [Genero], [Contraseña]) VALUES (3, 3, 76543210, N'María', N'López', N'Av. Belgrano 234', N'Rosario', N'2233445588', N'maria.lopez@email.com', N'Femenino', N'111')
INSERT [dbo].[Prestador] ([IdPrestador], [IdEspecialidad], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [Email], [Genero], [Contraseña]) VALUES (4, 4, 65432109, N'Carlos', N'Sánchez', N'Calle 9 de Julio 123', N'Mendoza', N'2233445599', N'carlos.sanchez@email.com', N'Masculino', N'333')
INSERT [dbo].[Prestador] ([IdPrestador], [IdEspecialidad], [Dni], [Nombre], [Apellido], [Direccion], [Localidad], [Telefono], [Email], [Genero], [Contraseña]) VALUES (5, 5, 54321098, N'Laura', N'Martínez', N'Av. Independencia 456', N'Salta', N'2233445600', N'laura.martinez@email.com', N'Femenino', N'444')
SET IDENTITY_INSERT [dbo].[Prestador] OFF
GO
SET IDENTITY_INSERT [dbo].[Situacion] ON 

INSERT [dbo].[Situacion] ([IdSituacion], [Nombre]) VALUES (1, N'Finalizado')
INSERT [dbo].[Situacion] ([IdSituacion], [Nombre]) VALUES (2, N'Activo    ')
INSERT [dbo].[Situacion] ([IdSituacion], [Nombre]) VALUES (3, N'Solicitud cierre')
SET IDENTITY_INSERT [dbo].[Situacion] OFF
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
/****** Object:  StoredProcedure [dbo].[asistenciasEnCurso]    Script Date: 23/9/2024 09:06:42 ******/
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
/****** Object:  StoredProcedure [dbo].[datosPacienteYMedico]    Script Date: 23/9/2024 09:06:42 ******/
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
/****** Object:  StoredProcedure [dbo].[procesoPaciente]    Script Date: 23/9/2024 09:06:42 ******/
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

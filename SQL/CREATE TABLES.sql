CREATE DATABASE AnaliseVendasEcommerce;
GO

USE AnaliseVendasEcommerce;
GO

CREATE TABLE DimData (
    ID_Data INT PRIMARY KEY,
    Data DATE NOT NULL,
    Dia_do_Mes INT NOT NULL,
    Dia_Semana INT NOT NULL, -- 1=Domingo, 7=Sábado
    Nome_Dia_Semana VARCHAR(15) NOT NULL,
    Mes INT NOT NULL,
    Nome_Mes VARCHAR(15) NOT NULL,
    Trimestre INT NOT NULL,
    Ano INT NOT NULL,
    Ano_Mes INT NOT NULL, -- Formato YYYYMM
    Ano_Trimestre INT NOT NULL, -- Formato YYYYQ
    eh_Fim_de_Semana BIT NOT NULL -- 0=Não, 1=Sim
);

CREATE TABLE DimFuncionario(
	ID_Funcionario INT PRIMARY KEY,
	Nome_Completo NVARCHAR(50),
	Email NVARCHAR(50),
	Telefone NVARCHAR(50),
	ID_Data_Contratacao INT,
	Departamento NVARCHAR(50),
	Cargo NVARCHAR(50),
	Gerente_ID INT,
	Status NVARCHAR(50),
	Data_Nascimento DATE,
	Genero NVARCHAR(50),
	CONSTRAINT FK_DimFuncionario_DimData FOREIGN KEY (ID_Data_Contratacao) REFERENCES DimData(ID_Data),
	CONSTRAINT FK_DimFuncionario_DimFuncionario FOREIGN KEY (Gerente_ID) REFERENCES DimFuncionario(ID_Funcionario)
);

CREATE TABLE DimFornecedor(
	ID_Fornecedor INT PRIMARY KEY,
	Nome_Fornecedor NVARCHAR(50),
	CNPJ NVARCHAR(20),
	Telefone NVARCHAR(20),
	Email NVARCHAR(100),
	Endereco NVARCHAR(200),
	Cidade NVARCHAR(50),
	Estado NVARCHAR(50),
	Pais NVARCHAR(50),
	Tipo NVARCHAR(50),
	ID_Data_Cadastro INT,
	Status NVARCHAR(20),
	Nome_Contato NVARCHAR(50),
	FOREIGN KEY (ID_Data_Cadastro) REFERENCES DimData(ID_Data)
);

CREATE TABLE DimProduto(
	ID_Produto NVARCHAR(50) PRIMARY KEY,
	Nome_Produto NVARCHAR(50),
	Descricao NVARCHAR(50),
	Custo DECIMAL(10,2),
	Preco DECIMAL(10,2),
	Estoque INT,
	ID_Fornecedor INT,
	FOREIGN KEY (ID_Fornecedor) REFERENCES DimFornecedor(ID_Fornecedor)
);

CREATE TABLE DimCliente(
	ID_Cliente INT PRIMARY KEY,
	Nome_Completo NVARCHAR(50),
	Email NVARCHAR(50),
	Telefone NVARCHAR(50),
	ID_Data_Cadastro INT,
	Cidade NVARCHAR(50),
	Estado NVARCHAR(50),
	Pais NVARCHAR(50),
	Data_Nascimento DATE,
	Genero NVARCHAR(50),
	Segmento NVARCHAR(50),
	Status NVARCHAR(50),
	FOREIGN KEY (ID_Data_Cadastro) REFERENCES DimData(ID_Data)
);

CREATE TABLE FactVendas(
	ID_Venda INT PRIMARY KEY,
	ID_Produto NVARCHAR(50),
	ID_Cliente INT,
	ID_Funcionario INT,
	ID_Data INT,
	Qtd INT,
	Valor_Unit DECIMAL(10,2),
	Valor_Total DECIMAL(10,2),
	Tipo_Pag NVARCHAR(50),
	Status NVARCHAR(50),
	CONSTRAINT FK_FactVendas_DimProduto FOREIGN KEY (ID_Produto) REFERENCES DimProduto(ID_Produto),
	CONSTRAINT FK_FactVendas_DimCliente FOREIGN KEY (ID_Cliente) REFERENCES DimCliente(ID_Cliente),
	CONSTRAINT FK_FactVendas_DimFuncionario FOREIGN KEY (ID_Funcionario) REFERENCES DimFuncionario(ID_Funcionario),
	CONSTRAINT FK_FactVendas_DimData FOREIGN KEY (ID_Data) REFERENCES DimData(ID_Data)
);
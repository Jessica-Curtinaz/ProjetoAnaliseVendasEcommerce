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

-- Popular a tabela DimData usando uma CTE Recursiva
-- Primeiro, limpe a tabela caso ela já exista e contenha dados
TRUNCATE TABLE DimData;
GO

WITH DateSeries AS (
    -- Âncora: Começa em 01/01/2020
    SELECT
        CAST('2020-01-01' AS DATE) AS CurrentDate
    UNION ALL
    -- Recurso: Adiciona 1 dia até 31/12/2025
    SELECT
        DATEADD(day, 1, CurrentDate)
    FROM
        DateSeries
    WHERE
        CurrentDate < '2025-12-31'
)

INSERT INTO DimData (
    ID_Data,
    Data,
    Dia_do_Mes,
    Dia_Semana,
    Nome_Dia_Semana,
    Mes,
    Nome_Mes,
    Trimestre,
    Ano,
    Ano_Mes,
    Ano_Trimestre,
    eh_Fim_de_Semana
)

SELECT
    CAST(FORMAT(CurrentDate, 'yyyyMMdd') AS INT) AS ID_Data,
    CurrentDate AS Data,
    DAY(CurrentDate) AS Dia_do_Mes,
    DATEPART(weekday, CurrentDate) AS Dia_Semana, -- SQL Server: 1=Domingo, 7=Sábado
    DATENAME(weekday, CurrentDate) AS Nome_Dia_Semana,
    MONTH(CurrentDate) AS Mes,
    DATENAME(month, CurrentDate) AS Nome_Mes,
    DATEPART(quarter, CurrentDate) AS Trimestre,
    YEAR(CurrentDate) AS ano,
    CAST(FORMAT(CurrentDate, 'yyyyMM') AS INT) AS Ano_Mes,
    (YEAR(CurrentDate) * 10) + DATEPART(quarter, CurrentDate) AS Ano_Trimestre,
    CASE WHEN DATEPART(weekday, CurrentDate) IN (1, 7) THEN 1 ELSE 0 END AS eh_Fim_de_Semana -- 1=Domingo, 7=Sábado
FROM
    DateSeries
OPTION (MAXRECURSION 0);

-- Desafio 1 - SQL

-- ● Valor total das vendas e dos fretes por produto e ordem de venda;

-- Valor total das vendas por produto
-- O total de vendas é composto pelo valor menos o desconto, já que alguns valores possuem desconto

SELECT 
    v.ProdutoID,
    p.Produto,
    ROUND(SUM(v.Valor - v.Desconto), 2) AS TotalVendas 
FROM dbo.vendas v
JOIN dbo.Produtos p ON v.ProdutoID = p.ProdutoID
GROUP BY v.ProdutoID, p.Produto
ORDER BY v.ProdutoID;

-- Valor do frete por Ordem de venda
-- Um valor de frete para cada ordem de venda na tabela de frete

SELECT 
    CupomID AS Ordem_de_venda, 
    SUM(ValorFrete) AS TotalFrete
FROM dbo.expedicao
GROUP BY CupomID
ORDER BY CupomID;

-- ● Valor de venda por tipo de produto;

SELECT 
    c.Categoria,
    ROUND(SUM(v.Valor),2) AS ValorTotal_Venda
FROM dbo.vendas v
JOIN dbo.Produtos p ON v.ProdutoID = p.ProdutoID
JOIN dbo.Categoria c ON p.CategoriaID = c.CategoriaID
WHERE p.ProdutoID IS NOT NULL
GROUP BY Categoria;

-- ● Quantidade e valor das vendas por dia, mês, ano;

SELECT 
    CONVERT(DATE, e.Data) AS Data_da_Venda,
    v.CupomID AS OrdemPedido,
    SUM(v.Quantidade) AS QuantidadeTotal,
    ROUND(SUM(v.Valor), 2) AS ValorTotal
FROM dbo.vendas v
JOIN dbo.expedicao e ON v.CupomID = e.CupomID
GROUP BY e.Data, v.CupomID
ORDER BY e.Data DESC;

-- ● Lucro dos meses;

SELECT 
    YEAR(e.Data) AS Ano,
    MONTH(e.Data) AS Mes,
    ROUND(SUM(v.Custo - v.ValorLiquido), 2) AS Lucro
FROM dbo.vendas v
JOIN dbo.expedicao e ON v.CupomID = e.CupomID
GROUP BY YEAR(e.Data), MONTH(e.Data)
ORDER BY Ano DESC, Mes DESC;

-- ● Venda por produto;

SELECT 
    ProdutoID,
    SUM(Quantidade) AS Quantidade_vendida
FROM dbo.vendas
WHERE ProdutoID IS NOT NULL
GROUP BY ProdutoID
ORDER BY ProdutoID;

-- ● Venda por cliente, cidade do cliente e estado;
-- A tabela clientes é de âmbito internacional, sendo assim, não havia a coluna "Estado", portanto, coletei a coluna "País"

SELECT 
    e.ClienteID,
    c.Cliente,
    c.Cidade,
    c.Pais,
    SUM(v.Quantidade) AS Total_de_vendas,
    ROUND(SUM(v.Valor), 2) AS Valor_total_vendas
FROM dbo.vendas v
JOIN dbo.expedicao e ON v.CupomID = e.CupomID
JOIN dbo.Clientes c ON e.ClienteID = c.ClienteID
GROUP BY e.ClienteID, c.Cliente, c.Cidade, c.Pais
ORDER BY e.ClienteID;

-- ● Média de produtos vendidos;

-- Valor médio vendido

SELECT 
    ProdutoID,
    ROUND(AVG(Valor),2) AS Valor_medio_de_vendas
FROM dbo.vendas
WHERE ProdutoID IS NOT NULL
GROUP BY ProdutoID
ORDER BY ProdutoID;

-- Quantidade média vendida

SELECT 
    ProdutoID,
    ROUND(AVG(Quantidade),2) AS Quantidade_media_vendida
FROM dbo.vendas
WHERE ProdutoID IS NOT NULL
GROUP BY ProdutoID
ORDER BY ProdutoID;

-- ● Média de compras que um cliente faz.

SELECT 
    e.ClienteID,
    ROUND(AVG(Valor),2) AS Media_de_compras
FROM dbo.vendas v
JOIN dbo.expedicao e ON v.CupomID = e.CupomID
GROUP BY ClienteID
ORDER BY ClienteID;

-- EXTRA

-- Análise de venda por funcionário

SELECT 
    f.FuncionarioID,
    f.NomeFuncionario,
    SUM(v.Valor) AS TotalVendas
FROM dbo.expedicao e
JOIN dbo.Funcionarios f ON e.FuncionarioID = f.FuncionarioID
JOIN dbo.vendas v ON e.CupomID = v.CupomID
GROUP BY f.FuncionarioID, f.NomeFuncionario
ORDER BY FuncionarioID;

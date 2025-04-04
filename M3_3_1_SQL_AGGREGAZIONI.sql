-- ESERCIZIO 3.3.1 SQL - AGGREGAZIONI, GROUP BY, HAVING. Interrogare, filtrare e raggruppare


/* 1. Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. 
Quali considerazioni/ragionamenti è necessario che tu faccia? */

/* Conto i record totali e li confronto con il conteggio dei valori distinti di ProductKey. 
Il risultato finale è uguale per entrambi i campi (606), confermando ProductKey come chiave primaria. */
SELECT COUNT(*) AS TotalCount,
COUNT(DISTINCT ProductKey) AS ProductKeyCount
FROM dimproduct;


/* 2. Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK. */

/* Qui vale lo stesso ragionamento di prima. Si è eseguito un count su entrambi i campi e la somma equivale al totale di righe dell' entità (57851).
Considerando invece i campi separatamente il conteggio diverge. */ 
SELECT 
	COUNT(*) AS CountTOTAL
	, COUNT(DISTINCT SalesOrderNumber, SalesOrderLineNumber) AS SalesOrderNumber_SalesOrderLineNumber
	, COUNT(DISTINCT SalesOrderNumber) AS CountSalesOrderNumber
	, COUNT(DISTINCT SalesOrderLineNumber) AS CountSalesOrderLineNumber
	FROM factresellersales;


/* 3. Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020. */

SELECT COUNT(SalesOrderLineNumber)
FROM factresellersales
WHERE OrderDate >= '2020-01-01';


/* 4. Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity) e il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020. 
Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. I campi in output devono essere parlanti! */

SELECT 
	P.ProductKey
	,P.EnglishProductName AS Product
    , SUM(RS.SalesAmount) AS TotalSales
    , SUM(RS.OrderQuantity) AS TotalOrders
    , AVG(RS.UnitPrice) AS AverageUnitPrice
	, SUM(RS.SalesAmount)/SUM(RS.OrderQuantity) AS AveragePrice
FROM dimproduct AS P
INNER JOIN factresellersales AS RS
	ON P.ProductKey = RS.ProductKey
WHERE OrderDate >= '2020-01-01'
GROUP BY P.ProductKey, P.EnglishProductName 
ORDER BY AVG(RS.UnitPrice) DESC;


/* 5. Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory). 
Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta. 
I campi in output devono essere parlanti! */

SELECT 
	EnglishProductSubcategoryName AS Product
    , SUM(SalesAmount) AS TotalSales
    , SUM(OrderQuantity) TotalQuantity
FROM factresellersales AS RS
JOIN dimproduct AS P
	ON RS.ProductKey = P.ProductKey
JOIN dimproductsubcategory AS PS
	ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
JOIN dimproductcategory AS PC
	ON PS.ProductCategoryKey = PC.ProductCategoryKey
GROUP BY EnglishProductCategoryName;


/* 6. Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. 
Il result set deve esporre lʼelenco delle città con fatturato realizzato superiore a 60K. */

SELECT 
	G.City
	, SUM(RS.SalesAmount) AS TotalSales
FROM dimgeography AS G
JOIN dimreseller AS R
	ON G.GeographyKey= R.GeographyKey
JOIN factresellersales AS RS
	ON R.ResellerKey = RS.ResellerKey
WHERE RS.OrderDate >= '2020-01-01'
GROUP BY G.City
HAVING SUM(RS.SalesAmount) >= 60000
ORDER BY  TotalSales




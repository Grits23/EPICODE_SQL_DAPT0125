--ESERCIZIO M3_2_1 SQL - L'ISTRUZIONE SELECT 


-- 1) Esplora la tabella dei prodotti {DimProduct}

SELECT * 
FROM DimProduct;


-- 2) Esponi in Output i campi ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag e assegna un alias

SELECT 
	ProductKey, 
	ProductAlternateKey, 
	EnglishProductName, 
	Color, 
	StandardCost, 
	FinishedGoodsFlag 
FROM 
	DimProduct AS SelectedColumnsDimproduct;


-- 3) Esponi in Output i prodotti il cui campo FinishedGoodsFlag è uguale a 1

SELECT 
	ProductKey, 
	ProductAlternateKey, 
	EnglishProductName, 
	Color, 
	StandardCost, 
	FinishedGoodsFlag 
FROM 
	DimProduct AS SelectedColumnsDimproduct 
WHERE 
FinishedGoodsFlag = 1;


/* 4) Esponi in Output i prProductKeyodotti in cui il codice modello (ProductAlternateKey) comincia con FR o BK. 
Il result set deve contenere codice prodotto, modello, nome, costo standard e prezzo di listino */

SELECT 
	ProductKey, 
	ProductAlternateKey, 
	ModelName, 
	EnglishProductName, 
	Color, 
	StandardCost, 
	ListPrice
FROM 
	DimProduct
WHERE 
	ProductAlternateKey LIKE 'FR%' OR ProductAlternateKey LIKE 'BK%';


-- 5) Arricchisci il risultato della query scritta nel passaggio precedente del Markup applicato dallʼazienda (ListPrice - StandardCost)

SELECT 
	ProductKey, 
	ProductAlternateKey, 
	ModelName, 
	EnglishProductName, 
	Color, 
	StandardCost, 
	ListPrice, 
	ListPrice - StandardCost AS Markup
FROM 
	DimProduct 
WHERE 
	ProductAlternateKey LIKE 'FR%' OR ProductAlternateKey LIKE 'BK%';


-- 6) Scrivi unʼaltra query al fine di esporre lʼelenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000

SELECT 
	EnglishProductName, 
	ModelName, 
	ListPrice 
FROM 
	DimProduct 
WHERE 
	FinishedGoodsFlag =1 AND ListPrice BETWEEN 1000 AND 2000;


-- 7) Esplora la tabella degli impiegati aziendali DimEmployee

SELECT * 
FROM DimEmployee;


-- 8) Esponi, interrogando la tabella degli impiegati aziendali, lʼelenco dei soli agenti. Gli agenti sono i dipendenti per i quali il campo SalespersonFlag è uguale a 1.

SELECT 
	FirstName, 
	MiddleName, 
	LastName 
FROM 
	DimEmployee
WHERE 
	SalesPersonFlag=1;


-- 9) Interroga la tabella delle vendite (FactResellerSales). Esponi in output lʼelenco delle transazioni registrate a partire dal 1 gennaio 2013 dei soli codici prodotto: 597, 598, 477, 214. 
-- Calcola per ciascuna transazione il profitto (SalesAmount - TotalProductCost)


SELECT 
	ProductKey, 
	SalesAmount, 
	TotalProductCost, 
	SalesAmount - TotalProductCost AS Profit, 
	FORMAT(OrderDate, 'yyyy-MM-dd') AS OrderDate 
FROM 
	FactResellerSales 
WHERE 
	ProductKey IN (597, 598, 477, 214) AND OrderDate > '2013-01-01'

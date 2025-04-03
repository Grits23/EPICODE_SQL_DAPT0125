/* ESERCIZIO 3.2.2 SQL - "JOIN e SUBQUERY" -  AdventureWorksDW
Interrogare e filtrare le tabelle. Dove possibile svolgi gli esercizi utilizzando sia JOIN che SUBQUERY */

-- 1. Esponi lʼanagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria (DimProduct, DimProductSubcategory)
		
/* Inizio l'esplorazione delle due tabelle per conoscerne i campi */
SELECT * 
FROM dimproduct;

SELECT * 
FROM dimproductsubcategory;

/* Esploro anche la tabella dimproductcategory per capire se contiene informazioni utili */
SELECT * 
FROM dimproductcategory;

/* Con una left join il risultato mostra anche i record dove la sottocategoria è assente (606) */

SELECT 
	P.ProductKey
	, P.ProductSubcategoryKey
	, P.EnglishProductName AS Product
	, PS.EnglishProductSubcategoryName AS Subcategory
FROM dimproduct as P 
INNER JOIN dimproductsubcategory AS PS
	ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey;


/* Utilizzando una inner join è possibile mostrare solo i record dove nel prodotto è presente la sottocategoria */ 

SELECT
	P.ProductKey
	, P.ProductSubcategoryKey
	, P.EnglishProductName AS Product
	, PS.EnglishProductSubcategoryName AS Subcategory
FROM dimproduct as P 
INNER JOIN dimproductsubcategory AS PS
	ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey;

/* Verifico se il numero delle righe trovate (397) ha corrispondenza con quello delle righe contenenti la subcategory key nella tabella prodotti */
SELECT * 
FROM dimproduct
WHERE ProductSubcategoryKey is NOT NULL;

/* 1) Versione SUBQUERY: il campo Subcategory si ottiene chiedendo di selezionare il nome prodotto dalla tabella dimproductsubcategory tramite il match della sua subcategory key con quella presente nella tab prodotti */

SELECT
	P.ProductKey
	, P.ProductSubcategoryKey
	, P.EnglishProductName AS Product
	,	(
			SELECT
			PS.EnglishProductSubcategoryName 
			FROM dimproductsubcategory AS PS
			WHERE PS.ProductSubcategoryKey = P.ProductSubcategoryKey

		) AS Subcategory
FROM dimproduct as P 
WHERE P.ProductSubcategoryKey IS NOT NULL;



-- 2. Esponi lʼanagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria (DimProduct, DimProductSubcategory, DimProductCategory).

/* Aggiungo alla query precedente una inner join con la tabella dimproductcategory tramite le chiavi di productcategory */

SELECT 
	P.ProductKey
	, P.ProductSubcategoryKey
	, PS.ProductCategoryKey
	, P.EnglishProductName AS Product
	, PS.EnglishProductSubcategoryName AS Subcategory
	, PC.EnglishProductCategoryName AS Category
FROM dimproduct as P 
INNER JOIN dimproductsubcategory AS PS
	ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
INNER JOIN dimproductcategory AS PC 
	ON  PC.ProductCategoryKey = PS.ProductCategoryKey;


-- 2) Versione SUBQUERY: la logica è quella del punto precedente con una subquery aggiuntiva che definisce il campo Category

SELECT
	ProductKey
	, ProductSubcategoryKey
	, EnglishProductName AS Product
	,    (
    
			SELECT EnglishProductSubcategoryName
			FROM dimproductsubcategory AS PS
			WHERE PS.ProductSubcategoryKey = P.ProductSubcategoryKey
            
		) AS Subcategory
	,   (
     
			SELECT PC.EnglishProductCategoryName
			FROM dimproductsubcategory AS PS
			JOIN dimproductcategory AS PC ON PS.ProductCategoryKey = PC.ProductCategoryKey
			WHERE PS.ProductSubcategoryKey = P.ProductSubcategoryKey
            
		) AS Category
FROM dimproduct AS P
WHERE ProductSubcategoryKey IS NOT NULL;


-- 3)Esponi lʼelenco dei soli prodotti venduti (DimProduct, FactResellerSales). 

/* Qui innesto le subquery precedenti per mostrare i campi subcategory e category */
SELECT DISTINCT
P.ProductKey
, P.ProductSubcategoryKey
, RS.ResellerKey
, P.EnglishProductName AS Product
,	(

        SELECT EnglishProductSubcategoryName
        FROM dimproductsubcategory AS PS
        WHERE PS.ProductSubcategoryKey = P.ProductSubcategoryKey
        
    ) AS Subcategory
,	(
    
		SELECT PC.EnglishProductCategoryName
		FROM dimproductsubcategory AS PS
		JOIN dimproductcategory AS PC ON PS.ProductCategoryKey = PC.ProductCategoryKey
		WHERE PS.ProductSubcategoryKey = P.ProductSubcategoryKey
        
    ) AS Category
	, RS.SalesOrderNumber
	, RS.UnitPrice
	, RS.SalesAmount
	, RS.OrderDate
FROM dimproduct AS P 
INNER JOIN factresellersales AS RS
	ON P.ProductKey = RS.ProductKey 
/* Inserisco il filtro order by asc per verificare l'assenza di valori NULL in ResellerKey. 
Questo perchè nella tabella factresellersales sono presenti solo prodotti venduti */
ORDER BY ResellerKey ASC;
	


-- 4) Esponi lʼelenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1). 

SELECT 
	P.ProductKey
	, P.ProductSubcategoryKey
	, P.EnglishProductName AS Product
	, "Unsold"
FROM dimproduct AS P 
LEFT JOIN factresellersales AS RS
	ON P.ProductKey = RS.ProductKey 
WHERE P.FinishedGoodsFlag =1  AND RS.ProductKey IS NULL;

-- 4) Versione SUBQUERY

SELECT 
	ProductKey
	, ProductSubcategoryKey
	, EnglishProductName AS Product
	, 'Unsold'
FROM dimproduct
WHERE FinishedGoodsFlag = 1
/* NOT IN filtra i prodotti non presenti tra quelli venduti.
IS NOT NULL è inserito per non far escludere eventuali valori NULL, che NOT IN eliminerebbe dai risultati */
AND ProductKey NOT IN 
	(
    
		  SELECT ProductKey
		  FROM factresellersales
		  WHERE ProductKey IS NOT NULL
          
	);



-- 5) Esponi lʼelenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct)

SELECT 
	RS.ResellerKey
	, P.ProductKey
	, RS.SalesOrderNumber
	, RS.SalesAmount
	, P.EnglishProductName AS Product
FROM factresellersales AS RS 
LEFT JOIN dimproduct AS P
	ON RS.ProductKey= P.ProductKey;

-- 5) Versione SUBQUERY

SELECT 
	RS.ResellerKey
	, RS.ProductKey
	, RS.SalesOrderNumber
	, RS.SalesAmount
	,	(
    
			SELECT P.EnglishProductName AS Product
			FROM dimproduct AS P
			WHERE P.ProductKey = RS.ProductKey
            
		) AS Product
FROM factresellersales AS RS;

-- 6) Esponi lʼelenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.

SELECT 
	RS.ResellerKey
	, RS.SalesOrderNumber
	, RS.SalesAmount
	, P.EnglishProductName AS Product
	, PC.EnglishProductCategoryName AS ProductCategory
FROM factresellersales AS RS
LEFT JOIN dimproduct AS P
    ON RS.ProductKey = P.ProductKey
-- Il legame tra Product e ProductCategory passa attraverso la tabella intermedia dimproductsubcategory
LEFT JOIN dimproductsubcategory AS PS
    ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
LEFT JOIN dimproductcategory AS PC
    ON PS.ProductCategoryKey = PC.ProductCategoryKey;


-- 6) Versione SUBQUERY

SELECT 
RS.ResellerKey
, RS.SalesOrderNumber
, RS.SalesAmount
-- Subquery per il nome del prodotto
,	(

		SELECT P.EnglishProductName
		FROM dimproduct AS P
		WHERE P.ProductKey = RS.ProductKey
        
	) AS Product
  -- Subquery per la categoria del prodotto
,	(

		SELECT PC.EnglishProductCategoryName
		FROM dimproduct AS P
		JOIN dimproductsubcategory AS PS
			ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
		JOIN dimproductcategory AS PC
			ON PS.ProductCategoryKey = PC.ProductCategoryKey
		WHERE P.ProductKey = RS.ProductKey
        
    ) AS ProductCategory
FROM factresellersales AS RS;



-- 7) Esplora la tabella DimReseller
SELECT *
FROM dimreseller;

-- 8) Esponi in output lʼelenco dei reseller indicando, per ciascun reseller, anche la sua area geografica. 

SELECT 
	R.ResellerKey
	, R.GeographyKey
	, R.ResellerName
	, R.BusinessType
	, R.ProductLine
	, R.AnnualRevenue
	, G.EnglishCountryRegionName AS Region
	, G.StateProvinceName AS Province
	, G.City AS City 
FROM dimreseller AS R
LEFT JOIN dimgeography AS G
	ON R.GeographyKey = G.GeographyKey;
    
-- 8) Versione SUBQUERY

SELECT 
	R.ResellerKey
	, R.GeographyKey
	, R.ResellerName
	, R.BusinessType
	, R.ProductLine
	, R.AnnualRevenue
	,	(
    
			SELECT 
				G.EnglishCountryRegionName 
			FROM dimgeography AS G
			WHERE G.GeographyKey = R.GeographyKey
            
		)   AS Region
     ,   (
     
			SELECT 
				 G.StateProvinceName 
			FROM dimgeography AS G
			WHERE G.GeographyKey = R.GeographyKey
            
		)   AS Province
     ,   (
     
			SELECT 
				G.City 
			FROM dimgeography AS G
			WHERE G.GeographyKey = R.GeographyKey
            
		)   AS City
 FROM dimreseller AS R;
    

/* 9) Esponi lʼelenco delle transazioni di vendita. Il result set deve esporre i campi: 
SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost. 
Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e lʼarea geografica. */

SELECT 
	RS.ProductKey
	, P.ProductKey
	, RS.SalesOrderNumber
	, RS.SalesOrderLineNumber
	, RS.OrderDate
	, RS.UnitPrice
	, RS.OrderQuantity
	, RS.TotalProductCost
	, P.EnglishProductName AS Product
	, R.ResellerName AS ResellerName
	, G.GeographyKey
	, G.EnglishCountryRegionName AS Region
	, G.StateProvinceName AS Province
	, G.City AS City 
FROM factresellersales AS RS
LEFT JOIN dimproduct AS P
	ON RS.ProductKey = P.ProductKey
LEFT JOIN
dimreseller AS R
	ON RS.ResellerKey = R.ResellerKey
LEFT JOIN 
dimgeography AS G
	ON R.GeographyKey = G.GeographyKey;


-- 9) Versione SUBQUERY

SELECT
/* SUBQUERY A: Utilizza le transazioni di vendita (FactResellerSales) e le informazioni sul prodotto (DimProduct), calcolando il costo totale di ogni transazione:
Se RS.TotalProductCost è disponibile lo usa. Se è NULL lo ricalcola come StandardCost * OrderQuantity, stimando il costo totale usando il costo standard.*/
	A.*
	, A.SalesAmount - A.TotalProductCost AS Markup
	, PC.EnglishProductCategoryName AS ProductCategory
	, R.ResellerName
	, G.EnglishCountryRegionName
FROM 
	(
		SELECT 
			P.ProductKey
			, P.ProductSubcategoryKey
			, RS.SalesOrderNumber
			, RS.SalesOrderLineNumber
			, RS.OrderDate
			, RS.UnitPrice
			, RS.OrderQuantity
			-- , RS.TotalProductCost
			, CASE  WHEN RS.TotalProductCost IS NULL 
				THEN P.StandardCost*RS.OrderQuantity 
					ELSE RS.TotalProductCost 
						END AS TotalProductCost
			, RS.SalesAmount
			, RS.ResellerKey
			/*, P.StandardCost
			, RS.TotalProductCost/RS.OrderQuantity
			, (RS.TotalProductCost/RS.OrderQuantity)-P.StandardCost AS DIFF*/
		FROM factresellersales AS RS
		LEFT OUTER JOIN 
		dimproduct AS P 
			ON RS.ProductKey = P.ProductKey
	) as A
/* Le informazioni riguadanti la categoria, il rivenditore e l'area di vendita sono ricavate tramite join */
LEFT JOIN dimproductsubcategory AS PS
	ON PS.ProductSubcategoryKey = A.ProductSubcategoryKey 
LEFT JOIN dimproductcategory AS PC
	ON PC.ProductCategoryKey = PS.ProductCategoryKey
LEFT JOIN dimreseller R
	ON R.ResellerKey= A.ResellerKey
LEFT JOIN dimgeography AS G
	ON G.GeographyKey = R.GeographyKey
/*Tramite ORDER BY Merkup è possibile capire quali prodotti/transazioni hanno generato il guadagno maggiore. */
ORDER BY Markup DESC;


-- Esponi tutti i prodotti venduti nel 2019 considerando sia le vendite reseller che le vendite web
-- Tabelle: dimproduct, factresellersales , factinternetsales

SELECT 
	EnglishProductName AS SoldProducts2019 
FROM dimproduct AS P
WHERE P.ProductKey IN 
-- La doppia subquery divisa da OR permette di legare l'anno delle tabelle factresellersales e factinternetsales al nome prodotto presente in dimproducts atraverso i campi ProductKey
	(
		SELECT 
			RS.ProductKey 
		FROM factresellersales AS RS 
        WHERE YEAR (RS.OrderDate)= 2019
    
    ) 
OR P.ProductKey IN 
	(
    
		SELECT 
			WS.ProductKey 
        FROM factinternetsales AS WS 
        WHERE YEAR (WS.OrderDate)= 2019
        
	);
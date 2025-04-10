-- M3_3_2-SQL Built-in function e View

/* Implementa una vista denominata Product al fine di creare unʼanagrafica (dimensione) prodotto completa.
La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto, il nome della sottocategoria associata e il nome della categoria associata. */


/* 1. Implementa una vista denominata Product al fine di creare unʼanagrafica (dimensione) prodotto completa. 
La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto, il nome della sottocategoria associata e il nome della categoria associata. */

CREATE VIEW GR_View_Product 
AS (	
		SELECT 
			P.ProductKey 
            		, P.ProductSubcategoryKey
            		, PC.ProductCategoryKey
			, P.EnglishProductName AS ProductName
			, PS.EnglishProductSubcategoryName AS SubcategoryName
			, PC.EnglishProductCategoryName AS CategoryName 
            		, P.FinishedGoodsFlag AS FinishedProduct
            		, P.ListPrice AS ListPrice
		FROM dimproduct AS P
		JOIN dimproductsubcategory AS PS
			ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
		JOIN dimproductcategory AS PC
			ON PS.ProductCategoryKey = PC.ProductCategoryKey
	);
    
    SELECT *
    FROM gr_view_product;

/* 2. Implementa una vista denominata Reseller al fine di creare unʼanagrafica (dimensione) reseller completa. 
La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome del reseller, il nome della città e il nome della regione. */

CREATE VIEW GR_View_Reseller 
AS (
		SELECT 
			R.ResellerKey
           	 	, R.ResellerName AS ResellerName
           	 	, R.BusinessType AS BusinessType
            		, R.AnnualSales AS AnnualSales
            		, G.City AS City
            		, G.StateProvinceName AS Province
            		, G.EnglishCountryRegionName AS Region
        	FROM dimreseller AS R
        	JOIN dimgeography AS G
			ON R.GeographyKey = G.GeographyKey 
	);

SELECT *
FROM gr_view_reseller;

/* 3. Crea una vista denominata Sales che deve restituire la data dellʼordine, il codice documento, 
la riga di corpo del documento, la quantità venduta, lʼimporto totale e il profitto. */

CREATE VIEW GR_View_Sales 
AS	(
		SELECT 
			OrderDate
		        , SalesOrderNumber
		        , SalesOrderLineNumber
		        , ProductKey
		        , ResellerKey
		        , OrderQuantity
		        , UnitPrice
		        , SalesAmount
		        , TotalProductCost
		        , SalesAmount - TotalProductCost  AS Markup
		FROM factresellersales 
	);

SELECT *
FROM gr_view_sales;



/* 4. Crea un report in Excel che consenta ad un utente di analizzare quantità venduta, importo totale e profitti per prodotto/categoria prodotto e reseller/regione. */

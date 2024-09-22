-- Total number of returns and the quantity returned for each product
SELECT
    p.PRODUCT_NUMBER,
    p.PRODUCT_NAME,
    COUNT(ri.RETURN_CODE) AS NumberOfReturns,
    SUM(ri.RETURN_QUANTITY) AS TotalQuantityReturned
FROM
    dbo.RETURNED_ITEM ri
    LEFT JOIN dbo.ORDER_DETAILS od ON ri.ORDER_DETAIL_CODE = od.ORDER_DETAIL_CODE
    LEFT JOIN dbo.PRODUCT p ON od.PRODUCT_NUMBER = p.PRODUCT_NUMBER
GROUP BY
    p.PRODUCT_NUMBER,
    p.PRODUCT_NAME;

-- Forecasted volume of each product for a specific year
SELECT
    pf.PRODUCT_NUMBER,
    p.PRODUCT_NAME,
    pf.YEAR,
    SUM(pf.EXPECTED_VOLUME) AS TOTAL_EXPECTED_VOLUME
FROM
    dbo.PRODUCT_FORECAST pf
    JOIN dbo.PRODUCT p ON pf.PRODUCT_NUMBER = p.PRODUCT_NUMBER
WHERE
    pf.YEAR = 2014
GROUP BY
    pf.PRODUCT_NUMBER,
    p.PRODUCT_NAME,
    pf.YEAR
ORDER BY
    pf.PRODUCT_NUMBER;
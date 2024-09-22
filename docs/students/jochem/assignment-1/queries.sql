-- Top 5 products sold per region per year
WITH ProductSalesPerRegion AS (
    SELECT
        p.product_number,
        oh.sales_branch_code,
    YEAR(oh.order_date) AS sales_year,
    SUM(od.quantity) AS total_quantity_sold
FROM
    Order_Header oh
    JOIN
    Order_Details od ON oh.order_number = od.order_number
    JOIN
    Product p ON od.product_number = p.product_number
GROUP BY
    p.product_number, oh.sales_branch_code, YEAR(oh.order_date)
    )
SELECT
    ps.sales_year,
    sb.city AS sales_region,
    p.product_name,
    ps.total_quantity_sold
FROM
    ProductSalesPerRegion ps
        JOIN
    Sales_Branch sb ON ps.sales_branch_code = sb.sales_branch_code
        JOIN
    Product p ON ps.product_number = p.product_number
WHERE
    (ps.product_number, ps.total_quantity_sold) IN (
        SELECT
            ps2.product_number, ps2.total_quantity_sold
        FROM
            ProductSalesPerRegion ps2
        WHERE
            ps2.sales_year = ps.sales_year AND ps2.sales_branch_code = ps.sales_branch_code
        ORDER BY
            ps2.total_quantity_sold DESC
            FETCH FIRST 5 ROWS ONLY
    )
ORDER BY
    ps.sales_year, sb.city, ps.total_quantity_sold DESC;
-- CTE calculating the total quantity of products sold per region per year
-- subquery in where clause to get the top 5 products sold per region per year
-- aggregate: SUM(od.qauntity) calculates the total quantity of products.
-- advanced: FETCH FIRST 5 ROWS ONLY to get the top 5 products
-- sorting: ORDER BY ps.sales_year, sb.city, ps.total_quantity_sold DESC to sort the results

-- Sales staff target achievement
WITH ActualSales AS (
    SELECT
        ss.sales_staff_code,
    YEAR(oh.order_date) AS sales_year,
    MONTH(oh.order_date) AS sales_period,
    SUM(od.unit_sales_price * od.quantity) AS total_sales
FROM
    Order_Header oh
    JOIN
    Order_Details od ON oh.order_number = od.order_number
    JOIN
    Sales_Staff ss ON oh.sales_staff_code = ss.sales_staff_code
GROUP BY
    ss.sales_staff_code, YEAR(oh.order_date), MONTH(oh.order_date)
    )
SELECT
    st.sales_staff_code,
    CONCAT(ss.first_name, ' ', ss.last_name) AS sales_staff_name,
    st.sales_year,
    st.sales_period,
    st.sales_target,
    COALESCE(a.total_sales, 0) AS actual_sales,
    CASE
        WHEN COALESCE(a.total_sales, 0) >= st.sales_target THEN 'Achieved'
        ELSE 'Not Achieved'
        END AS target_status
FROM
    Sales_Target st
        LEFT JOIN
    ActualSales a ON st.sales_staff_code = a.sales_staff_code
        AND st.sales_year = a.sales_year
        AND st.sales_period = a.sales_period
        JOIN
    Sales_Staff ss ON st.sales_staff_code = ss.sales_staff_code
ORDER BY
    st.sales_year, st.sales_period, ss.sales_staff_code;
-- CTE calculating the total sales per sales staff per year and month
-- LEFT JOIN: The main query uses a LEFT JOIN to compare each sales target with the actual sales. If there is no corresponding sale, total_sales is set to 0 using COALESCE.
-- Aggregation: SUM(od.unit_sales_price * od.quantity) calculates the total sales value for each sales representative.
-- Advanced: CASE statement to determine if the sales target was achieved or not.
-- Sorting: ORDER BY st.sales_year, st.sales_period, ss.sales_staff_code to sort the results

-- Average sale price per product per year
WITH YearlyProductSales AS (
    SELECT
        p.product_number,
    YEAR(oh.order_date) AS sales_year,
    SUM(od.unit_sales_price * od.quantity) AS total_sales_value,
    SUM(od.quantity) AS total_quantity_sold
FROM
    Order_Header oh
    JOIN
    Order_Details od ON oh.order_number = od.order_number
    JOIN
    Product p ON od.product_number = p.product_number
GROUP BY
    p.product_number, YEAR(oh.order_date)
    )
SELECT
    p.product_name,
    yps.sales_year,
    yps.total_sales_value,
    yps.total_quantity_sold,
    (yps.total_sales_value / yps.total_quantity_sold) AS average_sale_price
FROM
    YearlyProductSales yps
        JOIN
    Product p ON yps.product_number = p.product_number
ORDER BY
    yps.sales_year, p.product_name;

-- CTE calculating the total sales value and quantity of products sold per product per year
-- Aggregation: SUM(od.unit_sales_price * od.quantity) calculates the total sales value for each product per year.
-- Calculation: (yps.total_sales_value / yps.total_quantity_sold) calculates the average sale price per product per year.
-- Sorting: ORDER BY yps.sales_year, p.product_name to sort the results

-- Product forecast vs actual sales monthly
WITH MonthlyActualSales AS (
    SELECT
        p.product_number,
    YEAR(oh.order_date) AS sales_year,
    MONTH(oh.order_date) AS sales_month,
    SUM(od.quantity) AS actual_sales_volume
FROM
    Order_Header oh
    JOIN
    Order_Details od ON oh.order_number = od.order_number
    JOIN
    Product p ON od.product_number = p.product_number
GROUP BY
    p.product_number, YEAR(oh.order_date), MONTH(oh.order_date)
    )
SELECT
    pf.product_number,
    pf.year,
    pf.month,
    pf.expected_volume,
    COALESCE(mas.actual_sales_volume, 0) AS actual_sales_volume,
    pf.expected_volume - COALESCE(mas.actual_sales_volume, 0) AS variance
FROM
    Product_Forecast pf
        LEFT JOIN
    MonthlyActualSales mas ON pf.product_number = mas.product_number
        AND pf.year = mas.sales_year
        AND pf.month = mas.sales_month
ORDER BY
    pf.year, pf.month, pf.product_number;

-- CTE calculating the actual sales volume per product per month
-- LEFT JOIN: The main query uses a LEFT JOIN to compare each product forecast with the actual sales volume. If there is no corresponding sale, actual_sales_volume is set to 0 using COALESCE.
-- Sorting: ORDER BY pf.year, pf.month, pf.product_number to sort the results

-- Top 5 products returned per year per reason
WITH YearlyReturns AS (
    SELECT
        rr.reason_description_en,
    YEAR(ri.return_date) AS return_year,
    COUNT(ri.return_code) AS total_returns
FROM
    Returned_Item ri
    JOIN
    Return_Reason rr ON ri.return_reason_code = rr.return_reason_code
GROUP BY
    rr.reason_description_en, YEAR(ri.return_date)
    )
SELECT
    return_year,
    reason_description_en,
    total_returns,
    RANK() OVER (PARTITION BY return_year ORDER BY total_returns DESC) AS return_rank
FROM
    YearlyReturns
ORDER BY
    return_year, return_rank;

-- CTE calculating the total returns per return reason per year
-- Ranking: RANK() OVER (PARTITION BY return_year ORDER BY total_returns DESC) ranks the return reasons based on the total number of returns.
-- Sorting: ORDER BY return_year, return_rank to sort the results

-- Sales growth per staff per year
WITH SalesByStaff AS (
    SELECT
        ss.sales_staff_code,
    YEAR(oh.order_date) AS sales_year,
    SUM(od.unit_sales_price * od.quantity) AS total_sales
FROM
    Order_Header oh
    JOIN
    Order_Details od ON oh.order_number = od.order_number
    JOIN
    Sales_Staff ss ON oh.sales_staff_code = ss.sales_staff_code
GROUP BY
    ss.sales_staff_code, YEAR(oh.order_date)
    ),
    SalesWithGrowth AS (
SELECT
    sbs.sales_staff_code,
    sbs.sales_year,
    sbs.total_sales,
    LAG(sbs.total_sales) OVER (PARTITION BY sbs.sales_staff_code ORDER BY sbs.sales_year) AS previous_year_sales,
    (sbs.total_sales - LAG(sbs.total_sales) OVER (PARTITION BY sbs.sales_staff_code ORDER BY sbs.sales_year)) AS sales_growth
FROM
    SalesByStaff sbs
    )
SELECT
    swg.sales_staff_code,
    CONCAT(ss.first_name, ' ', ss.last_name) AS sales_staff_name,
    swg.sales_year,
    swg.total_sales,
    COALESCE(swg.previous_year_sales, 0) AS previous_year_sales,
    COALESCE(swg.sales_growth, 0) AS sales_growth
FROM
    SalesWithGrowth swg
        JOIN
    Sales_Staff ss ON swg.sales_staff_code = ss.sales_staff_code
ORDER BY
    swg.sales_year, swg.sales_staff_code;
-- CTE calculating the total sales per sales staff per year
-- Window function: LAG(sbs.total_sales) OVER (PARTITION BY sbs.sales_staff_code ORDER BY sbs.sales_year) calculates the total sales of the previous year for each sales representative.
-- Sorting: ORDER BY swg.sales_year, swg.sales_staff_code to sort the results

-- Sales per product per month in a Pivot Table
SELECT
    product_number,
    [1] AS January,
    [2] AS February,
    [3] AS March,
    [4] AS April,
    [5] AS May,
    [6] AS June,
    [7] AS July,
    [8] AS August,
    [9] AS September,
    [10] AS October,
    [11] AS November,
    [12] AS December
FROM (
    SELECT
    p.product_number,
    MONTH(oh.order_date) AS sales_month,
    SUM(od.quantity) AS total_quantity_sold
    FROM
    Order_Header oh
    JOIN
    Order_Details od ON oh.order_number = od.order_number
    JOIN
    Product p ON od.product_number = p.product_number
    GROUP BY
    p.product_number, MONTH(oh.order_date)
    ) AS SalesData
    PIVOT (
    SUM(total_quantity_sold)
    FOR sales_month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
    ) AS PivotTable
ORDER BY
    product_number;

-- Pivot table to show the total quantity of products sold per product per month
-- Aggregation: SUM(od.quantity) calculates the total quantity of products sold per product per month.
-- Sorting: ORDER BY product_number to sort the results
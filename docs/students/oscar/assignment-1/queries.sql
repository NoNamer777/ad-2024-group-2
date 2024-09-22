-- Count the number of sales branches per country,
-- sorted from the country with the most to the least amount of branches in the country.
SELECT COUNT(SB.`sales_branch_code`) AS `branches_per_country`, C.`country`
FROM Country C
LEFT JOIN Sales_Branch SB
    ON C.`country_code` = SB.`country_code`
GROUP BY C.`country`
ORDER BY `branches_per_country` DESC;

-- Shows for how many days a promotion lasted, and for which products.
SELECT PM.`pr_number`, DATEDIFF(day, PM.`date_start`, PM.`date_end`) AS `promotion_length_in_days`, PD.`product_name`
FROM Promotion PM
LEFT JOIN Campaign C
    ON PM.`pr_number` = C.`pr_number`
LEFT JOIN Product PD
    ON C.`product_number` = PD.`product_number`;

-- Stored procedure to update the retailer name in the Sales_Target and Order_Header tables whenever the retailer_name
-- the Retailer table changes
CREATE PROCEDURE UpdateRetailerName
    AS
BEGIN
    SET NOCOUNT ON;

    -- Update retailer_name in Order_Header
UPDATE Order_Header
SET retailer_name = r.company_name
    FROM Order_Header oh
    JOIN Retailer r ON oh.retailer_site_code = r.retailer_code;

-- Update retailer_name in Sales_Target
UPDATE Sales_Target
SET retailer_name = r.company_name
    FROM Sales_Target st
    JOIN Retailer r ON st.retailer_code = r.retailer_code;
END;


-- Trigger to validate manager ID
CREATE TRIGGER validate_manager_code
    ON Sales_Staff
    INSTEAD OF INSERT
AS
BEGIN
    DECLARE @manager_code INT;
    DECLARE @sales_staff_code INT;

    SELECT @manager_code = i.manager_code, @sales_staff_code = i.sales_staff_code
    FROM inserted i;

    IF @manager_code IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Sales_Staff WHERE sales_staff_code = @manager_code)
        BEGIN
            RAISERROR ('Invalid manager_code: %d. It must be an existing sales_staff_code.', 16, 1, @manager_code);
            ROLLBACK TRANSACTION;
        END
    ELSE
        BEGIN
            INSERT INTO Sales_Staff (sales_staff_code, first_name, last_name, position_en, work_phone, extension, fax, email, date_hired, sales_branch_code, manager_code)

            SELECT sales_staff_code, first_name, last_name, position_en, work_phone, extension, fax, email, date_hired, sales_branch_code, manager_code
            FROM inserted;
        END
END;

-- Stored procedure that takes a product name and inventory count, grabs the product number based on the provided name,
-- automatically adds the month and year of when the procedure was executed and inserts this data into the inventory_levels table
CREATE PROCEDURE InsertInventoryLevel
    @product_name VARCHAR(255),
    @inventory_count INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @product_number INT;
    DECLARE @inventory_year SMALLINT;
    DECLARE @inventory_month SMALLINT;

    -- Get the current year and month
    SET @inventory_year = YEAR(GETDATE());
    SET @inventory_month = MONTH(GETDATE());

    -- Retrieve the product_number based on the product_name
    SELECT @product_number = product_number
    FROM Product
    WHERE product_name = @product_name;

    -- Check if the product_number was found
    IF @product_number IS NULL
    BEGIN
        RAISERROR ('Product not found: %s', 16, 1, @product_name);
        RETURN;
    END

    -- Insert the new inventory level
    INSERT INTO Inventory_Levels (inventory_year, inventory_month, product_number, inventory_count)
    VALUES (@inventory_year, @inventory_month, @product_number, @inventory_count);
END;

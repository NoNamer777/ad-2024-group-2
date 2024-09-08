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

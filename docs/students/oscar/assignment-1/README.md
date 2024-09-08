# Assignment 1

a. Remarks about the tables:

1. In the `Order_Header` table, the name of the retailer is set directly in the table while the name of the retailer is already known in the `Retailer` table. This could cause extra work when a retailer decides to change their name.
2. For the `Inventory_Levels` the day on which the levels are recorded are left out of scope, making the data less accurate.
3. 1. The `Sales_Staff` table has a lot of repetition for the `position_en`
   2. People that leave the company and get hired again will get multiple entries.
4. The name of the retailer is _once again_ directly used in the `Sales_Target` table.

b. See [provided erd](./revised-erd.pdf).

c. See [provided SQL script](./queries.sql).

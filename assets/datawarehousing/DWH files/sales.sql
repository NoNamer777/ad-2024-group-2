-- Dimension Tables
CREATE TABLE
    Dim_Customer (
        Customer_Id INT PRIMARY KEY,
        Customer_F_Name VARCHAR(255),
        Customer_L_Name VARCHAR(255),
        Customer_Adress VARCHAR(255),
        Customer_City VARCHAR(255),
        Customer_Street VARCHAR(255),
        Customer_Postal_Code VARCHAR(255),
        Customer_Phone_Number VARCHAR(255),
        Customer_Mailaddress VARCHAR(255),
        Customer_Segment VARCHAR(255),
        Customer_Registration_Date DATE
    );

CREATE TABLE
    Dim_Product (
        Product_Id INT PRIMARY KEY,
        Product_Name VARCHAR(255),
        Product_Price FLOAT,
        Product_Marge FLOAT,
        Product_Introduction_Date DATE,
        Product_Category VARCHAR(255),
        Product_Description VARCHAR(255),
        Product_Costs INT
    );

CREATE TABLE
    Dim_SalesStaff (
        SalesStaff_Id INT PRIMARY KEY,
        SalesStaff_F_Name VARCHAR(255),
        SalesStaff_L_Name VARCHAR(255),
        SalesStaff_Position VARCHAR(255),
        SalesStaff_Date_Hired DATE,
        SalesStaff_Office VARCHAR(255),
        SalesStaff_Region VARCHAR(255),
        SalesStaff_Manager_Id INT
    );

CREATE TABLE
    Dim_Time (Time_Date DATE PRIMARY KEY, Date_Key INT);

CREATE TABLE
    Dim_OrderMethod (
        OrderMethod_Id INT PRIMARY KEY,
        OrderMethod_Description VARCHAR(255),
        OrderMethod_Payment_Type VARCHAR(255)
    );

-- Fact Table
CREATE TABLE
    Sales (
        Product_Key INT,
        Customer_Key INT,
        Time_Key INT,
        SalesStaff_Key INT,
        OrderMethod_Key INT,
        Quantity_Sold INT,
        Total_Sales_Amount INT,
        Total_Costs INT,
        Gross_Profit INT,
        Applied_Discounts REAL,
        FOREIGN KEY (Product_Key) REFERENCES Dim_Product (Product_Id),
        FOREIGN KEY (Customer_Key) REFERENCES Dim_Customer (Customer_Id),
        FOREIGN KEY (Time_Key) REFERENCES Dim_Time (Date_Key),
        FOREIGN KEY (SalesStaff_Key) REFERENCES Dim_SalesStaff (SalesStaff_Id),
        FOREIGN KEY (OrderMethod_Key) REFERENCES Dim_OrderMethod (OrderMethod_Id)
    );
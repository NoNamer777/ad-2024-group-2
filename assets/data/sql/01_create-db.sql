USE master;
GO;

DROP TABLE IF EXISTS db_great_outdoors.Sales_Target;
DROP TABLE IF EXISTS db_great_outdoors.Inventory_Levels;

DROP TABLE IF EXISTS db_great_outdoors.Campaign;
DROP TABLE IF EXISTS db_great_outdoors.Promotion;
DROP TABLE IF EXISTS db_great_outdoors.Product_Forecast;
DROP TABLE IF EXISTS db_great_outdoors.Product;
DROP TABLE IF EXISTS db_great_outdoors.Product_Type;
DROP TABLE IF EXISTS db_great_outdoors.Product_Line;

DROP TABLE IF EXISTS db_great_outdoors.Returned_Item;
DROP TABLE IF EXISTS db_great_outdoors.Return_Reason;
DROP TABLE IF EXISTS db_great_outdoors.Order_Details;
DROP TABLE IF EXISTS db_great_outdoors.Order_Header;
DROP TABLE IF EXISTS db_great_outdoors.Order_Method;

DROP TABLE IF EXISTS db_great_outdoors.Sales_Staff;
DROP TABLE IF EXISTS db_great_outdoors.Sales_Branch;
DROP TABLE IF EXISTS db_great_outdoors.Retailer_Site;
DROP TABLE IF EXISTS db_great_outdoors.Country;
DROP TABLE IF EXISTS db_great_outdoors.Retailer_Site;
DROP TABLE IF EXISTS db_great_outdoors.Retailer;
DROP TABLE IF EXISTS db_great_outdoors.Retailer_Type;

DROP SCHEMA IF EXISTS db_great_outdoors;
GO;

CREATE SCHEMA db_great_outdoors;
GO;

CREATE TABLE db_great_outdoors.Country (
    country_code  INT PRIMARY KEY,
    country       NVARCHAR(50) NOT NULL,
	language      NVARCHAR(2) NOT NULL
);

CREATE TABLE db_great_outdoors.Retailer_Type (
    retailer_type_code    INT PRIMARY KEY,
    type_name_en      NVARCHAR(25) NOT NULL
);

CREATE TABLE db_great_outdoors.Retailer (
    retailer_code         INT PRIMARY KEY,
    retailer_codemr       INT,
    company_name          NVARCHAR(255) NOT NULL,
    retailer_type_code    INT NOT NULL,
    FOREIGN KEY (retailer_type_code) REFERENCES db_great_outdoors.Retailer_Type(retailer_type_code)
);

CREATE TABLE db_great_outdoors.Retailer_Site (
   retailer_site_code    INT PRIMARY KEY,
   retailer_code         INT NOT NULL,
   address1              NVARCHAR(50) NOT NULL,
   address2              NVARCHAR(50),
   city                  NVARCHAR(40),
   region                NVARCHAR(50),
   postal_zone           NVARCHAR(10),
   country_code          INT NOT NULL,
   active_indicator      BIT,
   FOREIGN KEY (retailer_code)    REFERENCES db_great_outdoors.Retailer(retailer_code),
   FOREIGN KEY (country_code)     REFERENCES db_great_outdoors.Country(country_code)
);

CREATE TABLE db_great_outdoors.Sales_Branch (
    sales_branch_code INT PRIMARY KEY,
    address1          NVARCHAR(50) NOT NULL,
    address2          NVARCHAR(50),
    city              NVARCHAR(40),
    region            NVARCHAR(50),
    postal_zone       NVARCHAR(10),
    country_code      INT NOT NULL,
    FOREIGN KEY (country_code) REFERENCES db_great_outdoors.Country(country_code)
);

CREATE TABLE db_great_outdoors.Sales_Staff (
    sales_staff_code  INT PRIMARY KEY,
    first_name        NVARCHAR(25) NOT NULL,
    last_name         NVARCHAR(30) NOT NULL,
    position_en       NVARCHAR(40) NOT NULL,
    work_phone        NVARCHAR(20),
    extension         NVARCHAR(6),
    fax               NVARCHAR(20),
    email             NVARCHAR(50),
    date_hired        DATETIME NOT NULL,
    sales_branch_code INT NOT NULL,
    manager_code      INT,
    FOREIGN KEY (sales_branch_code) REFERENCES db_great_outdoors.Sales_Branch(sales_branch_code)
);

CREATE TABLE db_great_outdoors.Product_Line (
    product_line_code INT PRIMARY KEY,
    product_line_en   NVARCHAR(40) NOT NULL
);

CREATE TABLE db_great_outdoors.Product_Type (
    product_type_code INT PRIMARY KEY,
    product_line_code INT,
    product_type_en   NVARCHAR(50) NOT NULL,
    FOREIGN KEY (product_line_code) REFERENCES db_great_outdoors.Product_Line(product_line_code)
);

CREATE TABLE db_great_outdoors.Product (
    product_number    INT PRIMARY KEY,
    introduction_date DATETIME NOT NULL,
    product_type_code INT NOT NULL,
    production_cost      FLOAT(53) NOT NULL,
    margin            FLOAT(53) NOT NULL,
    product_image     NVARCHAR(150) NOT NULL,
    product_name      NVARCHAR(255),
    FOREIGN KEY (product_type_code) REFERENCES db_great_outdoors.Product_Type(product_type_code)
);

CREATE TABLE db_great_outdoors.Sales_Target (
    sales_staff_code  INT,
    sales_year        INT,
    sales_period      INT,
    retailer_name     NVARCHAR(50),
    product_number    INT,
    sales_target      FLOAT(53),
    retailer_code     INT,
    PRIMARY KEY (sales_staff_code, sales_year, sales_period, product_number, retailer_code),
    FOREIGN KEY (sales_staff_code)    REFERENCES db_great_outdoors.Sales_Staff(sales_staff_code),
    FOREIGN KEY (product_number)      REFERENCES db_great_outdoors.Product(product_number),
    FOREIGN KEY (retailer_code)       REFERENCES db_great_outdoors.Retailer(retailer_code)
);

CREATE TABLE db_great_outdoors.Order_Method (
    order_method_code INT PRIMARY KEY,
    order_method_en   NVARCHAR(50) NOT NULL
);

CREATE TABLE db_great_outdoors.Order_Header (
    order_number          INT PRIMARY KEY,
    retailer_name         NVARCHAR(50) NOT NULL,
    retailer_site_code    INT NOT NULL,
    retailer_contact_code INT NOT NULL,
    sales_staff_code      INT NOT NULL,
    sales_branch_code     INT NOT NULL,
    order_date            DATETIME NOT NULL,
    order_method_code     INT NOT NULL,
    FOREIGN KEY (retailer_site_code)  REFERENCES db_great_outdoors.Retailer_Site(retailer_site_code),
    FOREIGN KEY (sales_staff_code)    REFERENCES db_great_outdoors.Sales_Staff(sales_staff_code),
    FOREIGN KEY (sales_branch_code)   REFERENCES db_great_outdoors.Sales_Branch(sales_branch_code),
    FOREIGN KEY (order_method_code)   REFERENCES db_great_outdoors.Order_Method(order_method_code)
);

CREATE TABLE db_great_outdoors.Order_Details (
    order_detail_code     INT PRIMARY KEY,
    order_number          INT NOT NULL,
    product_number        INT NOT NULL,
    quantity              SMALLINT NOT NULL,
    unit_cost             FLOAT(53) NOT NULl,
    unit_price            FLOAT(53) NOT NULl,
    unit_sale_price      FLOAT(53) NOT NULL,
    FOREIGN KEY (order_number) REFERENCES db_great_outdoors.Order_Header(order_number)
);

CREATE TABLE db_great_outdoors.Return_Reason (
    return_reason_code    INT PRIMARY KEY,
    reason_description_en NVARCHAR(50)
);

CREATE TABLE db_great_outdoors.Returned_Item (
    return_code           INT PRIMARY KEY,
    return_date           DATETIME NOT NULL,
    order_detail_code     INT NOT NULL,
    return_reason_code    INT NOT NULL,
    return_quantity       SMALLINT NOT NULL,
    FOREIGN KEY (order_detail_code)   REFERENCES db_great_outdoors.Order_Details(order_detail_code),
    FOREIGN KEY (return_reason_code)  REFERENCES db_great_outdoors.Return_Reason(return_reason_code)
);

CREATE TABLE db_great_outdoors.Product_Forecast (
    product_number    INT,
    year              SMALLINT,
    month             TINYINT,
    expected_volume   INT NOT NULL,
    PRIMARY KEY (product_number, year, month),
    FOREIGN KEY (product_number) REFERENCES db_great_outdoors.Product(product_number)
);

CREATE TABLE db_great_outdoors.Promotion (
    pr_number     SMALLINT PRIMARY KEY,
    date_start    DATETIME NOT NULL,
    date_end      DATETIME NOT NULL,
    description   NVARCHAR(50)
);

CREATE TABLE db_great_outdoors.Campaign (
    pr_number         SMALLINT,
    product_number    INT,
    discount          REAL,
    PRIMARY KEY (pr_number, product_number),
    FOREIGN KEY (pr_number)       REFERENCES db_great_outdoors.Promotion(pr_number),
    FOREIGN KEY (product_number)  REFERENCES db_great_outdoors.Product(product_number)
);

CREATE TABLE db_great_outdoors.Inventory_Levels (
    inventory_year    SMALLINT,
    inventory_month   SMALLINT,
    product_number    INT,
    inventory_count   INT NOT NULL,
    PRIMARY KEY (inventory_year, inventory_month, product_number),
    FOREIGN KEY (product_number) REFERENCES db_great_outdoors.Product(product_number)
);
GO;

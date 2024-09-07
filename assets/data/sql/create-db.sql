CREATE TABLE Country (
    `country_code`  INT PRIMARY KEY,
    `country`       VARCHAR(50) NOT NULL,
	`language`      VARCHAR(2) NOT NULL
);

CREATE TABLE Retailer_Type (
    `retailer_type_code`    INT PRIMARY KEY,
    `retailer_name_en`      VARCHAR(25) NOT NULL
);

CREATE TABLE Retailer (
    `retailer_code`         INT PRIMARY KEY,
    `retailer_codemr`       INT NOT NULL,
    `company_name`          VARCHAR(255) NOT NULL,
    `retailer_type_code`    INT NOT NULL,
    FOREIGN KEY (`retailer_type_code`) REFERENCES Retailer_Type(`retailer_type_code`)
);

CREATE TABLE Retailer_Site (
   `retailer_site_code`    INT PRIMARY KEY,
   `retailer_code`         INT NOT NULL,
   `address1`              VARCHAR(50) NOT NULL,
   `address2`              VARCHAR(50),
   `city`                  VARCHAR(40),
   `region`                VARCHAR(50),
   `postal_code`           VARCHAR(10),
   `country_code`          BIT NOT NULL,
   FOREIGN KEY (`retailer_code`)    REFERENCES Retailer(`retailer_code`),
   FOREIGN KEY (`country_code`)     REFERENCES Country(`country_code`)
);

CREATE TABLE Sales_Branch (
    `sales_branch_code` INT PRIMARY KEY,
    `address1`          VARCHAR(50) NOT NULL,
    `address2`          VARCHAR(50),
    `city`              VARCHAR(40),
    `region`            VARCHAR(50),
    `postal_code`       VARCHAR(10),
    `country_code`      INT NOT NULL,
    FOREIGN KEY (`country_code`) REFERENCES Country(`country_code`)
);

CREATE TABLE Sales_Staff (
    `sales_staff_code`  INT PRIMARY KEY,
    `first_name`        VARCHAR(25) NOT NULL,
    `last_name`         VARCHAR(30) NOT NULL,
    `position_en`       VARCHAR(40) NOT NULL,
    `work_phone`        VARCHAR(20),
    `extension`         VARCHAR(6),
    `fax`               VARCHAR(20),
    `email`             VARCHAR(50),
    `date_hired`        DATETIME NOT NULL,
    `sales_branch_code` INT NOT NULL,
    `manager_code`      INT,
    FOREIGN KEY (`sales_branch_code`) REFERENCES Sales_Branch(`sales_branch_code`)
);

CREATE TABLE Product_Line (
    `product_line_code` INT PRIMARY KEY,
    `product_line_en`   VARCHAR(40) NOT NULL
);

CREATE TABLE Product_Type (
    `product_type_code` INT PRIMARY KEY,
    `product_line_code` INT,
    `product_type_en`   VARCHAR(50) NOT NULL,
    FOREIGN KEY (`product_line_code`) REFERENCES Product_Line(`product_line_code`)
);

CREATE TABLE Product (
    `product_number`    INT PRIMARY KEY,
    `introduction_date` DATETIME NOT NULL,
    `product_type_code` INT NOT NULL,
    `product_cost`      FLOAT(53) NOT NULL,
    `margin`            FLOAT(53) NOT NULL,
    `product_image`     VARCHAR(150) NOT NULL,
    `product_name`      VARCHAR(255),
    FOREIGN KEY (`product_type_code`) REFERENCES Product_Type(`product_type_code`)
);

CREATE TABLE Sales_Target (
    `sales_staff_code`  INT,
    `sales_year`        INT,
    `sales_period`      INT,
    `retailer_name`     VARCHAR(50),
    `product_number`    INT,
    `sales_target`      FLOAT(53),
    `retailer_code`     INT,
    PRIMARY KEY (`sales_staff_code`, `sales_year`, `sales_period`, `product_number`, `retailer_code`),
    FOREIGN KEY (`sales_staff_code`)    REFERENCES Sales_Staff(`sales_staff_code`),
    FOREIGN KEY (`product_number`)      REFERENCES Product(`product_number`),
    FOREIGN KEY (`retailer_code`)       REFERENCES Retailer(`retailer_code`)
);

CREATE TABLE Order_Method (
    `order_method_code` INT PRIMARY KEY,
    `order_method_en`   VARCHAR(50) NOT NULL
);

CREATE TABLE Order_Header (
    `order_number`          INT PRIMARY KEY,
    `retailer_name`         VARCHAR(50) NOT NULL,
    `retailer_site_code`    INT NOT NULL,
    `retailer_contact_code` INT NOT NULL,
    `sales_staff_code`      INT NOT NULL,
    `sales_branch_code`     INT NOT NULL,
    `order_date`            DATETIME NOT NULL,
    `order_method_code`     INT NOT NULL,
    FOREIGN KEY (`retailer_site_code`)  REFERENCES Retailer_Site(`retailer_site_code`),
    FOREIGN KEY (`sales_staff_code`)    REFERENCES Sales_Staff(`sales_staff_code`),
    FOREIGN KEY (`sales_branch_code`)   REFERENCES Sales_Branch(`sales_branch_code`),
    FOREIGN KEY (`order_method_code`)   REFERENCES Order_Method(`order_method_code`)
);

CREATE TABLE Order_Details (
    `order_detail_code`     INT PRIMARY KEY,
    `order_number`          INT NOT NULL,
    `product_number`        INT NOT NULL,
    `quantity`              SMALLINT NOT NULL,
    `unit_cost`             FLOAT(53) NOT NULl,
    `unit_price`            FLOAT(53) NOT NULl,
    `unit_sales_price`      FLOAT(53) NOT NULL,
    FOREIGN KEY (`order_number`) REFERENCES Order_Header(`order_number`)
);

CREATE TABLE Return_Reason (
    `return_reason_code`    INT PRIMARY KEY,
    `reason_description_en` VARCHAR(50)
);

CREATE TABLE Returned_Item (
    `return_code`           INT PRIMARY KEY,
    `return_date`           DATETIME NOT NULL,
    `order_detail_code`     INT NOT NULL,
    `return_reason_code`    INT NOT NULL,
    `return_quantity`       SMALLINT NOT NULL,
    FOREIGN KEY (`order_detail_code`)   REFERENCES Order_Details(`order_detail_code`),
    FOREIGN KEY (`return_reason_code`)  REFERENCES Return_Reason(`return_reason_code`)
);

CREATE TABLE Product_Forecast (
    `product_number`    INT,
    `year`              SMALLINT,
    `month`             TINYINT,
    `expected_volume`   INT NOT NULL,
    PRIMARY KEY (`product_number`, `year`, `month`),
    FOREIGN KEY (`product_number`) REFERENCES Product(`product_number`)
);

CREATE TABLE Promotion (
    `pr_number`     SMALLINT PRIMARY KEY,
    `date_start`    DATETIME NOT NULL,
    `date_end`      DATETIME NOT NULL,
    `description`   VARCHAR(50)
);

CREATE TABLE Campaign (
    `pr_number`         SMALLINT,
    `product_number`    INT,
    `discount`          REAL,
    PRIMARY KEY (`pr_number`, `product_number`),
    FOREIGN KEY (`pr_number`)       REFERENCES Promotion(`pr_number`),
    FOREIGN KEY (`product_number`)  REFERENCES Product(`product_number`)
);

CREATE TABLE Inventory_Levels (
    `inventory_year`    SMALLINT,
    `inventory_month`   SMALLINT,
    `product_number`    INT,
    `inventory_count`   INT NOT NULL,
    PRIMARY KEY (`inventory_year`, `inventory_month`, `product_number`),
    FOREIGN KEY (`product_number`) REFERENCES Product(`product_number`)
);

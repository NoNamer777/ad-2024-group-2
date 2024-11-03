CREATE TABLE
    customer (
        id INT NOT NULL,
        fname VARCHAR(255) NULL,
        lname VARCHAR(255) NULL,
        address VARCHAR(255) NULL,
        city VARCHAR(255) NULL,
        state VARCHAR(255) NULL,
        zip VARCHAR(255) NULL,
        phone VARCHAR(255) NULL,
        company_name VARCHAR(255) NULL,
        type VARCHAR(1) NULL,
        discount INT NULL,
        max_quantity_order INT NULL,
        CONSTRAINT pk_customer PRIMARY KEY (id)
    );

CREATE TABLE
    department (
        dept_id INT NOT NULL,
        dept_name VARCHAR(255) NULL,
        dept_head_id INT NULL,
        CONSTRAINT pk_department PRIMARY KEY (dept_id)
    );

CREATE INDEX idx_department_dept_head_id ON department (dept_head_id);

CREATE TABLE
    employee (
        emp_id INT NOT NULL,
        manager_id INT NULL,
        emp_fname VARCHAR(255) NULL,
        emp_lname VARCHAR(255) NULL,
        dept_id INT NULL,
        street VARCHAR(255) NULL,
        city VARCHAR(255) NULL,
        state VARCHAR(255) NULL,
        zip_code VARCHAR(255) NULL,
        phone VARCHAR(255) NULL,
        status VARCHAR(255) NULL,
        ss_number VARCHAR(255) NULL,
        salary FLOAT (53) NULL,
        start_date DATETIME NULL,
        termination_date VARCHAR(255) NULL,
        birth_date DATETIME NULL,
        bene_health_ins VARCHAR(255) NULL,
        bene_life_ins VARCHAR(255) NULL,
        bene_day_care VARCHAR(255) NULL,
        sex VARCHAR(255) NULL,
        CONSTRAINT pk_employee PRIMARY KEY (emp_id),
        CONSTRAINT fk_employee_department FOREIGN KEY (dept_id) REFERENCES department (dept_id)
    );

CREATE INDEX idx_employee_dept_id ON employee (dept_id);

CREATE INDEX idx_employee_manager_id ON employee (manager_id);

CREATE INDEX idx_employee_zip_code ON employee (zip_code);

CREATE TABLE
    fin_code (
        code VARCHAR(255) NOT NULL,
        type VARCHAR(255) NULL,
        description VARCHAR(255) NULL,
        CONSTRAINT pk_fin_code PRIMARY KEY (code)
    );

CREATE TABLE
    product (
        id INT NOT NULL,
        name VARCHAR(255) NULL,
        description VARCHAR(255) NULL,
        prod_size VARCHAR(255) NULL,
        color VARCHAR(255) NULL,
        quantity INT NULL,
        unit_price FLOAT (53) NULL,
        picture_name VARCHAR(255) NULL,
        category VARCHAR(1) NULL,
        CONSTRAINT pk_product PRIMARY KEY (id)
    );

CREATE TABLE
    sales_order (
        id INT NOT NULL,
        cust_id INT NULL,
        order_date DATETIME NULL,
        fin_code_id VARCHAR(255) NULL,
        region VARCHAR(255) NULL,
        sales_rep INT NULL,
        CONSTRAINT pk_sales_order PRIMARY KEY (id),
        CONSTRAINT fk_sales_order_customer FOREIGN KEY (cust_id) REFERENCES customer (id),
        CONSTRAINT fk_sales_order_employee FOREIGN KEY (sales_rep) REFERENCES employee (emp_id),
        CONSTRAINT fk_sales_order_fin_code FOREIGN KEY (fin_code_id) REFERENCES fin_code (code)
    );

CREATE INDEX idx_sales_order_cust_id ON sales_order (cust_id);

CREATE INDEX idx_sales_order_sales_rep ON sales_order (sales_rep);

CREATE INDEX idx_sales_order_fin_code_id ON sales_order (fin_code_id);

CREATE TABLE
    sales_order_item (
        id INT NOT NULL,
        line_id INT NOT NULL,
        prod_id INT NULL,
        quantity INT NULL,
        ship_date DATETIME NULL,
        CONSTRAINT pk_sales_order_item PRIMARY KEY (id, line_id),
        CONSTRAINT fk_sales_order_item_product FOREIGN KEY (prod_id) REFERENCES product (id),
        CONSTRAINT fk_sales_order_item_sales_order FOREIGN KEY (id) REFERENCES sales_order (id)
    );

CREATE INDEX idx_sales_order_item_prod_id ON sales_order_item (prod_id);

CREATE INDEX idx_sales_order_item_sales_order_id ON sales_order_item (id);

CREATE INDEX idx_sales_order_item_line_id ON sales_order_item (line_id);
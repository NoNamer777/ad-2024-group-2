CREATE TABLE job (
    job_number INT,
    job_id     VARCHAR(255),
    job_title  VARCHAR(255),
    min_salary DECIMAL,
    max_salary DECIMAL,
    CONSTRAINT job_pk PRIMARY KEY(job_number)
);

CREATE TABLE department (
    dept_id      INT,
    dept_name    VARCHAR(255),
    dept_head_id INT,
    CONSTRAINT dept_pk PRIMARY KEY(dept_id)
);

CREATE TABLE employee (
    emp_id           INT           NOT NULL,
    manager_id       INT           NULL,
    emp_fname        VARCHAR(255)  NULL,
    emp_lname        VARCHAR(255)  NULL,
    dept_id          INT           NULL,
    street           VARCHAR(255)  NULL,
    city             VARCHAR(255)  NULL,
    state            VARCHAR(255)  NULL,
    zip_code         VARCHAR(255)  NULL,
    phone            VARCHAR(255)  NULL,
    status           VARCHAR(255)  NULL,
    ss_number        VARCHAR(255)  NULL,
    salary           DOUBLE(15, 5) NULL,
    start_date       DATETIME      NULL,
    termination_date VARCHAR(255)  NULL,
    birth_date       DATETIME      NULL,
    bene_health_ins  VARCHAR(255)  NULL,
    bene_life_ins    VARCHAR(255)  NULL,
    bene_day_care    VARCHAR(255)  NULL,
    sex              VARCHAR(255)  NULL,
    CONSTRAINT empl_pk PRIMARY KEY (emp_id),
    CONSTRAINT empl_dept_fk FOREIGN KEY (dept_id) REFERENCES department (dept_id)
);

CREATE TABLE bonus (
    emp_id	     INT,
    bonus_date   DATETIME,
    bonus_amount DECIMAL,
    CONSTRAINT bonus_pk PRIMARY KEY(emp_id,bonus_date)
);

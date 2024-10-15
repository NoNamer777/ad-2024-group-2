create table job
(
    job_number int,
    job_id     varchar(255),
    job_title  varchar(255),
     min_salary decimal,
    max_salary decimal,
    constraint job_pk primary key(job_number)
);


create table department
(
    dept_id      int,
    dept_name    varchar(255),
    dept_head_id int,
    constraint dept_pk primary key(dept_id)
);

create table employee
(
    emp_id           int           not null primary key,
    manager_id       int           null,
    emp_fname        varchar(255)  null,
    emp_lname        varchar(255)  null,
    dept_id          int           null,
    street           varchar(255)  null,
    city             varchar(255)  null,
    state            varchar(255)  null,
    zip_code         varchar(255)  null,
    phone            varchar(255)  null,
    status           varchar(255)  null,
    ss_number        varchar(255)  null,
    salary           double(15, 5) null,
    start_date       datetime      null,
    termination_date varchar(255)  null,
    birth_date       datetime      null,
    bene_health_ins  varchar(255)  null,
    bene_life_ins    varchar(255)  null,
    bene_day_care    varchar(255)  null,
    sex              varchar(255)  null,
    constraint empl_dept_fk
        foreign key (dept_id) references department (dept_id)
);

create table bonus (
    emp_id	int,
    bonus_date datetime ,
    bonus_amount decimal,
    constraint bonus_pk primary key(emp_id,bonus_date)
);

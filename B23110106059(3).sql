-- CREATE TABLES
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10, 2),
    dept_id INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    budget DECIMAL(12, 2),
    start_date DATE,
    end_date DATE
);
CREATE TABLE employee_projects (
    emp_id INT,
    project_id INT,
    hours_worked INT,
    PRIMARY KEY(emp_id, project_id),
    FOREIGN KEY(emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY(project_id) REFERENCES projects(project_id)
);
-- INSERT SAMPLE DATA (Pakistani Names & Cities)
INSERT INTO departments
VALUES (1, 'HR', 'Karachi'),
    (2, 'Accounts', 'Lahore'),
    (3, 'IT', 'Islamabad'),
    (4, 'Marketing', 'Multan');
-- department with no employees
INSERT INTO employees
VALUES (101, 'Ali Raza', 50000, 1, '2020-01-15'),
    (102, 'Sara Khan', 60000, 2, '2019-03-10'),
    (103, 'Ahmed Nawaz', 55000, 3, '2021-07-25'),
    (104, 'Fatima Bibi', 45000, NULL, '2022-05-14'),
    -- employee without department
    (105, 'Hassan Shah', 70000, 2, '2018-11-30');
INSERT INTO projects
VALUES (
        201,
        'NADRA System Upgrade',
        1000000,
        '2022-01-01',
        '2022-12-31'
    ),
    (
        202,
        'PTCL Website Redesign',
        200000,
        '2023-02-01',
        '2023-06-30'
    ),
    (
        203,
        'Jazz Mobile App',
        300000,
        '2023-05-01',
        '2023-12-31'
    ),
    (
        204,
        'PakWheels Campaign',
        150000,
        '2023-03-01',
        '2023-04-30'
    );
-- no employees assigned
INSERT INTO employee_projects
VALUES (101, 201, 120),
    (102, 202, 80),
    (103, 201, 100),
    (105, 203, 150);
-- PART 1: BASIC JOINS
SELECT e.emp_id,
    e.emp_name,
    d.dept_name
FROM employees e
    LEFT JOIN departments d ON e.dept_id = d.dept_id;
SELECT d.dept_id,
    d.dept_name,
    e.emp_name
FROM departments d
    LEFT JOIN employees e ON d.dept_id = e.dept_id;
SELECT emp_id,
    emp_name
FROM employees
WHERE dept_id IS NULL;
-- PART 2: COMPLEX JOINS
SELECT p.project_id,
    p.project_name,
    e.emp_name
FROM projects p
    LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
    LEFT JOIN employees e ON ep.emp_id = e.emp_id;
SELECT d.dept_id,
    d.dept_name,
    COALESCE(SUM(ep.hours_worked), 0) AS total_hours
FROM departments d
    LEFT JOIN employees e ON d.dept_id = e.dept_id
    LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
GROUP BY d.dept_id,
    d.dept_name;
SELECT e.emp_id,
    e.emp_name
FROM employees e
    LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
WHERE ep.project_id IS NULL;
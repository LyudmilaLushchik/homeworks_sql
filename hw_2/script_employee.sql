CREATE TABLE IF NOT EXISTS employee (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    dept VARCHAR(50),
    manager_id INTEGER,
    CONSTRAINT manager_id FOREIGN KEY (manager_id) REFERENCES employee(id)
);
-- Спроектированное хранилище данных методом моделирования данных Data Vault https://docs.google.com/document/d/1zktLZf9hgGPvgOdK_qbTQIZz9txC89vSveHxnyeGnLk/edit?usp=sharing 

-- Customers
CREATE TABLE Customer (
    customer_id BIGINT PRIMARY KEY,
    country VARCHAR,
    city VARCHAR,
    state VARCHAR,
    postal_code BIGINT
);

-- Products
CREATE TABLE Product (
    product_id BIGINT PRIMARY KEY,
    category VARCHAR,
    sub_category VARCHAR
);

-- Orders
CREATE TABLE Order (
    order_id BIGINT PRIMARY KEY,
    ship_mode VARCHAR,
    segment VARCHAR
);

-- Создание связи между Customers и Orders
CREATE TABLE Customer_Order (
    customer_id BIGINT REFERENCES Customer(customer_id),
    order_id BIGINT REFERENCES Order(order_id),
    PRIMARY KEY (customer_id, order_id)
);

-- Создание связи между Orders и Products
CREATE TABLE Order_Product (
    order_id BIGINT REFERENCES Order(order_id),
    product_id BIGINT REFERENCES Product(product_id),
    PRIMARY KEY (order_id, product_id)
);

-- Создание спутников для Customer
CREATE TABLE Customer_Satellite (
    customer_id BIGINT REFERENCES Customer(customer_id),
    country VARCHAR,
    city VARCHAR,
    state VARCHAR,
    postal_code BIGINT
);

-- Создание спутников для Products
CREATE TABLE Product_Satellite (
    product_id BIGINT REFERENCES Product(product_id),
    category VARCHAR,
    sub_category VARCHAR
);

-- Создание спутников для Orders
CREATE TABLE Order_Satellite (
    order_id BIGINT REFERENCES Order(order_id),
    sales DECIMAL,
    quantity BIGINT,
    discount DECIMAL,
    profit DECIMAL
);

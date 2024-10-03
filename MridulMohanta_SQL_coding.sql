create database Ecom
go

use Ecom
go

------Table Creation--------
create table customers(
customer_id INT Primary Key Identity(1,1),
firstname varchar(100),
lastname varchar(100),
email varchar(100),
address varchar(300));

create table products(
product_id INT Primary Key Identity(1,1),
name varchar(100),
description Text,
price decimal(10,2),
stockQuantity INT);

create table cart(
cart_id INT Primary Key Identity(1,1),
customer_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

create table orders(
order_id INT Primary Key Identity(1,1),
customer_id INT,
order_date DATE,
total_price decimal(10,2),
shipping_address varchar(300),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    product_id INT,
    quantity INT,
    itemAmount INT, 
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
----Data INPUT------

INSERT INTO customers(firstname, lastname, email, address)
VALUES
('John', 'Doe', 'johndoe@example.com', '123 Main St, City'),
('Jane', 'Smith', 'janesmith@example.com', '456 Elm St, Town'),
('Robert', 'Johnson', 'robert@example.com', '789 Oak St, Village'),
('Sarah', 'Brown', 'sarah@example.com', '101 Pine St, Suburb'),
('David', 'Lee', 'david@example.com', '234 Cedar St, District'),
('Laura', 'Hall', 'laura@example.com', '567 Birch St, County'),
('Michael', 'Davis', 'michael@example.com', '890 Maple St, State'),
('Emma', 'Wilson', 'emma@example.com', '321 Redwood St, Country'),
('William', 'Taylor', 'william@example.com', '432 Spruce St, Province'),
('Olivia', 'Adams', 'olivia@example.com', '765 Fir St, Territory');


INSERT INTO products(name,description, price, stockQuantity)
VALUES
('Laptop', 'High-performance laptop', 800.00, 10),
('Smartphone', 'Latest smartphone', 600.00, 15),
('Tablet', 'Portable tablet', 300.00, 20),
('Headphones', 'Noise-canceling', 150.00, 30),
('TV', '4K Smart TV', 900.00, 5),
('Coffee Maker', 'Automatic coffee maker', 50.00, 25),
('Refrigerator', 'Energy-efficient', 700.00, 10),
('Microwave Oven', 'Countertop microwave', 80.00, 15),
('Blender', 'High-speed blender', 70.00, 20),
('Vacuum Cleaner', 'Bagless vacuum cleaner', 120.00, 10);

INSERT INTO cart(customer_id, product_id, quantity)
VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 3),
(3, 4, 4),
(3, 5, 2),
(4, 6, 1),
(5, 1, 1),
(6, 10, 2),
(6, 9, 3),
(7, 7, 2);

INSERT INTO orders(customer_id, order_date, total_price, shipping_address)
VALUES
(1, '2023-01-05', 1200.00, ''),
(2, '2023-02-10', 900.00, ''),
(3, '2023-03-15', 300.00, ''),
(4, '2023-04-20', 150.00, ''),
(5, '2023-05-25', 1800.00, ''),
(6, '2023-06-30', 400.00, ''),
(7, '2023-07-05', 700.00, ''),
(8, '2023-08-10', 160.00, ''),
(9, '2023-09-15', 140.00, ''),
(10, '2023-10-20', 1400.00, '');

INSERT INTO order_items(order_id, product_id, quantity, itemAmount)
VALUES
(1, 1, 2, 1600.00),
(1, 3, 1, 300.00),
(2, 2, 3, 1800.00),
(3, 5, 2, 1800.00),
(4, 4, 4, 600.00),
(4, 6, 1, 50.00),
(5, 1, 1, 800.00),
(5, 2, 2, 1200.00),
(6, 10, 2, 240.00),
(6, 9, 3, 210.00);

-----main queries start-------
--1---
UPDATE products
SET price = 800
where name = 'Refrigerator';

--2--
DELETE from cart
where customer_id = 5;

--3--
Select * from products
where price<(100);

--4--
Select * from products
where stockQuantity>(5);

--5--
Select * from orders
where total_price Between 500 and 1000;

--6--
Select * from products
where right(name,1) = 'r';

--7--
Select * from cart
where customer_id = 5;

--8--
Select c.* from customers c
Join  orders o On c.customer_id = o.customer_id
where o.order_date Between '2023-01-01' and '2023-12-31';

--9--
select MIN(stockQuantity) AS min_stock_quantity
from products;

--10--
Select c.customer_id, c.firstname, c.lastname, SUM(o.total_price) AS total_spent 
from customers c
Join orders o On c.customer_id = o.customer_id
Group By c.customer_id, c.firstname, c.lastname;

--11--
Select c.customer_id, c.firstname, c.lastname, AVG(o.total_price) AS average_order_amount 
from customers c
Join orders o On c.customer_id = o.customer_id
Group By c.customer_id, c.firstname, c.lastname;

--12--
Select c.customer_id, c.firstname, c.lastname, COUNT(o.order_id) AS order_count 
from customers c
Join orders o On c.customer_id = o.customer_id
Group By c.customer_id, c.firstname, c.lastname;

--13--
Select c.customer_id, c.firstname, c.lastname, MAX(o.total_price) AS max_order_amount 
from customers c
Join orders o On c.customer_id = o.customer_id
Group By c.customer_id, c.firstname, c.lastname;

--14--
Select c.customer_id, c.firstname, c.lastname, SUM(o.total_price) AS total_spent 
from customers c
Join orders o On c.customer_id = o.customer_id
Group By c.customer_id, c.firstname, c.lastname
Having SUM(o.total_price) > (1000);

--15--
Select * from products p 
where NOT EXISTS (
    select 1 from cart c 
    where c.product_id = p.product_id
);

--16--
Select * from customers c 
where NOT EXISTS (
    select 1 from orders o 
    where o.customer_id = c.customer_id
);

--17--
Select p.product_id, Round((SUM(oi.itemAmount)/(Select SUM(total_price) from orders)) * 100,2) as revenue_perecent
from products p
Join order_items oi On p.product_id = oi.product_id
Group By p.product_id;

--18--(taking 5 as the lowest amount)
select * from products 
where stockQuantity <= 5;

--19--(taking minimum cost for high value item as 1000)
Select * from customers c
where exists(
	select 1 from orders o
	where o.customer_id = c.customer_id
	and o.total_price > 1000
);
---end---
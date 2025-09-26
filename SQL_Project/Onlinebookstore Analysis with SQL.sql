-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:
Select * from Books
where genre='Fiction';


-- 2) Find books published after the year 1950:
Select * from Books where published_year > 1950;

-- 3) List all customers from the Canada:
Select * from Customers where country='Canada';

-- 4) Show orders placed in November 2023:
select * from Orders where order_date Between '2023-11-01' AND '2023-11-30' Order BY order_date ASC;

-- 5) Retrieve the total stock of books available:
select Sum(stock) from Books;

-- 6) Find the details of the most expensive book:
Select * from Books order By price DESC limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
Select * from Orders where quantity > 1 Order by quantity ASC;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders where total_amount > 20 order by total_amount ASC;

-- 9) List all genres available in the Books table:
Select DISTINCT genre From Books;       -- unique

-- 10) Find the book with the lowest stock:
Select * from Books order by stock ASC limit 1; 

-- 11) Calculate the total revenue generated from all orders:
Select sum(total_amount) AS Revenue
from Orders;



SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Advance Questions : 

-- 12) Retrieve the total number of books sold for each genre:
Select b.Genre, Sum(o.quantity) AS Total_books_sold
From Orders o
JOIN Books b ON o.book_id = b.book_id Group By b.Genre;


-- 13) Find the average price of books in the "Fantasy" genre:
Select AVG(price) AS Average_price From Books Where Genre = 'Fantasy'


-- 14) List customers who have placed at least 2 orders:
Select customer_id, COUNT(order_id) AS ORDER_COUNT From orders 
Group By customer_id HAVING COUNT(order_id) >= 2;


Select o.customer_id, c.name, COUNT(o.order_id) AS ORDER_COUNT From orders o
JOIN customers c ON o.customer_id = c.customer_id
Group By o.customer_id, c.name HAVING COUNT(order_id) >= 2;


-- 15) Find the most frequently ordered book:
Select book_id, Count(order_id) AS ORDER_COUNT From orders Group By book_id
Order By ORDER_COUNT DESC limit 1;


-- 16) Show the top 3 most expensive books of 'Fantasy' Genre :
Select * from books Where genre='Fantasy' Order By price DESC limit 3;


-- 17) Retrieve the total quantity of books sold by each author:
Select b.author, sum(quantity) AS Total_book_sold From Orders o 
JOIN Books b ON o.book_id = b.book_id
Group By b.author order By Total_book_sold DESC;


-- 18) List the cities where customers who spent over $300 are located:
Select DISTINCT c.city, total_amount From orders o 
JOIN customers c ON o.customer_id = c.customer_id
Where o.total_amount > 300 Order By total_amount DESC;


-- 19) Find the customer who spent the most on orders:
Select c.customer_id, c.name, SUM(o.total_amount) AS Total_spent From Orders o
JOIN customers c ON o.customer_id = c.customer_id
Group By c.customer_id, c.name Order By Total_spent DESC Limit 1;


-- 20)* Calculate the stock remaining after fulfilling all orders:
Select b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
		b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_quantity
From books b
LEFT JOIN orders o ON b.book_id = o.book_id
Group By b.book_id Order BY b.book_id ASC;







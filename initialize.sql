DROP DATABASE IF EXISTS Bookstore;
CREATE DATABASE Bookstore;
USE Bookstore;


DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Publisher;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Returns;
DROP TABLE IF EXISTS Supplier;


CREATE TABLE Author(
   AuthorID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   FirstName VARCHAR(100) NOT NULL,
   LastName VARCHAR(100) NOT NULL,
   Biography VARCHAR(500),
   DateOfBirth DATE NOT NULL,
   PRIMARY KEY (AuthorID)
);


CREATE TABLE Customer(
   CustomerID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   FirstName VARCHAR(100) NOT NULL,
   LastName VARCHAR(100) NOT NULL,
   Email VARCHAR(100) NOT NULL UNIQUE,
   Address VARCHAR(300),
   PhoneNumber VARCHAR(15) NOT NULL,
   PRIMARY KEY (CustomerID)
);


CREATE TABLE Publisher(
   PublisherID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   Name VARCHAR(100) NOT NULL,
   Address VARCHAR(300),
   PhoneNumber VARCHAR(15) NOT NULL,
   Email VARCHAR(100) NOT NULL UNIQUE,
   PRIMARY KEY (PublisherID)
);


CREATE TABLE Supplier(
   SupplierID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   Name VARCHAR(100) NOT NULL,
   Address VARCHAR(300),
   Email VARCHAR(100) NOT NULL UNIQUE,
   PhoneNumber VARCHAR(15) NOT NULL,
   PRIMARY KEY (SupplierID)
);


CREATE TABLE Book(
   BookID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   Title VARCHAR(100),
   ISBN VARCHAR(13) NOT NULL UNIQUE,
   AuthorID SMALLINT UNSIGNED NOT NULL,
   Genre VARCHAR(50),
   PublisherID SMALLINT UNSIGNED NOT NULL,
   PublicationDate DATE NOT NULL,
   Price DECIMAL(10,2) NOT NULL,
   QuantityInStock SMALLINT NOT NULL,
   PRIMARY KEY(BookID),
   FOREIGN KEY (AuthorID) REFERENCES Author (AuthorID) 
ON DELETE CASCADE
ON UPDATE CASCADE,
   FOREIGN KEY (PublisherID) REFERENCES Publisher (PublisherID) 
ON DELETE CASCADE
ON UPDATE CASCADE
);


CREATE TABLE Inventory(
   InventoryID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   BookID SMALLINT UNSIGNED NOT NULL,
   QuantityInStock SMALLINT UNSIGNED,
   SupplierID SMALLINT UNSIGNED NOT NULL,
   PRIMARY KEY(InventoryID),
   FOREIGN KEY (BookID) REFERENCES Book (BookID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
   FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
   CHECK (QuantityInStock >= 0)
);


CREATE TABLE Orders(
   OrderID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   CustomerID SMALLINT UNSIGNED NOT NULL,
   OrderDate DATE NOT NULL,
   OrderStatus VARCHAR(50) NOT NULL,
   TotalAmount DECIMAL(10,2) NOT NULL,
   PaymentMethod VARCHAR(100) NOT NULL,
   ShippingAddress VARCHAR(500) NOT NULL,
   PRIMARY KEY(OrderID),
   FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) 
	ON DELETE RESTRICT,
   CHECK (TotalAmount > 0),
   CHECK (OrderStatus IN ('Pending', 'Shipped', 'Delivered', 'Cancelled', 'Processing'))
);


CREATE TABLE OrderItem(
   OrderItemID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   OrderID SMALLINT UNSIGNED NOT NULL,
   BookID SMALLINT UNSIGNED NOT NULL,
   Quantity SMALLINT UNSIGNED NOT NULL,
   UnitPrice DECIMAL(10,2) NOT NULL,
   PRIMARY KEY(OrderItemID),
   FOREIGN KEY (OrderID) REFERENCES Orders (OrderID)
ON DELETE CASCADE
ON UPDATE CASCADE,
   FOREIGN KEY (BookID) REFERENCES Book (BookID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
   CHECK (Quantity > 0),
   CHECK (UnitPrice > 0)
);


CREATE TABLE Payment(
   PaymentID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   OrderID SMALLINT UNSIGNED NOT NULL,
   PaymentMethod VARCHAR(100) NOT NULL,
   PaymentDate DATE NOT NULL,
   Amount DECIMAL(10,2) NOT NULL,
   PRIMARY KEY(PaymentID),
   FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) 
	ON DELETE CASCADE
ON UPDATE CASCADE,
   CHECK (Amount > 0)
);


CREATE TABLE Review(
   ReviewID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
   BookID SMALLINT UNSIGNED NOT NULL,
   CustomerID SMALLINT UNSIGNED NOT NULL,
   Rating SMALLINT UNSIGNED,
   ReviewDate DATE NOT NULL,
   ReviewText VARCHAR(10000),
   PRIMARY KEY(ReviewID),
   FOREIGN KEY (BookID) REFERENCES Book (BookID)
ON DELETE CASCADE
ON UPDATE CASCADE,
   FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID)
ON DELETE CASCADE
ON UPDATE CASCADE,
   CHECK (Rating IS NOT NULL OR ReviewText IS NOT NULL),
   CHECK (Rating BETWEEN 0 AND 5)
);


CREATE TABLE Returns(
    ReturnID SMALLINT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    OrderID SMALLINT UNSIGNED NOT NULL,
    BookID SMALLINT UNSIGNED NOT NULL,
    ReturnDate DATE NOT NULL,
    OrderDate DATETIME NOT NULL,
    QuantityReturned SMALLINT UNSIGNED NOT NULL,
    Reason VARCHAR(500),
    PRIMARY KEY(ReturnID),
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Book (BookID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (QuantityReturned > 0),
    CHECK (DATEDIFF(ReturnDate, OrderDate) <= 7)
);

CREATE INDEX idx_book_id ON Inventory(BookID);


CREATE INDEX idx_supplier_id ON Inventory(SupplierID);


CREATE INDEX idx_order_id ON OrderItem(OrderID);


CREATE INDEX idx_book_id ON OrderItem(BookID);


CREATE INDEX idx_order_id ON Payment(OrderID);


CREATE INDEX idx_book_id ON Review(BookID);


CREATE INDEX idx_customer_id ON Review(CustomerID);


CREATE INDEX idx_order_id ON Returns(OrderID);


CREATE INDEX idx_book_id ON Returns(BookID);


INSERT INTO Author (AuthorID, FirstName, LastName, Biography, DateOfBirth) VALUES
    (1, 'John', 'Doe', 'John Doe is a prolific author of mystery novels.', '1970-01-15'),
    (2, 'Jane', 'Smith', 'Jane Smith writes science fiction and fantasy.', '1980-05-22'),
    (3, 'Emily', 'Johnson', 'Emily Johnson is known for her historical fiction.', '1965-03-10'),
    (4, 'Michael', 'Brown', 'Michael Brown specializes in thriller and suspense.', '1975-07-25'),
    (5, 'Sarah', 'Davis', 'Sarah Davis writes contemporary romance novels.', '1985-11-30'),
    (6, 'David', 'Wilson', 'David Wilson is a renowned author of horror stories.', '1960-09-05'),
    (7, 'Laura', 'Martinez', 'Laura Martinez is famous for her fantasy series.', '1978-12-12'),
    (8, 'James', 'Anderson', 'James Anderson writes detective and crime fiction.', '1982-04-18'),
    (9, 'Linda', 'Taylor', 'Linda Taylor is a celebrated author of children’s books.', '1971-06-22'),
    (10, 'Robert', 'Moore', 'Robert Moore is known for his science fiction works.', '1968-08-14'),
    (11, 'Patricia', 'Jackson', 'Patricia Jackson writes historical romance novels.', '1973-02-28'),
    (12, 'Charles', 'White', 'Charles White is a popular author of adventure novels.', '1980-10-10'),
    (13, 'Barbara', 'Harris', 'Barbara Harris writes psychological thrillers.', '1962-01-05'),
    (14, 'Thomas', 'Clark', 'Thomas Clark is known for his epic fantasy series.', '1977-03-20'),
    (15, 'Jennifer', 'Lewis', 'Jennifer Lewis writes contemporary fiction.', '1983-05-15'),
    (16, 'Christopher', 'Walker', 'Christopher Walker is a renowned horror writer.', '1969-07-07'),
    (17, 'Karen', 'Hall', 'Karen Hall is famous for her mystery novels.', '1974-09-09'),
    (18, 'Daniel', 'Allen', 'Daniel Allen writes science fiction and dystopian novels.', '1981-11-11'),
    (19, 'Nancy', 'Young', 'Nancy Young is a celebrated author of children’s fantasy.', '1963-12-25'),
    (20, 'Paul', 'King', 'Paul King writes historical fiction and drama.', '1976-02-14'),
    (21, 'Betty', 'Wright', 'Betty Wright is known for her romantic thrillers.', '1984-04-04'),
    (22, 'Mark', 'Scott', 'Mark Scott writes detective and crime fiction.', '1972-06-06'),
    (23, 'Sandra', 'Green', 'Sandra Green is a popular author of contemporary romance.', '1986-08-08'),
    (24, 'Steven', 'Adams', 'Steven Adams writes epic fantasy and adventure.', '1967-10-10'),
    (25, 'Donna', 'Baker', 'Donna Baker is known for her psychological thrillers.', '1979-12-12');


INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Address, PhoneNumber) VALUES
    (1, 'Alice', 'Johnson', 'alice.johnson@example.com', '123 Main St, Anytown, USA', '555-1234'),
    (2, 'Bob', 'Williams', 'bob.williams@example.com', '456 Oak St, Anytown, USA', '555-5678'),
    (3, 'Carol', 'Smith', 'carol.smith@example.com', '789 Pine St, Anytown, USA', '555-8765'),
    (4, 'David', 'Brown', 'david.brown@example.com', '101 Maple St, Anytown, USA', '555-4321'),
    (5, 'Eve', 'Davis', 'eve.davis@example.com', '202 Elm St, Anytown, USA', '555-9876'),
    (6, 'Frank', 'Wilson', 'frank.wilson@example.com', '303 Birch St, Anytown, USA', '555-6543'),
    (7, 'Grace', 'Martinez', 'grace.martinez@example.com', '404 Cedar St, Anytown, USA', '555-3210'),
    (8, 'Hank', 'Anderson', 'hank.anderson@example.com', '505 Spruce St, Anytown, USA', '555-0987'),
    (9, 'Ivy', 'Taylor', 'ivy.taylor@example.com', '606 Fir St, Anytown, USA', '555-7654'),
    (10, 'Jack', 'Moore', 'jack.moore@example.com', '707 Walnut St, Anytown, USA', '555-4321'),
    (11, 'Kathy', 'Jackson', 'kathy.jackson@example.com', '808 Chestnut St, Anytown, USA', '555-1234'),
    (12, 'Leo', 'White', 'leo.white@example.com', '909 Ash St, Anytown, USA', '555-5678'),
    (13, 'Mia', 'Harris', 'mia.harris@example.com', '1010 Poplar St, Anytown, USA', '555-8765'),
    (14, 'Nina', 'Clark', 'nina.clark@example.com', '1111 Cypress St, Anytown, USA', '555-4321'),
    (15, 'Oscar', 'Lewis', 'oscar.lewis@example.com', '1212 Redwood St, Anytown, USA', '555-9876'),
    (16, 'Pam', 'Walker', 'pam.walker@example.com', '1313 Sequoia St, Anytown, USA', '555-6543'),
    (17, 'Quinn', 'Hall', 'quinn.hall@example.com', '1414 Magnolia St, Anytown, USA', '555-3210'),
    (18, 'Ray', 'Allen', 'ray.allen@example.com', '1515 Willow St, Anytown, USA', '555-0987'),
    (19, 'Sue', 'Young', 'sue.young@example.com', '1616 Pine St, Anytown, USA', '555-7654'),
    (20, 'Tom', 'King', 'tom.king@example.com', '1717 Maple St, Anytown, USA', '555-4321'),
    (21, 'Uma', 'Wright', 'uma.wright@example.com', '1818 Elm St, Anytown, USA', '555-1234'),
    (22, 'Vic', 'Scott', 'vic.scott@example.com', '1919 Birch St, Anytown, USA', '555-5678'),
    (23, 'Wendy', 'Green', 'wendy.green@example.com', '2020 Cedar St, Anytown, USA', '555-8765'),
    (24, 'Xander', 'Adams', 'xander.adams@example.com', '2121 Spruce St, Anytown, USA', '555-4321'),
    (25, 'Yara', 'Baker', 'yara.baker@example.com', '2222 Fir St, Anytown, USA', '555-9876');



INSERT INTO Publisher (PublisherID, Name, Address, PhoneNumber, Email) VALUES
    (1, 'Mystery House', '789 Pine St, Anytown, USA', '555-8765', 'contact@mysteryhouse.com'),
    (2, 'Sci-Fi World', '101 Maple St, Anytown, USA', '555-4321', 'info@scifiworld.com'),
    (3, 'Historical Tales', '202 Elm St, Anytown, USA', '555-9876', 'contact@historicaltales.com'),
    (4, 'Thriller Press', '303 Birch St, Anytown, USA', '555-6543', 'info@thrillerpress.com'),
    (5, 'Romance Reads', '404 Cedar St, Anytown, USA', '555-3210', 'contact@romancereads.com'),
    (6, 'Horror House', '505 Spruce St, Anytown, USA', '555-0987', 'info@horrorhouse.com'),
    (7, 'Fantasy World', '606 Fir St, Anytown, USA', '555-7654', 'contact@fantasyworld.com'),
    (8, 'Crime Stories', '707 Walnut St, Anytown, USA', '555-4321', 'info@crimestories.com'),
    (9, 'Children’s Books', '808 Chestnut St, Anytown, USA', '555-1234', 'contact@childrensbooks.com'),
    (10, 'Sci-Fi Universe', '909 Ash St, Anytown, USA', '555-5678', 'info@scifiuniverse.com'),
    (11, 'Historical Romance', '1010 Poplar St, Anytown, USA', '555-8765', 'contact@historicalromance.com'),
    (12, 'Adventure Press', '1111 Cypress St, Anytown, USA', '555-4321', 'info@adventurepress.com'),
    (13, 'Psychological Thrillers', '1212 Redwood St, Anytown, USA', '555-9876', 'contact@psychthrillers.com'),
    (14, 'Epic Fantasy', '1313 Sequoia St, Anytown, USA', '555-6543', 'info@epicfantasy.com'),
    (15, 'Contemporary Fiction', '1414 Magnolia St, Anytown, USA', '555-3210', 'contact@contemporaryfiction.com'),
    (16, 'Horror Stories', '1515 Willow St, Anytown, USA', '555-0987', 'info@horrorstories.com'),
    (17, 'Mystery Novels', '1616 Pine St, Anytown, USA', '555-7654', 'contact@mysterynovels.com'),
    (18, 'Dystopian Press', '1717 Maple St, Anytown, USA', '555-4321', 'info@dystopianpress.com'),
    (19, 'Children’s Fantasy', '1818 Elm St, Anytown, USA', '555-1234', 'contact@childrensfantasy.com'),
    (20, 'Historical Drama', '1919 Birch St, Anytown, USA', '555-5678', 'info@historicaldrama.com'),
    (21, 'Romantic Thrillers', '2020 Cedar St, Anytown, USA', '555-8765', 'contact@romanticthrillers.com'),
    (22, 'Detective Stories', '2121 Spruce St, Anytown, USA', '555-4321', 'info@detectivestories.com'),
    (23, 'Contemporary Romance', '2222 Fir St, Anytown, USA', '555-9876', 'contact@contemporaryromance.com'),
    (24, 'Epic Adventures', '2323 Oak St, Anytown, USA', '555-6543', 'info@epicadventures.com'),
    (25, 'Psychological Mysteries', '2424 Maple St, Anytown, USA', '555-3210', 'contact@psychmysteries.com');


INSERT INTO Supplier (SupplierID, Name, Address, Email, PhoneNumber) VALUES
    (1, 'Book Supplies Inc.', '123 Main St, Anytown, USA', 'contact@booksupplies.com', '555-1234'),
    (2, 'Novel Distributors', '456 Oak St, Anytown, USA', 'info@noveldistributors.com', '555-5678'),
    (3, 'Literary Goods', '789 Pine St, Anytown, USA', 'sales@literarygoods.com', '555-8765'),
    (4, 'Page Turners', '101 Maple St, Anytown, USA', 'support@pageturners.com', '555-4321'),
    (5, 'Story House', '202 Elm St, Anytown, USA', 'contact@storyhouse.com', '555-9876'),
    (6, 'Book Haven', '303 Birch St, Anytown, USA', 'info@bookhaven.com', '555-6543'),
    (7, 'Readers Paradise', '404 Cedar St, Anytown, USA', 'support@readersparadise.com', '555-3210'),
    (8, 'Book World', '505 Spruce St, Anytown, USA', 'contact@bookworld.com', '555-0987'),
    (9, 'Literature Hub', '606 Fir St, Anytown, USA', 'info@literaturehub.com', '555-7654'),
    (10, 'Book Emporium', '707 Walnut St, Anytown, USA', 'sales@bookemporium.com', '555-4321'),
    (11, 'Novelty Books', '808 Chestnut St, Anytown, USA', 'support@noveltybooks.com', '555-1234'),
    (12, 'Book Depot', '909 Ash St, Anytown, USA', 'contact@bookdepot.com', '555-5678'),
    (13, 'Fictional Supplies', '1010 Poplar St, Anytown, USA', 'info@fictionalsupplies.com', '555-8765'),
    (14, 'Book Bazaar', '1111 Cypress St, Anytown, USA', 'support@bookbazaar.com', '555-4321'),
    (15, 'Literary Treasures', '1212 Redwood St, Anytown, USA', 'contact@literarytreasures.com', '555-9876'),
    (16, 'Book Mart', '1313 Sequoia St, Anytown, USA', 'info@bookmart.com', '555-6543'),
    (17, 'Novel Nook', '1414 Magnolia St, Anytown, USA', 'support@novelnook.com', '555-3210'),
    (18, 'Book Outlet', '1515 Willow St, Anytown, USA', 'contact@bookoutlet.com', '555-0987'),
    (19, 'Literary Source', '1616 Pine St, Anytown, USA', 'info@literarysource.com', '555-7654'),
    (20, 'Book Warehouse', '1717 Maple St, Anytown, USA', 'support@bookwarehouse.com', '555-4321'),
    (21, 'Novel Network', '1818 Elm St, Anytown, USA', 'contact@novelnetwork.com', '555-1234'),
    (22, 'Book Distributors', '1919 Birch St, Anytown, USA', 'info@bookdistributors.com', '555-5678'),
    (23, 'Literary Exchange', '2020 Cedar St, Anytown, USA', 'support@literaryexchange.com', '555-8765'),
    (24, 'Book Traders', '2121 Spruce St, Anytown, USA', 'contact@booktraders.com', '555-4321'),
    (25, 'Novel Suppliers', '2222 Fir St, Anytown, USA', 'info@novelsuppliers.com', '555-9876');


INSERT INTO Book (BookID, Title, ISBN, AuthorID, Genre, PublisherID, PublicationDate, Price, QuantityInStock) VALUES
    (1, 'Mystery at the Mansion', '1234567890123', 1, 'Mystery', 1, '2022-01-01', 19.99, 50),
    (2, 'Journey to Mars', '9876543210987', 2, 'Science Fiction', 2, '2023-05-15', 24.99, 30),
    (3, 'The Lost Treasure', '1234567890124', 1, 'Adventure', 1, '2021-07-21', 15.99, 40),
    (4, 'Space Odyssey', '9876543210988', 2, 'Science Fiction', 2, '2023-08-10', 22.99, 25),
    (5, 'Haunted House', '1234567890125', 1, 'Horror', 1, '2020-10-31', 18.99, 35),
    (6, 'Galactic Wars', '9876543210989', 2, 'Science Fiction', 2, '2022-12-12', 26.99, 20),
    (7, 'Secret of the Pyramid', '1234567890126', 1, 'Mystery', 1, '2021-03-15', 17.99, 45),
    (8, 'Alien Invasion', '9876543210990', 2, 'Science Fiction', 2, '2023-01-25', 23.99, 28),
    (9, 'The Enchanted Forest', '1234567890127', 1, 'Fantasy', 1, '2022-05-05', 20.99, 32),
    (10, 'Robots and AI', '9876543210991', 2, 'Science Fiction', 2, '2023-09-09', 27.99, 18),
    (11, 'The Hidden Cave', '1234567890128', 1, 'Adventure', 1, '2021-11-11', 16.99, 38),
    (12, 'Mars Colony', '9876543210992', 2, 'Science Fiction', 2, '2022-06-06', 25.99, 22),
    (13, 'Ghosts of the Past', '1234567890129', 1, 'Horror', 1, '2020-09-09', 19.99, 30),
    (14, 'Future World', '9876543210993', 2, 'Science Fiction', 2, '2023-04-04', 28.99, 24),
    (15, 'Mystery of the Old Mill', '1234567890130', 1, 'Mystery', 1, '2021-02-02', 18.99, 42),
    (16, 'Space Explorers', '9876543210994', 2, 'Science Fiction', 2, '2023-07-07', 24.99, 26),
    (17, 'The Dark Forest', '1234567890131', 1, 'Fantasy', 1, '2022-08-08', 21.99, 34),
    (18, 'AI Revolution', '9876543210995', 2, 'Science Fiction', 2, '2023-11-11', 29.99, 16),
    (19, 'The Secret Island', '1234567890132', 1, 'Adventure', 1, '2021-12-12', 17.99, 36),
    (20, 'Journey Beyond Earth', '9876543210996', 2, 'Science Fiction', 2, '2022-03-03', 26.99, 20),
    (21, 'Haunted Castle', '1234567890133', 1, 'Horror', 1, '2020-11-11', 19.99, 28),
    (22, 'Galactic Empire', '9876543210997', 2, 'Science Fiction', 2, '2023-02-02', 27.99, 22),
    (23, 'Mystery of the Lost City', '1234567890134', 1, 'Mystery', 1, '2021-04-04', 18.99, 40),
    (24, 'Alien Worlds', '9876543210998', 2, 'Science Fiction', 2, '2023-06-06', 25.99, 24),
    (25, 'The Magic Realm', '1234567890135', 1, 'Fantasy', 1, '2022-10-10', 22.99, 30);


INSERT INTO Inventory (InventoryID, BookID, QuantityInStock, SupplierID) VALUES
    (1, 1, 50, 1),
    (2, 2, 30, 2),
    (3, 3, 40, 3),
    (4, 4, 25, 4),
    (5, 5, 35, 5),
    (6, 6, 20, 6),
    (7, 7, 45, 7),
    (8, 8, 28, 8),
    (9, 9, 32, 9),
    (10, 10, 18, 10),
    (11, 11, 38, 11),
    (12, 12, 22, 12),
    (13, 13, 30, 13),
    (14, 14, 24, 14),
    (15, 15, 42, 15),
    (16, 16, 26, 16),
    (17, 17, 34, 17),
    (18, 18, 16, 18),
    (19, 19, 36, 19),
    (20, 20, 20, 20),
    (21, 21, 28, 21),
    (22, 22, 22, 22),
    (23, 23, 40, 23),
    (24, 24, 24, 24),
    (25, 25, 30, 25);


INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderStatus, TotalAmount, PaymentMethod, ShippingAddress) VALUES
    (1, 1, '2023-01-01', 'Shipped', 59.97, 'Credit Card', '123 Main St, Anytown, USA'),
    (2, 2, '2023-01-05', 'Delivered', 49.98, 'PayPal', '456 Oak St, Anytown, USA'),
    (3, 3, '2023-01-10', 'Processing', 39.99, 'Credit Card', '789 Pine St, Anytown, USA'),
    (4, 4, '2023-01-15', 'Cancelled', 29.99, 'Credit Card', '101 Maple St, Anytown, USA'),
    (5, 5, '2023-01-20', 'Shipped', 19.99, 'Credit Card', '202 Elm St, Anytown, USA'),
    (6, 6, '2023-01-25', 'Delivered', 89.97, 'PayPal', '303 Birch St, Anytown, USA'),
    (7, 7, '2023-01-30', 'Processing', 79.96, 'Credit Card', '404 Cedar St, Anytown, USA'),
    (8, 8, '2023-02-01', 'Shipped', 69.95, 'Credit Card', '505 Spruce St, Anytown, USA'),
    (9, 9, '2023-02-05', 'Delivered', 59.94, 'PayPal', '606 Fir St, Anytown, USA'),
    (10, 10, '2023-02-10', 'Processing', 49.93, 'Credit Card', '707 Walnut St, Anytown, USA'),
    (11, 11, '2023-02-15', 'Cancelled', 39.92, 'Credit Card', '808 Chestnut St, Anytown, USA'),
    (12, 12, '2023-02-20', 'Shipped', 29.91, 'PayPal', '909 Ash St, Anytown, USA'),
    (13, 13, '2023-02-25', 'Delivered', 19.90, 'Credit Card', '1010 Poplar St, Anytown, USA'),
    (14, 14, '2023-03-01', 'Processing', 99.89, 'Credit Card', '1111 Cypress St, Anytown, USA'),
    (15, 15, '2023-03-05', 'Shipped', 89.88, 'PayPal', '1212 Redwood St, Anytown, USA'),
    (16, 16, '2023-03-10', 'Delivered', 79.87, 'Credit Card', '1313 Sequoia St, Anytown, USA'),
    (17, 17, '2023-03-15', 'Processing', 69.86, 'Credit Card', '1414 Magnolia St, Anytown, USA'),
    (18, 18, '2023-03-20', 'Cancelled', 59.85, 'PayPal', '1515 Willow St, Anytown, USA'),
    (19, 19, '2023-03-25', 'Shipped', 49.84, 'Credit Card', '1616 Pine St, Anytown, USA'),
    (20, 20, '2023-03-30', 'Delivered', 39.83, 'Credit Card', '1717 Maple St, Anytown, USA'),
    (21, 21, '2023-04-01', 'Processing', 29.82, 'PayPal', '1818 Elm St, Anytown, USA'),
    (22, 22, '2023-04-05', 'Cancelled', 19.81, 'Credit Card', '1919 Birch St, Anytown, USA'),
    (23, 23, '2023-04-10', 'Shipped', 99.80, 'Credit Card', '2020 Cedar St, Anytown, USA'),
    (24, 24, '2023-04-15', 'Delivered', 89.79, 'PayPal', '2121 Spruce St, Anytown, USA'),
    (25, 25, '2023-04-20', 'Processing', 79.78, 'Credit Card', '2222 Fir St, Anytown, USA');


INSERT INTO OrderItem (OrderItemID, OrderID, BookID, Quantity, UnitPrice) VALUES
    (1, 1, 1, 2, 19.99),
    (2, 1, 3, 1, 15.99),
    (3, 2, 2, 2, 24.99),
    (4, 2, 4, 1, 22.99),
    (5, 3, 5, 2, 18.99),
    (6, 3, 6, 1, 26.99),
    (7, 4, 7, 1, 17.99),
    (8, 4, 8, 2, 23.99),
    (9, 5, 9, 1, 20.99),
    (10, 5, 10, 1, 27.99),
    (11, 6, 11, 2, 16.99),
    (12, 6, 12, 1, 25.99),
    (13, 7, 13, 1, 19.99),
    (14, 7, 14, 2, 28.99),
    (15, 8, 15, 1, 18.99),
    (16, 8, 16, 1, 24.99),
    (17, 9, 17, 2, 21.99),
    (18, 9, 18, 1, 29.99),
    (19, 10, 19, 1, 17.99),
    (20, 10, 20, 2, 26.99),
    (21, 11, 21, 1, 19.99),
    (22, 11, 22, 1, 27.99),
    (23, 12, 23, 2, 18.99),
    (24, 12, 24, 1, 25.99),
    (25, 13, 25, 1, 22.99);


INSERT INTO Payment (PaymentID, OrderID, PaymentMethod, PaymentDate, Amount) VALUES
    (1, 1, 'Credit Card', '2023-01-01', 59.97),
    (2, 2, 'PayPal', '2023-01-05', 49.98),
    (3, 3, 'Credit Card', '2023-01-10', 39.99),
    (4, 4, 'Credit Card', '2023-01-15', 29.99),
    (5, 5, 'Credit Card', '2023-01-20', 19.99),
    (6, 6, 'PayPal', '2023-01-25', 89.97),
    (7, 7, 'Credit Card', '2023-01-30', 79.96),
    (8, 8, 'Credit Card', '2023-02-01', 69.95),
    (9, 9, 'PayPal', '2023-02-05', 59.94),
    (10, 10, 'Credit Card', '2023-02-10', 49.93),
    (11, 11, 'Credit Card', '2023-02-15', 39.92),
    (12, 12, 'PayPal', '2023-02-20', 29.91),
    (13, 13, 'Credit Card', '2023-02-25', 19.90),
    (14, 14, 'Credit Card', '2023-03-01', 99.89),
    (15, 15, 'PayPal', '2023-03-05', 89.88),
    (16, 16, 'Credit Card', '2023-03-10', 79.87),
    (17, 17, 'Credit Card', '2023-03-15', 69.86),
    (18, 18, 'PayPal', '2023-03-20', 59.85),
    (19, 19, 'Credit Card', '2023-03-25', 49.84),
    (20, 20, 'Credit Card', '2023-03-30', 39.83),
    (21, 21, 'PayPal', '2023-04-01', 29.82),
    (22, 22, 'Credit Card', '2023-04-05', 19.81),
    (23, 23, 'Credit Card', '2023-04-10', 99.80),
    (24, 24, 'PayPal', '2023-04-15', 89.79),
    (25, 25, 'Credit Card', '2023-04-20', 79.78);


INSERT INTO Review (ReviewID, BookID, CustomerID, Rating, ReviewDate, ReviewText) VALUES
    (1, 4, 22, 2, '2023-01-23', 'This is a review text for book 4 by customer 22.'),
    (2, 23, 12, 4, '2020-12-16', 'This is a review text for book 23 by customer 12.'),
    (3, 16, 1, 3, '2018-08-17', 'This is a review text for book 16 by customer 1.'),
    (4, 8, 8, 3, '2023-12-21', 'This is a review text for book 8 by customer 8.'),
    (5, 5, 25, 1, '2022-05-19', 'This is a review text for book 5 by customer 25.'),
    (6, 14, 18, 4, '2021-11-11', 'This is a review text for book 14 by customer 18.'),
    (7, 7, 10, 5, '2020-07-07', 'This is a review text for book 7 by customer 10.'),
    (8, 21, 3, 2, '2023-03-03', 'This is a review text for book 21 by customer 3.'),
    (9, 12, 5, 3, '2022-09-09', 'This is a review text for book 12 by customer 5.'),
    (10, 19, 7, 4, '2021-01-01', 'This is a review text for book 19 by customer 7.'),
    (11, 6, 15, 5, '2020-10-10', 'This is a review text for book 6 by customer 15.'),
    (12, 25, 20, 1, '2023-06-06', 'This is a review text for book 25 by customer 20.'),
    (13, 11, 2, 2, '2021-12-12', 'This is a review text for book 11 by customer 2.'),
    (14, 3, 6, 3, '2020-04-04', 'This is a review text for book 3 by customer 6.'),
    (15, 18, 9, 4, '2022-02-02', 'This is a review text for book 18 by customer 9.'),
    (16, 9, 13, 5, '2023-08-08', 'This is a review text for book 9 by customer 13.'),
    (17, 2, 17, 1, '2021-03-03', 'This is a review text for book 2 by customer 17.'),
    (18, 24, 11, 2, '2020-11-11', 'This is a review text for book 24 by customer 11.'),
    (19, 10, 4, 3, '2022-07-07', 'This is a review text for book 10 by customer 4.'),
    (20, 15, 8, 4, '2023-05-05', 'This is a review text for book 15 by customer 8.'),
    (21, 22, 14, 5, '2021-09-09', 'This is a review text for book 22 by customer 14.'),
    (22, 13, 19, 1, '2020-06-06', 'This is a review text for book 13 by customer 19.'),
    (23, 1, 21, 2, '2022-01-01', 'This is a review text for book 1 by customer 21.'),
    (24, 17, 16, 3, '2023-04-04', 'This is a review text for book 17 by customer 16.'),
    (25, 20, 23, 4, '2021-08-08', 'This is a review text for book 20 by customer 23.');


INSERT INTO Returns (ReturnID, OrderID, BookID, ReturnDate, QuantityReturned, Reason) VALUES
    (1, 1, 1, '2023-01-10', 1, 'Reason for returning book 1 from order 1.'),
    (2, 2, 2, '2023-01-15', 2, 'Reason for returning book 2 from order 2.'),
    (3, 3, 3, '2023-01-20', 1, 'Reason for returning book 3 from order 3.'),
    (4, 4, 4, '2023-01-25', 3, 'Reason for returning book 4 from order 4.'),
    (5, 5, 5, '2023-01-30', 2, 'Reason for returning book 5 from order 5.'),
    (6, 6, 6, '2023-02-01', 1, 'Reason for returning book 6 from order 6.'),
    (7, 7, 7, '2023-02-05', 2, 'Reason for returning book 7 from order 7.'),
    (8, 8, 8, '2023-02-10', 1, 'Reason for returning book 8 from order 8.'),
    (9, 9, 9, '2023-02-15', 3, 'Reason for returning book 9 from order 9.'),
    (10, 10, 10, '2023-02-20', 2, 'Reason for returning book 10 from order 10.'),
    (11, 11, 11, '2023-02-25', 1, 'Reason for returning book 11 from order 11.'),
    (12, 12, 12, '2023-03-01', 2, 'Reason for returning book 12 from order 12.'),
    (13, 13, 13, '2023-03-05', 1, 'Reason for returning book 13 from order 13.'),
    (14, 14, 14, '2023-03-10', 3, 'Reason for returning book 14 from order 14.'),
    (15, 15, 15, '2023-03-15', 2, 'Reason for returning book 15 from order 15.'),
    (16, 16, 16, '2023-03-20', 1, 'Reason for returning book 16 from order 16.'),
    (17, 17, 17, '2023-03-25', 2, 'Reason for returning book 17 from order 17.'),
    (18, 18, 18, '2023-03-30', 1, 'Reason for returning book 18 from order 18.'),
    (19, 19, 19, '2023-04-01', 3, 'Reason for returning book 19 from order 19.'),
    (20, 20, 20, '2023-04-05', 2, 'Reason for returning book 20 from order 20.'),
    (21, 21, 21, '2023-04-10', 1, 'Reason for returning book 21 from order 21.'),
    (22, 22, 22, '2023-04-15', 2, 'Reason for returning book 22 from order 22.'),
    (23, 23, 23, '2023-04-20', 1, 'Reason for returning book 23 from order 23.'),
    (24, 24, 24, '2023-04-25', 3, 'Reason for returning book 24 from order 24.'),
    (25, 25, 25, '2023-04-30', 2, 'Reason for returning book 25 from order 25.');



CREATE VIEW CustomerOrders AS
SELECT
   o.OrderID,
   c.CustomerID,
   c.FirstName,
   c.LastName,
   o.OrderDate,
   o.OrderStatus,
   o.TotalAmount
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID;


CREATE VIEW BookInventory AS
SELECT
   b.BookID,
   b.Title,
   b.ISBN,
   i.QuantityInStock,
   s.Name AS SupplierName
FROM Book b
JOIN Inventory i ON b.BookID = i.BookID
JOIN Supplier s ON i.SupplierID = s.SupplierID;


CREATE VIEW OrderDetails AS
SELECT
   o.OrderID,
   oi.OrderItemID,
   b.Title,
   oi.Quantity,
   oi.UnitPrice,
   (oi.Quantity * oi.UnitPrice) AS TotalPrice
FROM Orders o
JOIN OrderItem oi ON o.OrderID = oi.OrderID
JOIN Book b ON oi.BookID = b.BookID;


DELIMITER $$

CREATE PROCEDURE AddNewOrder(
   IN p_CustomerID  SMALLINT,
   IN p_OrderDate DATE,
   IN p_OrderStatus VARCHAR(50),
   IN p_TotalAmount DECIMAL(10,2),
   IN p_PaymentMethod VARCHAR(100),
   IN p_ShippingAddress VARCHAR(500)
)
BEGIN
    INSERT INTO Orders (CustomerID, OrderDate, OrderStatus, TotalAmount, PaymentMethod, ShippingAddress)
    VALUES (p_CustomerID, p_OrderDate, p_OrderStatus, p_TotalAmount, p_PaymentMethod, p_ShippingAddress);
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE UpdateInventory(
   IN p_BookID  SMALLINT,
   IN p_Quantity  SMALLINT
)
BEGIN
    UPDATE Inventory
    SET QuantityInStock = QuantityInStock - p_Quantity
    WHERE BookID = p_BookID;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER AfterOrderItemInsert
AFTER INSERT ON OrderItem
FOR EACH ROW
BEGIN
    CALL UpdateInventory(NEW.BookID, NEW.Quantity);
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER ApplyDiscount
BEFORE INSERT OR UPDATE ON Orders
FOR EACH ROW
BEGIN
   IF NEW.TotalAmount > 100 THEN
      SET NEW.TotalAmount = NEW.TotalAmount * 0.98;
   END IF;
END;

DELIMITER ;

DELIMITER $$

CREATE TRIGGER CheckReturnDate
BEFORE INSERT OR UPDATE ON Returns
FOR EACH ROW
BEGIN
   DECLARE order_date DATETIME;
   SELECT OrderDate INTO order_date FROM Orders WHERE OrderID = NEW.OrderID;


   IF DATEDIFF(day, order_date, NEW.ReturnDate) > 7 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ReturnDate must be within 7 days of OrderDate';
   END IF;
END;

DELIMITER ;

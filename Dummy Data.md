INSERT INTO Author (AuthorID, FirstName, LastName, Biography, DateOfBirth) VALUES
(1, 'John', 'Doe', 'John Doe is a prolific author of mystery novels.', '1970-01-15'),
(2, 'Jane', 'Smith', 'Jane Smith writes science fiction and fantasy.', '1980-05-22');


INSERT INTO Customer (CustomerID, FirstName, LastName, Email, Address, PhoneNumber) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@example.com', '123 Main St, Anytown, USA', '555-1234'),
(2, 'Bob', 'Williams', 'bob.williams@example.com', '456 Oak St, Anytown, USA', '555-5678');


INSERT INTO Publisher (PublisherID, Name, Address, PhoneNumber, Email) VALUES
(1, 'Mystery House', '789 Pine St, Anytown, USA', '555-8765', 'contact@mysteryhouse.com'),
(2, 'Sci-Fi World', '101 Maple St, Anytown, USA', '555-4321', 'info@scifiworld.com');


INSERT INTO Supplier (SupplierID, Name, Address, Email, PhoneNumber) VALUES
(1, 'Book Distributors Inc.', '202 Elm St, Anytown, USA', 'sales@bookdistributors.com', '555-9876'),
(2, 'Global Books', '303 Birch St, Anytown, USA', 'support@globalbooks.com', '555-6543');


INSERT INTO Book (BookID, Title, ISBN, AuthorID, Genre, PublisherID, PublicationDate, Price, QuantityInStock) VALUES
(1, 'Mystery at the Mansion', '1234567890123', 1, 'Mystery', 1, '2022-01-01', 19.99, 50),
(2, 'Journey to Mars', '9876543210987', 2, 'Science Fiction', 2, '2023-05-15', 24.99, 30);


INSERT INTO Inventory (InventoryID, BookID, QuantityInStock, SupplierID) VALUES
(1, 1, 50, 1),
(2, 2, 30, 2);


INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderStatus, TotalAmount, PaymentMethod, ShippingAddress) VALUES
(1, 1, '2024-11-01', 'Shipped', 39.98, 'Credit Card', '123 Main St, Anytown, USA'),
(2, 2, '2024-11-02', 'Processing', 24.99, 'PayPal', '456 Oak St, Anytown, USA');


INSERT INTO OrderItem (OrderItemID, OrderID, BookID, Quantity, UnitPrice) VALUES
(1, 1, 1, 2, 19.99),
(2, 2, 2, 1, 24.99);


INSERT INTO Payment (PaymentID, OrderID, PaymentMethod, PaymentDate, Amount) VALUES
    (1, 1, 'Credit Card', '2024-11-01', 39.98),
    (2, 2, 'PayPal', '2024-11-02', 24.99);

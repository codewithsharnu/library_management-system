-- ==============================================================================
-- DATABASE SCHEMA: LIBRARY MANAGEMENT SYSTEM (DBMS)
-- Compatible with SQLite, MySQL, and PostgreSQL
-- ==============================================================================

-- 1. BOOKS CATALOG
CREATE TABLE IF NOT EXISTS books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(25) UNIQUE NOT NULL,
    genre VARCHAR(50) NOT NULL,
    total_copies INTEGER NOT NULL DEFAULT 1,
    available_copies INTEGER NOT NULL DEFAULT 1,
    published_year INTEGER NOT NULL,
    shelf_location VARCHAR(20) NOT NULL
);

-- 2. LIBRARY MEMBERS
CREATE TABLE IF NOT EXISTS members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    membership_type VARCHAR(30) NOT NULL DEFAULT 'Student',
    join_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);

-- 3. BORROW / ISSUE TRANSACTIONS
CREATE TABLE IF NOT EXISTS borrow_records (
    issue_id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Issued',
    fine_amount REAL DEFAULT 0.0,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- 4. FINES AND PAYMENTS
CREATE TABLE IF NOT EXISTS fines (
    fine_id INTEGER PRIMARY KEY AUTOINCREMENT,
    issue_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Unpaid',
    paid_date DATE,
    FOREIGN KEY (issue_id) REFERENCES borrow_records(issue_id) ON DELETE CASCADE
);

-- ==============================================================================
-- SAMPLE INITIAL DATA SEEDING
-- ==============================================================================

-- Insert Sample Books
INSERT INTO books (title, author, isbn, genre, total_copies, available_copies, published_year, shelf_location) VALUES
('Clean Code: A Handbook of Agile Software Craftsmanship', 'Robert C. Martin', '978-0132350884', 'Computer Science', 5, 3, 2008, 'CS-A1'),
('The Pragmatic Programmer: Your Journey to Mastery', 'Andrew Hunt, David Thomas', '978-0135957059', 'Computer Science', 4, 3, 2019, 'CS-A2'),
('Introduction to Algorithms', 'Thomas H. Cormen', '978-0262033848', 'Computer Science', 6, 5, 2009, 'CS-B1'),
('Database System Concepts', 'Abraham Silberschatz', '978-0073523323', 'Computer Science', 5, 4, 2019, 'CS-B2'),
('To Kill a Mockingbird', 'Harper Lee', '978-0061120084', 'Fiction', 4, 4, 1960, 'LIT-F1'),
('1984', 'George Orwell', '978-0451524935', 'Fiction', 5, 2, 1949, 'LIT-F2'),
('Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', '978-0062316097', 'History', 4, 3, 2014, 'HIST-H1'),
('A Brief History of Time', 'Stephen Hawking', '978-0553380163', 'Science', 3, 3, 1988, 'SCI-S1'),
('Atomic Habits', 'James Clear', '978-0735211292', 'Self-Help', 6, 4, 2018, 'BUS-M1'),
('Principles: Life and Work', 'Ray Dalio', '978-1501124020', 'Business', 3, 3, 2017, 'BUS-M2');

-- Insert Sample Members
INSERT INTO members (name, email, phone, membership_type, join_date, status) VALUES
('Aarav Sharma', 'aarav.sharma@example.com', '+91 9876543210', 'Student', '2025-01-10', 'Active'),
('Diya Patel', 'diya.patel@example.com', '+91 9876543211', 'Student', '2025-02-15', 'Active'),
('Dr. Ramesh Kulkarni', 'ramesh.kulkarni@example.com', '+91 9876543212', 'Faculty', '2024-08-01', 'Active'),
('Sneha Deshmukh', 'sneha.deshmukh@example.com', '+91 9876543213', 'Premium', '2025-03-05', 'Active'),
('Vikram Mehta', 'vikram.mehta@example.com', '+91 9876543214', 'General', '2024-11-20', 'Active');

-- Insert Sample Borrow Records (Active, Returned, and Overdue)
INSERT INTO borrow_records (book_id, member_id, issue_date, due_date, return_date, status, fine_amount) VALUES
(1, 1, '2026-08-01', '2026-08-15', NULL, 'Overdue', 20.0),
(1, 2, '2026-08-10', '2026-08-24', NULL, 'Issued', 0.0),
(2, 3, '2026-08-05', '2026-08-19', NULL, 'Issued', 0.0),
(6, 4, '2026-07-15', '2026-07-29', '2026-07-28', 'Returned', 0.0),
(6, 1, '2026-08-02', '2026-08-16', NULL, 'Overdue', 10.0),
(6, 5, '2026-08-12', '2026-08-26', NULL, 'Issued', 0.0),
(9, 2, '2026-08-08', '2026-08-22', NULL, 'Issued', 0.0),
(9, 3, '2026-08-11', '2026-08-25', NULL, 'Issued', 0.0);

-- Insert Sample Fines
INSERT INTO fines (issue_id, amount, payment_status, paid_date) VALUES
(1, 20.0, 'Unpaid', NULL),
(5, 10.0, 'Unpaid', NULL);

-- ==============================================================================
-- USEFUL LIBRARY SQL QUERIES (EXAMPLES)
-- ==============================================================================

-- Query 1: Find all currently issued & overdue books with member details
SELECT 
    br.issue_id,
    b.title AS book_title,
    b.isbn,
    m.name AS member_name,
    m.email,
    br.issue_date,
    br.due_date,
    br.status,
    br.fine_amount
FROM borrow_records br
JOIN books b ON br.book_id = b.book_id
JOIN members m ON br.member_id = m.member_id
WHERE br.status IN ('Issued', 'Overdue')
ORDER BY br.due_date ASC;

-- Query 2: Genre distribution and total available copies
SELECT 
    genre, 
    COUNT(book_id) AS total_titles,
    SUM(total_copies) AS total_inventory,
    SUM(available_copies) AS currently_available
FROM books
GROUP BY genre
ORDER BY total_inventory DESC;

-- Query 3: Most active borrowers
SELECT 
    m.member_id,
    m.name,
    m.membership_type,
    COUNT(br.issue_id) AS total_borrowed_count
FROM members m
LEFT JOIN borrow_records br ON m.member_id = br.member_id
GROUP BY m.member_id, m.name, m.membership_type
ORDER BY total_borrowed_count DESC;

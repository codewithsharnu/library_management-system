# 📚 Library Management System (Python & SQLite DBMS)

A complete, full-stack Library Management System web application built with **Python (Flask)** and **SQLite Relational Database**.

---

## 📂 File Structure

```text
c:\Users\lenovo\OneDrive\Desktop\SQL\library_management\
│
├── 📄 library_app.py / app.py        <- Main Python Flask Backend & API Routes
├── 📄 library.db                     <- SQLite Database File (Tables: books, members, borrow_records)
├── 📄 library_schema.sql             <- SQL Schema & Table Creation Script
├── 📁 templates/
│   └── library.html                  <- Complete Interactive Frontend Web Interface
├── 🚀 run_library.bat                <- 1-Click Launcher (Starts Flask server & opens browser)
├── 🌐 share_library_public_url.bat   <- Cloudflare Tunnel launcher for public sharing
└── 📦 library_project_ready_for_cloud.zip <- Zipped deployment package
```

---

## 🧠 Key Python Functions in `library_app.py`

1. **Database Connection (`get_db_connection`):**
   - Connects to `library.db` using Python's built-in `sqlite3` module.
   - Sets `conn.row_factory = sqlite3.Row` for dictionary-like column access.

2. **Database Initialization (`init_db`):**
   - Creates three relational tables with Foreign Keys:
     - `books` (book_id, title, author, isbn, genre, available_copies, total_copies, shelf_location)
     - `members` (member_id, name, email, phone, membership_type, status)
     - `borrow_records` (issue_id, book_id, member_id, issue_date, due_date, return_date, fine_amount, status)

3. **Core Library Business Logic:**
   - **Issue Book:** Decrements `available_copies` in `books` table and inserts a new row in `borrow_records` with a 14-day due date.
   - **Return Book:** Marks record as `'Returned'`, increments `available_copies`, and calculates overdue fines if returned past the due date.
   - **Overdue Fine Calculation:** Daily fine rate applied to late returns:
     $$\text{Fine} = \max(0, \text{Days Overdue}) \times \text{Daily Rate}$$
   - **Search & Filters:** Real-time search across titles, authors, ISBNs, and genre categories.

---

## 🚀 How to Run the Library System

* **Option 1 (Easiest):** Double-click **`run_library.bat`**.
* **Option 2 (Terminal):**
  ```powershell
  cd c:\Users\lenovo\OneDrive\Desktop\SQL\library_management
  python library_app.py
  ```
  Then open your browser at: **`http://localhost:5000`**

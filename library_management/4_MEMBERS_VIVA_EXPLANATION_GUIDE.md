# 🎓 4-Member Group Presentation & Viva Guide
## Project: Library Management System & DBMS Circulation Studio (Python & SQLite)
## Live Website: https://sharnu.pythonanywhere.com/library
## Code File: `library_app.py` (c:\Users\lenovo\OneDrive\Desktop\SQL\library_management\library_app.py)

---

# 📋 Group Presentation Overview (5–7 Minutes Total)

| Member | Assigned Role & Title | Exact Python Code Lines | Core Concepts Explained |
| :--- | :--- | :--- | :--- |
| **MEMBER 1** | **Team Lead & Web Architect** | Lines 1–45 | Flask setup, `@app.route` decorators, HTTP GET/POST, URL mapping |
| **MEMBER 2** | **Database & Data Engineer** | Lines 10–35 & 210–236 | `sqlite3` driver, `row_factory`, Schema 3NF, List Comprehensions & Dictionaries |
| **MEMBER 3** | **Core Logic & Algorithm Lead** | Lines 424–531 | Input validation, `datetime` + `timedelta`, late fine formula, `conn.rollback()` |
| **MEMBER 4** | **API Controller & Live Demo** | Lines 145–208 & 578–625 | REST JSON APIs, `time.time()` latency timer, Live Demo of 6 website tabs |

---

# 🚀 The 4 Steps of the Presentation

1. **Step 1: Stand in Sequence:** Member 1 ➔ Member 2 ➔ Member 3 ➔ Member 4.
2. **Step 2: Have Screens Ready:** 
   - Screen Tab A: Live Website at `https://sharnu.pythonanywhere.com/library`
   - Screen Tab B: VS Code or Notepad with `library_app.py` open.
3. **Step 3: Member Handover:** Every member ends with *"Now [Next Member] will explain..."*.
4. **Step 4: Live Demo by Member 4:** Issues a book, returns a book, and runs a live query in SQL Studio.

---

# 👤 MEMBER 1: Team Lead & Flask Architecture

### 🎯 Your Focus:
Explain the project background, why Python was selected, how Flask was initialized, and how URL routes connect browser clicks to Python functions.

### 💻 Code to Show on Screen:
**File:** `library_app.py` (Lines 5–42)
```python
import os
import sqlite3
import time
from datetime import datetime, timedelta
from flask import Flask, render_template, request, jsonify

# 1. Initialize Flask Application
app = Flask(__name__)
DB_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "library.db")

# 2. Python Function Decorator for Routing
@app.route("/")
def index():
    """Render the primary HTML single-page dashboard."""
    return render_template("library.html")
```

### 🗣️ What Member 1 Explains to Miss (Word-for-Word):
> *"Good morning Miss. I am **[Member 1 Name]**, the team lead for our Python project: **Library Management System & DBMS Circulation Studio**.*
>
> *We chose **Python 3** paired with the **Flask** micro-framework because Python provides clean, readable code and lightweight server routing without unnecessary complexity.*
>
> *(Point to line 7 in library_app.py:)*  
> *Here on line 7, we instantiate our web application using `app = Flask(__name__)`. We also dynamically configure our database path using Python's `os.path.join()` to ensure the code runs identically across Windows, Linux, and Cloud environments.*
>
> *(Point to line 40:)*  
> *On line 40, we use a **Python Function Decorator** (`@app.route("/")`). In Python, decorators wrap functions and bind web URLs to backend handlers. When a patron opens our website, Flask captures the HTTP GET request and executes our `index()` function, which delivers `library.html` to the browser.*
>
> *Our project is fully deployed live 24/7 on the internet at `https://sharnu.pythonanywhere.com/library`.*
>
> *Now, **[Member 2 Name]** will explain how Python connects to our database and structures the data."*

---

# 👤 MEMBER 2: Database & Python Data Structures

### 🎯 Your Focus:
Explain how Python connects to SQLite, why `row_factory = sqlite3.Row` was used, and how Python List Comprehensions convert raw database records into JSON dictionaries.

### 💻 Code to Show on Screen:
**File:** `library_app.py` (Lines 10–25 & Lines 212–236)
```python
def get_db_connection():
    """Connect to SQLite database with dictionary-like row access."""
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row  # Enables column access like row['title']
    return conn

@app.route("/api/books", methods=["GET"])
def get_books():
    genre = request.args.get("genre", "").strip()
    search = request.args.get("search", "").strip()

    conn = get_db_connection()
    cursor = conn.cursor()
    # ... executes query ...
    
    # Python List Comprehension: converts SQL tuples into Python dictionaries
    books = [dict(row) for row in cursor.fetchall()]
    conn.close()

    return jsonify({"books": books, "count": len(books)})
```

### 🗣️ What Member 2 Explains to Miss (Word-for-Word):
> *"Good morning Miss, I am **[Member 2 Name]**.*
> *I was responsible for database connectivity and Python data structure transformations.*
>
> *(Point to line 10 in library_app.py:)*  
> *In line 10, we define `get_db_connection()`. We use Python's built-in `sqlite3` driver. This eliminates the need for separate database software like XAMPP or MySQL servers.*
>
> *(Point to line 12:)*  
> *Notice line 12: `conn.row_factory = sqlite3.Row`. By default, Python returns database rows as plain tuples `(1, "Clean Code", 5)`. Setting `sqlite3.Row` allows us to access values by column name, such as `row['title']` or `row['available_copies']`.*
>
> *(Point to line 233:)*  
> *On line 233, we use a **Python List Comprehension**:  
> `books = [dict(row) for row in cursor.fetchall()]`  
> In a single line of Python, this iterates through all database rows, casts each row into a Python dictionary, and packages it into a list. Flask's `jsonify()` then converts that dictionary list into a JSON response for our frontend table.*
>
> *Now, **[Member 3 Name]** will explain our core business logic and date calculations."*

---

# 👤 MEMBER 3: Core Python Logic & Date Mathematics

### 🎯 Your Focus:
Explain input validation, available stock check, the 14-day date calculation using `datetime` and `timedelta`, overdue fine calculation, and transaction rollback safety (`conn.rollback()`).

### 💻 Code to Show on Screen:
**File:** `library_app.py` (Lines 438–475 & Lines 495–520)
```python
# 1. Stock Validation Check
cursor.execute("SELECT available_copies, title FROM books WHERE book_id=?", (book_id,))
book = cursor.fetchone()
if book["available_copies"] <= 0:
    return jsonify({"error": f"No available copies of '{book['title']}' in stock."}), 400

# 2. Python Date Math (Adding 14 Days)
issue_date = datetime.now().strftime("%Y-%m-%d")
due_date = (datetime.now() + timedelta(days=14)).strftime("%Y-%m-%d")

# 3. Stock Decrement & Transaction Rollback
try:
    cursor.execute("UPDATE books SET available_copies = available_copies - 1 WHERE book_id=?", (book_id,))
    # ... insert borrow record ...
    conn.commit()
except Exception as e:
    conn.rollback()  # Rollback changes if error occurs
    return jsonify({"error": str(e)}), 500

# 4. Overdue Fine Calculation (Date Subtraction)
if return_dt > due_date:
    overdue_days = (return_dt - due_date).days
    fine_amount = overdue_days * 10.0   # ₹10 per day penalty
```

### 🗣️ What Member 3 Explains to Miss (Word-for-Word):
> *"Good morning Miss, I am **[Member 3 Name]**.*
> *I developed the core business logic, stock verification, and date calculations.*
>
> *(Point to line 443 in library_app.py:)*  
> *Before issuing any book, Python validates availability: `if book['available_copies'] <= 0`. If copies are zero, Python halts and returns an HTTP 400 status with a message that the book is out of stock. This prevents ghost borrowing.*
>
> *(Point to line 458:)*  
> *On line 458, we use Python's built-in `datetime` and `timedelta` modules:  
> `due_date = (datetime.now() + timedelta(days=14)).strftime("%Y-%m-%d")`  
> Python automatically handles month-end boundaries, leap years, and calendar transitions to set a 14-day borrowing interval.*
>
> *(Point to line 500:)*  
> *When a book is returned, Python calculates late fees using date object subtraction:  
> `overdue_days = (return_dt - due_date).days`  
> If the book is late, Python multiplies overdue days by ₹10 per day and generates an unpaid record in the fines table.*
>
> *(Point to line 473:)*  
> *Finally, we wrap checkout and return transactions in `try...except` blocks with `conn.rollback()`. If a crash happens midway, Python rolls back the database to prevent corrupted records.*
>
> *Now, **[Member 4 Name]** will explain our API endpoints and demonstrate the live deployed website."*

---

# 👤 MEMBER 4: API Controller, Live Demo & Conclusion

### 🎯 Your Focus:
Explain the REST API endpoints, the execution timer using `time.time()`, run the live website demo on screen, and conclude the presentation.

### 💻 Code to Show on Screen:
**File:** `library_app.py` (Lines 585–618)
```python
@app.route("/api/execute-sql", methods=["POST"])
def execute_sql():
    sql_text = request.json.get("query", "").strip()
    
    # Python Performance Stopwatch
    start_time = time.time()
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(sql_text)
    # ... fetch results ...
    conn.commit()
    conn.close()

    # Measure latency in milliseconds
    elapsed_ms = round((time.time() - start_time) * 1000, 2)
    return jsonify({"success": True, "execution_time_ms": elapsed_ms})
```

### 🗣️ What Member 4 Explains to Miss (Word-for-Word):
> *"Good morning Miss, I am **[Member 4 Name]**.*
> *I designed our REST API controllers, execution latency tracking, and handled the live cloud deployment.*
>
> *(Point to line 585 in library_app.py:)*  
> *In line 585, our `/api/execute-sql` endpoint accepts queries from the browser. We use Python's `time.time()` module before and after query execution to benchmark performance, returning the exact execution latency in milliseconds.*
>
> *(Switch to browser and open: https://sharnu.pythonanywhere.com/library)*  
> *Let me demonstrate our live application running on PythonAnywhere:*
> 1. ***Dashboard (Tab 1):** Python computes and returns our live KPI counters—Total Titles, Active Loans, and Unpaid Fines—rendered into dynamic Chart.js charts.*
> 2. ***Book Catalog (Tab 2):** Notice our real-time search: as I type, Python filters through books using parameterized queries.*
> 3. ***Circulation (Tab 4):** Watch as I click 'Issue Book': Python decrements available copies by 1 and assigns the return deadline.*
> 4. ***Live SQL Studio (Tab 6):** Here, we can execute any multi-table SQL query and see results along with Python's measured execution speed.*
>
> *In conclusion, our group has built a complete, atomic, full-stack Python application that eliminates manual paperwork and automates library management. Thank you Miss, we are now ready for your questions."*

---

# 🏆 The Top 4 Questions Miss Will Ask & Your Exact Answers

1. **Question for Member 1:** *"Why use Flask instead of Django?"*
   * **Answer:** *"Miss, Flask is a lightweight micro-framework ideal for REST APIs and Single-Page Applications. Django includes heavy built-in admin overhead that we did not need for this focused library circulation system."*

2. **Question for Member 2:** *"What is the benefit of `sqlite3.Row`?"*
   * **Answer:** *"Miss, standard SQLite tuples only allow index access like `row[1]`. `sqlite3.Row` maps column names into a dictionary-like interface, so we can write readable code like `row['title']` and avoid hard-coded index bugs."*

3. **Question for Member 3:** *"How does Python prevent negative stock?"*
   * **Answer:** *"Miss, in line 443 we check `if book['available_copies'] <= 0`. If copies are zero, Python immediately exits and sends an HTTP 400 response before any update statement can run."*

4. **Question for Member 4:** *"Is this website accessible on the internet right now?"*
   * **Answer:** *"Yes Miss, it is hosted 24/7 on PythonAnywhere cloud servers at `https://sharnu.pythonanywhere.com/library`. You can open it right now on your mobile phone or laptop."*

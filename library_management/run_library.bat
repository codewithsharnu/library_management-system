@echo off
title Library Management System & DBMS Studio
echo ==========================================================
echo   📚 Starting Library DBMS & Web Frontend Server...
echo ==========================================================
echo.
echo Opening Web Browser at http://127.0.0.1:5000 ...
start http://127.0.0.1:5000
echo.
echo Starting Python Backend Server...
python library_app.py
pause

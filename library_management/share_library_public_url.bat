@echo off
title Library DBMS - Free Public Live Domain
echo ==========================================================
echo    LIBRARY DBMS: STARTING SERVER WITH FREE PUBLIC DOMAIN
echo ==========================================================
echo.
echo 1. Starting Local Library Backend Server...
start /B python library_app.py
timeout /t 2 /nobreak >nul
echo.
echo 2. Generating Free Public HTTPS Domain URL...
echo ----------------------------------------------------------
echo Copy the HTTPS link below to share with your friends!
echo ----------------------------------------------------------
echo.
ssh -T -o StrictHostKeyChecking=no -R 80:127.0.0.1:5000 serveo.net
pause

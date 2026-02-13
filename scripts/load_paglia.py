'''
pagila-sql-analysis/
│
├── data/
│   ├── film.csv
│   ├── rental.csv
│   ├── inventory.csv
│   ├── customer.csv
│   ├── payment.csv
│   ├── store.csv
│   ├── category.csv
│   └── film_category.csv
│
├── scripts/
│   └── load_pagila.py
│
├── pagila_analysis_sqlite.sql
├── README.md
└── requirements.txt
'''


import pandas as pd
import sqlite3
import os

# Path to CSV folder
data_dir = os.path.join(os.path.dirname(__file__), "../data")

# Connect/create SQLite DB
conn = sqlite3.connect(os.path.join(os.path.dirname(__file__), "../pagila.db"))

# List of tables
tables = ["film","rental","inventory","customer","payment","store","category","film_category"]

# Load each CSV into SQLite
for table in tables:
    csv_path = os.path.join(data_dir, f"{table}.csv")
    print(f"Loading {table}...")
    df = pd.read_csv(csv_path)
    df.to_sql(table, conn, index=False, if_exists='replace')

print("All tables loaded into pagila.db!")
conn.close()

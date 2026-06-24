# 🚲 BikeStore — SQL-Powered Retail Performance System

A full end-to-end **Business Intelligence project** built in **SQL Server**, analyzing sales, inventory, staff performance, and customer behavior for a multi-branch bike store chain.

---

## 📌 Project Overview

This project simulates a real-world BI pipeline — from raw CSV ingestion through staging tables, to a normalized relational schema, analytical views, stored procedures, and KPI dashboards.

| Detail | Info |
|--------|------|
| **Database** | Microsoft SQL Server |
| **Tool** | SQL Server Management Studio (SSMS) |
| **Data Sources** | 9 CSV files |
| **Schema** | Normalized relational (Sales + Production) |

---

## 🗂️ Database Schema

The database is split into two logical schemas:

**Sales** — `customers`, `orders`, `order_items`, `staffs`, `stores`

**Production** — `products`, `brands`, `categories`, `stocks`

![Database Relationship Diagram](assets/database_relationships.png)

---

## 🏗️ Project Architecture

```
Raw CSV Files (9 sources)
        ↓
Staging Tables (BULK INSERT / OPENROWSET)
        ↓
Normalized Tables (INSERT INTO ... SELECT)
        ↓
Analytical Views (6 views)
        ↓
Stored Procedures (4 procedures)
        ↓
KPI Dashboard (PowerPoint)
```

---

## 📊 Analytical Views (6)

| View | Description |
|------|-------------|
| `vw_StoreSalesSummary` | Revenue, order count, and Average Order Value (AOV) per store |
| `vw_TopSellingProducts` | Products ranked by total sales volume |
| `vw_InventoryStatus` | Low-stock products across all stores |
| `vw_StaffPerformance` | Orders and revenue contribution per staff member |
| `vw_RegionalTrends` | Revenue breakdown by city / region |
| `vw_SalesByCategory` | Sales volume and gross profit margin by product category |

---

## ⚙️ Stored Procedures (4)

| Procedure | Description |
|-----------|-------------|
| `sp_CalculateStoreKPI` | Input: store ID → Returns full KPI report for that store |
| `sp_GenerateRestockList` | Returns low-stock product list per store |
| `sp_CompareSalesYearOverYear` | Compares sales performance between two years |
| `sp_GetCustomerProfile` | Returns a customer's total spend, order count, and top products |

---

## 📈 Business KPIs

| KPI | Business Insight |
|-----|-----------------|
| Total Revenue | Overall company performance |
| Average Order Value (AOV) | Customer spending behavior |
| Inventory Turnover | Warehouse stock efficiency |
| Revenue by Store | Identifies strongest and weakest branches |
| Gross Profit by Category | High vs. low margin product lines |
| Sales by Brand | Supplier performance tracking |
| Staff Revenue Contribution | Staff productivity monitoring |

---

## 📂 Repository Structure

```
BikeStore-BI/
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_staging_tables.sql
│   ├── 03_normalized_tables.sql
│   ├── 04_views.sql
│   └── 05_stored_procedures.sql
├── data/
│   ├── products.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── stores.csv
│   ├── stocks.csv
│   ├── staffs.csv
│   ├── customers.csv
│   ├── brands.csv
│   └── categories.csv
├── assets/
│   └── database_relationships.png
├── BikeStore_KPI_Presentation.pptx
└── README.md
```

---

## 🚀 How to Run

1. Open **SQL Server Management Studio (SSMS)**
2. Run `01_create_database.sql` to create the database
3. Run `02_staging_tables.sql` to create staging tables
4. Load CSV files into staging tables using **BULK INSERT**
5. Run `03_normalized_tables.sql` to build the relational schema
6. Run `04_views.sql` to create all analytical views
7. Run `05_stored_procedures.sql` to create stored procedures

---

## 🛠️ Tools & Technologies

- **SQL Server 2019+**
- **SSMS (SQL Server Management Studio)**
- **T-SQL** — DDL, DML, Views, Stored Procedures, BULK INSERT
- **PowerPoint / Canva** — KPI presentation design

---

## 👤 Author

**Shohjahon** — Data Science student at Westminster International University in Tashkent

[![GitHub](https://img.shields.io/badge/GitHub-shohjahon6598-black?logo=github)](https://github.com/shohjahon6598)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/)

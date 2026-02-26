# Supply Chain Management Data Warehouse

![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)
![Dataset](https://img.shields.io/badge/Dataset-Kaggle-20BEFF?style=for-the-badge&logo=kaggle&logoColor=white)
![Schema](https://img.shields.io/badge/Schema-Star%20Schema-1F4E79?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

A complete **Data Warehouse** implementation for Supply Chain Management built using **Microsoft SQL Server**, following the **Star Schema** architecture. This project covers everything from database design and data import to advanced SQL objects like Stored Procedures, Views, and Triggers.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Schema Design](#schema-design)
- [Project Structure](#project-structure)
- [Tasks Completed](#tasks-completed)
- [Key Results](#key-results)
- [How to Run](#how-to-run)
- [Technologies Used](#technologies-used)

---

## Project Overview

This project implements a **Supply Chain Management Data Warehouse** that enables analytical queries on shipment data across multiple dimensions including products, suppliers, warehouses, orders, and time.

**Key Highlights:**
- Star Schema with 1 Fact Table + 5 Dimension Tables
- 167,128 shipment records loaded
- Real-world dataset from Kaggle
- 5 Basic analytical queries + 4 Advanced SQL objects

---

## Dataset

| Attribute | Details |
|-----------|---------|
| Source | [Kaggle - Supply Chain Analysis by Harsh Singh](https://www.kaggle.com/) |
| Format | CSV |
| Rows | 100 products / shipment records |
| Columns | 24 columns |
| Categories | Haircare, Skincare, Cosmetics |
| Suppliers | Supplier 1 through Supplier 5 |

---

## Schema Design

The database follows a **Star Schema** — a standard data warehousing pattern where a central Fact table is surrounded by Dimension tables.

![Star Schema Diagram](star_schema_diagram.png)

### Tables

| Table | Type | Rows | Description |
|-------|------|------|-------------|
| `FactShipments` | FACT | 167,128 | Central table with all shipment transactions |
| `DimProducts` | DIMENSION | 100 | Product details — SKU, category, price, stock |
| `DimSupplier` | DIMENSION | 100 | Supplier name and location |
| `DimWarehouse` | DIMENSION | 100 | Route, transport mode, location |
| `DimOrder` | DIMENSION | 100 | Order quantity, customer type, revenue |
| `DimTime` | DIMENSION | 12 | Date, month, quarter, year |

---

## Project Structure

```
supply-chain-dw/
│
├── supply_chain_dw.sql        # Complete SQL script (tables + data + queries)
├── supply_chain_data.csv      # Original Kaggle dataset
├── star_schema_diagram.html   # Interactive Star Schema diagram
├── SupplyChain_Report.docx    # Complete assignment report
└── README.md                  # This file
```

---

## Tasks Completed

### Basic Tasks

| Task | Description | Result |
|------|-------------|--------|
| Task 1 | Total quantity shipped per product category | Cosmetics: 351,514 units (top) |
| Task 2 | Most efficient warehouses by avg shipping days | Route B & C: 5 days avg |
| Task 3 | Total shipment value per supplier | Supplier 1: $29.5M (highest) |
| Task 4 | Top 5 products by total shipment quantity | SKU43 Haircare: 41,796 units |
| Task 5 | Distribution of shipment values per category | Skincare: $32.5M total revenue |

### Advanced Tasks

| Task | Object | Description |
|------|--------|-------------|
| Advanced 1 | Stored Procedure | `UpdateShipment` — updates ShippingDays for any shipment record |
| Advanced 2 | View | `ShipmentSummary` — consolidated category-level performance summary |
| Advanced 3 | Analytical Query | Year-over-Year supplier comparison using `LAG()` window function |
| Advanced 4 | Trigger | `TrackShipmentChanges` — auto-logs changes to `ShipmentHistory` audit table |

---

## Key Results

```
Total Shipments Loaded   :  167,128 rows
Top Category (Volume)    :  Cosmetics — 351,514 units
Top Supplier (Value)     :  Supplier 1 — $29,546,896
Most Efficient Route     :  Route B & C — 5 days avg shipping
Top Product              :  SKU43 (Haircare) — 41,796 units
Total Revenue            :  $92,413,406
```


## Technologies Used

| Tool | Purpose |
|------|---------|
| Microsoft SQL Server | Primary database engine |
| SQL Server Management Studio (SSMS) | Query execution and database management |
| T-SQL (Transact-SQL) | All queries, procedures, views, triggers |
| Kaggle | Dataset source |
| Star Schema | Data warehouse architecture pattern |

---

## SQL Objects Created

```sql
-- Tables
CREATE TABLE FactShipments  -- Fact table (central)
CREATE TABLE DimProducts    -- Product dimension
CREATE TABLE DimSupplier    -- Supplier dimension
CREATE TABLE DimWarehouse   -- Warehouse dimension
CREATE TABLE DimOrder       -- Order dimension
CREATE TABLE DimTime        -- Time dimension

-- Advanced Objects
CREATE PROCEDURE UpdateShipment         -- Stored procedure
CREATE VIEW ShipmentSummary             -- Summary view
CREATE TABLE ShipmentHistory            -- Audit/history table
CREATE TRIGGER TrackShipmentChanges     -- Audit trigger
```

---

## Author

Made with dedication as part of a **Data Warehousing Assignment** using real-world supply chain data.

---

> **Note:** Dataset contains beauty/healthcare product supply chain data (Haircare, Skincare, Cosmetics) sourced from Kaggle.

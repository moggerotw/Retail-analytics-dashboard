## Dataset Source

**Name:** Online Retail II UCI
**Source:** [Kaggle](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci)
**Original:** UCI Machine Learning Repository
**Size:** 1,067,371 transactions | 8 columns | 2009–2011
**License:** Public domain / educational use

## Columns
| Column | Description |
|---|---|
| Invoice | Transaction ID (prefix C = return) |
| StockCode | Product ID |
| Description | Product name |
| Quantity | Units sold (negative = return) |
| InvoiceDate | Date and time of purchase |
| Price | Unit price in GBP |
| Customer ID | Unique customer identifier |
| Country | Customer country |

## How to reproduce this project
1. Download dataset from Kaggle link above
2. Place `online_retail_II.csv` in `data/raw/` folder
3. Run `python/analysis.ipynb` top to bottom
4. Cleaned CSVs auto-generated in `data/cleaned/`
5. Import `data/cleaned/retail_cleaned.csv` into MySQL
6. Run queries from `sql/queries.sql`
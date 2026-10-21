# Retail Analytics & Business Intelligence Dashboard

> End-to-end analytics project using Python, SQL (MySQL), and Power BI  
> on 1,067,371 retail transactions from the UCI Online Retail II dataset

---

## Problem Statement

Retail management lacked visibility into which customers, products, and 
regions were driving revenue — and which customer segments were at risk 
of churning. This project builds a full analytics pipeline to answer 
those questions with data-driven insights.

---

## Tools & Technologies

| Layer | Tools |
|---|---|
| Data Cleaning & EDA | Python, Pandas, NumPy |
| Visualization (Python) | Matplotlib, Seaborn |
| Customer Segmentation | Scikit-learn (K-Means), RFM Analysis |
| Database & SQL | MySQL |
| SQL Techniques | CTEs, Window Functions, LAG, RANK, CASE WHEN |
| BI Dashboard | Power BI Desktop (DAX, Power Query, Drill-through) |
| Version Control | Git, GitHub |

---

## Dataset

- **Source:** UCI Online Retail II via [Kaggle](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci)
- **Size:** 1,067,371 transactions | 5,942 unique customers | 43 countries
- **Period:** December 2009 – December 2011
- **Columns:** Invoice, StockCode, Description, Quantity, InvoiceDate, Price, CustomerID, Country

---

## Key Findings

- **Champion customers (1,280) drove 73.2%** of £19.3M total revenue despite being only 21.5% of the customer base
- **Pareto validated:** Top 20% of customers generated 80%+ of revenue
- **Q4 seasonal spike confirmed:** November 2010 (+36.1% MoM) and November 2011 (+36.5% MoM)
- **K-Means clustering (k=4, silhouette score: 0.59)** identified 4 distinct behavioral segments
- **2,919 At-Risk/Lost customers** represent £1.33M in recoverable revenue
- **UK dominates** with ~83% of revenue; Netherlands and Germany are strongest international markets
- **Thursday** is peak revenue day; Sunday consistently lowest

---

## Dashboard Pages

### Page 1 — Executive Overview
![Executive Overview](dashboard/screenshots/powerbi/page1_executive_overview.png)

### Page 2 — Product Performance
![Product Performance](dashboard/screenshots/powerbi/page2_product_performance.png)

### Page 3 — Customer Segments
![Customer Segments](dashboard/screenshots/powerbi/page3_customer_segments.png)

### Page 4 — Time Intelligence
![Time Intelligence](dashboard/screenshots/powerbi/page4_time_intelligence.png)

### Page 5 — Country Drill Through
![Country Detail](dashboard/screenshots/powerbi/page5_country_detail.png)

---

## Python Analysis Highlights

![Monthly Revenue](dashboard/screenshots/python/01_monthly_revenue.png)
![Customer Clusters](dashboard/screenshots/python/05_clusters.png)

---

## SQL Highlights

8 business queries written in MySQL covering:

| Query | Technique | Business Question |
|---|---|---|
| Q1 | Aggregation | Overall business performance |
| Q2 | LAG() window function | Month-over-month revenue growth |
| Q3 | SUM() OVER() | Cumulative revenue tracking |
| Q4 | RANK() OVER() | Top countries by revenue |
| Q5 | RANK() OVER() | Top products by revenue |
| Q6 | CASE WHEN + CTEs | RFM customer scoring |
| Q7 | CTEs + subquery | Segment revenue share |
| Q8 | RANK() OVER() | Day-of-week patterns |

→ [View all queries](sql/queries.sql)

---

## Resume Bullets (Verified with Real Data)

- Analyzed **1,067,371** retail transactions from UCI Online Retail II dataset using Python (Pandas) and MySQL; identified **5,942** unique customers across **43** countries
- Applied RFM segmentation + K-Means clustering (k=4, silhouette score **0.59**) — Champions (**1,280** customers) drove **73.2%** of £19.3M total revenue
- Wrote 8 business SQL queries using CTEs, window functions (LAG, RANK, SUM OVER) and CASE WHEN RFM scoring
- Built 5-page Power BI dashboard with DAX time intelligence, drill-through pages, and slicers — surfacing **£1.33M** in recoverable At-Risk/Lost customer revenue

---

## Repository Structure

\`\`\`
retail-analytics-dashboard/
├── data/
│   ├── raw/data_source.md          
│   └── cleaned/rfm_segments.csv    
├── python/
│   └── analysis.ipynb              
├── sql/
│   └── queries.sql                 
├── dashboard/
│   ├── retail_dashboard.pbix       
│   └── screenshots/
│       ├── python/                 
│       ├── sql/                    
│       └── powerbi/               
├── insights/
│   └── key_findings.md             
└── README.md
\`\`\`

---

## How to Reproduce

1. Download dataset from [Kaggle](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci) → place in `data/raw/`
2. Run `python/analysis.ipynb` top to bottom
3. Import `data/raw/online_retail_II.csv` into MySQL
4. Run queries from `sql/queries.sql`
5. Open `dashboard/retail_dashboard.pbix` in Power BI Desktop

---

*Project by Aditya Sharma | B.Tech Data Science, OIST Bhopal (2024–2028)*  
*[LinkedIn](https://www.linkedin.com/in/aditya-mog0n/) | [GitHub](https://github.com/moggerotw)*
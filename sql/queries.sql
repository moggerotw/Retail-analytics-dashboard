-- ============================================================
-- RETAIL ANALYTICS — BUSINESS SQL QUERIES
-- Dataset: UCI Online Retail II | 1,067,371 transactions
-- Author: Aditya Sharma | B.Tech Data Science, OIST Bhopal
-- ============================================================

USE retail_analytics;

-- ============================================================
-- QUERY 1: Business Overview — Key Metrics
-- Business question: What is the overall performance?
-- Result: 53,628 transactions | 5,942 customers | £19.3M revenue
-- ============================================================
SELECT
    COUNT(DISTINCT Invoice)    AS total_transactions,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(DISTINCT Country)    AS countries_served,
    ROUND(SUM(Revenue), 0)     AS total_revenue,
    ROUND(AVG(Revenue), 2)     AS avg_order_value,
    ROUND(SUM(Quantity), 0)    AS total_units_sold
FROM retail_sales;


-- ============================================================
-- QUERY 2: Month-over-Month Revenue Growth using LAG()
-- Business question: Is revenue growing? Which months dropped?
-- Insight: Nov 2010 +36.1% | Nov 2011 +36.5% — Q4 seasonal spike
-- ============================================================
WITH monthly_revenue AS (
    SELECT
        YearMonth,
        ROUND(SUM(Revenue), 0) AS revenue
    FROM retail_sales
    GROUP BY YearMonth
)
SELECT
    YearMonth,
    revenue,
    LAG(revenue) OVER (ORDER BY YearMonth)  AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY YearMonth))
        / LAG(revenue) OVER (ORDER BY YearMonth) * 100
    , 1) AS mom_growth_pct
FROM monthly_revenue
ORDER BY YearMonth;


-- ============================================================
-- QUERY 3: Running Cumulative Revenue Total
-- Business question: How does cumulative revenue build over time?
-- ============================================================
WITH monthly AS (
    SELECT
        YearMonth,
        ROUND(SUM(Revenue), 0) AS monthly_revenue
    FROM retail_sales
    GROUP BY YearMonth
)
SELECT
    YearMonth,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY YearMonth) AS running_total,
    ROUND(
        SUM(monthly_revenue) OVER (ORDER BY YearMonth)
        / SUM(monthly_revenue) OVER () * 100
    , 1) AS cumulative_pct_of_total
FROM monthly
ORDER BY YearMonth;


-- ============================================================
-- QUERY 4: Top 10 Countries by Revenue with RANK()
-- Business question: Which markets drive the most value?
-- Insight: UK dominates | Netherlands & Germany top international
-- ============================================================
SELECT
    Country,
    ROUND(SUM(Revenue), 0)  AS total_revenue,
    COUNT(DISTINCT Invoice) AS transactions,
    ROUND(AVG(Revenue), 2)  AS avg_order_value,
    RANK() OVER (ORDER BY SUM(Revenue) DESC) AS revenue_rank
FROM retail_sales
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- QUERY 5: Top 10 Products by Revenue with RANK()
-- Business question: Which products are strongest revenue drivers?
-- ============================================================
SELECT
    StockCode,
    Description,
    SUM(Quantity)           AS total_units_sold,
    ROUND(SUM(Revenue), 0)  AS total_revenue,
    ROUND(AVG(Price), 2)    AS avg_unit_price,
    RANK() OVER (ORDER BY SUM(Revenue) DESC) AS revenue_rank
FROM retail_sales
GROUP BY StockCode, Description
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- QUERY 6: RFM Customer Scoring using CASE WHEN
-- Business question: Which customers are Champions vs. Lost?
-- ============================================================
WITH customer_rfm AS (
    SELECT
        CustomerID,
        DATEDIFF('2011-12-10', MAX(InvoiceDate))  AS recency_days,
        COUNT(DISTINCT Invoice)                    AS frequency,
        ROUND(SUM(Revenue), 2)                    AS monetary
    FROM retail_sales
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
rfm_scored AS (
    SELECT *,
        CASE
            WHEN recency_days <= 30  THEN 4
            WHEN recency_days <= 90  THEN 3
            WHEN recency_days <= 180 THEN 2
            ELSE 1
        END AS r_score,
        CASE
            WHEN frequency >= 12 THEN 4
            WHEN frequency >= 6  THEN 3
            WHEN frequency >= 3  THEN 2
            ELSE 1
        END AS f_score,
        CASE
            WHEN monetary >= 5000 THEN 4
            WHEN monetary >= 1000 THEN 3
            WHEN monetary >= 300  THEN 2
            ELSE 1
        END AS m_score
    FROM customer_rfm
)
SELECT
    CustomerID,
    recency_days,
    frequency,
    monetary,
    (r_score + f_score + m_score) AS rfm_total,
    CASE
        WHEN (r_score + f_score + m_score) >= 10 THEN 'Champion'
        WHEN (r_score + f_score + m_score) >= 7  THEN 'Loyal'
        WHEN (r_score + f_score + m_score) >= 5  THEN 'At Risk'
        ELSE 'Lost'
    END AS segment
FROM rfm_scored
ORDER BY rfm_total DESC;


-- ============================================================
-- QUERY 7: Segment Summary — Revenue share per segment
-- Business question: What % of revenue does each segment hold?
-- Result: Champions (1,280) = 73.2% | Lost (1,597) = only 2.1%
-- ============================================================
WITH customer_rfm AS (
    SELECT
        CustomerID,
        DATEDIFF('2011-12-10', MAX(InvoiceDate)) AS recency_days,
        COUNT(DISTINCT Invoice)                   AS frequency,
        ROUND(SUM(Revenue), 2)                   AS monetary
    FROM retail_sales
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
rfm_scored AS (
    SELECT *,
        CASE WHEN recency_days <= 30 THEN 4 WHEN recency_days <= 90 THEN 3 WHEN recency_days <= 180 THEN 2 ELSE 1 END AS r_score,
        CASE WHEN frequency >= 12 THEN 4 WHEN frequency >= 6 THEN 3 WHEN frequency >= 3 THEN 2 ELSE 1 END AS f_score,
        CASE WHEN monetary >= 5000 THEN 4 WHEN monetary >= 1000 THEN 3 WHEN monetary >= 300 THEN 2 ELSE 1 END AS m_score
    FROM customer_rfm
),
segmented AS (
    SELECT *,
        CASE WHEN (r_score+f_score+m_score) >= 10 THEN 'Champion'
             WHEN (r_score+f_score+m_score) >= 7  THEN 'Loyal'
             WHEN (r_score+f_score+m_score) >= 5  THEN 'At Risk'
             ELSE 'Lost' END AS segment
    FROM rfm_scored
)
SELECT
    segment,
    COUNT(*)                 AS customer_count,
    ROUND(SUM(monetary), 0)  AS total_revenue,
    ROUND(AVG(monetary), 0)  AS avg_revenue_per_customer,
    ROUND(SUM(monetary) / (SELECT SUM(monetary) FROM segmented) * 100, 1) AS revenue_share_pct
FROM segmented
GROUP BY segment
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 8: Revenue by Day of Week
-- Business question: Which days generate the most transactions?
-- ============================================================
SELECT
    DayOfWeek,
    COUNT(DISTINCT Invoice)  AS transactions,
    ROUND(SUM(Revenue), 0)   AS total_revenue,
    ROUND(AVG(Revenue), 2)   AS avg_order_value,
    RANK() OVER (ORDER BY SUM(Revenue) DESC) AS day_rank
FROM retail_sales
GROUP BY DayOfWeek
ORDER BY total_revenue DESC;
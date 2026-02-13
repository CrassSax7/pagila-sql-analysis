-- ========================================================
-- Pagila SQLite Analysis (Formatted Output Version)
-- ========================================================

.mode column
.headers on

SELECT '';
SELECT '========================================================';
SELECT '1) TOP 10 MOST RENTED FILMS';
SELECT '========================================================';
SELECT '';

SELECT
    f.title AS Title,
    COUNT(r.rental_id) AS Rental_Count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY Rental_Count DESC
LIMIT 10;


SELECT '';
SELECT '========================================================';
SELECT '2) MOST POPULAR FILM CATEGORY BY RENTALS';
SELECT '========================================================';
SELECT '';

SELECT
    c.name AS Category,
    COUNT(r.rental_id) AS Total_Rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY Total_Rentals DESC
LIMIT 10;


SELECT '';
SELECT '========================================================';
SELECT '3) TOTAL REVENUE BY STORE';
SELECT '========================================================';
SELECT '';

SELECT
    s.store_id AS Store_ID,
    ROUND(SUM(p.amount), 2) AS Total_Revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id
ORDER BY Total_Revenue DESC;


SELECT '';
SELECT '========================================================';
SELECT '4) TOP 5 CUSTOMERS BY TOTAL SPENT';
SELECT '========================================================';
SELECT '';

SELECT
    c.customer_id AS Customer_ID,
    c.first_name || ' ' || c.last_name AS Customer_Name,
    ROUND(SUM(p.amount), 2) AS Total_Spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY Total_Spent DESC
LIMIT 5;


SELECT '';
SELECT '========================================================';
SELECT '5) TOP 5 FILMS BY INVENTORY COUNT (PER STORE)';
SELECT '========================================================';
SELECT '';

WITH store_inventory AS (
    SELECT
        s.store_id,
        f.title,
        COUNT(*) AS copies_available
    FROM store s
    JOIN inventory i ON s.store_id = i.store_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY s.store_id, f.title
),
ranked_inventory AS (
    SELECT
        store_id,
        title,
        copies_available,
        RANK() OVER (
            PARTITION BY store_id
            ORDER BY copies_available DESC
        ) AS rank_per_store
    FROM store_inventory
)
SELECT
    store_id AS Store_ID,
    title AS Film_Title,
    copies_available AS Copies_Available,
    rank_per_store AS Rank_In_Store
FROM ranked_inventory
WHERE rank_per_store <= 5
ORDER BY Store_ID, Rank_In_Store;


SELECT '';
SELECT '========================================================';
SELECT '6) MONTHLY PAYMENT REVENUE TREND';
SELECT '========================================================';
SELECT '';

SELECT
    strftime('%Y-%m-01', payment_date) AS Month,
    ROUND(SUM(amount), 2) AS Monthly_Revenue
FROM payment
GROUP BY strftime('%Y-%m-01', payment_date)
ORDER BY Month;

SELECT '';
SELECT '==================== END OF ANALYSIS ====================';
SELECT '';

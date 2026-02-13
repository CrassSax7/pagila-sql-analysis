-- ========================================================
-- 1) Top 10 Most Rented Films
-- ========================================================
SELECT
    f.title,
    COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

-- ========================================================
-- 2) Most Popular Film Category by Rentals
-- ========================================================
SELECT
    c.name AS category,
    COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_rentals DESC
LIMIT 10;

-- ========================================================
-- 3) Total Revenue by Store
-- ========================================================
SELECT
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;

-- ========================================================
-- 4) Top 5 Customers by Total Spent
-- ========================================================
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- ========================================================
-- 5) Film Inventory by Store — Window Functions
-- ========================================================
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
SELECT *
FROM ranked_inventory
WHERE rank_per_store <= 5;


-- ========================================================
-- 6) Payments Trend by Month
-- ========================================================
SELECT
    strftime('%Y-%m-01', payment_date) AS month,
    SUM(amount) AS monthly_revenue
FROM payment
GROUP BY strftime('%Y-%m-01', payment_date)
ORDER BY month;

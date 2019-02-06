/*
<Shimin Zhang>
<sz6939>
<8am>
Assignment 2
*/

--Question 1
SELECT AVG(list_price),MEDIAN(list_price),MAX(list_price)
FROM products
;

--Question 2
SELECT category_name,category_id,COUNT(*) AS category_qty
FROM categories
GROUP BY category_name,category_id
;

--Question 3
SELECT customer_id,customer_first_name,customer_last_name,COUNT(*)as order_qty
FROM orders JOIN customers_om USING (customer_ID)
GROUP BY customer_id,customer_first_name,customer_last_name
HAVING SUM(order_id)>0
ORDER BY SUM(order_id)
;

--Question 4
SELECT item_id,title, count(*) as qty
FROM order_details JOIN items USING (item_id)
GROUP BY item_id,title
ORDER BY count(*) DESC
FETCH FIRST 3 ROWS WITH TIES
;

--Question 5
WITH summary1 AS (
    SELECT product_id,product_name, count(*) as qty,list_price
FROM products JOIN order_items USING (product_id)
GROUP BY product_id,product_name,list_price
)

SELECT product_id,product_name,qty*list_price AS gross_revenue
FROM summary1
WHERE qty= (SELECT MIN(qty)FROM summary1 )
;

--Question 6        
SELECT customer_id,customer_first_name,customer_last_name, count(*) as qty
FROM customers_om JOIN orders USING (customer_id)
GROUP BY customer_id,customer_first_name,customer_last_name
ORDER BY count(*) DESC
FETCH FIRST 1 ROWS WITH TIES
;

--Question 7 
WITH summary2 AS (
    SELECT vendor_state, count(*)AS qty
    FROM vendors
    GROUP BY vendor_state
    ORDER BY count(*) DESC
    FETCH FIRST 1 ROW ONLY)
    
SELECT vendor_id, vendor_name,payment_total,vendor_state
FROM vendors JOIN invoices USING (vendor_id)
WHERE vendor_state IN (SELECT vendor_state FROM summary2)
ORDER BY payment_total DESC
FETCH FIRST 1 ROW ONLY
;
--Question 8
WITH summary3 AS (
    SELECT vendor_city,COUNT(*)
    FROM vendors JOIN invoices USING (vendor_id)
    GROUP BY vendor_city
    ORDER BY count(*) DESC
    FETCH FIRST 2 ROW ONLY)
, summary4 AS (
    SELECT terms_id, count(*)
    FROM invoices
    GROUP BY terms_id
    ORDER BY count(*) DESC
    FETCH FIRST 1 ROW ONLY)

SELECT invoice_id,invoice_number, vendor_id,vendor_name,terms_id,payment_date,vendor_city
FROM vendors JOIN invoices USING(vendor_id)
WHERE vendor_city in (SELECT vendor_city FROM summary3)
     and terms_id in (SELECT terms_id FROM summary4) and payment_date is null
;

--Question 9
WITH summary5 AS (
    SELECT manager_id, count(*)
    FROM employees
    GROUP BY manager_id
    ORDER BY count(*)DESC
    FETCH FIRST 1 ROW WITH TIES
    )

SELECT employee_id, last_name, first_name,department_name,manager_id
FROM employees LEFT JOIN departments USING(department_number)
WHERE manager_id in (SELECT manager_id FROM summary5)

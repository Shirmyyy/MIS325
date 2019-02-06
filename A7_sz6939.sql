SET SERVEROUTPUT ON;
SET VERIFY OFF;


DECLARE
--1
TYPE student_array IS VARRAY(10) OF VARCHAR2(20);
students student_array := student_array(NULL,NULL,NULL);
--20
BEGIN
    students(1):=&student_id;
    students(2):=&first_name;
    students(3):=&last_name;
    FOR i IN 1..students.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(students(i));
    END LOOP;
END;
/

--3
BEGIN
EXECUTE IMMEDIATE(
'CREATE TABLE gifts
(
    receipt_id  NUMBER  PRIMARY KEY,
    recipient_name VARCHAR2(100),
    address  VARCHAR2(100),
    gift  VARCHAR2(100)
)'
);
END;
/

BEGIN
    INSERT INTO gifts
    VALUES (1,'Beca','Red River','An A for MIS373');
    
    INSERT INTO gifts
    VALUES (2,'Shirley','Rio Grande','An A for MIS373 too');
    
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

END;
/

--drop table gifts;

--4
/*
There are a few steps in the whole transaction:
    1. add Madalyn to MIS333K (insert a row into registration detail)
    2. drop Madalyn from MIS374 (delete a row into registration detail)
    3. commit the transaction
If any of those steps failed, the transaction should be rollbacked. Otherwise, commit the transaction.
*/

--5
SELECT *
FROM gifts;
/

--6
CREATE TABLE invoice_change_log
(
    change_timestamp  TIMESTAMP
)
;
CREATE or REPLACE TRIGGER update_invoices_trigger 
AFTER UPDATE OR DELETE OR INSERT ON invoices

BEGIN 
    INSERT INTO invoice_change_log
    VALUES (SYSDATE); 
END; 
/ 

--7
CREATE TABLE invoice_change_log_detailed
(
    invoice_id   NUMBER(10)  PRIMARY KEY,
    change_timestamp  TIMESTAMP,
    old_invoice_balance  NUMBER(20),
    new_invoice_balance  NUMBER(20)
)
;
--DROP TABLE invoice_change_log_detailed;
CREATE or REPLACE TRIGGER change_invoices_trigger 
AFTER UPDATE OR INSERT ON invoices
FOR EACH ROW
BEGIN 
IF UPDATING THEN
    INSERT INTO invoice_change_log_detailed
    VALUES (:old.invoice_id, sysdate, :old.invoice_total-:old.payment_total, :new.invoice_total-:new.payment_total);
ELSIF INSERTING THEN
    INSERT INTO invoice_change_log_detailed
    VALUES (:new.invoice_id, sysdate, null, :new.invoice_total-:new.payment_total);
END IF;
END;
/ 

--8
CREATE OR REPLACE PROCEDURE insert_num_proc
(
    float_id_var NUMBER,
    float_value_var   NUMBER
)
AS
    checker_variable NUMBER;
BEGIN
    SELECT 1
    INTO checker_variable
    FROM float_sample
    WHERE float_id=float_id_var;
    
    DBMS_OUTPUT.PUT_LINE('Duplicate value in float_id');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    
    INSERT INTO float_sample
    VALUES(float_id_var,float_value_var);
END;
/

--drop table float_sample;

--9
DECLARE
float_var  NUMBER;
float_id  NUMBER:=4;
float_value  NUMBER;
BEGIN
    FOR float_var IN 1..5 LOOP
        SELECT invoice_total
        INTO float_value
        FROM invoices
        WHERE invoice_id=float_id;
    insert_num_proc(float_id,float_value);
    float_id:=float_id+3;
    END LOOP;
END;
/

--10
COMMIT;
/
--11
CREATE OR REPLACE FUNCTION month_least_prod
(
    month_least_var  NUMBER
)
RETURN NUMBER 
AS
    category_id_var  NUMBER;
    product_id_var NUMBER;
    
    CURSOR product_ordered_times IS
        SELECT product_id,COUNT(*)
        FROM order_items JOIN orders_mgs USING (order_id)
        WHERE EXTRACT(MONTH FROM order_date)= month_least_var
        GROUP BY product_id
        ORDER BY COUNT(*)
        FETCH FIRST 1 ROW ONLY;
    cursor_row product_ordered_times%ROWTYPE;

BEGIN
    OPEN product_ordered_times;
    FETCH product_ordered_times INTO cursor_row;
    product_id_var:=cursor_row.product_id;
    CLOSE product_ordered_times;
    
    SELECT category_id INTO category_id_var
    FROM products
    WHERE product_id=product_id_var;
    
    RETURN category_id_var;
    
END;
/

--12
DECLARE
    category_id_var  NUMBER:=month_least_prod(3);
BEGIN
UPDATE products
SET discount_percent=75
WHERE category_id=category_id_var;
END;
/

--13
ROLLBACK;
/
--14
DECLARE
    CURSOR change_discount IS
        SELECT product_id,product_name, count(*) AS qty,list_price, (count(*)*list_price) AS total_revenue
        FROM products JOIN order_items USING (product_id)
        WHERE category_id=month_least_prod(3)
        GROUP BY product_id,product_name,list_price;
    cursor_row   change_discount%ROWTYPE;
BEGIN
    OPEN change_discount;
    LOOP
    FETCH change_discount INTO cursor_row;
    EXIT WHEN change_discount%NOTFOUND;
        IF cursor_row.total_revenue<1000 THEN
            UPDATE products
            SET discount_percent=75;
            DBMS_OUTPUT.PUT_LINE('Discount percent updated successfully for product_id of'||cursor_row.product_id);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Product_id of '||cursor_row.product_id||' does not require a discount percent change.');
        END IF;
    END LOOP;
END;
/

--15
ROLLBACK;


CASE a
    WHEN a>1 and a<5 THEN






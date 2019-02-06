/*
<Shimin Zhang>
<sz6939>
<8am>
Assignment 6
*/

--1
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    date_var TIMESTAMP;

BEGIN
    date_var:=SYSDATE;
    DBMS_OUTPUT.PUT_LINE(date_var);
END;
/

--2
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    user_variable NUMBER;

BEGIN
    user_variable:=&uservariable;
    IF MOD(user_variable,10)=0 THEN
        DBMS_OUTPUT.PUT_LINE(user_variable||' is a multiple of 10.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The remainder is '||MOD(user_variable,10)||'.');
    END IF;
END;
/

--3
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    average_amount_paid NUMBER;
    median_amount_paid NUMBER;
    mean_median_difference NUMBER;

BEGIN
    SELECT AVG(item_price - discount_amount),MEDIAN(item_price - discount_amount)
    INTO average_amount_paid, median_amount_paid
    FROM order_items;
    
    mean_median_difference:=average_amount_paid- median_amount_paid;
    DBMS_OUTPUT.PUT_LINE(mean_median_difference);
    
END;
/

--4
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    average_amount_paid NUMBER;
    median_amount_paid NUMBER;
    mean_median_difference NUMBER;

BEGIN
    SELECT AVG(item_price - discount_amount),MEDIAN(item_price - discount_amount)
    INTO average_amount_paid, median_amount_paid
    FROM order_items;
    
    mean_median_difference:=average_amount_paid- median_amount_paid;
    
    IF mean_median_difference>=3 THEN
        DBMS_OUTPUT.PUT_LINE('Mean is greater than median.');
    ELSIF mean_median_difference<=-3 THEN
        DBMS_OUTPUT.PUT_LINE('Mean is smaller than median.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Mean approximately equal to median.');
    END IF;
END;
/

--5
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    average_amount_paid NUMBER;
    median_amount_paid NUMBER;
    mean_median_difference NUMBER;

BEGIN
    SELECT AVG(item_price - discount_amount),MEDIAN(item_price - discount_amount)
    INTO average_amount_paid, median_amount_paid
    FROM order_items;
    
    mean_median_difference:=average_amount_paid- median_amount_paid;
    
    CASE 
    WHEN mean_median_difference>=3 THEN
        DBMS_OUTPUT.PUT_LINE('Mean is greater than median.');
    WHEN mean_median_difference<=-3 THEN
        DBMS_OUTPUT.PUT_LINE('Mean is smaller than median.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Mean approximately equal to median.');
    END CASE;
END;
/

--6
SET SERVEROUTPUT ON;
SET VERIFY OFF;
CREATE TABLE running_sum
(
    key_num   NUMBER  PRIMARY KEY,
    sum_value   NUMBER
)
;
DECLARE
    cnt  NUMBER;
BEGIN
    FOR i IN 1..10 LOOP
    cnt:=0;
        FOR j in 1..i LOOP
            cnt:=cnt+j;
        END LOOP;
        INSERT INTO running_sum VALUES(i,cnt);
    END LOOP;
END;
/

/*
SELECT *
FROM running_sum;
DROP TABLE running_sum;
*/

--7
SET SERVEROUTPUT ON;
SET VERIFY OFF;
BEGIN
    INSERT INTO running_sum VALUES(10,66);
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('You attempted to insert a duplicate value.');
END;
/

--8

--ORIGINAL VERSION
/*  
DECLARE
    sum_invoice_total  NUMBER:=0;
    row_invoice_total NUMBER:=0;
    row_invoice_date  DATE;
    row_num  NUMBER:=0;

BEGIN
    WHILE sum_invoice_total<100000 LOOP
        row_num:=row_num+1;
        
        SELECT invoice_total 
        INTO row_invoice_total
        FROM invoices
        WHERE invoice_id=row_num;
        
        sum_invoice_total:=sum_invoice_total+row_invoice_total;
    END LOOP;
    
    SELECT invoice_date,invoice_total 
    INTO row_invoice_date,row_invoice_total
    FROM invoices
    WHERE invoice_id=row_num;
        
    DBMS_OUTPUT.PUT_LINE('Invoice ID: '||row_num);
    DBMS_OUTPUT.PUT_LINE('Invoice Date: '||row_invoice_date);
    DBMS_OUTPUT.PUT_LINE('Invoice Total: '||row_invoice_total);
    DBMS_OUTPUT.PUT_LINE('Accumulator: '||sum_invoice_total);
    END IF;
END;
/
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
  CURSOR invoice_cursor IS
      SELECT invoice_id, invoice_date, invoice_total FROM invoices;
  cursor_row invoice_cursor%ROWTYPE;
  sum_invoice_total  NUMBER:=0;
  row_invoice_total NUMBER;
  row_invoice_date  DATE;
  row_invoice_id    NUMBER;
  
BEGIN
  OPEN invoice_cursor;
  WHILE sum_invoice_total<100000
  LOOP
    FETCH invoice_cursor INTO cursor_row;
    sum_invoice_total:=sum_invoice_total+cursor_row.invoice_total;
    row_invoice_total:=cursor_row.invoice_total;
    row_invoice_date:=cursor_row.invoice_date;
    row_invoice_id:=cursor_row.invoice_id;
  END LOOP;
  CLOSE invoice_cursor;
    DBMS_OUTPUT.PUT_LINE('Invoice ID: '||row_invoice_id);
    DBMS_OUTPUT.PUT_LINE('Invoice Date: '||row_invoice_date);
    DBMS_OUTPUT.PUT_LINE('Invoice Total: '||row_invoice_total);
    DBMS_OUTPUT.PUT_LINE('Accumulator: '||sum_invoice_total);
END;
/

--9
/*
A transaction, treated as a single unit, is a group of commands modifying the data in a database. A transaction ensures that if
one command fails, the whole transaction fails. In this way, either all commands were committed, or none of them. Therefore, 
transactions help prevent some database error, especially the data integrity error.
*/

--10
/*
If a person wants to transfer money from his/her savings account to his/her checkings account, a transaction would be utilized. 
There will be three steps in the transaction: decreasing savings account, increasing checkings account, and recording the transaction
in the transaction journal. If one step fails, such as insuffient balance in savings account, the whole transaction should not be 
performed.
*/
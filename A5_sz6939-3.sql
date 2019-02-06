/*
<Shimin Zhang>
<sz6939>
<8am>
Assignment 5
*/


--6
CREATE OR REPLACE VIEW  intern AS
    SELECT order_id,customers_mgs.customer_id,order_date,ship_amount,tax_amount,ship_date,orders_mgs.ship_address_id,orders_mgs.billing_address_id,state
    FROM addresses JOIN customers_mgs ON (addresses.address_id = customers_mgs.shipping_address_id)
                   JOIN orders_mgs ON (orders_mgs.customer_id=customers_mgs.customer_id)
;
/*SELECT *
FROM intern;

DROP VIEW intern;*/

--7
CREATE VIEW outstanding_balance_percent AS
    SELECT TO_CHAR(invoice_date,'MONTH') AS invoice_month,SUM(invoice_total-payment_total)/SUM(invoice_total) AS balance_percent
    FROM invoices
    GROUP BY TO_CHAR(invoice_date,'MONTH')
;

/*DROP VIEW outstanding_balance_percent
;
SELECT *
FROM outstanding_balance_percent
;*/

--8
UPDATE vendors
SET vendor_phone = REPLACE(vendor_phone, 'NULL', null);
UPDATE vendors
SET vendor_address1 = REPLACE(vendor_address1, 'NULL', null);
UPDATE vendors
SET vendor_address2= REPLACE(vendor_address2, 'NULL', null);


SELECT vendor_id,vendor_name,vendor_phone,vendor_address1,vendor_address2,
    CASE 
        WHEN vendor_phone IS NOT NULL THEN vendor_phone
        WHEN vendor_address1 IS NOT NULL THEN vendor_address1
        WHEN vendor_address2 IS NOT NULL THEN vendor_address2
        ELSE 'No contact information'
    END AS contact_information
FROM vendors
;

--9
SELECT vendor_id,vendor_name,vendor_phone,vendor_address1,vendor_address2,COALESCE(vendor_phone,vendor_address1,vendor_address2,'No contact information')AS contact_information
FROM vendors
;

--10
CREATE TABLE not_paid_contact_info AS
(
   SELECT vendor_id,vendor_name,vendor_phone,vendor_address1,vendor_address2,COALESCE(vendor_phone,vendor_address1,vendor_address2,'No contact information')AS contact_information
FROM vendors 
)
;
ALTER TABLE not_paid_contact_info
MODIFY contact_information
CONSTRAINT contact_information_nn NOT NULL
;
/*
DROP TABLE not_paid_contact_info
;
SELECT *
FROM not_paid_contact_info
;*/
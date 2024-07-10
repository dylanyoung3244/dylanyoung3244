/* Trigger_Transactions.sql
 Author: Dylan Young
 Email: dylanyoung3244@gmail.com
.Purpose: Trigger for creating a detailed table to show each transaction 
 - by de-normalizing data to provide an easier view.
 - Includes he date, price, genre, and whether or not the dvd
 - was kid friendly.
.Tables: Output table contains data de-normalized from the following tables
 - dvdrental.payment
 - dvdrental.category
 - dvdrental.film
						Table "dvdrental.transactions"
	Column			|         Type          | Description
	----------------+-----------------------+-----------------------------------------
	payment_id		| integer               | Primary Key
	date			| date	                | Date of the transaction
	amount			| numeric (5,2)         | Total amount of the transaction
	name			| character varying (25)| Name of the genre of the DVD
	is_kidfriendly	| boolean               | Whether or not the rating is 'G', 'PG', or 'PG-13'

.Notes
  Version:        1.0
  Author:         Dylan Young
  Creation Date:  9/26/2022
  Purpose/Change: Initial script development. Minimal viable product acheived.
  Tested:		  Sucessful in both HCLS-PostgreSQL01 & WGU's VDI instance name DESKTOP-BT4131D

.Notes
  Version:        1.1
  Author:         Dylan Young
  Creation Date:  6/17/2024
  Purpose/Change: Minimal changes due to retaking the classe.
  Tested:		  Sucessful in both FBI-Van & WGU's VDI instance name DESKTOP-BT4131D

.Notes
  Version:        1.2
  Author:         Dylan Young
  Creation Date:  6/21/2024
  Purpose/Change: Switched to using the 'is_kidfriendly' function
  Tested:		  Sucessful in both FBI-Van & WGU's VDI instance name DESKTOP-BT4131D
 
 */
CREATE OR REPLACE FUNCTION Update_Transactions()
    RETURNS trigger 
    AS $$ 
    --LANGUAGE plpgsql VOLATILE
    BEGIN
    DROP TABLE IF EXISTS transactions;
    CREATE TABLE transactions (
        payment_id integer,
        date DATE,
        amount numeric(5,2),
        name varchar(25),
        is_kidfriendly boolean
    );

    INSERT INTO transactions
    SELECT payment.payment_id,
        DATE(payment.payment_date),
        payment.amount,
        category.name,
        --This is the transformation feild
        is_kidfriendly(film.rating) as is_kidfriendly
    FROM payment
    /*
    * The 'category' table is 5 steps away from the 'payment' table
    * payment >> rental >> inventory >> film >> film_category >> category
    */
    LEFT Join rental ON rental.rental_id = payment.rental_id
    LEFT Join inventory ON inventory.inventory_id = rental.inventory_id
    LEFT Join film ON film.film_id = inventory.film_id
    LEFT Join film_category ON film_category.film_id = film.film_id
    LEFT Join category ON category.category_id = film_category.category_id
;
END;

$$
LANGUAGE plpgsql VOLATILE -- Says the function is implemented in the plpgsql language; VOLATILE says the function has side effects.
COST 100; -- Estimated execution cost of the function.



CREATE Trigger transactions_update
    AFTER INSERT
    ON payment
    FOR EACH ROW
    EXECUTE PROCEDURE Update_Transactions();

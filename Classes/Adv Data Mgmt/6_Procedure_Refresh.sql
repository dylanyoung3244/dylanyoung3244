/* Procedure_Refresh.sql
 Author: Dylan Young
 Email: dylanyoung3244@gmail.com
 Purpose: This file creates a stored procedure call 'refresh_genre'
 - that deletes both dvdrental.transactions and dvdrental.genre_agg
 - and repopulates the data in them.
 Schedule: Due to how the triggers function this procedure can be ran
 - monthly or whenever the data's accuracy or age is in question

 .Notes
  Version:        1.0
  Author:         Dylan Young
  Creation Date:  9/26/2022
  Purpose/Change: Initial script development. Minimal viable product acheived.
  Tested:		  Sucessful in both HCLS-PostgreSQL01 & WGU's VDI instance name DESKTOP-BT4131D

 .Notes
  Version:        1.1
  Author:         Dylan Young
  Creation Date:  6/18/2024
  Purpose/Change: Updated script for new version of the course
  Tested:		  Sucessful in both FBI-Van & WGU's VDI instance name DESKTOP-BT4131D

.Notes
  Version:        1.2
  Author:         Dylan Young
  Creation Date:  6/21/2024
  Purpose/Change: Switched to using the 'is_kidfriendly' function
  Tested:		  Sucessful in both FBI-Van & WGU's VDI instance name DESKTOP-BT4131D

.Notes
  Version:        1.3
  Author:         Dylan Young
  Creation Date:  6/25/2024
  Purpose/Change: Removed possible redundant code for populating the summary table
  Tested:		  Sucessful in both FBI-Van & WGU's VDI instance name DESKTOP-BT4131D

*/
CREATE PROCEDURE refresh_genre()
    LANGUAGE plpgsql 
    AS $$
    BEGIN
    -- Start the detailed table recreation
    TRUNCATE transactions;

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
    LEFT Join category ON category.category_id = film_category.category_id;
END $$;
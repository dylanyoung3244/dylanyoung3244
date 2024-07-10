/* Trigger_Transactions.sql
 Author: Dylan Young
 Email: dylanyoung3244@gmail.com
 Purpose: Extracts raw payment data and de-normalizes then into a readable table
 */
CREATE OR REPLACE FUNCTION Update_Transactions()
    RETURNS trigger 
    AS $$ 
    --LANGUAGE plpgsql VOLATILE
    BEGIN
    TRUNCATE transactions;
    );

    INSERT INTO transactions
    SELECT payment.payment_id,
        DATE(payment.payment_date),
        payment.amount,
        category.name,
        --This is the transformation feild
        CASE film.rating
            WHEN 'G' THEN TRUE
            WHEN 'PG' THEN TRUE
            WHEN 'PG-13' THEN TRUE
            ELSE FALSE
        END is_kidfriendly
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




CREATE Trigger GenreAgg_update
    AFTER INSERT
    ON transactions
    FOR EACH ROW
    EXECUTE PROCEDURE Update_Transactions();
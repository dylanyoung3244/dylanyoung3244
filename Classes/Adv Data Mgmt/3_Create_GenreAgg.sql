/* Create_GenreAg.sql
.Author: Dylan Young
 Email: dylanyoung3244@gmail.com
.Purpose: Creating a table with the the following information for each genre
 - Genre name, rental count, amount of profit the genre generated,
 - how many were and were not kid frienly, as well as their order by
 - rental count and amount of profit generated.
.Tables: Output table contains data originating from the following tables
 - dvdrental.transactions
						Table "dvdrental.genre_agg"
	Column					|         Type          | Description
	------------------------+-----------------------+----------------------------------------------------------------
	genre_name 		   		| character varying (25)| Primary Key - Name of the Genre
	rental_count			| bigint				| Number of rentals
	amount					| bigint                | Sum of the transaction for the genre
	kidfriendly_count		| bigint				| Count of rentals that were kid friendly
	not_kidfriendly_count	| bigint                | Count of rentals that were not kid friendly
	rental_order			| bigint				| Ordinal - The order of the genres by the count of rentals
	amount_order			| bigint				| Ordinal - The order of the genres by the sum of the transaction amounts

.Notes
  Version:        1.0
  Author:         Dylan Young
  Creation Date:  9/26/2022
  Purpose/Change: Initial script development. Minimal viable product acheived.
  Tested:		  Sucessful in both HCLS-PostgreSQL01 & VDI DESKTOP-BT4131D

.Notes
  Version:        1.1
  Author:         Dylan Young
  Creation Date:  10/13/2022
  Purpose/Change: Fixed issues mentioned in feedback.
  Tested:		  Sucessful in both HCLS-PostgreSQL01 & VDI DESKTOP-BT4131D

.Notes
  Version:        1.2
  Author:         Dylan Young
  Creation Date:  6/18/2024
  Purpose/Change: Updated for new version of coursework
  Tested:		  Sucessful in both FBI-Van & VDI DESKTOP-BT4131D

*/
DROP TABLE IF EXISTS genre_agg;
CREATE TABLE genre_agg (
	genre_name varchar(25),
	rental_count bigint,
	amount bigint,
	kidfriendly_count bigint,
	not_kidfriendly_count bigint,
	rental_order bigint,
	amount_order bigint
);
INSERT INTO genre_agg
SELECT transactions.name
		AS genre_name, 
	COUNT(transactions.payment_id)
		AS rental_count,
	SUM(transactions.amount)
		AS amount,
	COUNT(*) FILTER (WHERE transactions.is_kidfriendly = TRUE)
		AS kidfriendly_count,
	COUNT(*) FILTER (WHERE transactions.is_kidfriendly = FALSE)
		AS not_kidfriendly_count,
	RANK() OVER (ORDER BY COUNT(transactions.payment_id) DESC)
		AS rental_order,
	RANK() OVER (ORDER BY SUM(transactions.amount) DESC)
		AS amount_order
		
FROM transactions
GROUP BY transactions.name
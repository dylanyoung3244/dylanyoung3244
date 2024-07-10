/* Create_function_is_kidfriendly.sql
 Author: Dylan Young
 Email: dylanyoung3244@gmail.com
 Purpose: This file creates a function call 'is_kidfriendly'
 - that returns true if the rating is 'G', 'PG', or 'PG-13'

 .Notes
  Version:        1.0
  Author:         Dylan Young
  Creation Date:  6/12/2024
  Purpose/Change: Initial script development. Minimal viable product acheived.
  Tested:		  Sucessful in both FBI-Van & WGU's VDI instance name DESKTOP-BT4131D

 .Notes
  Version:        1.1
  Author:         Dylan Young
  Creation Date:  7/1/2024
  Purpose/Change: Changed the data type of the 'rating' feild to 'mpaa_rating'
  Tested:		  Sucessful in both FBI-Van & WGU's VDI instance name DESKTOP-BT4131D

*/


CREATE OR REPLACE FUNCTION is_kidfriendly(rating public.mpaa_rating)
    RETURNS boolean
    AS $$
    BEGIN
    CASE rating
        WHEN 'G' THEN RETURN TRUE;
        WHEN 'PG' THEN RETURN TRUE;
        WHEN 'PG-13' THEN RETURN TRUE;
        ELSE RETURN FALSE;
    END CASE;
    END
    $$ LANGUAGE plpgsql; -- Says the function is implemented in the plpgsql language. Sometimes it was being sassy with different envronments.

USE sakila;

SELECT *
FROM actor

#1a. Display the first and last names of all actors from the table actor.
SELECT 
	first_name,
    last_name
FROM actor

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT concat(
	first_name,
    '  ',
    last_name
) AS 'Actor Name'
FROM actor

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'JOE';

#2b. Find all actors whose last name contain the letters GEN:
SELECT last_name
FROM actor
WHERE last_name LIKE '%GEN%'

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, 
-- in that order:
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT *
FROM country

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
-- as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP description;

SELECT *
FROM actor

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, 
	COUNT(*)
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at 
-- least two actors
SELECT last_name, 
	COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET 
	first_name = 'HARPO'
WHERE
	first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

SELECT *
FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET 
	first_name = 'GROUCHO'
WHERE
	first_name = 'HARPO' AND last_name = 'WILLIAMS';

SELECT *
FROM actor
WHERE first_name = 'GROUCHO'AND last_name = 'WILLIAMS';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
SHOW CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff
INNER JOIN address USING(address_id);

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT
	staff.first_name,
    staff.last_name,
    sum(payment.amount)
AS total
FROM staff
JOIN payment 
ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.staff_id; 


#6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT
	title, COUNT(actor_id) AS 'number of actors'
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY title;
	

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
	title, COUNT(inventory_id) AS 'no. of copies'
FROM film f 
INNER JOIN inventory i USING(film_id)
WHERE title = 'Hunchback Impossible'

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
--  ![Total amount paid](Images/total_payment.png)
SELECT first_name, last_name, SUM(amount) AS 'total payment'
FROM customer c
INNER JOIN payment USING(customer_id)
GROUP BY c.customer_id
ORDER BY last_name ASC;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE language_id IN (
	SELECT language_id
    FROM language
    WHERE name = 'English')
AND title LIKE 'K%'
OR  title LIKE 'Q%';

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip')
);
		
	

#7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT
	customer.first_name,
    customer.last_name,
    customer.email
FROM customer
INNER JOIN address USING(address_id)
INNER JOIN city USING(city_id)
INNER JOIN country USING(country_id)
WHERE country = 'Canada';
	

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

#7e. Display the most frequently rented movies in descending order.

#7f. Write a query to display how much business, in dollars, each store brought in.

#7g. Write a query to display for each store its store ID, city, and country.

#7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.

#8b. How would you display the view that you created in 8a?

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.


-- 1.Select the first name, last name, and email address of all the customers who have rented a movie.
select first_name, last_name, email from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
group by first_name, last_name, email;

-- 2.What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
select b.customer_id, concat(first_name, " ", last_name) as names, avg(amount) from customer a
join payment b on a.customer_id = b.customer_id
group by a.customer_id;

-- 3.Select the name and email address of all the customers who have rented the "Action" movies
select first_name, last_name, email from customer a
join rental b on a.customer_id = b.customer_id
join inventory c on b.inventory_id = c.inventory_id
join film_category d on c.film_id = d.film_id
join category e on d.category_id = e.category_id
where e.name = "Action";

-- 4.Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment.
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
select payment_id, amount, 	(case when amount < 2 then "low"
							when amount > 2 and amount < 4 then "medium"
							when amount > 4 then "high" end) as column1
from payment;



-- Lab | Stored procedures
 -- 1.Convert the query into a simple stored procedure
 
 DELIMITER //
create procedure basic_customer_info() 
begin
   select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
 end //
DELIMITER ;
 
 -- 2.Now keep working on the previous stored procedure to make it more dynamic.
 -- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre
 
 
  DELIMITER //
create procedure basic_customer_info(in param varchar(10)) 
begin
   select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = param
  group by first_name, last_name, email;
 end //
DELIMITER ;
 
 call basic_customer_info("Animation");
 
 
-- Write a query to check the number of movies released in each movie category.
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number.
-- Pass that number as an argument in the stored procedure.
 
  DELIMITER //
create procedure film_released_category(in param varchar(10),in x int) 
begin 
declare that_count varchar(20) default "";
declare param1 int;

select count(title) into param1 from film a
join film_category b on a.film_id = b.film_id
join category c on b.category_id = c.category_id
where c.name = param;

if param1 >= x then
	set that_count = 'Lots of Movies';
elseif param1 < x then
    set that_count = 'Not that many movies';
else
    set that_count = "No option";
end if;

select that_count;
end //
DELIMITER ;

 call film_released_category("Animation", 65);


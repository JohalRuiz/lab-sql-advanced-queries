-- Lab | SQL Advanced queries
use sakila;
select * from film_actor;

-- List each pair of actors that have worked together.
SELECT fa1.film_id, concat(a1.first_name, ' ', a1.last_name) AS actor1, concat(a2.first_name, ' ', a2.last_name) AS actor2
FROM film_actor fa1
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id 
AND fa1.actor_id <> fa2.actor_id 
JOIN actor a2 ON fa2.actor_id = a2.actor_id;

CREATE OR REPLACE VIEW actor_pairs AS
SELECT concat(a1.first_name, ' ', a1.last_name) AS actor1, concat(a2.first_name, ' ', a2.last_name) AS actor2
FROM film_actor fa1
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id 
AND fa1.actor_id <> fa2.actor_id 
JOIN actor a2 ON fa2.actor_id = a2.actor_id;

SELECT * FROM actor_pairs;
SELECT DISTINCT actor1, actor2 
FROM actor_pairs;

-- just to check:
SELECT DISTINCT * FROM actor_pairs
WHERE actor1 = 'CHRISTIAN GABLE' AND actor2 = 'PENELOPE GUINESS';


-- For each film, list actor that has acted in more films.

select * from film_actor; -- 5462 rows

CREATE OR REPLACE VIEW count_per_actor AS
select film_id, actor_id, count(film_id) as films_count FROM film_actor
group by actor_id;
select * from count_per_actor
-- order by films_count desc
; 
-- in this view, we store the count of films per actor

select * from film;

SELECT fa.film_id, f.title, fa.actor_id
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id; -- this query diplays the results from film_actor with the titles

CREATE OR REPLACE VIEW count_per_actor_per_film AS
SELECT fa.film_id, f.title, fa.actor_id, cpa.films_count 
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id -- basically the same query as above, but here we join the film_count column from the previous view
JOIN count_per_actor cpa ON fa.actor_id = cpa.actor_id; -- hence this join

select * from count_per_actor_per_film; 

select film_id, title, actor_id, max(films_count) FROM count_per_actor_per_film
group by title;

SELECT fa.film_id, f.title, fa.actor_id, max(cpa.films_count) 
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id -- basically the same query as above, but here we join the film_count column from the previous view
JOIN count_per_actor cpa ON fa.actor_id = cpa.actor_id
group by title; -- same result as above using a query instead of creating a view

SELECT fa.film_id, f.title, fa.actor_id, count(f.film_id) 
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY fa.film_id, fa.actor_id
ORDER BY fa.film_id;

SELECT * FROM count_per_actor
-- ORDER BY film_count DESC
; -- 200 rows, same as the number of actors

select * from film;
SELECT actor_id, film_id, film_count, title FROM film
JOIN count_per_actor USING(film_id)
-- GROUP BY actor_id
;

SELECT * FROM film_actor;
SELECT * FROM actor;
SELECT * FROM film;
SELECT title, actor_id, max(film_count) FROM film f 
JOIN count_per_actor cpa USING(film_id)
GROUP BY title;

SELECT title, actor_id, film_count FROM film f 
JOIN count_per_actor cpa USING(film_id)
ORDER BY title ASC, film_count DESC;

--- Who is the senior ,ost employee based on the job title
select * from employee
ORDER BY levels desc
limit 1

--Which coountries have the most invoices
select COUNT(*) as count,billing_country  from invoice
group by billing_country
order by count desc

---what are top 3 values of total invoice

select total from invoice 
order by total desc

---which city has the best customers we would like to throw a promotional music festival in city we made the most money rite a query 
that return one city that has the highest sum of invoices total returns both the city thatv has yhe highest sum of invoices total
select sum(total)as invoice_total,billing_city from invoice
group by billing_city
order by invoice_total desc

---Who is best customer
select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) as total
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

---write a query to return the email,first name,last name & genre of all rock music lisner .return your list orderd alphabetically by email starting with A

select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id=genre.genre_id
	where genre.name like 'Rock'
)
order by email;


---lets invite the artist who have written the most rock music in our data set.write a query that returns the artist name and total track count of the top 10 rock brand
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;

---return all the track names that have a song length longer than the average song lenght  return the name and milisecond for each track order by the song lenght withe the longest song listed first

select name,milliseconds from track
where milliseconds >(
	select avg(milliseconds) as average_time
	from track
)
order by milliseconds desc

---find how much amount spent by each customer on artist write a query to return customer name and total artist

with best_selling_artist as(
select artist.artist_id as artist_id,artist.name as artist_name,sum(invoice_line.unit_price*invoice_line.quantity)as total_sales
	from invoice_line
	join track on track.track_id=invoice_line.track_id
	join album on album.album_id=track.album_id
	join artist on artist.artist_id=album.artist_id
	group  by 1
	order by 3 desc
	limit 1
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity)as amount_spent
from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album alb on alb.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by  5 desc;

---we want to find out the most popular music genre for each country.we determine
the most popular genre as the genre with the highest amount of purchase write a query that return
each country along with the top genre for countries where the maximum number of purchase is shared
 return all genres
 
with popular_genre as(
	select count(invoice_line.quantity) as purchase,customer.country,genre.name,genre.genre_id,
	row_number()over(partition by customer.country order by count (invoice_line.quantity)desc)as Rowno
	from invoice_line
	join invoice on invoice .invoice_id=invoice_line.invoice_id
	join customer on customer.customer_id=invoice.customer_id
	join track on  track.track_id=invoice_line.track_id
	join genre on genre.genre_id=track.genre_id
	group by 2,3,4
	order by 2 asc ,1 desc
)
 select *from popular_genre where Rowno<=1



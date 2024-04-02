#To retrieve unique item names
select distinct name from items;

#To get count of distinct names
select count(distinct name) from items;

#to get count of items that are veg or non veg or vegan
select is_veg,count(name) as veg_items from items group by is_veg;

#to get count of unique orders
select count(distinct order_id) from orders;

#to find the cnames of items that has name with 'chicken'
select * from items where name like '%chicken%';

#to find the cnames of items that has name with 'paratha'
select * from items where name like '%paratha%';

#to find average number of items per order
select count(name)/count(distinct order_id) as avg_items_per_order from items;

#to check how many times each item got ordered and highest ordered by the user.
select name,count(*) from items group by name order by count(*) desc;

#to see different rain modes(0: lite rain, 2: normal rain, 5:heavy rain)
select distinct rain_mode from orders;

#unique restaurant names user has ordered from
select count( distinct restaurant_name) from orders;

#to check how many times an user has ordered from a particular restaurant and most ordered restaurant
select restaurant_name,count(*) from orders group by restaurant_name order by count(*) desc;

#to find which month has more orders
select date_format(order_time,'%Y-%m') as ymonth, count(distinct order_id) from orders 
group by date_format(order_time,'%Y-%m')
ORDER BY count(distinct order_id) desc;

#to find recent order
select max(order_time) from orders;

#to find the total revenue made using order_time
select date_format(order_time,'%y-%m'),sum(order_total) as total_revenue from orders
group by date_format(order_time,'%y-%m')
order by total_revenue desc;

#to find avergage order value(how much an user is spending on an order)
select sum(order_total)/count(distinct order_id) as Avg_order_value from orders;

#how much money spent on swiggy and also find year on year change in revenue
with final as 
(select year(order_time) as year_order,sum(order_total) as revenue_by_Year from orders
group by year(order_time))
select year_order,revenue_by_Year,lag(revenue_by_Year) 
over (order by year_order) as previous_year_revenue from final;

#how much money spent on swiggy year wise and ranking them.
with final as 
(select year(order_time) as year_order,sum(order_total) as revenue_by_Year from orders
group by year(order_time))
select year_order,revenue_by_Year,rank() over (order by revenue_by_Year desc) as ranking from final;

#how much money spent on swiggy restaurant name wise and ranking them.
with final as 
(select restaurant_name,sum(order_total) as revenue_by_Year from orders
group by restaurant_name)
select restaurant_name,revenue_by_Year,rank() over (order by revenue_by_Year desc) as ranking from final;

#money made from different rain modes
select rain_mode,sum(order_total) from orders
group by rain_mode;

#to see what items were orders from each order
select i.name,i.is_veg,o.restaurant_name,o.order_id,o.order_time from items i 
inner join orders o on i.order_id=o.order_id ;

#to find the unique combo orders
select a.order_id,a.name,b.name as name2, concat(a.name,"-",b.name) from items a
join items b on a.order_id=b.order_id
where a.name!=b.name and a.name<b.name;
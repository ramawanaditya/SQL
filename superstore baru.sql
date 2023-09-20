use superstore;

select * from orders;

update orders 
set `Order Date` = date_format(str_to_date(`Order Date`, '%m/%d/%Y'), '%Y-%m-%d');

alter table orders modify column `Order Date` DATE;

update orders 
set `Ship Date` = date_format(str_to_date(`Ship Date`, '%m/%d/%Y'), '%Y-%m-%d');

alter table orders modify column `Ship Date` DATE;

select * from orders;

# cek ada berapa total customer
select
	count(distinct `Customer Name`) as Customers
from orders;

# cek trend penjualan pada tahun 2022 dan 2021
select 
	date_format(`Order Date`, '%Y-%m') as bulan_tahun, sum(Sales) penjualan 
from orders
where YEAR(`Order Date`) in (2022, 2021) 
group by date_format(`Order Date`, '%Y-%m')
order by date_format(`Order Date`, '%Y-%m');

# cek trend profit pada tahun 2022 dan 2021
select 
	date_format(`Order Date`, '%Y-%m') as bulan_tahun, sum(Profit) profit 
from orders
where YEAR(`Order Date`) in (2022, 2021) 
group by date_format(`Order Date`, '%Y-%m')
order by date_format(`Order Date`, '%Y-%m');

# cek trend quantity pada tahun 2022 dan 2021
select 
	date_format(`Order Date`, '%Y-%m') as bulan_tahun, sum(Quantity) Quantity 
from orders
where YEAR(`Order Date`) in (2022, 2021) 
group by date_format(`Order Date`, '%Y-%m')
order by date_format(`Order Date`, '%Y-%m');

# Sales and profit by State
select * from orders;

select 
	`State/Province` as State, sum(Sales) Penjualan, sum(Profit) Profit 
from orders
where `Country/Region` = 'United States'
group by 1
order by 2 desc;

# monthly sales by segment
## consumer
with avg_consumer as (
    select 
        date_format(`Order Date`, '%m') as Bulan, sum(Sales) penjualan_consumer
    from orders
    where year(`Order Date`) = 2022 and Segment = 'Consumer'
    group by 1
)
select avg(penjualan_consumer) as avg_consumer from avg_consumer;

## Corporate
with avg_corporate as (
	select 
		date_format(`Order Date`, '%m') as Bulan, sum(Sales) penjualan_Corporate
	from orders
	where year(`Order Date`) = 2022 and Segment = 'Corporate'
	group by 1
)
select avg(penjualan_corporate) as avg_corporate from avg_corporate;

## Home Office
with avg_homeoffice as(
	select 
		date_format(`Order Date`, '%m') as Bulan, sum(Sales) penjualan_home_office
	from orders
	where year(`Order Date`) = 2022 and Segment = 'Home Office'
	group by 1
)
select avg(penjualan_home_office) as avg_penjualan_homeoffice from avg_homeoffice;


# Total sales by location and manager
select 
	Region, sum(Sales) Penjualan
from orders
where year(`Order Date`) = 2022 and `Country/Region` = 'United States'
group by 1
order by sum(Sales) desc;

select 
	o.`Country/Region` as Country,
	p.`Regional Manager` as Manager,
	sum(o.Sales) penjualan
from orders o join people p on o.Region = p.Region 
where o.`Country/Region` = 'United States' and year(o.`Order Date`) = 2022
group by 2,1
order by sum(o.Sales) desc;

select * from orders;

# State above and below the U.S Sales Average
with state_sales_average as(
select 
	`State/Province` state,
	avg(sales) as avg_penjualan
from orders 
where `Country/Region` = 'United States' and year(`Order Date`) = 2022
group by 1
order by 2 desc)
select
	state,
	case 
		when avg_penjualan >= 221 then 'Above'
		when avg_penjualan < 221 then 'Below'
	end above_below
from state_sales_average;


# state above and below the u.s profit average
with state_profit_average as(
select 
	`State/Province` as State,
	sum(Profit) as total_profit
from orders 
where `Country/Region` = 'United States' and year(`Order Date`) = 2022
group by 1
order by 2 desc)
select
	State,
	case 
		when total_profit >= 1988 then 'Above'
		when total_profit < 1988 then 'Below'
	end above_below_profit
from state_profit_average;





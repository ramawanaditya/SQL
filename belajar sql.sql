use superstore;

# Tampilkan semua data dari tabel tersebut.
select * from orders;

# Tampilkan hanya 5 baris pertama dari tabel tersebut.
select * 
from orders
limit 5;

# Hitung jumlah total order yang ada dalam tabel.
select count(`Order ID`) as order_id
from orders;

# Hitung jumlah produk yang terjual.
select sum(Quantity) as product_name
from orders;

# Tampilkan semua data unik dalam kolom "Category."
select distinct Category
from orders;

# Tampilkan semua data unik dalam kolom "Segment."
select distinct Segment 
from orders;

# Tampilkan semua data unik dalam kolom "Country."
select distinct `Country/Region`
from orders;

# Tampilkan produk dengan penjualan (Sales) tertinggi.
select `Product Name`, max(sales) as Sales  
from orders
group by 1
order by 2 desc
limit 1;

select *
from orders o 
order by sales desc
limit 1;

# Tampilkan produk dengan profit (Profit) tertinggi.
select `Product Name`, max(Profit) as Profit  
from orders
group by 1
order by 2 desc
limit 1;

# Tampilkan semua data unik dalam kolom "Sub-Category" bersama dengan jumlah produk yang terjual untuk masing-masing sub-kategori.
select `Sub-Category`, sum(Quantity) total_quantity 
from orders
group by 1;

# Tampilkan total profit yang diperoleh dari penjualan di setiap negara.
select `Country/Region`, sum(Profit)
from orders
group by 1;

# Tampilkan 10 pelanggan (Customer Name) dengan jumlah order terbanyak.
select `Customer Name`, count(`Product Name`)
from orders
group by 1
order by 2 desc
limit 10;

# Tampilkan total profit yang diperoleh dari setiap kategori produk.
select Category, sum(Profit)
from orders o
group by 1;

# Tampilkan produk yang memiliki diskon (Discount) di atas 20%.
select `Product Name`, Discount 
from orders o
where discount > 0.2;

# Tampilkan jumlah produk yang dijual pada setiap tanggal (Order Date).
select `Order Date`, sum(Quantity) 
from orders o 
group by 1;

# Tampilkan 10 pelanggan (Customer Name) dengan total penjualan (Sales) tertinggi.
select `Customer Name`, sum(Sales) penjualan
from orders o 
group by 1
order by 2 desc 
limit 10;

# Tampilkan 5 produk terlaris berdasarkan jumlah terjual (Quantity).
select `Product Name`, sum(Quantity) total_quantity 
from orders o 
group by 1
order by 2 desc 
limit 5;

# Tampilkan pelanggan (Customer Name) yang memiliki jumlah order (Order ID) paling banyak dalam satu hari.
select 
	`Customer Name`, 
	`Order Date`, 
	count(`Order ID`) jumlah_order 
from orders o 
group by 2, 1
order by 3 desc
limit 1;

# Hitung rata-rata diskon (Discount) yang diberikan untuk produk dalam setiap kategori (Category).
select Category, avg(Discount) ratarata_discount
from orders o 
group by 1;

# Tampilkan 5 negara (Country) dengan total profit (Profit) tertinggi.
select `State/Province`, sum(Profit) Profit 
from orders o 
group by 1
order by 2 desc 
limit 5;

# Tampilkan produk dengan penjualan (Sales) terendah untuk masing-masing segmen (Segment).
select Segment, `Product Name`, min(Sales) 
from orders o
group by 1,2;

# Tampilkan pelanggan (Customer Name) yang memiliki total profit (Profit) paling tinggi.
select `Customer Name`, sum(Profit) as Profit 
from orders o 
group by 1
order by 2 desc
limit 1;

# Tampilkan 10 produk dengan profit margin (Profit/Sales) tertinggi.
select `Product Name`, Profit / Sales as margin
from orders o 
order by 2 desc 
limit 10;

# Tampilkan 5 negara (Country) dengan tingkat pengiriman (Ship Mode) terbanyak.
select `State/Province`, `Ship Mode`, count(*) shipcount
from orders o 
group by 1,2
order by 3 desc
limit 5;

# Tampilkan 5 produk dengan diskon (Discount) tertinggi yang memiliki profit negatif.
select `Product Name`, Discount, Profit 
from orders o 
where Profit < 0
order by 2 desc
limit 5;

SELECT `Product Name`, Discount, Profit
FROM orders
WHERE Discount > 0 AND Profit < 0
ORDER BY Discount DESC
LIMIT 5;

# Tampilkan produk yang memiliki penjualan (Sales) lebih tinggi dari rata-rata penjualan dari semua produk.
select `Product Name`, Sales
from orders o
where sales > (select avg(Sales) from orders o2);

# Tampilkan pelanggan (Customer Name) yang melakukan pembelian terbanyak di setiap negara (Country).
WITH RankedCustomers AS (
  SELECT
    `State/Province` as state,
    `Customer Name` as customer_name,
    COUNT(`Order ID`) AS total_order,
    ROW_NUMBER() OVER (PARTITION BY `State/Province` ORDER BY COUNT(`Order ID`) DESC) AS rankkk
  FROM
    orders
  GROUP BY
    1,
    2
)
SELECT
  state,
  customer_name,
  total_order
FROM
  RankedCustomers
WHERE
  rankkk <= 3; -- Ubah angka 3 sesuai dengan jumlah pelanggan teratas yang ingin ditampilkan

# Tampilkan 5 produk dengan harga tertinggi (Sales) untuk setiap kategori (Category).
with each_category as (
	select 
		`Product Name`,
		Category,
		max(Sales) as Sales,
		row_number() over(partition by Category order by max(Sales) desc) as rankk
	from orders
	group by 1,2
)
select 
	`Product Name`,
	Category,
	Sales
from each_category
where rankk <= 5
order by 2, 3 desc;
# Tampilkan pelanggan (Customer Name) yang memiliki jumlah order (Order ID) lebih dari 
# rata-rata jumlah order dari semua pelanggan.
with final_query as (
	select 
		customer_name,
		jumlah_order,
		avg(jumlah_order) over() as avg_overall_order
	from
		(select 
		`Customer Name` as customer_name,
		count(`Order ID`) as jumlah_order
		from orders
		group by 1) as test
	group by 1,2
)
select 
	customer_name,
	jumlah_order
from final_query
where jumlah_order >= avg_overall_order;

# Tampilkan total penjualan harian (Sales) selama 7 hari terakhir dari data.
SELECT `Order Date` , SUM(Sales) AS TotalSales
FROM orders
WHERE `Order Date`  >= (SELECT MAX(`Order Date`) - INTERVAL 6 DAY FROM orders)
GROUP BY 1;

# Tampilkan total profit (Profit) yang dihasilkan oleh produk dengan diskon (Discount) tertinggi.
select 
	sum(Profit) as profit,
	max(Discount) as Discount 
from 
	orders;

select 
	sum(Profit) as total_profit
from orders
where discount = (select max(Discount) from orders);

# Tampilkan rata-rata penjualan harian (Sales) untuk setiap bulan.
select 
	date_format(`Order Date`, '%Y-%m')  bulan_tahun,
	avg(Sales) ratarata_penjualan
from
	orders
group by 1;
	
# Tampilkan 5 pelanggan (Customer Name) yang memiliki jumlah order terbanyak dalam rentang tahun tertentu.
with rank_tahun as(
	select 
		date_format(`Order Date`, '%Y') as tahun,
		`Customer Name` as pelanggan,
		count(`Order ID`) as jumlah_order,
		row_number() over(partition by tahun order by jumlah_order desc) as rankk
	from 
		orders o
	group by 1,2)
select 
	tahun,
	pelanggan,
	jumlah_order
from 
	rank_tahun
where 
	rankk <= 5
order by 1, 3 desc;

# Hitung jumlah total produk yang dijual (Quantity) setiap bulan.
select 
	date_format(`Order Date`, '%Y-%m') as bulan_tahun,
	sum(quantity) total_quantity
from 
	orders
group by 1;

# Tampilkan 10 pelanggan yang memiliki profit tertinggi berdasarkan total profit mereka.
select 
	`Customer Name` as pelanggan,
	sum(Profit) as total_profit
from orders o
group by 1
order by 2 desc
limit 10;
# Tampilkan produk dengan penjualan (Sales) terendah untuk masing-masing negara (Country) yang memiliki lebih dari satu kota (City).
SELECT `State/Province`, `Product Name` , MIN(Sales) AS MinSales
FROM orders o 
WHERE `State/Province`  IN (
    SELECT `State/Province` 
    FROM orders o2 
    GROUP BY `State/Province` 
    HAVING COUNT(DISTINCT City) > 1
)
GROUP BY 1, 2;

# Tampilkan 5 negara (Country) dengan rata-rata diskon (Discount) tertinggi.
select `State/Province`, avg(Discount) avg_discount 
from orders o
group by 1
order by 2 desc 
limit 5;

# Tampilkan produk dengan penjualan (Sales) terendah yang masih menghasilkan profit positif.
select 
	`Product Name` as product,
	Sales,
	Profit  
from orders o
where Profit > 0
order by 2;

SELECT `Product Name`, Sales, Profit
FROM orders o 
WHERE Sales = (SELECT MIN(Sales) FROM orders o2 WHERE Profit > 0);

# Tampilkan 5 pelanggan (Customer Name) dengan jumlah order terbanyak dalam satu tahun tertentu.
with rank_tahun as(
	select 
		date_format(`Order Date`, '%Y') as tahun,
		`Customer Name` as pelanggan,
		count(`Order ID`) as jumlah_order,
		row_number() over(partition by tahun order by jumlah_order desc) as rankk
	from 
		orders o
	group by 1,2)
select 
	tahun,
	pelanggan,
	jumlah_order
from 
	rank_tahun
where 
	rankk <= 5
order by 1, 3 desc;

# Tampilkan 10 produk terlaris berdasarkan total penjualan selama tahun tertentu.
with rank_tahun as(
	select 
		date_format(`Order Date`, '%Y') as tahun,
		`Product Name` as nama_produk,
		count(`Order ID`) as jumlah_order,
		row_number() over(partition by tahun order by jumlah_order desc) as rankk
	from 
		orders o
	group by 1,2)
select 
	tahun,
	nama_produk,
	jumlah_order
from 
	rank_tahun
where 
	rankk <= 5
order by 1, 3 desc;

# Tampilkan total penjualan harian (Sales) selama minggu kerja (Senin hingga Jumat) 2021.
select 
	`Order Date`,
	dayname(`Order Date`) as nama_hari ,
	sum(Sales) total_penjualan
from orders o 
where year(`Order Date`) = 2021 and dayofweek(`Order Date`) between 2 and 6 
group by 1, 2;
# Tampilkan produk dengan diskon (Discount) tertinggi yang masih menghasilkan profit positif.
select 
	`Product Name`,
	Discount,
	Profit
from orders 
where Profit > 0
order by 2 desc;

SELECT `Product Name` , Discount, Profit
FROM orders o
WHERE Discount = (SELECT MAX(Discount) FROM orders o2 WHERE Profit > 0);
# Tampilkan 5 pelanggan (Customer Name) dengan profit tertinggi berdasarkan total profit selama tahun 2021.
select `Customer Name`, sum(Profit) totalprofit
from orders o
where date_format(`Order Date`, '%Y') = 2021
group by 1
order by 2 desc 
limit 5;

# Hitung jumlah total produk yang dijual (Quantity) setiap hari dalam bulan maret 2022.
select `Order Date`, sum(Quantity) total_quantity
from orders 
where date_format(`Order Date`, '%Y') = 2022 and date_format(`Order Date`, '%m') = 03 
group by 1;

# Tampilkan 10 pelanggan yang memiliki total penjualan (Sales) tertinggi berdasarkan total penjualan selama tahun 2019.
select 
	`Customer Name` as pelanggan,
	sum(Sales) as total_penjualan
from orders o 
where date_format(`Order Date`, '%Y') = 2019
group by 1
order by 2 desc 
limit 10;






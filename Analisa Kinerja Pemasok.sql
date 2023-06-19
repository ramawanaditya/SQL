use AdventureWorksDW2022;

select * from DimReseller;

select * from FactResellerSales;

select * from DimDate;

select * from DimProduct;

/*
delete kolom LargePhoto
*/
alter table DimProduct
drop column LargePhoto;


-- Check data and column
select distinct dr.BusinessType
from DimReseller dr inner join FactResellerSales fr on dr.ResellerKey = fr.ResellerKey;

select distinct dr.ResellerName
from DimReseller dr inner join FactResellerSales fr on dr.ResellerKey = fr.ResellerKey;

select distinct dr.ResellerName, dr.BusinessType
from DimReseller dr inner join FactResellerSales fr on dr.ResellerKey = fr.ResellerKey
where dr.BusinessType = 'Warehouse';

select distinct dr.ResellerName, dr.BusinessType
from DimReseller dr inner join FactResellerSales fr on dr.ResellerKey = fr.ResellerKey
where dr.BusinessType = 'Value Added Reseller';

select distinct dr.ResellerName, dr.BusinessType
from DimReseller dr inner join FactResellerSales fr on dr.ResellerKey = fr.ResellerKey
where dr.BusinessType = 'Specialty Bike Shop' and (dr.ResellerName LIKE '%Bike%' OR dr.ResellerName LIKE '%Bicycle%');

select distinct dr.ResellerName, dr.BusinessType, fr.ResellerKey
from DimReseller dr inner join FactResellerSales fr on dr.ResellerKey = fr.ResellerKey
where dr.BusinessType = 'Specialty Bike Shop'
order by 3;

-- cek geography country region
select distinct CountryRegionCode
from DimGeography;

-- cek tipe bisnis
select distinct BusinessType
from DimReseller;

select *
from DimReseller;

-- Analisa Tipe Bisnis Specialty Bike Shop di US, Total Biaya Produk, Pendapatan Penjualan, Profit, Jumlah Produk Terjual
select dr.ResellerName, dg.StateProvinceName,
sum(fr.TotalProductCost) as totalbiayaproduk, 
sum(fr.SalesAmount) JumlahPenjualan, 
sum(fr.SalesAmount) - sum(fr.TotalProductCost) as Profit,
avg(fr.DiscountAmount) ratarata_diskon
from DimGeography dg 
inner join DimReseller dr on dg.GeographyKey = dr.GeographyKey 
inner join FactResellerSales fr on dr.ResellerKey = fr.ResellerKey
where dr.BusinessType = 'Specialty Bike Shop' and dg.CountryRegionCode = 'US'
group by dr.ResellerName, dg.StateProvinceName
order by Profit desc;

-- cek country region code
select distinct CountryRegionCode
from DimGeography;

/*	
Analisa Tipe Bisnis Specialty Bike Shop di US, mengetahui ratarata harga jual, 
harga tertinggi suatu produk terjual, harga terendah suatu produk terjual
*/
select dr.ResellerName, dg.StateProvinceName,
avg(fr.UnitPrice) Ratarata_hargajual, 
max(fr.UnitPrice)HargaTertinggi, 
min(fr.UnitPrice)HargaTerendah
from DimGeography dg 
inner join DimReseller dr on dg.GeographyKey = dr.GeographyKey 
inner join FactResellerSales fr on dr.ResellerKey = fr.ResellerKey
where dr.BusinessType = 'Specialty Bike Shop' and dg.CountryRegionCode = 'US'
group by dr.ResellerName, dg.StateProvinceName
order by Ratarata_hargajual;

-- Menampilkan orderquantity dari tipe bisnis specialty bike shop, dikelompokkan dalam bulan-tahun, dan reseller name.
select dr.ResellerName, 
FORMAT(fr.OrderDate,'yyyy-MM') as bulan_tahun, 
sum(fr.OrderQuantity) total_jumlahorder
from FactResellerSales fr 
inner join DimReseller dr on fr.ResellerKey = dr.ResellerKey
inner join DimGeography dg on dr.GeographyKey = dg.GeographyKey
where dr.BusinessType = 'Specialty Bike Shop' and dg.CountryRegionCode = 'US'
group by dr.ResellerName, FORMAT(fr.OrderDate,'yyyy-MM')
order by ResellerName, bulan_tahun;

-- Menampilkan orderquantity dari tipe bisnis, dikelompokkan dalam pertahun, dan Country.
select dg.EnglishCountryRegionName as Country, dr.BusinessType as BusinessType, 
FORMAT(fr.OrderDate,'yyyy') as pertahun, 
sum(fr.OrderQuantity) total_jumlahorder
from FactResellerSales fr 
inner join DimReseller dr on fr.ResellerKey = dr.ResellerKey
inner join DimGeography dg on dr.GeographyKey = dg.GeographyKey
group by dg.EnglishCountryRegionName, dr.BusinessType, FORMAT(fr.OrderDate,'yyyy')
order by Country, BusinessType,pertahun;

-- menampilkan jumlah penjualan, total biaya produksi, profit dari tipe bisnis dan category product
select dr.BusinessType, dpc.EnglishProductCategoryName as category_product, format(fr.orderdate,'yyyy') pertahun,
sum(fr.TotalProductCost) as Cost_Product, 
sum(fr.SalesAmount) Jumlah_Penjualan, 
sum(fr.SalesAmount) - sum(fr.TotalProductCost) as Profit
from FactResellerSales fr 
join DimReseller dr on fr.ResellerKey = dr.ResellerKey
join DimProduct dp on fr.ProductKey = dp.ProductKey
join DimProductSubcategory dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
join DimProductCategory dpc on dps.ProductCategoryKey = dpc.ProductCategoryKey
join DimGeography dg on dr.GeographyKey = dg.GeographyKey
where dg.CountryRegionCode = 'US'
group by dr.BusinessType, dpc.EnglishProductCategoryName, format(fr.orderdate,'yyyy')
order by dr.BusinessType, category_product;

-- menampilkan berapa banyak masing-masing business type
-- tidak dengan france, karena banyak unknown location
select BusinessType, count(BusinessType) jumlah_businesstype
from FactResellerSales fr join DimReseller dr on fr.ResellerKey = dr.ResellerKey
join DimGeography dg on dr.GeographyKey = dg.GeographyKey
where dg.CountryRegionCode <> 'FR'
group by BusinessType;

select BusinessType, count(BusinessType) jumlah_businesstype
from FactResellerSales fr join DimReseller dr on fr.ResellerKey = dr.ResellerKey
group by BusinessType;

-- menampilkan jumlah penjualan, total biaya produksi, profit dari tipe bisnis tiap negara
select dg.EnglishCountryRegionName as Country, dr.BusinessType as Tipebisnis,
sum(fr.TotalProductCost) as Cost_Product, 
sum(fr.SalesAmount) Jumlah_Penjualan, 
sum(fr.SalesAmount) - sum(fr.TotalProductCost) as Profit
from FactResellerSales fr 
join DimReseller dr on fr.ResellerKey = dr.ResellerKey
join DimProduct dp on fr.ProductKey = dp.ProductKey
join DimProductSubcategory dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
join DimProductCategory dpc on dps.ProductCategoryKey = dpc.ProductCategoryKey
join DimGeography dg on dr.GeographyKey = dg.GeographyKey
group by dr.BusinessType, dg.EnglishCountryRegionName
order by Country;

-- berdasarkan country
select dg.EnglishCountryRegionName as Country,
sum(fr.TotalProductCost) as Cost_Product, 
sum(fr.SalesAmount) Jumlah_Penjualan, 
sum(fr.SalesAmount) - sum(fr.TotalProductCost) as Profit
from FactResellerSales fr 
join DimReseller dr on fr.ResellerKey = dr.ResellerKey
join DimProduct dp on fr.ProductKey = dp.ProductKey
join DimProductSubcategory dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
join DimProductCategory dpc on dps.ProductCategoryKey = dpc.ProductCategoryKey
join DimGeography dg on dr.GeographyKey = dg.GeographyKey
group by dg.EnglishCountryRegionName
order by Profit desc;

-- berdasarkan province
select dg.StateProvinceName as Province,
sum(fr.TotalProductCost) as Cost_Product, 
sum(fr.SalesAmount) Jumlah_Penjualan, 
sum(fr.SalesAmount) - sum(fr.TotalProductCost) as Profit
from FactResellerSales fr 
join DimReseller dr on fr.ResellerKey = dr.ResellerKey
join DimProduct dp on fr.ProductKey = dp.ProductKey
join DimProductSubcategory dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
join DimProductCategory dpc on dps.ProductCategoryKey = dpc.ProductCategoryKey
join DimGeography dg on dr.GeographyKey = dg.GeographyKey
group by dg.StateProvinceName
order by Profit desc;
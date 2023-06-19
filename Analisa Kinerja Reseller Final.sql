use AdventureWorksDW2022;

-- Menampilkan orderquantity dari tipe bisnis, dikelompokkan dalam pertahun, dan Country.
select dg.EnglishCountryRegionName as Country, dr.BusinessType as BusinessType, 
FORMAT(fr.OrderDate,'yyyy') as pertahun, 
sum(fr.OrderQuantity) total_jumlahorder
from FactResellerSales fr 
inner join DimReseller dr on fr.ResellerKey = dr.ResellerKey
inner join DimGeography dg on dr.GeographyKey = dg.GeographyKey
group by dg.EnglishCountryRegionName, dr.BusinessType, FORMAT(fr.OrderDate,'yyyy')
order by Country, BusinessType,pertahun;

-- Menampilkan Orderquantity by Province, dikelompokkan pertahun
select dg.EnglishCountryRegionName as Country, 
FORMAT(fr.OrderDate,'yyyy') as pertahun, 
sum(fr.OrderQuantity) total_jumlahorder
from FactResellerSales fr 
inner join DimReseller dr on fr.ResellerKey = dr.ResellerKey
inner join DimGeography dg on dr.GeographyKey = dg.GeographyKey
group by dg.EnglishCountryRegionName, FORMAT(fr.OrderDate,'yyyy')
order by Country, pertahun;

-- Menampilkan Total Orderquantity by Province
select dg.EnglishCountryRegionName as Country, 
sum(fr.OrderQuantity) total_jumlahorder
from FactResellerSales fr 
inner join DimReseller dr on fr.ResellerKey = dr.ResellerKey
inner join DimGeography dg on dr.GeographyKey = dg.GeographyKey
group by dg.EnglishCountryRegionName
order by Country;

-- Menampilkan Total Profit pertahun, United States
select FORMAT(fr.OrderDate,'yyyy') as pertahun, 
sum(fr.SalesAmount)-sum(fr.TotalProductCost) as profit
from FactResellerSales fr 
inner join DimReseller dr on fr.ResellerKey = dr.ResellerKey
inner join DimGeography dg on dr.GeographyKey = dg.GeographyKey
where dg.EnglishCountryRegionName = 'United States'
group by FORMAT(fr.OrderDate,'yyyy')
order by pertahun;
-- Menampilkan Total Profit perbulan selama perido 2012-2013, United States
select FORMAT(fr.OrderDate,'yyyy-MM') as bulan_pertahun, 
sum(fr.SalesAmount)-sum(fr.TotalProductCost) as profit
from FactResellerSales fr 
inner join DimReseller dr on fr.ResellerKey = dr.ResellerKey
inner join DimGeography dg on dr.GeographyKey = dg.GeographyKey
where dg.EnglishCountryRegionName = 'United States'
group by FORMAT(fr.OrderDate,'yyyy-MM')
order by bulan_pertahun;

-- Menampilkan Total Orderquantity pertahun, United States
select format(fr.OrderDate,'yyyy') as pertahun,
sum(fr.OrderQuantity) total_jumlahorder
from FactResellerSales fr 
inner join DimReseller dr on fr.ResellerKey = dr.ResellerKey
inner join DimGeography dg on dr.GeographyKey = dg.GeographyKey
where dg.EnglishCountryRegionName = 'United States'
group by format(fr.OrderDate,'yyyy')
order by pertahun;
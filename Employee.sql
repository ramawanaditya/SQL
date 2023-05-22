use AdventureWorksDW2022;

select * from DimEmployee;

select HireDate, StartDate
from DimEmployee;

-- cek duplikat
select FirstName, lastname, count(*) jumlah_duplikat
from DimEmployee
group by FirstName, LastName
having count(*) > 1;

-- employee count aktif
select count(distinct concat(firstname,' ',lastname)) as karyawan_aktif
from DimEmployee;

-- total employee
select count(FirstName) total_karyawan
from DimEmployee;

-- update kolom status null menjadi extend contract
update DimEmployee
set Status = 'Extend Contract'
where status is null;

-- total karyawan extend contract
select Status, count(status)
from DimEmployee
where status = 'Extend Contract'
group by Status;

-- umur masing-masing karyawan
select distinct concat(FirstName,' ',LastName) fullname, BirthDate, datediff(year, BirthDate, GETDATE()) as umur
from DimEmployee;

-- rata-rata umur karyawan
select avg(umur) as ratarata_umurkaryawan
from (
	select datediff(year, BirthDate, GETDATE()) as umur
	from DimEmployee
	where Status <> 'Extend Contract'
) as nyoba;

-- total karyawan laki-laki dan perempuan
select gender, count(gender) as total_gender
from DimEmployee
where status <> 'Extend Contract'
group by gender;

-----------------------------------------
-- mengelompokkan umur karyawan
select umur, count(umur) jumlah
from (
	select datediff(year, BirthDate, GETDATE()) as umur
	from DimEmployee
	where Status <> 'Extend Contract'
) as nyoba
group by umur
order by umur;

-- total title employee paling banyak 5 teratas
select top 5 title, count(title) jumlah
from DimEmployee
where status <> 'Extend Contract'
group by title
order by jumlah desc;

-- total department employee paling banyak 5 teratas
select DepartmentName, count(DepartmentName) jumlah 
from DimEmployee
where Status <> 'Extend Contract'
group by DepartmentName
order by jumlah desc;

-- karyawan dengan gaji/jam paling tinggi
select concat(FirstName,' ', LastName) as fullname, datediff(year, BirthDate, GETDATE()) as umur, DepartmentName, max(BaseRate) gaji_per_jam
from DimEmployee
where Status <> 'Extend Contract'
group by concat(FirstName,' ', LastName), DepartmentName, datediff(year, BirthDate, GETDATE())
order by gaji_per_jam desc;

-- rata-rata gaji karyawan per jam berdasarkan departmentname
select DepartmentName, avg(BaseRate) gaji_per_jam
from DimEmployee
where Status <> 'Extend Contract'
group by DepartmentName
order by gaji_per_jam desc;
use imdb;

select * from imdb_movies_new;

select names from imdb_movies_new;


-- cek kolom yang mempunyai nilai hilang atau missing value
select genre from imdb_movies_new
where genre = "";

select * from imdb_movies_new imn 
where genre = "" or crew = "";

-- cek duplikat
select distinct names
from imdb_movies_new imn;

-- cek date dari dataset ini
select date_x 
from imdb_movies_new
order by date_x;

-- cek duplikasi
select * from imdb_movies_new 
where names = 'Troll';

##########################################################
-- menampilkan biaya produksi, pendapatan film dari 2000
select date_format(date_x, '%Y') as pertahun, sum(budget_x) biaya_produksi, sum(revenue) pendapatan 
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2000
group by date_format(date_x, '%Y');

-- menampilkan ratings film paling tinggi pada tahun 2020 - 2023
select names as judul_film, date_format(date_x, '%Y') as tahun, max(score) ratings
from imdb_movies_new imn 
where date_format(date_x, '%Y') >= 2020
group by names 
order by ratings desc;

-- total genre 2022 - 2023 top 5
select genre, date_format(date_x, '%Y') as tahun, count(genre) total
from imdb_movies_new imn 
where date_format(date_x, '%Y') between 2022 and 2023
group by genre
order by total desc
limit 10;

-- menampilkan budget film paling besar pada tahun 2022 - 2023
select names as judul_film, date_format(date_x, '%Y') as tahun, max(budget_x) as biaya_produksi
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2022
group by names 
order by biaya_produksi desc;

-- menampilkan pendapatan film paling besar pada tahun 2022 - 2023
select names as judul_film, date_format(date_x, '%Y') as tahun, max(revenue) as pendapatan
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2022
group by names 
order by pendapatan desc;

-- menampilkan pendapatan bersih film paling besar pada tahun 2022 - 2023
select names as judul_film, date_format(date_x, '%Y') as tahun, max(revenue) - max(budget_x) pendapatan_bersih
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2022
group by names 
order by pendapatan_bersih desc;

-- menampilkan rating film paling tinggi bergenre tv movies 2020 - 2023 #skip
select names as judul_film, date_format(date_x, '%Y') as tahun, max(score) ratings, genre
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2020 and genre like ('TV%')
group by names 
order by ratings desc;

select * from imdb_movies_new imn 
where genre like ('TV%');

-- menampilkan budget, revenue, pendapatan bersih film bergenre tv movies 2020 - 2023 #skip
select names as judul_film, date_format(date_x, '%Y') as tahun, max(budget_x) as biaya_produksi
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2020 and genre like ('TV%')
group by names 
order by biaya_produksi desc;

select names as judul_film, date_format(date_x, '%Y') as tahun, max(revenue) as pendapatan
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2020 and genre like ('TV%')
group by names 
order by pendapatan desc;

select names as judul_film, date_format(date_x, '%Y') as tahun, max(revenue) - max(budget_x) pendapatan_bersih
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2020 and genre like ('TV%')
group by names 
order by pendapatan_bersih desc;

-- menampilkan film yang memiliki kerugian
select names as judul_film, date_format(date_x, '%Y') as tahun, max(revenue) - max(budget_x) pendapatan_bersih
from imdb_movies_new imn
where date_format(date_x, '%Y') >= 2022
group by names
having max(revenue) - max(budget_x) < 0
order by pendapatan_bersih;

-- Total Movies in Period 2022 - 2023
select count(*) Total_Movies
from imdb_movies_new imn 
where date_format(date_x, '%Y') >= 2022;

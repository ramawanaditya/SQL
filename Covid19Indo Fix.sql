create database covid19indo;
use covid19indo;

/* kasus covid-19 di indonesia berdasarkan bulan dan tahun
*/
select DATE_FORMAT(date, '%Y-%m') AS bulan_tahun,
sum(`New Cases`) kasus_covid, sum(`New Deaths`) kasus_kematian, sum(`New Recovered`) kasus_pemulihan
-- sum(`New Cases`)-(sum(`New Deaths`) + sum(`New Recovered`)) as rawat_jalan
from covid
where location != "Indonesia"
group by DATE_FORMAT(date, '%Y-%m')
order by bulan_tahun; 

-- merubah tipedata date varchar ke datetime

alter table covid modify column date date;

-- UPDATE covid SET date = STR_TO_DATE(date, '%m/%d/%Y');

select * from covid;

/*
 * Tanggal berapa total kasus Covid-19 di Indonesia mencapai 30.000 kasus?
 */
select date, sum(`New Cases`)
from covid
where location != "Indonesia"
group by 1
having sum(`New Cases`) >= 30000
order by 1
limit 1;

/* Hitung jumlah data saat kasus covid mulai menyentuh 30.000 kasus
select date, count(`New Cases`) Jumlah_Data
from covid
where location != "Indonesia"
group by 1
having count(`New Cases`) <= 30000
order by 1;
*/

/*
 * Temukan total tingkat kematian kasus dan tingkat pemulihan 
 * kasus dari setiap kode iso lokasi dan urutkan berdasarkan nilai terendah
 */
select `Location ISO Code` kode_iso_lokasi, sum(`New Deaths`) total_kematian, sum(`New Recovered`) total_pemulihan
from covid
where `Location ISO Code` <> "IDN"
group by 1
order by 2,3;

/*Cari tanggal dengan angka sembuh tertinggi di Indonesia, 
 * tampilkan dengan nilainya
 */
select date as tanggal, MAX(`New Recovered`) as angka_sembuh_tertinggi
from covid
where Location != "Indonesia"
group by 1
order by 2 desc
limit 1;

/*Ambil 2 lokasi kode iso dengan jumlah kematian 
 * paling sedikit karena Covid-19
 */
select `Location ISO Code` Location_iso_code, sum(`New Deaths`) Total_kematian
from covid
where `Location ISO Code` != 'IDN'
group by 1
order by 2
limit 2;

/*
 * ambil seluruh provinsi, kasus covid dan populasi
 */
select Province, sum(`New Cases`) kasus_covid, max(Population) populasi  
from covid
where Province <> ""
group by Province 
order by 2 desc;

/*	
 * max recovered by provice
 */
select province, max(`New Recovered`) Pemulihan
from covid
where Province <> ""
group by Province
order by 2 desc;

/*	
 * kematian paling sedikit dari province
 */

select Province, max(`New Deaths`) kematian
from covid 
where province <> ""
group by 1
order by 2;








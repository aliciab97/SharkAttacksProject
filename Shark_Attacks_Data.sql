-- Looking for where Shark Attacks Happen
Select country, area, location
From Shark_Attacks..attacks$
where country is not null
	and area is not null
	and location is not null
	and year between 1917 and 2017
	

--Data for Sex vs Provocation
with cte as(
Select 

cast(count(case when type = 'Provoked' AND sex = 'M' then 1 end)as float)  as MaleProvoked ,
cast(count(case when type = 'Unprovoked' and sex = 'M' then 1 end)as float) as MaleUnprovoked,

cast(count(case when type = 'Provoked' AND sex = 'F' then 1 end)as float) as FemaleProvoked ,
cast(count(case when type = 'Unprovoked' and sex = 'F' then 1 end)as float) as FemaleUnprovoked,

count(sex) as attacks

from Shark_Attacks..attacks$
where year between 1917 and 2017 and type is not null and sex is not null

)

Select  (MaleProvoked/attacks)*100 as MaleAttacksProvoked, (MaleUnprovoked/attacks)*100 as MalesUnprovoked, 
(FemaleProvoked/attacks)*100 as FemalesProvoked, (FemaleUnprovoked/attacks)*100 as FemalesUnprovoked
From cte


-- attacks per year
Select year, count(year) as attacks_per_year
From Shark_Attacks..attacks$
where year between 1917 and 2017
group by year
order by 1,2
	

-- fatal vs age
select age, [Fatal (Y/N)]
from Shark_Attacks..attacks$
where year between 1917 and 2017 
and age is not null
and [Fatal (Y/N)] is not null
order by 1,2


-- rate of change throughout the years

with cte as(
select year,
count(type) as attacks_per_year 

from Shark_Attacks..attacks$
where year between 1917 and 2017
and year is not null 
and type is not null

group by year
)
select year, attacks_per_year,
(attacks_per_year - LAG(attacks_per_year,1) OVER (order by YEAR(year)))/
	NULLIF(LAG(attacks_per_year,1) OVER (order by YEAR(year)),0) as rate_of_change

from cte
order by 1,2

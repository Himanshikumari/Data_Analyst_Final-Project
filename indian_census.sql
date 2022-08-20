select * from indian_census.district_table;
-- select * from indian_census.litracy;
select * from indian_census.litracy1;
-- total no of rows in each dataset
select count(*) from indian_census.district_table;
select count(*) from indian_census.litracy1;
-- dataset for jhakhand and bihar
select * from indian_census.district_table
where state in("Jharkahnd","Bihar");

-- Population of india
select sum(population) from indian_census.litracy1;

-- average growth of india
select round(avg(Growth),0) as avg_Growth from indian_census.district_table;

-- average growth of india statewise
select state,round(avg(Growth),0) as avg_Growth from indian_census.district_table group by state;

-- average sex ratio
select round(avg(Sex_ratio),0) as avg_sexratio from indian_census.district_table;

-- average sex ratio statewise
select state,round(avg(Sex_ratio),0) as avg_sexratio from indian_census.district_table group by state;

-- average literacy rate
select state,round(avg(literacy),0) as avg_literacy from indian_census.district_table group by state;

-- average literacy rate >80
select state,round(avg(literacy),0) as avg_literacy from indian_census.district_table 
group by state having avg_literacy>80 order by avg_literacy ;

-- top 3 state having highest growth rate
select state,round(avg(Growth),0) as avg_Growth from indian_census.district_table group by state order by avg_Growth desc limit 3;

-- last 3 state having lowest growth rate
select state,round(avg(Growth),0) as avg_Growth from indian_census.district_table group by state order by avg_Growth asc limit 3;

-- top and bottom 3 states in literacy rate
drop table if exists Topstates;
create table Topstates
( state varchar(255),
  topstate float
);
insert into Topstates 
select state,round(avg(literacy),0) as avg_literacy from indian_census.district_table group by state order by avg_literacy desc limit 3;
select * from Topstates;
drop table if exists Bottomstates;
create table Bottomstates
( state varchar(255),
  bottomstate float
);
insert into bottomstates 
select state,round(avg(literacy),0) as avg_literacy from indian_census.district_table group by state order by avg_literacy asc limit 3;
select * from Bottomstates;
-- union operator
select * from Topstates
union
select * from Bottomstates;

-- state starting with "a"
select state from indian_census.district_table where lower(state) like "a%";

-- state starting with "a" or "u"
select state from indian_census.district_table where lower(state) like "a%" or lower(state) like "b%"; 

-- joining both table
select d.District,d.State,d.Population,d.Sex_ratio from indian_census.district_table as d inner join indian_census.litracy1 as l
on d.District=l.District;

/* females/males=sex_ratio---1
females+males=Population...2
femlaes=population-males....3
(sex_ratio)*males=Population-males
Population=males(Sex_ratio+1)
Population/(Sex_ratio+1)=males
population-(Population/(Sex_ratio+1))=females
population(1-1/(Sex_ratio))=Females
Population((Sex_ratio-1)/Sex_ratio)=females
*/
-- No of males and females
select e.District, e.State, e.Population/(e.Sex_ratio+1) as Male, e.Population*((e.Sex_ratio-1)/e.Sex_ratio) as Female
from (select d.District,d.State,d.Population,d.Sex_ratio/1000 as Sex_ratio from indian_census.district_table as d inner join indian_census.litracy1 as l
on d.District=l.District) as e;

select d.District,d.State,round(d.Population/(d.Sex_ratio+1),0) as Male,round(d.Population*((d.Sex_ratio-1)/d.Sex_ratio),0) as Female
from indian_census.district_table as d inner join indian_census.litracy1 as l on d.District=l.District;

select d.Population from indian_census.district_table as d;

select f.state,sum(f.Male) As Total_Male,sum(f.Female) as Total_female from
(select e.District, e.State, round(e.Population/(e.Sex_ratio+1),0) as Male, round(e.Population*((e.Sex_ratio+1)/e.Sex_ratio),0) as Female
from (select d.District,d.State,d.Population,d.Sex_ratio/1000 as Sex_ratio from indian_census.district_table as d inner join indian_census.litracy1 as l
on d.District=l.District) as e) as f
group by f.state order by f.state ;

-- Total literacy rate
/* Total_literate people/population=literacy_ratio
total_literate_people=populaton*Literacy_ratio*/
select d.District,d.State,d.Population,d.Literacy/100  as literacy_ratio from indian_census.district_table as d inner join indian_census.litracy1 as l
on d.District=l.District;

select m.state,m.District,round(m.literacy_ratio*m.Population,0) as literate_people, round((1-m.literacy_ratio)*m.Population,0) as illtearte_people from
(select d.District,d.State,d.Population,d.Literacy/100  as literacy_ratio from indian_census.district_table as d inner join indian_census.litracy1 as l
on d.District=l.District) as m;

select n.State,n.District, sum(literate_people) as literate_people , sum(illtearte_people) as illtearte_people from
(select m.state,m.District,round(m.literacy_ratio*m.Population,0) as literate_people, 
round((1-m.literacy_ratio)*m.Population,0) as illtearte_people from
(select d.District,d.State,d.Population,d.Literacy/100  as literacy_ratio from indian_census.district_table as d inner join indian_census.litracy1 as l
on d.District=l.District) as m) as n group by n.State;


-- Population in previous census
select d.District,d.State,d.Growth  from indian_census.district_table as d inner join indian_census.litracy1 as l
on d.District=l.District;
/* populatin=previous_census+growth*previous_census
previous_census=population/(1+growth)*/

select h.District,h.state,h.Population/(1+h.Growth) as PreviousCensus_Population, h.Population as Current_population from
(select d.District,d.State,d.Growth,d.Population from indian_census.district_table as d inner join indian_census.litracy1 as l
on d.District=l.District) as h;

select h.District,h.state,h.Population/(1+h.Growth) as PreviousCensus_Population, h.Population as Current_population from
(select d.District,d.State,d.Growth/1000 as Growth,d.Population from indian_census.litracy1 as l inner join indian_census.district_table as d 
on l.District=d.District) as h;







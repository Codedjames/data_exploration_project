-- creating a database
create database data_exploration_project

--- creating a schema
create schema my_schema

-- create covid death table
create table my_schema.covid_deaths
(iso_code varchar, continent varchar,location varchar,date date, population bigint,total_cases int,
 new_cases int,new_cases_smoothed decimal,total_deaths int,new_deaths int,
 new_deaths_smoothed decimal,total_cases_per_million decimal,new_cases_per_million decimal,
 new_cases_smoothed_per_million decimal, total_deaths_per_million decimal,
 new_deaths_per_million decimal,new_deaths_smoothed_per_million decimal,
 reproduction_rate decimal,icu_patients int,icu_patients_per_million decimal,
 hosp_patients int,hosp_patients_per_million decimal,weekly_icu_admissions int,
 weekly_icu_admissions_per_million decimal,weekly_hosp_admissions int,
 weekly_hosp_admissions_per_million decimal)
 
-- view covid_deaths table
select * from my_schema.covid_deaths
 
-- import data into covid_deaths table
copy my_schema.covid_deaths
from 'C:\Users\Public\Covid_deaths.csv'
delimiter ',' csv header

-- create covid vaccination table
create table my_schema.covid_vaccinations
(iso_code varchar, continent varchar, location varchar, date date,
 total_tests bigint, new_tests bigint, total_tests_per_thousand decimal,
 new_tests_per_thousand decimal, new_tests_smoothed bigint,	
 new_tests_smoothed_per_thousand decimal, positive_rate decimal, tests_per_case decimal, 
 tests_units varchar, total_vaccinations bigint, people_vaccinated bigint,
 people_fully_vaccinated bigint, total_boosters bigint, new_vaccinations bigint,
 new_vaccinations_smoothed bigint, total_vaccinations_per_hundred decimal, people_vaccinated_per_hundred decimal,
 people_fully_vaccinated_per_hundred decimal, total_boosters_per_hundred decimal, new_vaccinations_smoothed_per_million	bigint,
 new_people_vaccinated_smoothed	bigint, new_people_vaccinated_smoothed_per_hundred	decimal, 
 stringency_index decimal, population_density decimal, median_age decimal, aged_65_older decimal, aged_70_older decimal,
 gdp_per_capita decimal, extreme_poverty decimal, cardiovasc_death_rate	decimal, diabetes_prevalence decimal, 	female_smokers decimal,	male_smokers decimal,
 handwashing_facilities decimal, hospital_beds_per_thousand	decimal, life_expectancy decimal, human_development_index decimal,
 excess_mortality_cumulative_absolute decimal, excess_mortality_cumulative decimal,	excess_mortality decimal,
 excess_mortality_cumulative_per_million decimal)
 
 drop table my_schema.covid_vaccinations 
 
 -- view covid vaccination table
 select *
 from my_schema.covid_vaccinations
 
 -- import data into covid_vaccinations table
copy my_schema.covid_vaccinations
from 'C:\Users\Public\Covid_vaccinations.csv'
delimiter ',' csv header


-- Selecting the data I'll be using
select Location, date, total_cases, new_cases, total_deaths, population
from my_schema.covid_deaths
order by 1,2 

-- I will be exploring the total cases vs total deaths
-- This shows the likelihood of dying if you're in a covid country
Select Location, date, total_cases,total_deaths,
case when total_cases = 0 THEN 0
else (total_deaths / total_cases) * 100
end as DeathPercentage
From my_schema.covid_deaths
order by 1,2

-- This shows the possibility of dying in Nigeria
Select Location, date, total_cases,total_deaths, total_deaths/total_cases as DeathPercentage
From my_schema.covid_deaths
Where location like 'Nigeria'
order by 1, 2

-- select (total_deaths/total_cases) 
-- From my_schema.covid_deaths
-- Where location like 'Nigeria'

SELECT Location, date, total_cases, total_deaths,
       (total_deaths / CAST(total_cases AS FLOAT)) * 100 AS DeathPercentage
FROM my_schema.covid_deaths
where location like 'Nigeria'
ORDER BY 1, 2;

-- Total cases vs Population 
-- This shows the percentage of the population infected with Covid
Select Location, date, Population, total_cases,  (cast(total_cases as float)/population)*100 as PercentPopulationInfected
FROM my_schema.covid_deaths
where location like 'Nigeria'
order by 1,2

-- countries with the highest infection rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((cast(total_cases as float)/population))*100 as PercentPopulationInfected
From my_schema.covid_deaths
--where location like 'Nigeria'
Group by Location, Population
order by PercentPopulationInfected desc

-- countries with the highest death count by population
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From my_schema.covid_deaths
Group by location
order by TotalDeathCount desc

-- countinents with the highest death count by population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From my_schema.covid_deaths
Group by continent
order by TotalDeathCount desc

--- Total population vs vaccinations
--- join the two tables
select * 
from my_schema.covid_deaths as dea
join my_schema.covid_vaccinations as vac
on dea.location = vac.location
and dea.date = vac.date 
order by 1,2 

-- displaying only the relevant data:
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from my_schema.covid_deaths as dea
join my_schema.covid_vaccinations as vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
order by 2,3





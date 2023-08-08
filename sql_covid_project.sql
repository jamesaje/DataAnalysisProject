select *
from coviddeaths;

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by location, date;

select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%states%'
order by location, date;

-- likelihood of dying if you contract covid in Nigeria
select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%Nigeria%'
order by location, date;

-- Looking at Total cases vs population
-- percentage of population that got Covid

select location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
from coviddeaths
-- where location like '%Nigeria%'
order by location, date;

-- What countries have highest infection compared to population
select location, population, MAX(total_cases) as HightestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
from coviddeaths
group by location, population
order by PercentagePopulationInfected DESC;

-- countries with hightest death count per population
select location, MAX(CAST(total_deaths AS unsigned integer)) as TotalDeathCount
from coviddeaths
where continent <> '0'
group by location
order by TotalDeathCount desc;

-- breaking down by location
select location, MAX(CAST(total_deaths AS unsigned integer)) as TotalDeathCount
from coviddeaths
where continent = '0'
group by location
order by TotalDeathCount DESC;

-- break down by continent
select continent, MAX(CAST(total_deaths AS unsigned integer)) as TotalDeathCount
from coviddeaths
where continent <> '0'
group by continent
order by TotalDeathCount DESC;

-- Global numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as unsigned integer)) as total_deaths,
	sum(cast(new_deaths as unsigned integer))/sum(new_cases)*100 as DeathPercentage
from coviddeaths
where continent <> '0'
-- group by date
order by date, total_cases;

-- Total population compared with vaccinations
use covid;

select * from covidvaccinations;

select * from coviddeaths d
join covidvaccinations v
on d.location = v.location
and d.date = v.date;


select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(cast(v.new_vaccinations as unsigned integer)) over (partition by d.location order by d.location, d.date)
as RollingPeopleVaccinated
from coviddeaths d 
join covidvaccinations v on d.location = v.location
and d.date = v.date
where d.continent <> ''
order by d.location, d.date;

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(cast(v.new_vaccinations as unsigned integer)) over (partition by d.location order by d.location, d.date)
as RollingPeopleVaccinated
from coviddeaths d 
join covidvaccinations v on d.location = v.location
and d.date = v.date
where d.continent <> ''
-- order by d.location, d.date;
)
Select * , (RollingPeopleVaccinated/Population)*100 from PopvsVac

-- TEMP TABLE

CREATE TABLE PercentPopulationVaccinated (
	Continent varchar(255) DEFAULT NULL,
	Location varchar(255) DEFAULT NULL,
	Date datetime DEFAULT NULL,
	Population double DEFAULT NULL,
	New_vaccinations double DEFAULT NULL,
	RollingPeopleVaccinated double DEFAULT NULL
);




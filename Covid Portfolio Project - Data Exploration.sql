Select *
from [Portfolio Project]..CovidDeaths
order by 3,4

--Select *
--from [Portfolio Project]..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at Total cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
order by 1,2


-- Looking at Countries with Highest infection rate compared to the population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Group by location, population
order by 4 Desc

-- Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
order by 2 Desc


-- Let's break things down by Continent


-- Showing continents with highest death count per Population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by 2 Desc


-- Global Numbers

Select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
-- Where location like '%states%'
where continent is not null
--group by date
order by 1,2


-- Looking at total population vs Vaccinations

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date , dea.population, Convert(int, vac.new_vaccinations) as new_vaccinations, 
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location AND dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac
order by 2,3


-- TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date , dea.population, Convert(int, vac.new_vaccinations) as new_vaccinations, 
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location AND dea.date = vac.date
--where dea.continent is not null
--Order by 2,3


Select *, (RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated
from #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date , dea.population, Convert(int, vac.new_vaccinations) as new_vaccinations, 
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
on dea.location = vac.location AND dea.date = vac.date
where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated
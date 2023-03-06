Select *
from PortfolioProject..CovidDeaths
order by 3,4

Select *
from PortfolioProject..CovidVaccinations
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%Kingdom%'
order by 1,2

-- Total Cases vs Population

Select location, date, population, total_cases,(total_cases/population)*100 as PerecntPopulationInfected
from PortfolioProject..CovidDeaths
where location like '%Kingdom%'
order by 1,2

-- Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PerecntPopulationInfected
from PortfolioProject..CovidDeaths
Group by location, population
order by PerecntPopulationInfected desc

-- Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

--Continents

--Continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

 -- Global Numbers

Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Join Two Tables

Select * 
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date

-- Total Population vs Vaccination

--USE CTE

with PopvsVac (Continent, Location, Date, Population, new_Vaccinations, RolllingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RolllingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)

Select *, (RolllingPeopleVaccinated/Population)*100 as PercentPopulatedVaccinated
from PopvsVac

-- Creating View to store data for later visualizations

Create View PercentPopulatedVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RolllingPeopleVaccinated
-- , (RolllingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
-- order by 2,3

Select *
from PercentPopulatedVaccinated

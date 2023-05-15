Select *
From [Portfolio Project]..CovidDeaths
where continent is not null
order by 1,2


--Select *
--From [Portfolio Project]..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
order by 1,2

--Total Cases vs Total Deaths
--Select Location, date, total_cases, total_deaths,
--((cast(total_deaths as bigint))/(cast(total_cases as bigint)))*100 as DeathPercentage
--From [Portfolio Project]..CovidDeaths
--Where location like '%Asia%'
--order by 1,2

--Total Cases vs Total Deaths
Select Location, date, total_cases,total_deaths,
(cast(total_deaths as decimal))/(cast(total_cases as decimal))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%Bangladesh%'
order by 1,2

--Total Cases vs Population
--Shows what percentage of population got Covid

Select Location, date,population, total_cases,
(cast(total_cases as decimal))/(cast(population as decimal))*100 as  PercentGotCovid
From [Portfolio Project]..CovidDeaths
Where location like '%Bangladesh%'
order by 1,2

--Countries with Highest Infection Rate compared to population

Select Location,population, MAX(cast (total_cases as decimal)) as HighestInfectionCount,
Max((cast(total_cases as decimal))/(cast(population as decimal)))*100 as PercentGotCovid
From [Portfolio Project]..CovidDeaths
--Where location like '%Bangladesh%'
Group by Location, population
order by PercentGotCovid desc



--Countries with highest Death Count Per population

Select Location, MAX(cast (total_deaths as decimal)) as TotalDeathCount
--,Max((cast(total_cases as decimal))/(cast(population as decimal)))*100 as PercentGotCovid
From [Portfolio Project]..CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc


--Data by Continent

Select location, MAX(cast (total_deaths as decimal)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is null
Group by location
order by TotalDeathCount desc


--Continent with highest death Count

Select continent, MAX(cast (total_deaths as decimal)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers

Select --date,
SUM(new_cases) as total_cases, SUM(cast (new_deaths as decimal)) as total_deaths,
(SUM(cast (new_deaths as decimal)))/(SUM(new_cases))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
--Where location like '%Bangladesh%'
where continent is not null
--Group by date
order by 1,2


--Looking at Tatal Population vs Vaccinations

--Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
--SUM(convert(decimal, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.Date) as PeopleVaccinatingSum,
--(PeopleVaccinatingSum/population)
--From [Portfolio Project]..CovidDeaths dea
--Join [Portfolio Project]..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


--USE CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, PeopleVaccinatingSum)
as
(
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(convert(decimal, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.Date) as PeopleVaccinatingSum
--(PeopleVaccinatingSum/population)
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select * , (PeopleVaccinatingSum/population)*100
From PopvsVac



--Maximum Vaccintation
--With MaxNumb (continent, location, population, new_vaccinations, PeopleVaccinatingSum)
--as
--(
--Select dea.continent, dea.location, dea.population, vac.new_vaccinations,
--SUM(convert(decimal, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location) as PeopleVaccinatingSum
----(PeopleVaccinatingSum/population)
--From [Portfolio Project]..CovidDeaths dea
--Join [Portfolio Project]..CovidVaccinations vac
--	On dea.location = vac.location
--where dea.continent is not null
----order by 2,3
--)
--Select * , (PeopleVaccinatingSum/population)*100
--From MaxNumb


--Temp Table
Drop table if exists #Percent_Population_vac
Create Table #Percent_Population_vac
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	PeopleVaccinatingSum numeric
)

Insert into #Percent_Population_vac
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(convert(decimal, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.Date) as PeopleVaccinatingSum
--(PeopleVaccinatingSum/population)
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * , (PeopleVaccinatingSum/population)*100
From #Percent_Population_vac




----------------Creating VIEW to Store data for visualization-------------------------
----Temp Table
Create view Percent_Population_vac as
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(convert(decimal, vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.Date) as PeopleVaccinatingSum
--(PeopleVaccinatingSum/population)
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

--Continent with highest death Count
Create view TotalDeathCount as
Select continent, MAX(cast (total_deaths as decimal)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
where continent is not null
Group by continent
--order by TotalDeathCount desc

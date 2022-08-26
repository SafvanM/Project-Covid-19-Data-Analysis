--SELECT * FROM ProjectCovid19..CovidDeaths
--order by 3,4

--SELECT * FROM ProjectCovid19..CovidVaccinations
--order by 3,4

--Data that are we going to use 

--select Location,date, total_cases, new_cases, total_deaths, population
--from ProjectCovid19..CovidDeaths
--order by 1,2

-- looking at total cases vs total deaths 

--select Location,date, total_cases, total_deaths,(total_deaths/total_cases)* 100 as DeathPercentage 
--from ProjectCovid19..CovidDeaths
--where Location like '%states%'
--order by 1,2

-- Looking at the total_cases vs population 
-- Shows what percentage of people got covid-19 

--select Location,date, total_cases, population,(total_cases/population)* 100 as DeathPercentage
--from ProjectCovid19..CovidDeaths
----where Location like '%states%'
--order by 1,2 

-- Looking at countries with highest infection rate compared to population 

--select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 as PercentPopulationInfected
--from ProjectCovid19..CovidDeaths
--Group by location, population
--order by 1,2   

--Show ing countries with hihgest death count per population 

--showing the continent with the highest death count per popultion 

--select continent, MAX(cast(Total_deaths as int )) as Total_deaths 
--from ProjectCovid19..CovidDeaths
--where continent is not null
--Group by continent
--order by Total_deaths desc


-- GLOBAL numbers 

--select date, SUM(new_cases )--, total_deaths,(total_deaths/total_cases)* 100 as DeathPercentage 
--from ProjectCovid19..CovidDeaths
--where continent is not null
--group by date 
--order by 1,2

-- Covide vaccinations 


--Looking at total popultion vs vaccinations 
--select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
--Sum(convert( int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccination,
--(RollingPeopleVaccination/dea.population)	
--from ProjectCovid19..CovidDeaths dea
--join ProjectCovid19..CovidVaccinations vac 
--on dea.location = vac.location 
--and dea.date = vac.date 
--where dea.continent is not null and vac.new_vaccinations is not null
--order by  2,3

--Use CTE

--with PopvsVac (continent, location, date, population, new_vaccinations,RollingPeopleVaccination)
--as
--(
--select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
--Sum(convert( int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccination
----(RollingPeopleVaccination/dea.population)*100
--from ProjectCovid19..CovidDeaths dea
--join ProjectCovid19..CovidVaccinations vac 
--on dea.location = vac.location 
--and dea.date = vac.date 
--where dea.continent is not null and vac.new_vaccinations is not null
----order by  2,3
--)
--select *, (RollingPeopleVaccination/population)*100 as PercentageR
--from PopvsVac



--Temp Table 


Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccination numeric
)

Insert into #PercentPopulationVaccinated
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
Sum(convert( int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccination
--(RollingPeopleVaccination/dea.population)*100
from ProjectCovid19..CovidDeaths dea
join ProjectCovid19..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date 
--where dea.continent is not null and vac.new_vaccinations is not null
--order by  2,3
select *, (RollingPeopleVaccination/population)*100 as PercentageR
from #PercentPopulationVaccinated


-- Creating view to store data for later Visualizations

create view PercentPopulationVaccinations as 
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
Sum(convert( int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccination
--(RollingPeopleVaccination/dea.population)*100
from ProjectCovid19..CovidDeaths dea
join ProjectCovid19..CovidVaccinations vac 
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null and vac.new_vaccinations is not null
--order by  2,3

select * from PercentPopulationVaccinations
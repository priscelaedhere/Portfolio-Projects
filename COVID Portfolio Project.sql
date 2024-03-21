select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4;

select location, date, population, total_cases, new_cases, total_deaths
from PortfolioProject..CovidDeathsp
where continent is not null
order by 1,2;

select location, date, population, total_cases, total_deaths, (cast(total_deaths as float)/nullif(cast(total_cases as float) ,0))* 100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2;

select location, date, population, total_cases, (cast(total_cases as float)/nullif(cast(population as float) ,0))* 100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2;

select location, population, max(total_cases) as HighestInfectionCount, max(cast(total_cases as float)/nullif(cast(population as float) ,0))* 100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location,population
order by PercentagePopulationInfected desc;

select location, max(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc;


select continent, max(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc;

Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))*100.0/nullif(sum(new_cases),0) as DeathPercent
From PortfolioProject..CovidDeaths 
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2;

select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3;

select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3;


with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
	select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/nullif(cast(Population as float),0))*100.0
From PopvsVac;


DROP Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population bigint,
New_vaccinations bigint,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3;

Select *, (RollingPeopleVaccinated/nullif(cast(Population as float),0))*100.0
From #PercentPopulationVaccinated

create view PercentPopVaccinated as
select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccinations)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3;

select *
from PercentPopVaccinated





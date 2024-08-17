/*

THIS QUERY FILE IS MY GENERAL DATA EXPLORATIONS ON THE DATASET--COVID DEATHS AND COVID VACCINATIONS

WILL BE EXPLAINING EACH STEP AS WE MOVE FORWARD

*/

--WILL GET TO KNOW THE DATA FIRST 


SELECT * 
FROM [Portfolio Project]..['Covid Deaths']

--STUDY THE DATA TO FIND OUT WHAT THE DATA CONSISTS OF 
/*
IT BASICALLY CONSISTS CONTINENT , COUNTRYWISE AND DATEWISE LIST OF TABLE AND RESPECTIVE DATA 
OF NEW DEATHS AND NEW CASES

THE TOTAL CASES/DEATHS ARE JUST A CUMULATIVE VALUES OF NEW DEATHS AND NEW CASES

POPULTAION CONSISTS OF TOTAL POP OF THTA COUNTRY AS OF LAST UPDATED DATASET

COLUMNS FROM REPRODUCCTION RATE TILL LAST DO NOT HAVE MUCH DATA IT SEEMS WILL HAVE TO FILTER IT OUT THEN
*/

--WE CAN FURTHER FIND BASIC EXPLORATIONS CASES
--LIKE USING CONTINENT/ COUNTRY/ POPULATION WISE
--ALSO CAN BE DONE DATE WISE

/* LETS CHECK THE DATA DATE WISE */

SELECT *
from [Portfolio Project]..['Covid Deaths'] as cd
order by cd.date

-- data from 1-1-2020 to 4-4-2024 4 year data

--we can see that the continents contain some null data
--we may miss some data in future so lets filter continent to understand the null dataset

select continent, location
from [Portfolio Project].dbo.['Covid Deaths']
where continent is null
group by continent, location

--so we can find the data related to specific continents by using (where location ='ContinentName')
--so we can find the data related to specific income class by using (where location ='IncomeClass')
--also others like world, or unions like European union

--just checking the continent where it is not null
select continent, location
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null
group by continent, location
order by 1

--so we are good to go explore the real data now after finding the dataset nullities

SELECT * 
FROM [Portfolio Project]..['Covid Deaths']
where continent is not null

--1) HIGHEST NUMBER OF NEW CASES COUNTRY WISE--CHINA

--taking in considerations that continent include data which we dont want it this query

SELECT  location, max(new_cases) as HighestCasesCountryWise
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null
group by location
order by HighestCasesCountryWise DESC

--2) HIGHEST NUMBER OF NEW CASES CONTINENT WISE--ASIA

SELECT  continent, max(new_cases) as HighestCasesContinentWise
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null
group by continent
order by HighestCasesContinentWise DESC

--3) HIGHEST NUMBER OF NEW DEATHS COUNTRY WISE--

SELECT  location, max(new_deaths) as HighestDeathsCountryWise
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null
group by location
order by HighestDeathsCountryWise DESC

--4) HIGHEST NUMBER OF NEW DEATHS CONTINENT WISE--ASIA

SELECT  continent, max(new_deaths) as HighestDeathsContinentWise
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null
group by continent
order by HighestDeathsContinentWise DESC

--LETS CHECK SOME DATA DATE WISE

--5)DATE WHEN HIGHEST CASES WERE RECORDED IN THE WORLD--2022-12-25 00:00:00.000

--SINCE AGGREGATE FUNCTIONS NEED TO CONDITIONED FURTHER NEED TO USE HAVING CLAUSE

SELECT date, max(new_cases) as NewCasesPerDay
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null 
group by date
HAVING max(new_cases) <> 0
ORDER BY 2 DESC

--6)DATE WHEN HIGHEST CASES WERE RECORDED IN THE WORLD FILTERED BY COUNTRY-- CHINA --2022-12-25 00:00:00.000

SELECT date, location, max(new_cases) as NewCasesPerDay
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null 
group by date, location
HAVING max(new_cases) <> 0
ORDER BY 3 DESC

--7)DATE WHEN HIGHEST DEATHS WERE RECORDED IN THE WORLD FILTERED BY COUNTRY-- CHINA --2023-02-05 00:00:00.000

SELECT date, location, max(new_deaths) as NewDeathsPerDay
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null 
group by date, location
HAVING max(new_deaths) <> 0
ORDER BY 3 DESC

--lets find the new deaths and new cases for the continent having null 

--8)
select continent, location, max(new_cases) AS HighestCases, MAX(new_deaths) AS HighestDeaths 
from [Portfolio Project].dbo.['Covid Deaths']
where continent is null and location <> 'World'
group by continent, location
order by 4 desc


--lets work with the numbers now 

--lets find out the HIghest % of death to cases
--9)

select continent, location, max(new_cases) AS HighestCases, MAX(new_deaths) AS HighestDeaths ,
max(cast(new_deaths as float))/max(cast(new_cases as float))*100 AS DeathPerCase
from [Portfolio Project].dbo.['Covid Deaths']
where continent is null and location <> 'World'
group by continent, location
order by 5 desc

select * from [Portfolio Project].dbo.['Covid Deaths']

--10)HIGHEST Case percentage per population and Death percentage per population Country wise 


select 
	continent,
	location,
	population,
	max(new_cases) AS HighestCases,
	max(new_deaths) AS HighestDeaths,
	max(cast(new_cases as int))/max(population)*100 AS HighestCasesPerPopulation,
	max(cast(new_deaths as int))/max(population)*100 AS HighestDeathPerPopulation
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null
group by continent,location, population
order by 7 desc

select * from [Portfolio Project].dbo.['Covid Deaths']

--11)Highest Case percentage per population and Death percentage per populationspecifically for India

select 
	continent,
	location,
	max(new_cases) AS HighestCases,
	max(new_deaths) AS HighestDeaths,
	max(cast(new_cases as int))/max(population)*100 AS HighestCasesPerPopulation,
	max(cast(new_deaths as int))/max(population)*100 AS HighestDeathPerPopulation
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null 
	AND	location ='India'
group by continent,location, population
order by 6 desc

---12)Case percentage per population and Death percentage per populationspecifically for India all days

select 
	date,
	continent,
	location,
	new_cases AS HighestCases,
	new_deaths AS HighestDeaths,
	(cast(new_cases as int)/population)*100 AS HighestCasesPerPopulation,
	(cast(new_deaths as int)/population)*100 AS HighestDeathPerPopulation
from [Portfolio Project].dbo.['Covid Deaths']
where continent is not null 
	AND	location ='India'
order by 6 desc

--13)List of Total Icu Patient locations wise side by the actual location and icu_patients 
	--and date for the actual count of icu_patients

select date,location, icu_patients, SUM(cast(icu_patients as bigint)) over (partition by location) AS Total_Icu_Patients
from [Portfolio Project].dbo.['Covid Deaths']
where icu_patients is not null and continent is not null
order by Total_Icu_Patients DESC--cast(icu_patients as int) DESC


---lets delve in the covid vaccination database to explore more

select * from [Portfolio Project].dbo.['Covid Vaccination']

--can see similar type of data here to the previous one as in iso,date,locations, continent 
-- new data to be explored here is new_tests, people_vaccinated, people fully vaccinated , new_vaccinations

--For the sake of simplicity and productive utilizations of time lets do multiple things in a single query

--1)Exploring the Highest new tests--India, Highest postive rate--Mongolia

select 
	continent, location,
	date, new_tests, positive_rate,
	tests_units, people_vaccinated, 
	people_fully_vaccinated,
	max(cast(new_tests as bigint)) as Highest_Test_cases,
	max(positive_rate) as Highest_positive_rate	
from [Portfolio Project].dbo.['Covid Vaccination']
where continent is not null and --coalesce(new_tests, positive_rate, tests_units, people_vaccinated, people_fully_vaccinated) is not null
	new_tests is not null and
	positive_rate is not null and
	tests_units is not null and
	people_vaccinated is not null and 
	people_fully_vaccinated is not null
	group by continent,location, date, new_tests, positive_rate, tests_units, people_vaccinated, people_fully_vaccinated 
order by 
	Highest_Test_cases DESC
	--Highest_positive_rate DESC
	--Highest_Test_cases 
	--Highest_positive_rate



--select * from ['Covid Vaccination']

--2)Bifurcating the country (count) on the basis of tests_units

--(practice)
select 
	tests_units,
	count(distinct location) as Country_Count_perTest_units
from 
	[Portfolio Project]..['Covid Vaccination']
where 
	continent is not null
	and tests_units is not null
	and location in(
		select location --(location word is very important because location should contain only location query)
		from [Portfolio Project].dbo.['Covid Vaccination']
		where continent is not null
		and continent <> 'World'
	)
group by
	tests_units
order by
	1;


select 
	tests_units, 
	count(distinct location) as Countries_per_unit_tested  
from 
	[Portfolio Project].dbo.['Covid Vaccination']
where 
	continent is not null 
	and tests_units is not null 
	and location in (
		select location 
		from [Portfolio Project].dbo.['Covid Vaccination']
		where continent is not null 
		and continent <> 'World'
	)
group by 
	tests_units
order by
	1;

	---------alternative
--(this makes more sense because you dont want 
--locations with continent null and World)
SELECT 
    tests_units, 
    COUNT(DISTINCT location) as Countries_per_unit_tested
FROM 
    [Portfolio Project].dbo.['Covid Vaccination']
WHERE 
    continent IS NOT NULL 
    AND tests_units IS NOT NULL 
    AND location not IN (
        SELECT location 
        FROM [Portfolio Project].dbo.['Covid Vaccination']
        WHERE continent IS NULL OR continent = 'World'
    )
GROUP BY 
    tests_units
order by
	1;

-- We are getting a units unclear for test_units

--3)Which country are we getting this units unclear (case 2: keeping the existing columns same)??

--CASE 1-- country we are getting as units unclear

--chatgpt 3.0 way
WITH RankedUnits AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY tests_units ORDER BY location) AS RowNum
    FROM 
        [Portfolio Project].dbo.['Covid Vaccination']
    WHERE 
        tests_units = 'units unclear'
)
SELECT 
    location,
    tests_units
FROM 
    RankedUnits
WHERE
	RowNum = 1;



SELECT 
    location,
    tests_units
FROM 
    [Portfolio Project].dbo.['Covid Vaccination']
WHERE 
    tests_units = 'units unclear'
    AND location IN (
        SELECT 
            location
        FROM 
            [Portfolio Project].dbo.['Covid Vaccination']
        WHERE 
            tests_units = 'units unclear'
    );

--3)Which country are we getting this units unclear (case 2: keeping the existing columns same)??

--CASE 2-- country we are getting as units unclear 
--keeping the columns same

SELECT 
    tests_units,
    COUNT(DISTINCT location) AS Countries_per_unit_tested,
    CASE 
        WHEN tests_units = 'units unclear' THEN (
            SELECT DISTINCT location
            FROM [Portfolio Project].dbo.['Covid Vaccination'] AS sub
            WHERE sub.tests_units = main.tests_units
        )
    END AS Country_units_unclear
FROM 
    [Portfolio Project].dbo.['Covid Vaccination'] AS main
WHERE 
    continent IS NOT NULL 
    AND tests_units IS NOT NULL 
    AND location IN (
        SELECT location 
        FROM [Portfolio Project].dbo.['Covid Vaccination']
        WHERE continent IS NOT NULL AND continent <> 'World'
    )
GROUP BY 
    tests_units;



--4) Display the test units column with countries count + name of each country in the column next to it
--this can be done in 2 ways 

--i) USING 2 TEMP TABLES AND JOINING THEM LATER (least preferable just to 
--illustrate)

--since we have been using this table quite a lot lets create a temp table to 
--to do things a little quick

--FIRST TEMP TABLE CREATION INSERTION SELECTION 
SET ANSI_WARNINGS OFF;
DROP TABLE IF EXISTS #temp_testsunits
CREATE TABLE #temp_testsunits
(test_units nvarchar(255) null, 
Country_count_units int)
INSERT INTO #temp_testsunits
SELECT 
    tests_units, 
    COUNT(DISTINCT location) as Country_count_units
FROM 
    [Portfolio Project].dbo.['Covid Vaccination']
WHERE 
    continent IS NOT NULL 
    AND tests_units IS NOT NULL 
    AND location not IN (
        SELECT location 
        FROM [Portfolio Project].dbo.['Covid Vaccination']
        WHERE continent IS NULL OR continent = 'World'
    )
GROUP BY 
    tests_units
order by
	1;
SELECT * FROM #temp_testsunits;
SET ANSI_WARNINGS ON;

--SECOND TEMP TABLE CREATION INSERTION SELECTION 

SET ANSI_WARNINGS OFF;
DROP TABLE IF EXISTS #TEMP_testunits2;
CREATE TABLE #TEMP_testunits2(
test_units nvarchar(255) null,
location nvarchar(255) null);
insert into #TEMP_testunits2
SELECT 
	distinct tests_units,
	location
FROM	
	[Portfolio Project].dbo.['Covid Vaccination'] 
WHERE 
	tests_units IS NOT NULL and continent is 
	not null and continent<> 'World'
order by 
	1;
select * from #TEMP_testunits2;
SET ANSI_WARNINGS ON;

-- applying inner join to illustrate the inner join

SELECT one.test_units, two.location ,one.Country_count_units
FROM #temp_testsunits one
JOIN #TEMP_testunits2 two
	ON one.test_units = two.test_units
order by 1 ;

--4) Display the test units column with countries count + 
--name of each country in the column next to it

--this can be done in 2 ways 
--ii)USING SUBQUERY AND PARTION BY (PREFERABLE)

--how to do this shittt
select
	tests_units,
	location,
	count(location) over (partition by tests_units) as Country_count_units
from 
	[Portfolio Project].dbo.['Covid Vaccination'] 
where 
	continent is not null 
	and continent <> 'World' 
	and tests_units is not null
group by
	tests_units,
	location
order by 
	1;

--LETS WORK IN JOINING THE 2 MAIN TABLES AND LOOK INTO WHAT WE CAN FIND

SELECT * FROM [Portfolio Project]..['Covid Deaths']

SELECT * FROM [Portfolio Project]..['Covid Vaccination']

WITH Cjoin AS( 
SELECT * FROM [Portfolio Project]..['Covid Deaths'] DEA 
JOIN [Portfolio Project]..['Covid Vaccination'] VACC
	ON DEA.location = VACC.location 
		AND DEA.continent = VACC.continent 
			AND DEA.date = VACC.date 
				AND	DEA.iso_code = VACC.iso_code
)
SELECT 
	distinct(dea.location),
	vacc.median_age, 
	dea.population,
	max(cast(vacc.new_vaccinations as bigint)) OVER (PARTITION BY DEA.LOCATION) AS MAX_Vaccinations
FROM [Portfolio Project]..['Covid Deaths'] dea 
JOIN [Portfolio Project]..['Covid Vaccination'] VACC
	ON dea.location = VACC.location 
		AND dea.continent = VACC.continent 
			AND dea.date = VACC.date
				AND DEA.iso_code = VACC.iso_code
WHERE 
	dea.continent IS NOT NULL AND dea.continent <> 'World'
	and VACC.new_vaccinations IS NOT NULL and 
	VACC.aged_65_older IS NOT NULL	
--GROUP BY
--	distinct(dea.location),
--	vacc.median_age, 
--	dea.population
order by
	3 desc;



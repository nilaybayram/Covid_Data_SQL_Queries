SELECT
    *
FROM
    vaccination;

SELECT
    COUNT(1)
FROM
    vaccination;

SELECT
    *
FROM
    deaths;

--Total Cases vs. Total Deaths
--Likelihood of dying if you have covid in specic countries
SELECT
    location,
    incident_date,
    total_cases,
    total_deaths,
    round((total_deaths / total_cases) * 100, 3) AS death_percentage
FROM
    deaths
WHERE
    continent IS NOT NULL
ORDER BY
    location,
    incident_date;

--Total Cases vs Population
--Shows what percentage of population got Covid

SELECT
    location,
    incident_date,
    population,
    total_cases,
    total_deaths,
    round((total_cases / population) * 100, 3) AS case_rate
FROM
    deaths
WHERE
    continent IS NOT NULL
ORDER BY
    location,
    incident_date;

--Countries with Highest Infection Rate Compared to Population

SELECT
    location,
    population,
    MAX(total_cases)                                AS highest_infection_count,
    MAX(round((total_cases / population) * 100, 3)) AS infection_percentage
FROM
    deaths
WHERE
    continent IS NOT NULL
GROUP BY
    population,
    location
ORDER BY
    4 DESC;

--Total Deaths vs Population
--Countries With Highest Detah Rate

SELECT
    location,
    population,
    MAX(total_deaths),
    MAX(round(((total_deaths / population) * 100), 3)) AS highest_death_percentage
FROM
    deaths
WHERE
    continent IS NOT NULL
GROUP BY
    location,
    population
ORDER BY
    highest_death_percentage DESC;

--Continentally Breaking Down the Total Death Numbers

SELECT
    continent,
    MAX(total_deaths),
    MAX(round((total_deaths / population) * 100, 3)) AS highest_death_percentage
FROM
    deaths
WHERE
    continent IS NOT NULL
GROUP BY
    continent
ORDER BY
    3 DESC;

--Global Numbers


SELECT
    incident_date,
    SUM(new_cases)                             AS total_cases,
    SUM(new_deaths)                            AS total_deaths,
    round(SUM(new_deaths) / SUM(new_cases), 3) AS death_rate_daily
FROM
    deaths
WHERE
    new_cases > 0
GROUP BY
    incident_date
ORDER BY
    incident_date ASC;

SELECT
    *
FROM
    (
        SELECT
            incident_date,
            SUM(new_cases)                             AS total_cases,
            SUM(new_deaths)                            AS total_deaths,
            round(SUM(new_deaths) / SUM(new_cases), 3) AS death_rate_daily
        FROM
            deaths
        WHERE
            new_cases > 0
        GROUP BY
            incident_date
        ORDER BY
            death_rate_daily DESC
    )
WHERE
    ROWNUM <= 6;

--Total Population vs Vaccination 

SELECT
    deaths.location,
    MAX(deaths.population)                                                       AS population,
    SUM(vaccination.total_vaccinations)                                          AS vaccination,
    round(SUM(vaccination.total_vaccinations) / SUM(deaths.population) * 100, 3) AS vaccination_rate
FROM
         deaths
    JOIN vaccination ON deaths.location = vaccination.location
                        AND deaths.incident_date = vaccination.incident_date
WHERE
    vaccination.total_vaccinations IS NOT NULL
    AND deaths.population IS NOT NULL
GROUP BY
    deaths.location
ORDER BY
    4 DESC;
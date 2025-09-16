/*
 TASK:
 Testing out dataset by exploring times with abnormal amount of charges for an arrest
 */
--multi charge cases/duplicate arrest numbers
SELECT arrestnumber, COUNT(*) AS count
FROM "arrests"
GROUP BY arrestnumber
HAVING COUNT(*) > 17
ORDER BY COUNT(*) DESC
LIMIT 50;

-----------------------------------------------------
/*
 TASK:
 Exploring each jurisdiction's most common crime types

 Notes:
 - some crimecodes had overlapping descriptions causing incomplete results,
 like pet larceny
 - there was an additional jurisdiction ori: VA002023C
 - For ACPD, a lot of larceny, domestic abuse
 - For CPD, a lot of drunk in public, warrant service, domestic assault
 - For UPD, a lot of alcohol and trespassing as expected
 */
--comparing crimes by jurisdiction
SELECT
    CASE
        WHEN "ori" = 'VA1020000' THEN 'CPD'
        WHEN "ori" = 'VA0020300' THEN 'ACPD'
        WHEN "ori" = 'VA0020100' THEN 'UPD'
        ELSE "ori"
    END AS Jurisdiction,
    "description" AS "crime type",
    crimecode,
    COUNT(*) AS "arrest num"
FROM
    "arrests"
GROUP BY
    Jurisdiction,
    "crime type",
    crimecode
HAVING COUNT(*) > 50
ORDER BY
    Jurisdiction,
    "arrest num" DESC;

--------------------------------------------------
/*
 TASK:
 Grouping crime types that I found repetitive by common factor

 Notes:
 - One issue is that it groups misdemeanors with felonies
 */

--groups all arrests related to 'Larceny'
SELECT description, COUNT(*) AS Occurences
FROM arrests
WHERE description ILIKE '%Larceny%'
GROUP BY description
ORDER BY Occurences DESC;

--groups all arrests related to 'DUI'
SELECT description, COUNT(*) AS Occurences
FROM arrests
WHERE description ILIKE '%DUI%'
GROUP BY description
ORDER BY Occurences DESC;

--groups all arrests related to 'Warrant'
SELECT description, COUNT(*) AS Occurences
FROM arrests
WHERE description ILIKE '%Warrant%'
GROUP BY description
ORDER BY Occurences DESC;

--------------------------------------------------
/*
 Task:
 Exploring the demographic breakdown by changing previous code

 Notes:
 - If I had population sums of demographics, I could take percentages
 - Misdemeanor and Felony overlap
 - For Larceny, African American male nearly the same as white male
 - For DUI, predominantly white demographic
 - For Warrant, 1561 (White male) vs 1224 (African American male) so pretty close
 - For Assault, African American male was 200 less than White male, and African
 American female was 13 less than White female
 - For Drug, 3002 (White male) vs 1909 (African American male), and 783 vs 292 (female)

 */

--Sort by Larceny
SELECT race, sex, COUNT(*) AS NumberOfLarcenyArrests
FROM arrests
WHERE description ILIKE '%Larceny%'
AND race NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND sex NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND race IS NOT NULL AND race != ('')
AND sex IS NOT NULL AND sex != ('')
GROUP BY race, sex
ORDER BY NumberOfLarcenyArrests DESC;

--Sort by DUI
SELECT race, sex, COUNT(*) AS NumberOfDUIArrests
FROM arrests
WHERE description ILIKE '%DUI%'
AND race NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND sex NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND race IS NOT NULL AND race != ('')
AND sex IS NOT NULL AND sex != ('')
GROUP BY race, sex
ORDER BY NumberOfDUIArrests DESC;

--Sort by Warrant-related arrests
SELECT race, sex, COUNT(*) AS NumberOfWarrantArrests
FROM arrests
WHERE description ILIKE '%Warrant%'
AND race NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND sex NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND race IS NOT NULL AND race != ('')
AND sex IS NOT NULL AND sex != ('')
GROUP BY race, sex
ORDER BY NumberOfWarrantArrests DESC;

--Sort by Assault arrests
SELECT race, sex, COUNT(*) AS NumberOfAssaultArrests
FROM arrests
WHERE description ILIKE '%Assault%'
AND race NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND sex NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND race IS NOT NULL AND race != ('')
AND sex IS NOT NULL AND sex != ('')
GROUP BY race, sex
ORDER BY NumberOfAssaultArrests DESC;

--Sort by Drug arrests
SELECT race, sex, COUNT(*) AS NumberOfDrugArrests
FROM arrests
WHERE description ILIKE '%Drug%'
AND race NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND sex NOT IN ('Unknown', 'Microsoft Word', 'New World Text')
AND race IS NOT NULL AND race != ('')
AND sex IS NOT NULL AND sex != ('')
GROUP BY race, sex
ORDER BY NumberOfDrugArrests DESC;

--------------------------------------------------
/*
 Task:
 Exploring arrest report trends over time

 Notes:
 For total:
 - Highest in 2017 at 11556 by a considerable margin
 - Dipped and was the lowest in 2020 (probably due to Covid)
 - Increased and plateaued at ~6000 from 2022-24

 For by race:
 - When looking at proportions, the numbers are very consistent from 2017-2024
 - White proportions hovers from 55-57%; AA proportions hovers from 40-42%
 */

--Total arrest trend from 2017-2024
SELECT EXTRACT(YEAR FROM TO_DATE(arrestdatetime, 'DD-Mon-YY')) AS ArrestYear,
       COUNT(*) AS TotalArrests
FROM arrests
GROUP BY ArrestYear
ORDER BY ArrestYear;

--White vs AA arrest count from 2017-2024
SELECT EXTRACT(YEAR FROM TO_DATE(arrestdatetime, 'DD-Mon-YY')) AS ArrestYear,
       COUNT(CASE WHEN race = 'White' THEN 1 END) AS WhiteArrestCount,
       COUNT(CASE WHEN race = 'African American' THEN 1 END) AS AAArrestCount
FROM arrests
WHERE race IN ('White', 'African American')
GROUP BY ArrestYear
ORDER BY ArrestYear;

--White vs AA arrest count proportionate to total arrest count from 2017-2024
SELECT EXTRACT(YEAR FROM TO_DATE(arrestdatetime, 'DD-Mon-YY')) AS ArrestYear,
       ROUND((COUNT(CASE WHEN race = 'White' THEN 1 END)*1.0/COUNT(*)),3) AS "WhiteArrestProportion",
       ROUND((COUNT(CASE WHEN race = 'African American' THEN 1 END)*1.0/COUNT(*)),3) AS "AAArrestProportion"
FROM arrests
GROUP BY ArrestYear
ORDER BY ArrestYear;

--------------------------------------------------
--Extra:

--male vs female
SELECT sex, COUNT(CASE WHEN sex = 'Male' THEN 1 END) AS male, COUNT(CASE WHEN sex = 'Female' THEN 1 END) AS female
FROM arrests
WHERE sex IS NOT NULL AND sex != 'Unknown'
GROUP BY sex

--record of amount of reports with an unclassified race
SELECT
    CASE
        WHEN race IN ('Unknown', 'Microsoft Word', 'New World Text', '') OR race IS NULL
        THEN 'Unclassified'
        ELSE 'Classified'
    END AS RaceCategory,
    COUNT(*) AS NumberOfArrests
FROM
    "arrests"
GROUP BY
    RaceCategory;

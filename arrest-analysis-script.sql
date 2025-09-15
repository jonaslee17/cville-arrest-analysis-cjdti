/*
 TASK:
 Testing out dataset by exploring times with abnormal amount of charges for an arrest
 */
--multi charge cases/duplicate arrest numbers
SELECT arrestnumber, COUNT(*) AS count
FROM "arrests"
GROUP BY arrestnumber
HAVING COUNT(*) > 1
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

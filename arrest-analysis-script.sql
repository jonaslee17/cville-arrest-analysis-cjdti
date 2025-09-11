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
 - some descriptions had overlapping traits causing incomplete results
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
 */

--groups all arrests related to 'Larceny'
SELECT description, COUNT(*) AS Occurences
FROM arrests
WHERE description ILIKE '%Larceny%'
GROUP BY description
ORDER BY Occurences DESC

--groups all arrests related to 'DUI'
SELECT description, COUNT(*) AS Occurences
FROM arrests
WHERE description ILIKE '%DUI%'
GROUP BY description
ORDER BY Occurences DESC

--groups all arrests related to 'Warrant'
SELECT description, COUNT(*) AS Occurences
FROM arrests
WHERE description ILIKE '%Warrant%'
GROUP BY description
ORDER BY Occurences DESC


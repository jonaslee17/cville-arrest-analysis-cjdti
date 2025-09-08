--multi charge cases/duplicate arrest numbers
SELECT arrestnumber, COUNT(*) AS count
FROM arrests
GROUP BY arrestnumber
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
LIMIT 50;


--comparing crimes by jurisdiction
SELECT
    CASE
        WHEN "ori" = 'VA1020000' THEN 'CPD'
        WHEN "ori" = 'VA0020300' THEN 'ACPD'
        WHEN "ori" = 'VA0020100' THEN 'UPD'
        ELSE "ori"
    END AS Jurisdiction,
    "description" AS "crime type",
    COUNT(*) AS "arrest num"
FROM
    "arrests"
GROUP BY
    Jurisdiction,
    "crime type"
HAVING COUNT(*) > 50
ORDER BY
    Jurisdiction,
    "arrest num" DESC;

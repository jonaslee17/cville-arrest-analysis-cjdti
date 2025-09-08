--multi charge cases/duplicate arrest numbers
SELECT arrestnumber, COUNT(*) AS count
FROM arrests
GROUP BY arrestnumber
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
LIMIT 50;


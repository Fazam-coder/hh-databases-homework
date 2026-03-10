SELECT area_id,
       AVG(compensation_from) AS compensation_from,
       AVG(compensation_to) AS compensation_to,
       AVG((compensation_from + compensation_to) / 2) AS compensation_avg
FROM vacancies
GROUP BY area_id
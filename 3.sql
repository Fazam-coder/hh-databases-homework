SELECT area_id,
       AVG(compensation_from) AS compensation_from,
       AVG(compensation_to) AS compensation_to,
       AVG(COALESCE((compensation_from + compensation_to) / 2.0,
                    compensation_from,
                    compensation_to
           )) AS compensation_avg
FROM vacancies
GROUP BY area_id
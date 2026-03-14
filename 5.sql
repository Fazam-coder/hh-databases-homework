SELECT
    v.id AS vacancy_id,
    v.title AS vacancy_title,
    COUNT(r.id) AS responses_in_first_week
FROM vacancies v
INNER JOIN responses r ON v.id = r.vacancy_id
WHERE r.created_at BETWEEN (v.created_at, v.created_at + INTERVAL '7 days')
GROUP BY v.id, v.title
HAVING COUNT(r.id) > 5;
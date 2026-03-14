(SELECT
    DATE_TRUNC('month', created_at) AS month,
    'vacancies' AS entity_type
FROM vacancies
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY COUNT(*) DESC
LIMIT 1)
UNION
(SELECT
    DATE_TRUNC('month', created_at) AS month,
    'resumes' AS entity_type
FROM resumes
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY COUNT(*) DESC
LIMIT 1);
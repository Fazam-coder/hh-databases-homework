-- 1. Специализации
INSERT INTO specializations (id, name)
SELECT i, 'Специализация ' || i
FROM generate_series(1, 50) AS i;

-- 2. Вакансии
INSERT INTO vacancies (
    id,
    company_id,
    title,
    description,
    compensation_from,
    compensation_to,
    area_id,
    remote_work,
    experience_level,
    views_count,
    created_at
)
SELECT
    i,
    floor(random() * 1000 + 1)::INTEGER,
    (SELECT name FROM specializations ORDER BY random() LIMIT 1),
    'Описание вакансии #' || i || '. Требования: опыт работы, знание технологий.',
    from_compensation,
    floor(from_compensation * (1.1 + random() * 0.4))::INTEGER,
    floor(random() * 50 + 1)::INTEGER,
    random() < 0.3,
    exp_levels[floor(random() * 4 + 1)::INTEGER],
    floor(random() * 5000)::INTEGER,
    NOW() - (random() * INTERVAL '1825 days')
FROM generate_series(1, 10000) AS i
CROSS JOIN LATERAL (
    SELECT floor(random() * 270000 + 30000)::INTEGER AS from_compensation
) AS comp
CROSS JOIN (
    SELECT ARRAY['noExperience', 'between1And3', 'between3And6', 'moreThan6'] AS exp_levels
) AS consts;

-- 3. Резюме
INSERT INTO resumes (
    id,
    user_id,
    title,
    about_me,
    desired_salary,
    total_experience_years,
    created_at
)
SELECT
    i,
    i,
    (SELECT name FROM specializations ORDER BY random() LIMIT 1) || ' - Соискатель',
    'Ответственный специалист с опытом работы.',
    floor(random() * 360000 + 40000)::INTEGER,
    floor(random() * 20)::INTEGER,
    NOW() - (random() * INTERVAL '1825 days')
FROM generate_series(1, 100000) AS i;

-- 4. Отклики
INSERT INTO responses (id, vacancy_id, resume_id, cover_letter, employer_comment, created_at)
SELECT
    i,
    floor(random() * 10000 + 1)::INTEGER,
    floor(random() * 100000 + 1)::INTEGER,
    -- Сопроводительное письмо (у 70% откликов)
    CASE WHEN random() < 0.7
         THEN 'Здравствуйте! Меня заинтересовала ваша вакансия. Мой опыт соответствует требованиям.'
         ELSE NULL
    END,
    -- Комментарий работодателя (у 40% откликов)
    CASE WHEN random() < 0.4
         THEN (ARRAY['Приглашаем на собеседование', 'Отказ', 'Резерв', 'На рассмотрении'])[floor(random() * 4 + 1)::INTEGER]
         ELSE NULL
    END,
    NOW()
FROM generate_series(1, 210000) AS i -- 210000 чтобы точно было >200000, даже в случае игнорирования некоторых строк
ON CONFLICT(vacancy_id, resume_id) DO NOTHING;

UPDATE responses r
SET created_at = LEAST(
        GREATEST(v.created_at, res.created_at) + (random() * INTERVAL '30 days'),
        NOW())
    FROM vacancies v, resumes res
WHERE r.vacancy_id = v.id AND r.resume_id = res.id;

-- 5. Связь Вакансии и Специализации
INSERT INTO vacancy_specializations (vacancy_id, specialization_id, specialization_level)
SELECT
    v.id,
    s.id,
    (ARRAY['Начальный', 'Средний', 'Высокий', 'Любой'])[floor(random() * 4 + 1)::INTEGER]
FROM vacancies v
CROSS JOIN LATERAL (
    SELECT id FROM specializations
    ORDER BY random()
    LIMIT floor(random() * 3 + 1)::INTEGER
) s;

-- 6. Связь Резюме и Специализации
INSERT INTO resume_specializations (resume_id, specialization_id, specialization_level)
SELECT
    r.id,
    s.id,
    (ARRAY['Начальный', 'Средний', 'Высокий'])[floor(random() * 3 + 1)::INTEGER]
FROM resumes r
CROSS JOIN LATERAL (
    SELECT id FROM specializations
    ORDER BY random()
    LIMIT floor(random() * 4 + 1)::INTEGER
) s;
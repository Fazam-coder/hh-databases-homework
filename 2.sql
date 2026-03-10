-- 1. Специализации
INSERT INTO specializations (name)
SELECT 'Специализация ' || i
FROM generate_series(1, 50) AS i;

-- 2. Вакансии
INSERT INTO vacancies (
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
    user_id,
    title,
    about_me,
    desired_salary,
    total_experience_years,
    work_history,
    education,
    created_at
)
SELECT
    i,
    (SELECT name FROM specializations ORDER BY random() LIMIT 1) || ' - Соискатель',
    'Ответственный специалист с опытом работы.',
    floor(random() * 360000 + 40000)::INTEGER,
    floor(random() * 20)::INTEGER,
    'Компания А (2 года) -> Компания Б (3 года) -> Компания В (текущее место)',
    'Высшее техническое образование, ВУЗ #' || floor(random() * 100 + 1)::INTEGER,
    NOW() - (random() * INTERVAL '1825 days')
FROM generate_series(1, 100000) AS i;

-- 4. Отклики
INSERT INTO responses (vacancy_id, resume_id, cover_letter, employer_comment, created_at)
SELECT
    resp.vacancy_id,
    resp.resume_id,
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
    LEAST(
        GREATEST(resp.vacancy_created_at, resp.resume_created_at) + (random() * INTERVAL '30 days'),
        NOW()
    )
FROM (
    SELECT
        v.id AS vacancy_id,
        r.id AS resume_id,
        v.created_at AS vacancy_created_at,
        r.created_at AS resume_created_at
    FROM vacancies v
    CROSS JOIN resumes r
    WHERE random() < 0.0002  -- Вероятность отклика для получения (прямое перемножение дает 1 млрд. строк)
    ORDER BY random()
    LIMIT 200000
) AS resp;

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
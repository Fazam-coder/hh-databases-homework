-- 1. Специализации
CREATE TABLE specializations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- 2. Вакансии
CREATE TABLE vacancies (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,

    compensation_from INTEGER,
    compensation_to INTEGER,

    area_id INTEGER NOT NULL,
    remote_work BOOLEAN DEFAULT FALSE,   -- Возможность удаленной работы
    experience_level VARCHAR(50),        -- 'noExperience', 'between1And3', 'between3And6', 'moreThan6'
    views_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Резюме
CREATE TABLE resumes (
    id SERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    about_me TEXT,
    desired_salary INTEGER, -- Желаемая зарплата
    total_experience_years INTEGER,
    work_history TEXT,
    education TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Отклики
CREATE TABLE responses (
    id BIGSERIAL PRIMARY KEY,
    vacancy_id BIGINT NOT NULL REFERENCES vacancies(id),
    resume_id BIGINT NOT NULL REFERENCES resumes(id),
    cover_letter TEXT, -- Сопроводительное письмо
    employer_comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Связь специализаций и вакансий (Many-to-Many)
CREATE TABLE vacancy_specializations (
    id SERIAL PRIMARY KEY,
    vacancy_id INTEGER NOT NULL REFERENCES vacancies(id),
    specialization_id INTEGER NOT NULL REFERENCES specializations(id),
    specialization_level VARCHAR(50)
);

-- 6. Связь специализаций и резюме
CREATE TABLE resume_specializations (
    id SERIAL PRIMARY KEY,
    resume_id INTEGER NOT NULL REFERENCES resumes(id),
    specialization_id INTEGER NOT NULL REFERENCES specializations(id),
    specialization_level VARCHAR(50)
);

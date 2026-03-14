-- Для поиска вакансий в конкретном городе
CREATE INDEX idx_vacancies_area ON vacancies (area_id);

-- Для поиска вакансий у конкретной компании (например для страницы компании)
CREATE INDEX idx_vacancies_company ON vacancies(company_id);

-- Для фильтрации вакансий по зарплате
CREATE INDEX idx_vacancies_compensation_from_to ON vacancies(compensation_from, compensation_to);

-- Для поиска соискателей на конкретную должность и с желаемой зарплатой
CREATE INDEX idx_resumes_title_desired_salary ON resumes(title, desired_salary);

-- Для поиска соискателей на конкретную должность и с конкретным опытом работы
CREATE INDEX idx_resumes_title_total_experience ON resumes(title, total_experience_years);

-- Для поиска откликов на конкретную вакансию
CREATE INDEX idx_responses_vacancy ON responses(vacancy_id);

-- Для поиска откликов на конкретную вакансию по дате
CREATE INDEX idx_responses_created_at ON responses(vacancy_id, created_at);
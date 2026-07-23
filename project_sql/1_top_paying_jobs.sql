SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name

FROM
    job_postings_fact

LEFT JOIN company_dim 
    ON job_postings_fact.company_id=company_dim.company_id

WHERE
    job_title_short = 'Data Analyst' and
    job_work_from_home is TRUE and 
    salary_year_avg is not null

ORDER BY    
    salary_year_avg DESC


limit 10;


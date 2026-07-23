with top_paying_job as(

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

    LIMIT 10

)

select
    top_paying_job.*,
    skills

from top_paying_job

INNER JOIN skills_job_dim on top_paying_job.job_id=skills_job_dim.job_id

INNER JOIN skills_dim on skills_dim.skill_id=skills_job_dim.skill_id


ORDER BY
    top_paying_job.salary_year_avg desc
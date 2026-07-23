
with skill as (
SELECT
    skills_dim.skill_id,
    skills,
    count(*) as skill_count,
    round(avg(salary_year_avg),0) as salary


FROM
    job_postings_fact

inner JOIN skills_job_dim as skill_no ON job_postings_fact.job_id=skill_no.job_id
inner JOIN skills_dim on skill_no.skill_id = skills_dim.skill_id


WHERE
    job_title_short= 'Data Analyst' AND
    job_work_from_home = TRUE AND
    salary_year_avg is not null
    

GROUP BY
    skills_dim.skill_id

ORDER BY   
    salary DESC,
    skill_count DESC
    


) 

SELECT 
    skill.*

FROM    
    skill

where
    skill_count > 10



    
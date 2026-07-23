SELECT 
    
    skills,
    round(avg(salary_year_avg),0) as salary_avg

FROM
    job_postings_fact as job_post

INNER JOIN skills_job_dim on job_post.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id

where 
    job_title_short = 'Data Analyst' AND
    
    salary_year_avg is not null

GROUP BY
    skills

ORDER BY
    salary_avg DESC


limit 10;
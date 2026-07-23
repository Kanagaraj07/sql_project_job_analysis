with demand_skill as (
    SELECT
        skill_id,
        count(*) as skill_count

    FROM
        job_postings_fact
    
    INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id

    WHERE
        job_work_from_home is TRUE AND
        job_title_short = 'Data Analyst'
    
    GROUP BY
        skill_id
    
    

)

SELECT
    skills_dim.skill_id,
    skills,
    skill_count

FROM  demand_skill

INNER JOIN skills_dim on demand_skill.skill_id=skills_dim.skill_id

ORDER BY
    skill_count DESC

limit 5;
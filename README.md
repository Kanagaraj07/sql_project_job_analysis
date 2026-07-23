# Introduction


This project explores the data analyst job market using SQL. The goal was to answer practical questions such as which jobs offer the highest salaries, what skills employers are looking for, and which skills provide the best balance between demand and salary.

The analysis was completed using PostgreSQL by writing SQL queries on a real-world job posting dataset.

Sql queries ? Check them out here! -> [project sql](/project_sql/)
# Background


I completed this project after learning SQL through Luke Barousse's SQL course. Instead of only practicing basic queries, I wanted to apply SQL to solve real business questions using an actual dataset.

The project focuses on helping aspiring data analysts understand:

- Which jobs pay the highest salaries
- Which technical skills are required for those jobs
- Which skills are most frequently requested
- Which skills lead to higher salaries
- Which skills are both highly demanded and well paid



# Tools I Used



- PostgreSQL – to query and analyze the dataset.
- Visual Studio Code – for writing and organizing SQL scripts.
- Git & GitHub – for version control and project sharing.
- Markdown – for documenting the project.

# The Analysis

## 1. Top Paying Data Analyst Jobs

This query identifies the highest-paying remote Data Analyst positions available in the dataset.

```sql
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
```

### Insights

- The highest-paying Data Analyst position offers an annual salary of **$650,000**, significantly higher than the rest of the dataset.
- Most of the top-paying opportunities are **fully remote**, showing that remote positions can offer premium salaries.
- Senior-level positions such as **Director** and **Principal Data Analyst** dominate the highest salary range.
- Companies like **Meta**, **AT&T**, **SmartAsset**, and **Pinterest** appear among the highest-paying employers.
- The salaries in the top 10 range from **$184K to $650K**, indicating a large salary gap based on role and experience.

![top paying jobs](assets\query_1.png)

## 2. Skills Required for Top Paying Jobs

This query joins the top-paying Data Analyst jobs with their required skills to identify the technologies employers expect from high-paying candidates.

```sql
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
```

### Insights

- **SQL** appears in almost every top-paying job, making it the most essential technical skill.
- **Python** is another frequently required skill, highlighting its importance in data analysis and automation.
- Visualization tools such as **Tableau** and **Power BI** are commonly requested alongside SQL.
- Cloud platforms including **AWS**, **Azure**, and **Snowflake** appear in several high-paying roles, indicating increasing demand for cloud data skills.
- Employers also value supporting tools like **Excel**, **Git**, **Jira**, **Confluence**, and **Pandas**, showing that modern data analysts work across multiple technologies rather than relying on a single tool.

![skill for top paying jobs](assets\query_2.png)

## 3. Most In-Demand Skills

This query identifies the skills most frequently requested across Data Analyst job postings.

```sql
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
```

### Insights

- **SQL** is the most requested skill, appearing in **7,291** job postings.
- **Excel** ranks second, demonstrating that spreadsheet skills remain highly valuable despite the rise of modern analytics tools.
- **Python** is the third most requested skill, reflecting its importance for automation and data analysis.
- Business Intelligence tools such as **Tableau** and **Power BI** are consistently in demand for data visualization and reporting.
- The results suggest that a strong foundation in SQL, Excel, Python, and visualization tools covers the core technical requirements for many Data Analyst positions.
![most in demand skill](assets\query_3.png)

## 4. Top Paying Skills

This query calculates the average salary associated with each skill to identify which technologies command the highest salaries.

```sql
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
```

### Insights

- Specialized technologies generally offer higher average salaries than commonly used analytical tools.
- **SVN** has the highest average salary in the dataset at **$400K**, although it appears in very few job postings.
- Skills such as **Solidity**, **Couchbase**, **DataRobot**, **Terraform**, and **Golang** are associated with salaries above **$145K**, reflecting demand for niche expertise.
- Many of the highest-paying skills belong to cloud infrastructure, machine learning, and software engineering rather than traditional data analysis.
- High salary alone does not indicate a good skill to learn, as several of these technologies have relatively low demand.

![top paying skill](assets\query_4.png)
## 5. Most Optimal Skills (High Demand + High Salary)

This query combines skill demand and average salary to identify technologies that provide the best balance between market demand and earning potential.

```sql


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
```

### Insights

- **Python** and **SQL** stand out by combining both high demand and competitive salaries, making them the strongest skills for aspiring Data Analysts.
- Cloud technologies such as **AWS**, **Azure**, **Snowflake**, and **BigQuery** provide strong salaries while maintaining solid market demand.
- Business Intelligence tools like **Tableau** and **Power BI** continue to be valuable, appearing frequently in job postings with attractive average salaries.
- While niche technologies like **Go** offer higher salaries, they appear in significantly fewer job postings compared to SQL or Python.
- The analysis suggests that learning **SQL, Python, Tableau, Power BI, and one cloud platform** provides an excellent balance between employability and salary potential.

![most optimal skill](assets\query_5.png)

# Conclusion

#### 1. Senior-level positions such as **Director** and **Principal Data Analyst** dominate the highest salary range.

#### 2.**SQL** appears in almost every top-paying job, making it the most essential technical skill. 

#### 3. **SQL** is the most requested skill, appearing in **7,291** job postings.

#### 4. **SVN** has the highest average salary in the dataset at **$400K**, although it appears in very few job postings.

#### 5. Cloud technologies such as **AWS**, **Azure**, **Snowflake**, and **BigQuery** provide strong salaries while maintaining solid market demand.


## closing thoughts

The SQL analysis reveals that SQL remains the foundation of data analytics, appearing as the most requested skill across job postings. Python, Tableau, and Power BI further strengthen a candidate's profile by combining strong market demand with competitive salaries.

While niche technologies such as Solidity, Terraform, and Golang command higher average salaries, they appear in relatively few job postings. In contrast, SQL and Python provide the best balance between demand and earning potential, making them excellent investments for aspiring data analysts.

Overall, this project demonstrates how SQL can be used to transform raw job posting data into meaningful insights that support career planning and market analysis.

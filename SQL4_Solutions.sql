--SQL 4 Solutions

--1) The Number of Seniors and Juniors to Join the Company - Problem No :- 12

with cte as (
select employee_id, experience,
sum(salary) over (partition by experience order by salary) as 'rsum'
from candidates
)

select 'Senior' as 'experience' , count(employee_id) as accepted_candidates
from cte 
where experience = 'Senior'
and rsum <= 70000
union 
select 'Junior' as 'experience', count(employee_id) as accepted_candidates
from cte
where experience = 'Junior' and rsum <= (select 70000 - MAX(rsum) from cte	
										 where experience = 'Senior'
										 AND rsum <= 70000);



--2) League Statistics - Problem No :- 13


with cte as (
	select home_team_id as r1, away_team_id as r2, home_team_goals as g1, away_team_goals as g2 
	from Matches
	
	union all
	
	select away_team_id as r1, home_team_id as r2, away_team_goals as g1, home_team_goals as g2
	from Matches
)



SELECT t.team_name, count(c.r1) AS 'matches_played', SUM(
		CASE
			WHEN c.g1 > c.g2 then 3
			WHEN c.g1 = c.g2 then 1
			ELSE 0 
		END) AS 'points',
		SUM(c.g1) as 'goal_for',
		SUM(c.g2) as 'goal_against',
		SUM(c.g1) - SUM(c.g2) as 'goal_diff'
		from Teams t JOIN 
		cte c on t.team_id = c.r1
		GROUP BY c.r1
		ORDER BY points DESC, goal_diff DESC, t.team_name;





--3) Sales Person - Problem No :- 14

select distinct name from SalesPerson
where name not in (
select distinct s.name from SalesPerson s inner join Orders o on s.sales_id = o.sales_id
inner join Company c on c.com_id = o.com_id
where c.name='RED'
);



--4) Friend Requests II - Problem No :- 17

with cte as(
    select requester_id as id , count(requester_id) as num
from RequestAccepted
group by 1
union all
select accepter_id as id , count(accepter_id) as num
from RequestAccepted
group by 1)

select id,sum(num) as num
from cte 
group by id
order by sum(num) desc
limit 1;
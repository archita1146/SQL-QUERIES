-- 1. COMBINE TWO TABLES: 
Table: Person 
+-------------+---------+ 
| Column Name | Type    | 
+-------------+---------+ 
| PersonId    | int     | 
| FirstName   | varchar | 
| LastName    | varchar | 
+-------------+---------+ 
PersonId is the primary key column for this table.

Table: Address 
+-------------+---------+ 
| Column Name | Type    | 
+-------------+---------+ 
| AddressId   | int     | 
| PersonId    | int     | 
| City        | varchar | 
| State       | varchar | 
+-------------+---------+ 
AddressId is the primary key column for this table. 
-- Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people: FirstName, LastName, City, State 

-- ANSWER :   
Select Person.FirstName, Person.LastName, Address.City, Address.State from Person LEFT JOIN Address on Person.PersonId = Address.PersonId; 

-- 2. SECOND HIGHEST SALARY: 
-- Write a SQL query to get the second highest salary from the Employee table. 
+----+--------+ 
| Id | Salary | 
+----+--------+ 
| 1  | 100    | 
| 2  | 200    | 
| 3  | 300    | 
+----+--------+ 

-- ANSWERS :   

with A AS 
(SELECT *, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS RANK_SALARY FROM EMPLOYEE) 
SELECT SALARY AS SecondHighestSalary from A where RANK_SALARY = 2; 

SELECT (SELECT DISTINCT(salary) FROM employee ORDER BY salary desc LIMIT 1 OFFSET 1) AS SecondHighestSalary; 

SELECT SALARY AS SecondHighestSalary from Employee 
WHERE SALARY < (Select max(salary) from employee) limit 1 offset 1; 

-- 3 EMPLOYEE EARNING MORE THAN MANAGERS: 

The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id. 
+----+-------+--------+-----------+ 
| Id | Name  | Salary | ManagerId | 
+----+-------+--------+-----------+ 
| 1  | Joe   | 70000  | 3         | 
| 2  | Henry | 80000  | 4         | 
| 3  | Sam   | 60000  | NULL      | 
| 4  | Max   | 90000  | NULL      | 
+----+-------+--------+-----------+ 

-- Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager. 

-- ANSWERS :   
Select Name as Employee from Employee a
where ManagerId IS NOT NULL 
AND SALARY > (select salary from employee b where a.ManagerId = b.Id);

SELECT A.NAME AS EMPLOYEE FROM EMPLOYEE AS A JOIN EMPLOYEE AS B ON A.MANAGERID = B.ID AND A.SALARY > B.SALARY; 

-- 4. DUPLICATE MAILS: 

-- Write a SQL query to find all duplicate emails in a table named Person. 

+----+---------+ 
| Id | Email   | 
+----+---------+ 
| 1  | a@b.com | 
| 2  | c@d.com | 
| 3  | a@b.com | 
+----+---------+ 
Note: All emails are in lowercase. 

ANSWER :   
SELECT email from person group by email having count(email) > 2 
select distinct a.email as email from person a join person b where a.email = b.email and a.id != b.id; 
 
-- 5. CUSTOMER WHO NEVER ORDER:
-- Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Table: Orders.
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+

ANSWER : 
SELECT a.Name as Customers from Customers a Left Join Orders b On a.id = b.customerId where b.CustomerId IS NULL;
select name as customers from Customers where ID NOT IN (SELECT CUSTOMERID FROM ORDERS);

-- 6. DELETE DUPLICATE EMAILS: 
-- Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id. 
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+ 
-- Id is the primary key column for this table.  
--For example, after running your query, the above Person table should have the following rows: 
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+ 
-- Note: Your output is the whole Person table after executing your sql. Use delete statement. 

ANSWER :   
DELETE FROM Person WHERE Id NOT IN  
(SELECT * FROM( 
    SELECT MIN(Id) FROM Person GROUP BY Email) as p); 
    
DELETE A.* FROM PERSON A JOIN PERSON B ON A.EMAIL = B.EMAIL WHERE A.EMAIL = B.EMAIL AND A.ID > B.ID; 

-- 7. RISING TEMPERATURE:
-- Table: Weather 
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
-- id is the primary key for this table. This table contains information about the temperature in a certain day.  
-- Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday). 
-- Return the result table in any order.The query result format is in the following example: 

Weather
+----+------------+-------------+
| id | recordDate | Temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+

Result table:
+----+
| id |
+----+
| 2  |
| 4  |
+----+
-- In 2015-01-02, temperature was higher than the previous day (10 -> 25).
-- In 2015-01-04, temperature was higher than the previous day (30 -> 20).

ANSWER :  
Select a.id as id from weather a, weather b WHERE datediff(a.recordDate, b.recordDate) = 1 AND a.temperature > b.temperature; 

Select a.id as id from weather a join weather b on datediff(a.recordDate, b.recordDate) = 1 and a.temperature > b.temperature; 

-- 8. GAME PLAY ANALYSIS 1: 
Table: Activity  
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
-- (player_id, event_date) is the primary key of this table. 
-- This table shows the activity of players of some game. Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.  
-- Write an SQL query that reports the first login date for each player. 

-- The query result format is in the following example:   
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Result table:
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+  

ANSWER : 
-- #Using Group By 
SELECT player_id, min(event_date) as first_login from Activity group by player_id order by player_id; 

-- #windows function rank  
with T AS 
Select *, rank() over(partition by player_id order by event_date) as rank_number from activity) 
select t.player_id, t.event_date as first_login from T where rank_number = 1; 

-- #windows function dense_rank 
select a.player_id,a.event_date as first_login 
from (select player_id,event_date,dense_rank() over (partition by player_id order by event_date) as Rank_number from activity) as a 
where Rank_number < 2; 

-- 9. GAME PLAY ANALYSIS 2: 
Table: Activity  
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
-- (player_id, event_date) is the primary key of this table. 
-- This table shows the activity of players of some game. Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.  
-- Write a SQL query that reports the device that is first logged in for each player. 

-- The query result format is in the following example:   
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Result table:
+-----------+-----------+
| player_id | device_id |
+-----------+-----------+
| 1         | 2         |
| 2         | 3         |
| 3         | 1         |
+-----------+-----------+ 

ANSWER : 
-- #windows function rank  
with T AS 
Select *, rank() over(partition by player_id order by event_date) as rank_number from activity) 
select t.player_id, t.device_id from T where rank_number = 1; 

-- #windows function dense_rank 
select a.player_id,a.device_id 
from (select player_id,device_id,dense_rank() over (partition by player_id order by event_date) as Rank_number from activity) as a 
where Rank_number = 1; 

-- 10. EMPLOYEE BONUS: 
-- Select all employee's name and bonus whose bonus is < 1000. 
Table:Employee 
+-------+--------+-----------+--------+
| empId |  name  | supervisor| salary |
+-------+--------+-----------+--------+
|   1   | John   |  3        | 1000   |
|   2   | Dan    |  3        | 2000   |
|   3   | Brad   |  null     | 4000   |
|   4   | Thomas |  3        | 4000   |
+-------+--------+-----------+--------+
-- empId is the primary key column for this table.  

Table: Bonus 
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
empId is the primary key column for this table.
Example ouput:
+-------+-------+
| name  | bonus |
+-------+-------+
| John  | null  |
| Dan   | 500   |
| Brad  | null  |
+-------+-------+

ANSWER : 
Select a.name, b.bonus from Employee a left Join Bonus b On a.empId = b.empId where b.bonus < 1000 or b.bonus is null; 

-- USING COALESCE
Select a.name, b.bonus from Employee a left Join Bonus b On a.empId = b.empId where coalesce(b.bonus, 0) < 1000; 

-- 11. FIND CUSTOMER REFEREE: 
-- Given a table customer holding customers information and the referee. 
+------+------+-----------+
| id   | name | referee_id|
+------+------+-----------+
|    1 | Will |      NULL |
|    2 | Jane |      NULL |
|    3 | Alex |         2 |
|    4 | Bill |      NULL |
|    5 | Zack |         1 |
|    6 | Mark |         2 |
+------+------+-----------+

-- Write a query to return the list of customers NOT referred by the person with id '2'.  
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+

ANSWER : 
-- USING COALESCE
Select name from customer where coalesce(referee_id, 0) != 2; 

SELECT name FROM customer WHERE referee_id IS NULL OR referee_id <> 2;

-- 12. CUSTOMER PLACING THE LARGEST NUMBER OF ORDERS: 
-- Query the customer_number from the orders table for the customer who has placed the largest number of orders. 
-- It is guaranteed that exactly one customer will have placed more orders than any other customer. 

The orders table is defined as follows: 
| Column | Type | 
|-------------------|-----------| 
| order_number (PK) | int | 
| customer_number | int | 
| order_date | date | 
| required_date | date | 
| shipped_date | date | 
| status | char(15) | 
| comment | char(200) | 
 
Sample Input 
| order_number | customer_number | order_date | required_date | shipped_date | status | comment | 
|--------------|-----------------|------------|---------------|--------------|--------|---------| 
| 1 | 1 | 2017-04-09 | 2017-04-13 | 2017-04-12 | Closed | | 
| 2 | 2 | 2017-04-15 | 2017-04-20 | 2017-04-18 | Closed | | 
| 3 | 3 | 2017-04-16 | 2017-04-25 | 2017-04-20 | Closed | | 
| 4 | 3 | 2017-04-18 | 2017-04-28 | 2017-04-25 | Closed | | 
 
Sample Output 
| customer_number | 
|-----------------| 
| 3 | 
 
-- Explanation 
-- The customer with number '3' has two orders, which is greater than either customer '1' or '2' because each of them only has one order.  
-- So the result is customer_number '3'. 
-- Follow up: What if more than one customer have the largest number of orders, can you find all the customer_number in this case? 

ANSWER : 
-- USING WINDOWS FUNCTION
with T AS
 (SELECT customer_number, rank() over(partition by customer_number order by order_number) as cust_rank from orders)
select customer_number from t where cust_rank > 1 order by t.cust_rank desc limit 1; 

select customer_number from (select customer_number, rank() over(partition by customer_number order by order_number) as cust_rank from orders) T where T.cust_rank > 1 ORDER BY T.cust_rank DESC LIMIT 1; 

-- USING GROUP BY
SELECT CUSTOMER_NUMBER FROM ORDERS GROUP BY CUSTOMER_NUMBER order by count(customer_number) desc limit 1;

-- 13. BIG COUNTRIES: 
-- There is a table World 
+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
-- A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million. 
-- Write a SQL solution to output big countries' name, population and area. 
-- For example, according to the above table, we should output: 
+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+

ANSWER : 
-- #using OR 
SELECT name, population, area from World WHERE area > '3000000' OR population > '25000000'; 
-- #USING UNION 
SELECT name, population, area FROM world WHERE area > 3000000 UNION SELECT name, population, area FROM world WHERE population > 25000000; 

-- 14. CLASSES MORE THAN 5 STUDENTS: 
-- There is a table courses with columns: student and class 
-- Please list out all classes which have more than or equal to 5 students. 
-- For example, the table:  
   +---------+------------+
| student | class      |
+---------+------------+
| A       | Math       |
| B       | English    |
| C       | Math       |
| D       | Biology    |
| E       | Math       |
| F       | Computer   |
| G       | Math       |
| H       | Math       |
| I       | Math       |
+---------+------------+

-- Should output:  
+---------+
| class   |
+---------+
| Math    |
+---------+
-- Note: 
-- The students should not be counted duplicate in each course. 

ANSWER : 
-- #Using group by
SELECT CLASS FROM COURSES GROUP BY CLASS having count(distinct student) >= 5; 
-- # Using Subquery
SELECT CLASS FROM  (SELECT COUNT(DISTINCT STUDENT) AS CNT, CLASS FROM COURSES GROUP BY CLASS) T WHERE CNT >= 5;

-- 15. FRIEND REQUESTS |: OVERALL ACCEPTANCE RATE: 
-- In social network like Facebook or Twitter, people send friend requests and accept others’ requests as well. Now given two tables as below: 
Table: friend_request
| sender_id | send_to_id |request_date|
|-----------|------------|------------|
| 1         | 2          | 2016_06-01 |
| 1         | 3          | 2016_06-01 |
| 1         | 4          | 2016_06-01 |
| 2         | 3          | 2016_06-02 |
| 3         | 4          | 2016-06-09 |

Table: request_accepted 
| requester_id | accepter_id |accept_date | 
| 1 | 2 | 2016_06-03 | 
| 1 | 3 | 2016-06-08 | 
| 2 | 3 | 2016-06-08 | 
| 3 | 4 | 2016-06-09 | 
| 3 | 4 | 2016-06-10 | 
 
-- Write a query to find the overall acceptance rate of requests rounded to 2 decimals, which is the number of acceptance divide the number of requests.  
-- For the sample data above, your query should return the following result. 

|accept_rate| |-----------| | 0.80|  


-- Note: The accepted requests are not necessarily from the table friend_request. In this case, you just need to simply count the total accepted requests (no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate. 

-- It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once. In this case, the ‘duplicated’ requests or acceptances are only counted once. 

-- If there is no requests at all, you should return 0.00 as the accept_rate. 

-- Explanation: There are 4 unique accepted requests, and there are 5 requests in total. So the rate is 0.80. 

ANSWER : 
Select coalesce(round(count(distinct b.requester_id, b.accepter_id) / count(distinct a.sender_id, a.send_to_id), 2), 0) as accept_rate from friend_request a, request_accepted b; 

Select round(ifnull((select count(*) from (select distinct requester_id, accepter_id from request_accepted) as A) /  
(select count(*) from (select distinct sender_id, send_to_id from friend_request) as B),0, 2) as accept_rate; 

-- Follow-up: 
-- Can you write a query to return the accept rate but for every month? 

Select month(b.accept_date) as month, coalesce(round(count(distinct b.requester_id, b.accepter_id) /  
count(distinct a.sender_id, a.send_to_id), 2), 0) as accept_rate from friend_request a, request_accepted b  
where month (a.request_date) = month(b.accept_date) group by month(accept_date) 

-- 16. CONSECUTIVE AVAILABLE SEATS: 
-- Several friends at a cinema ticket office would like to reserve consecutive available seats. 
-- Can you help to query all the consecutive available seats order by the seat_id using the following cinema table? 

| seat_id | free | 
| 1 | 1    | 
| 2 | 0    | 
| 3 | 1    | 
| 4 | 1    | 
| 5 | 1    | 

-- Your query should return the following result for the sample case above. 
| seat_id | 
|3|
|4| 
|5|  
--Note: 
--The seat_id is an auto increment int, and free is bool ('1' means free, and '0' means occupied.). 
--Consecutive available seats are more than 2(inclusive) seats consecutively available. 

ANSWER : 
SELECT distinct a.seat_id  
from cinema a  
JOIN cinema b  
ON ABS(a.seat_id - b.seat_id) = 1  
and a.free = true and b.free = true  
order by a.seat_id;  

#USING WINDOWS FUNCTION 
select seat_id from  
( 
  select *, lag(free, 1, false) over(order by seat_id) as prev_free, 
  lead(free, 1, false) over(order by seat_id) as next_free from cinema 
) as t 
where (free = 1 and prev_free = 1) or (free =1 and next_free = 1) 
order by seat_id; 

 

-- 17. SALES PERSON: 
-- Description 
-- Given three tables: salesperson, company, orders. 
-- Output all the names in the table salesperson, who didn’t have sales to company 'RED'. 

-- Example 
-- Input 

Table: salesperson 
| sales_id | name | salary | commission_rate | hire_date | 
|   1      | John | 100000 |     6           | 4/1/2006  | 
|   2      | Amy  | 120000 |     5           | 5/1/2010  | 
|   3      | Mark | 65000  |     12          | 12/25/2008| 
|   4      | Pam  | 25000  |     25          | 1/1/2005  | 
|   5      | Alex | 50000  |     10          | 2/3/2007  | 

-- The table salesperson holds the salesperson information. Every salesperson has a sales_id and a name. 

Table: company 

| com_id  |  name  |    city    | 
|   1     |  RED   |   Boston   | 
|   2     | ORANGE |   New York | 
|   3     | YELLOW |   Boston   | 
|   4     | GREEN  |   Austin   | 
 
-- The table company holds the company information. Every company has a com_id and a name. 

Table: orders 
| order_id | order_date | com_id  | sales_id | amount | 
| 1        |   1/1/2014 |    3    |    4     | 100000 | 
| 2        |   2/1/2014 |    4    |    5     | 5000   | 
| 3        |   3/1/2014 |    1    |    1     | 50000  | 
| 4        |   4/1/2014 |    1    |    4     | 25000  | 
 
-- The table orders holds the sales record information, salesperson and customer company are represented by sales_id and com_id. 

output 
+------+ 
| name |  
+------+ 
| Amy  |  
| Mark |  
| Alex | 
+------+ 
 --Explanation 
 --According to order '3' and '4' in table orders, it is easy to tell only salesperson 'John' and 'Pam' have sales to company 'RED', 
--so we need to output all the other names in the table salesperson.  

ANSWER : 
select s.name from salesperson s where s.sales_id NOT IN ( 
 select a.sales_id from orders a Left Join company b on a.com_id = b.com_id where b.name = 'RED' 
); 

select s.name 
from orders o join company c on (o.com_id = c.com_id and c.name = 'RED') 
right join salesperson s on s.sales_id = o.sales_id 
where o.sales_id is null;  

--18. TRIANGLE JUDGEMENT:
-- A pupil Tim gets homework to identify whether three line segments could possibly form a triangle. However, this assignment is very heavy because there are hundreds of records to calculate.
-- Could you help Tim by writing a query to judge whether these three sides can form a triangle, assuming table triangle holds the length of the three sides x, y and z.
	| x  | y  | z  |
	| 13 | 15 | 30 |
	| 10 | 20 | 15 |
 
	--For the sample data above, your query should return the follow result:
	| x  | y  | z  | triangle |
	| 13 | 15 | 30 | No       |
	| 10 | 20 | 15 | Yes      |
	
	ANSWER :
	SELECT *,
	(case 
	   when x+y > z and y+z > x and x + z > y then 'Yes'
	    else 'No'
	END) AS 'triangle'
	from triangle; 
	
	SELECT *, IF(x+y>z and x+z>y and y+z>x, 'Yes', 'No') as triangle FROM triangle; 

-- 19. SHORTEST DISTANCE IN LINE:
-- Table point holds the x coordinate of some points on x-axis in a plane, which are all integers.
-- Write a query to find the shortest distance between two points in these points.
	| x   |
|-----|
| -1  |
| 0   |
| 2   |

-- The shortest distance is '1' obviously, which is from point '-1' to '0'. So the output is as below:
	| shortest|
|---------|
| 1       |
	
	ANSWER :
	Select coalesce(x - lag(x) over(order by x), 0) as shortest from point order by shortest asc limit 1 offset 1;
	
	SELECT min(distance) as shortest from
	(
		SELECT x, abs(x- LAG(x) OVER(order by x)) as distance from point
	) x;
	 
	SELECT MIN(a.x - b.x) as shortest from point a, point b where  a.x >  b.x;
                
-- 20. BIGGEST SINGLE NUMBER:
-- Table my_numbers contains many numbers in column num including duplicated ones.
-- Can you write a SQL query to find the biggest number, which only appears once.
	|num|+---+
| 8 |
| 8 |
| 3 |
| 3 |
| 1 |
| 4 |
| 5 |
| 6 | 
-- For the sample data above, your query should return the following result:-|num|+---+
| 6 |
-- Note: If there is no such number, just output null.
	
	ANSWER :
	select num from my_numbers group by num having count(num) = 1 order by num desc limit 1;
	 
	SELECT MAX(num) AS num FROM
	    (SELECT num FROM my_numbers
	    GROUP BY num HAVING COUNT(num) = 1) AS t;
                
-- 21. NOT BORING MOVIES:
-- X city opened a new cinema, many people would like to go to this cinema. The cinema also gives out a poster indicating the movies’ ratings and descriptions.
-- Please write a SQL query to output movies with an odd numbered ID and a description that is not 'boring'. Order the result by rating.
	 
For example, table cinema:
|   id    | movie     |  description |  rating   |	
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |

-- For the example above, the output should be:
	|   id    | movie     |  description |  rating   |
	|   5     | House card|   Interesting|   9.1     |
	|   1     | War       |   great 3D   |   8.9     |

	ANSWER :
select * from cinema where id % 2 <> 0 and description <> 'boring' order by rating desc;
select * from cinema where id % 2 <> 0 and description not like '%boring%' order by rating desc;

-- 22. SWAP SALARY:
-- Given a table salary, such as the one below, that has m=male and f=female values. Swap all f and m values (i.e., change all f values to m and vice versa) with a single update statement and no intermediate temp table.
-- Note that you must write a single update statement, DO NOT write any select statement for this problem.
-- Example:
	| id | name | sex | salary |
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
-- After running your update statement, the above salary table should have the following rows:
	| id | name | sex | salary |
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |
	
	ANSWER :
	UPDATE SALARY SET SEX = 
	CASE sex
	WHEN 'f' THEN 'm'
	ELSE 'f'
	END ; 
	
	UPDATE salary SET sex = IF(sex='m','f','m');

-- 23. ACTORS AND DIRECTORS WHO COOPERATED ATLEAST THREE TIMES:
-- Table: ActorDirector
	+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| actor_id    | int     |
| director_id | int     |
| timestamp   | int     |
+-------------+---------+
-- timestamp is the primary key column for this table.
	
-- Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor have cooperated with the director at least 3 times.
-- Example:
	ActorDirector table:
+-------------+-------------+-------------+
| actor_id    | director_id | timestamp   |
+-------------+-------------+-------------+
| 1           | 1           | 0           |
| 1           | 1           | 1           |
| 1           | 1           | 2           |
| 1           | 2           | 3           |
| 1           | 2           | 4           |
| 2           | 1           | 5           |
| 2           | 1           | 6           |
+-------------+-------------+-------------+
Result table:
+-------------+-------------+
| actor_id    | director_id |
+-------------+-------------+
| 1           | 1           |
+-------------+-------------+
-- The only pair is (1, 1) where they cooperated exactly 3 times.
	
ANSWER :
	select actor_id, director_id from ActorDirector group by actor_id, director_id having count(*) >= 3;
               
 SELECT actor_id, director_id FROM 
    (SELECT actor_id, director_id, COUNT(CONCAT(actor_id,"_", director_id)) as pairCount
     FROM ActorDirector 
     GROUP BY CONCAT(actor_id,"_", director_id)) as T WHERE pairCount > 2
                     
-- 24. PRODUCT SALES ANALYSIS I
	Table: Sales
	+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
-- (sale_id, year) is the primary key of this table.
-- product_id is a foreign key to Product table.
-- Note that the price is per unit.
	Table: Product
	+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
-- product_id is the primary key of this table.
-- Write an SQL query that reports all product names of the products in the Sales table along with their selling year and price.
For example:
	Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
                     
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
                     
Result table:
+--------------+-------+-------+
| product_name | year  | price |
+--------------+-------+-------+
| Nokia        | 2008  | 5000  |
| Nokia        | 2009  | 5000  |
| Apple        | 2011  | 9000  |
+--------------+-------+-------+
	
ANSWER :
	SELECT distinct b.product_name, a.year, a.price from Sales a Left Join Product b on a.product_id = b.product_id;
	
	SELECT DISTINCT P.product_name, S.year, S.price 
	FROM (SELECT DISTINCT product_id, year, price FROM Sales) S
	INNER JOIN Product AS P USING (product_id);
                    
-- 25. PRODUCT SALES ANALYSIS II
-- Table: Sales
	+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
-- sale_id is the primary key of this table.
-- product_id is a foreign key to Product table.
-- Note that the price is per unit.
	Table: Product
	+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
-- product_id is the primary key of this table.
-- Write an SQL query that reports the total quantity sold for every product id.
-- The query result format is in the following example:
Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+

Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
Result table:
+--------------+----------------+
| product_id   | total_quantity |
+--------------+----------------+
| 100          | 22             |
| 200          | 15             |
+--------------+----------------+
	
ANSWER :
	SELECT product_id, sum(quantity) as total_quantity from Sales group by product_id;
                     
-- 26. PROJECT EMPLOYEES I
Table: Project
	+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
-- (project_id, employee_id) is the primary key of this table.
-- employee_id is a foreign key to Employee table.

	Table: Employee
	+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
-- employee_id is the primary key of this table.
-- Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.
-- The query result format is in the following example:
	Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+
Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Result table:
+-------------+---------------+
| project_id  | average_years |
+-------------+---------------+
| 1           | 2.00          |
| 2           | 2.50          |
+-------------+---------------+
-- The average experience years for the first project is (3 + 2 + 1) / 3 = 2.00 and for the second project is (3 + 2) / 2 = 2.50
	
ANSWER :
	select project_id, round(avg(experience_years), 2) as average_years 
	from project a Left join employee b 
	on a.employee_id = b.employee_id 
	group by a.project_id;
	
	select a.project_id, round(sum(b.experience_years)/count(b.employee_id), 2) as average_years 
	from project a left join employee b on a.employee_id = b.employee_id
	group by a.project_id;

-- 27. PROJECT EMPLOYEES II
	Table: Project
	+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
-- (project_id, employee_id) is the primary key of this table.
-- employee_id is a foreign key to Employee table.
	Table: Employee
	+------------------+---------+
| Column Name      | Type    |

	+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
-- employee_id is the primary key of this table.
-- Write an SQL query that reports all the projects that have the most employees.
-- The query result format is in the following example:
	Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+

Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Result table:
+-------------+
| project_id  |
+-------------+
| 1           |
+-------------+
-- The first project has 3 employees while the second one has 2.
	
ANSWER :
	select project_id from project group by project_id 
	having count(employee_id) =
	(select count(employee_id) from project group by project_id order by count(employee_id) desc limit 1); 
	
	Select project_id from (select distinct project_id, dense_rank() over(order by count(employee_id) desc) as cnt_rank 
	from project group by project_id) t where cnt_rank = 1;

-- 28. SALES ANALYSIS I
Table: Product
	+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
-- product_id is the primary key of this table.
	Table: Sales
	+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+------ ------+---------+
-- This table has no primary key, it can have repeated rows.
-- product_id is a foreign key to Product table.
-- Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.
-- The query result format is in the following example:
	Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+
Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+
Result table:
+-------------+
| seller_id   |
+-------------+
| 1           |
| 3           |
+-------------+
-- Both sellers with id 1 and 3 sold products with the most total price of 2800.
	
ANSWER :
select seller_id from sales group by seller_id having sum(price) = (select sum(price) from sales group by seller_id order by sum(price) desc limit 1);
                     

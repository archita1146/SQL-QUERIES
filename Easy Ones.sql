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
-- #Using Group By 
SELECT player_id, device_id from Activity group by player_id order by event_date; 

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
SELECT CUSTOMER_NUMBER FROM ORDERS GROUP BY CUSTOMER_NUMBER HAVING COUNT(CUSTOMER_NUMBER) > 1; 

-- USING WINDOWS FUNCTION
with T AS
 (SELECT customer_number, rank() over(partition by customer_number order by      order_number) as cust_rank from orders)
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




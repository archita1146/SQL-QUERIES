## COMBINE TWO TABLES: 

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
Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people: 

FirstName, LastName, City, State 

ANSWER :   
Select Person.FirstName, Person.LastName, Address.City, Address.State from Person LEFT JOIN Address on Person.PersonId = Address.PersonId; 

 

## SECOND HIGHEST SALARY: 

Write a SQL query to get the second highest salary from the Employee table. 

+----+--------+ 
| Id | Salary | 
+----+--------+ 
| 1  | 100    | 
| 2  | 200    | 
| 3  | 300    | 
+----+--------+ 
 For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null. 

+---------------------+ 
| SecondHighestSalary | 
+---------------------+ 
| 200                 | 
+---------------------+ 

ANSWER :   

with A AS 

(SELECT *, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS RANK_SALARY FROM EMPLOYEE) 

SELECT SALARY AS SecondHighestSalary from A where RANK_SALARY = 2; 

 

SELECT (SELECT DISTINCT(salary) FROM employee ORDER BY salary desc LIMIT 1 OFFSET 1) AS SecondHighestSalary; 

SELECT SALARY AS SecondHighestSalary from Employee 

WHERE SALARY < (Select max(salary) from employee) limit 1 offset 1; 

 

## EMPLOYEE EARNING MORE THAN MANAGERS: 

The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id. 

 

+----+-------+--------+-----------+ 
| Id | Name  | Salary | ManagerId | 
+----+-------+--------+-----------+ 
| 1  | Joe   | 70000  | 3         | 
| 2  | Henry | 80000  | 4         | 
| 3  | Sam   | 60000  | NULL      | 
| 4  | Max   | 90000  | NULL      | 
+----+-------+--------+-----------+ 

Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager. 

+----------+ 
| Employee | 
+----------+ 
| Joe      | 
+----------+ 

 

 

ANSWER :   

Select Name as Employee from Employee a
where ManagerId IS NOT NULL 
AND SALARY > (select salary from employee b where a.ManagerId = b.Id);

SELECT A.NAME AS EMPLOYEE FROM EMPLOYEE AS A JOIN EMPLOYEE AS B ON A.MANAGERID = B.ID AND A.SALARY > B.SALARY; 


## DUPLICATE MAILS: 

Write a SQL query to find all duplicate emails in a table named Person. 

+----+---------+ 
| Id | Email   | 
+----+---------+ 
| 1  | a@b.com | 
| 2  | c@d.com | 
| 3  | a@b.com | 
+----+---------+ 
 

For example, your query should return the following for the above table: 

+---------+ 
| Email   | 
+---------+ 
| a@b.com | 
+---------+ 
 

Note: All emails are in lowercase. 

 

ANSWER :   

SELECT email from person group by email having count(email) > 2 

select distinct a.email as email from person a join person b where a.email = b.email and a.id != b.id; 
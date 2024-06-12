create database IPL;
use IPL;

create table matches(id	INT, 
city	varchar(100), 
date	varchar(100), 
player_of_match	varchar(100),
venue	varchar(200), 
neutral_venue	bit, 
team1	varchar(100),
team2	varchar(100), 
toss_winner	varchar(100), 
toss_decision	varchar(100), 
winner	varchar(100), 
result	varchar(100), 
result_margin	INT, 
eliminator	char(10),
method	varchar(100), 
umpire1	varchar(100),
umpire2 varchar(100)
);
select * from matches;
----------------------------------------------------------------------------------

CREATE TABLE ipl_ball (
id int NOT NULL,
inning int,
`over` int,
ball int,
batsman text,
non_striker text,
bowler text,
batsman_runs int,
extra_runs int,
total_runs int, 
is_wicket bit,
dismissal_kind text,
player_dismissed text,
fielder text,
extras_type text,
batting_team text,
bowling_team text,
venue text,
match_date text
);
/*
Steps to import large data using command line interface (non - gui client): 

Note:- Before importing the data through command line, firstly make your csv file up to date like remove all the commas in fielder
	and venue column from excel.

Text instructions: 
*Load large CSV files into MySQL Database faster using Command line prompt
1. Open MySQL Workbench, Create a new database to store the tables you'll import (eg- FacilitySerivces).
Then, Create the table with matching data types of csv file, usually with INT and CHAR datatypes only (without the data) in the database you just created using Workbench.
2. Open the terminal or command line prompt (Go to windows, search for cmd.exe. Shortcut - Windows button + R, then type cmd)
3. We'll now connect with MySQL database in command line prompt. Follow the steps below:
Copy the path of your MySQL bin directory in your computer. (Normally it is under c drive program files).
The bin directory of MySQL Server is generally in this path - C:\Program Files\MySQL\MySQL Server 8.0\bin
Now, in the Command Line prompt, type 

cd C:\Program Files\MySQL\MySQL Server 8.0\bin 

and press enter.

4. Connect to the MySQL database using the following command in command line prompt

mysql -u root -p

(please replace "root" with your user name that you must have configured while installing MySQL server)
(press enter, it will ask for the password, give your password)

5. If you are successfully logged to mysql,
then set the global variables by using below command so that data can be imported from local computer folder.

mysql> SET GLOBAL local_infile=1;

Query OK, 0 rows affected (0.00 sec)
(you've just instructed MySQL server to allow local file upload from your computer)

6. Quit current server connection:
mysql> quit

7. Load the file from CSV file to the MySQL database. In order to do this, please follow the commands:
(We'll connect with the MySQL server again with the local-infile system variable. 
This basically means you want to upload data into a database table from your local machine)

mysql --local-infile=1 -u root -p
(give password)

- Show Databases;
(It'll show all the databases in MySQL server.)

- mysql> USE ipl;
(makes the database that you had created in step 1 as default schema to use for the next sql scripts)
(Use your Database and load the file into the table.

The next step is to load the data from local case study folder into the ipl_ball in ipl database)

mysql> LOAD DATA LOCAL INFILE 'F:\\SQL\\Large Data Import\\IPL_Ball.csv'
INTO TABLE ipl_ball
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

*VERY IMP - Please replace single backward (\) slash in the path with double back slashes (\\) instead of single slash*
Also note that "ipl_ball" is my table name, use the table name that you've given while creating the database in step 1.

8. Now check if data has been imported or not.

SELECT * FROM ipl_ball LIMIT 20;

9. If data has been imported successfully with 100% accuracy without error,
then alter the table to update the datatypes (if needed) of some columns, etc. You're all set now.

*/
select * from ipl_ball;

-- -----------------------------------------------------------------------------------

-- 1. 1. Create a table named matches with appropriate data types for columns
-- 2. Create a table named 'deliveries' with appropriate data types for columns
-- 3. Import data from csv file 'IPL_matches.csv'attached in resources to'matches'
-- 4. Import data from csv file 'IPL_Ball.csv' attached in resources to matches
-- 5. Select the top 20 rows of the deliveries table.
select * from deliveries limit 20;
-- 6. Select the top 20 rows of the matches table.
select * from matches limit 20;
-- 7. Fetch data of all the matches played on 2nd May 2013.
alter table matches
add column new_date date;
alter table matches
drop column new_date;
update matches 
set new_date = if(date like "%/%", str_to_date(date,"%d/%m/%Y"), str_to_date(date,"%d-%m-%Y"));
set sql_safe_updates=0;

select new_date,venue,team1,team2 from matches
where new_date="2013-05-02";
-- 8. Fetch data of all the matches where the margin of victory is more than 100 runs.
select new_date,venue,team1,team2,result,result_margin from matches
where result_margin>100;
-- 9. Fetch data of all the matches where the final scores of both teams tied and order it in descending order of the date.
select * from matches;
select new_date,team1,team2,result from matches
where result="tie"
order by new_date desc;
-- 10. Get the count of cities that have hosted an IPL match.
select city, count(*) as city_count from matches
group by city;
-- 11. Create table deliveries_v02 with all the columns of deliveries and an additional column ball_result containing value boundary, dot or otherdepending on the total_run (boundary for &gt;= 4, dot for 0 and other for anyother number)
create table deliveries_v02
select * ,case
when total_runs>=4 then "Boundary"
when total_runs=0 then "dot"
else "other"
end ball_result
from ipl_ball;
select ball_result from deliveries_v02;
-- 12. Write a query to fetch the total number of boundaries and dot balls
select * from deliveries_v02;

select count(*) as total ,ball_result from deliveries_v02
group by ball_result;
-- 13. Write a query to fetch the total number of boundaries scored by each team
select count(*) as total ,ball_result,batting_team,bowling_team from deliveries_v02
where ball_result="Boundary"
group by batting_team,bowling_team;
-- 14. Write a query to fetch the total number of dot balls bowled by each team
select count(*) as total ,ball_result,batting_team,bowling_team from deliveries_v02
where ball_result="dot"
group by batting_team,bowling_team;
-- 15. Write a query to fetch the total number of dismissals by dismissal kinds
select * from ipl_ball;
select count(*) as total_dismissal ,dismissal_kind from ipl_ball
where dismissal_kind<>"NA"
group by dismissal_kind;
-- 16. Write a query to get the top 5 bowlers who conceded maximum extra runs
select distinct bowler,sum(extra_runs ) as conceded
from ipl_ball
where extras_type<>"NA"
group by bowler
order by conceded desc
limit 5;
-- 17. Write a query to create a table named deliveries_v03 with all the columns of deliveries_v02 table and two additional column (named venueand match_date) of venue and date from table matches
create table deliveries_v03
select dv2.id, inning, `over`, ball, batsman, non_striker, bowler, batsman_runs, extra_runs, total_runs, is_wicket, 
dismissal_kind, player_dismissed, fielder, extras_type, batting_team, bowling_team, ball_result,
m.venue, new_date from  deliveries_v02 dv2 inner join matches m using (id);
-- 18. Write a query to fetch the total runs scored for each venue and order it in the descending order of total runs scored.
select * from ipl_ball;
select distinct venue,sum(total_runs) as Run_scored from ipl_ball
group by venue
order by run_scored desc;
-- 19. Write a query to fetch the year-wise total runs scored at Eden Gardens and order it in the descending order of total runs scored.
 select year(new_date) as Years, sum(total_runs) as TotalRunsScored
from deliveries_v03
where venue = "Eden Gardens"
group by Years
order by TotalRunsScored desc;
 /*20. Get unique team1 names from the matches table, you will notice that there are two entries for Rising Pune Supergiant one with Rising Pune
Supergiant and another one with Rising Pune Supergiants. Your task is to
create a matches_corrected table with two additional columns team1_corr
and team2_corr containing team names with replacing Rising Pune
Supergiants with Rising Pune Supergiant. Now analyse these newly
created columns.*/
create table matches_corrected
select * from matches;

alter table matches_corrected
add column team1_corr varchar(30);

alter table matches_corrected
add column team2_corr varchar(30);

update matches_corrected
set team1_corr = if(team1 = "Rising Pune Supergiants", "Rising Pune Supergiant", team1),
        team2_corr = if(team2 = "Rising Pune Supergiants", "Rising Pune Supergiant", team2);

select distinct team1_corr
from matches_corrected;
/*21. Create a new table deliveries_v04 with the first column as ball_id
containing information of match_id, inning, over and ball separated by&#39;(For
ex. 335982-1-0-1 match_idinning-over-ball) and rest of the columns same
as deliveries_v03)*/

drop table deliveries_v04;
create table deliveries_v04
select *,concat(id,"-",inning,"-",`over`,"-",ball) as ball_id from deliveries_v03;
select * from deliveries_v05;
-- 22. Compare the total count of rows and total count of distinct ball_id in deliveries_v04;
select count(distinct id) as DitinctMatches,count(*) ball_id from deliveries_v04;
-- 23. Create table deliveries_v05 with all columns of deliveries_v04 and an additional column for row number partition over ball_id. (HINT :row_number() over (partition by ball_id) as r_num)
create table deliveries_v05
select *, row_number() over (partition by ball_id) as r_num
from deliveries_v04;
/*24. Use the r_num created in deliveries_v05 to identify instances where
ball_id is repeating. (HINT : select * from deliveries_v05 WHERE
r_num=2;)*/
select * from deliveries_v05 WHERE
r_num=2;
-- 25. Use subqueries to fetch data of all the ball_id which are repeating.
select * from deliveries_v05
where ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2);

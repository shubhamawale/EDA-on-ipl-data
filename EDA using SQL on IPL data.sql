create database ipl;
#-------------------------------------------------------------------------------------------------
show databases;
#-------------------------------------------------------------------------------------------------
use ipl;
#-------------------------------------------------------------------------------------------------
create table matches(
	id integer, season varchar(20), city varchar(30), date date,
    team1 varchar(30), team2 varchar(30), toss_winner varchar(30),
    toss_decision varchar(30), result varchar(30),
    dl_applied integer, winner varchar(30), win_by_runs varchar(30),
    win_by_wickets integer, player_of_match varchar(30),
    venue varchar(50), umpire1 varchar(30), umpire2 varchar(30),
    umpire3 varchar(30)
);

CREATE TABLE ipl.deliveries (
 matchid integer, inning integer, batting_team varchar(30), bowling_team varchar(30), 
 over_ integer, ball integer, batsman varchar(30), non_striker varchar(30), bowler varchar(30),
 is_super_over integer, wide_runs integer, bye_runs integer, legbye_runs integer, noball_runs integer, 
 penalty_runs integer, batsman_runs integer, extra_runs integer, total_runs integer, 
 player_dismissed varchar(20), dismissal_kind varchar(50), fielder varchar(30)
);
#-------------------------------------------------------------------------------------------------

show global variables like 'local_infile';
set global local_infile ='ON'; # way 1 to on
set global local_infile=1;     # way 2 to on 

#-------------------------------------------------------------------------------------------------

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/deliveries.csv'
INTO TABLE deliveries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/matches.csv'
into table ipl.matches
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- id, season, city, date, team1, team2, toss_winner, toss_decision, result, dl_applied, winner, win_by_runs, win_by_wickets, player_of_match, venue, umpire1, umpire2, umpire3);

############### its not working from here --- continue form youtube video --> EDA SQL BY Sandeep
# -------------------------------------------------------------------------------------------------------------- 

use ipl;

# -------------------------------------------------------------------------------------------------------------- 
# Shape of Data
select count(*) as 'No of Matches' from matches;
select count(*) as 'No of Balls' from deliveries;

select * from information_schema.columns
where table_name = 'matches';

select count(*) as 'No of Column' from information_schema.columns
where table_name = 'matches';

select count(*) as 'No of Column' from information_schema.columns
where table_name = 'deliveries';

select * from information_schema.tables;

# -------------------------------------------------------------------------------------------------------------- 
# viewing the data
select * from ipl.matches;
select * from ipl.deliveries;

# -------------------------------------------------------------------------------------------------------------- 
# No of Matches played in IPL every year
select distinct(season), count(*) as 'No of Matches' from matches
group by season
order by 2;

# -------------------------------------------------------------------------------------------------------------- 
# No of Matches playes in every city
select city, count(*) as 'No of Matches' from matches
group by city;

# -------------------------------------------------------------------------------------------------------------- 
# Seson winner of each season
select season, winner, max(date) as 'Match Date' from ipl.matches
group by season
order by 3 desc;

# -------------------------------------------------------------------------------------------------------------- 
# Venue of most recent 10 matches played
select venue from ipl.matches
order by date desc
limit 10;

# -------------------------------------------------------------------------------------------------------------- 
# Runs in words
select batsman, bowler, case when batsman_runs = 6 then 'Six'
							 when batsman_runs = 4 then 'Four'
                             when batsman_runs = 0 then 'Duck'
						else 
							 'Other'
						end as 'Runs in word'
from ipl.deliveries;

# -------------------------------------------------------------------------------------------------------------- 
# total win by runs and win by wickets of every team in every year
select * from ipl.matches;
select season, winner, sum(win_by_runs), sum(win_by_wickets) from ipl.matches
group by season, winner
order by 3 desc;

# -------------------------------------------------------------------------------------------------------------- 
# Which team bowler gave maxium extra runs
select bowler, sum(extra_runs) from deliveries
group by bowler
order by 2 desc;

# -------------------------------------------------------------------------------------------------------------- 
# Avg win by runs in ipl
select round(avg(win_by_runs),1) as 'Average winning runs', round(avg(win_by_wickets),1) as 'Avarage winning wickets'
from ipl.matches;

# -------------------------------------------------------------------------------------------------------------- 
# Avg win by runs and wickets of wining team
select winner, round(avg(win_by_runs),1) as 'Average winning runs', round(avg(win_by_wickets),1) as 'Avarage winning wickets'
from ipl.matches
group by winner;

# -------------------------------------------------------------------------------------------------------------- 
# How many extra runs made by SK Warne
select bowler, sum(extra_runs) from ipl.deliveries
where bowler='SK Warne';
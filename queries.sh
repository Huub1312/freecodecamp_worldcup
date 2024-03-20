#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

# Teams table
# team_id | name

# Games table
# game_id | year | round | winner_id | opponent_id | winner_goals | opponent_goals

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games;")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) FROM games;")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games;")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games;")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games;")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT GREATEST(MAX(winner_goals), MAX(opponent_goals)) FROM games;")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2;")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT teams.name FROM teams INNER JOIN games ON teams.team_id = games.winner_id WHERE games.year = 2018 AND games.round = 'Final';")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT teams.name FROM teams FULL JOIN games AS winners ON teams.team_id = winners.winner_id LEFT JOIN games AS opponents ON teams.team_id = opponents.opponent_id WHERE winners.year=2014 OR opponents.year=2014 AND (winners.round='Eighth-Final' OR opponents.round='Eighth-Final');")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT teams.name FROM teams RIGHT JOIN games AS winners ON teams.team_id = winners.winner_id ORDER BY teams.name ASC;")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT games.year, teams.name FROM games JOIN teams ON games.winner_id = teams.team_id WHERE games.round = 'Final' ORDER BY games.year ASC;")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT teams.name FROM teams WHERE name LIKE 'Co%';")"

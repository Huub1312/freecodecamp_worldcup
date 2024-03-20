#! /bin/bash
if [[ $1 == "test" ]]; then
	PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
	PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
	if [[ $YEAR != "year" &&
		$ROUND != "round" &&
		$WINNER != "winner" &&
		$OPPONENT != "opponent" &&
		$WINNER_GOALS != "winner_goals" &&
		$OPPONENT_GOALS != "opponent_goals" ]]; then
		WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		if [[ -z $WINNER_ID ]]; then
			INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
			if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]; then
				echo -e "\nInserted winner into teams table, $WINNER"
			fi
			WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		fi
		if [[ -z $OPPONENT_ID ]]; then
			INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
			if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]; then
				echo -e "\nInserted opponent into teams table, $OPPONENT"
			fi
			OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		fi
		$PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')"
		echo -e "\nInserted game:\nYear: $YEAR \nRound: $ROUND \n$WINNER vs $OPPONENT"
	fi
done <games.csv
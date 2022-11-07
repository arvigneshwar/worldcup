#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo -e "$($PSQL "TRUNCATE TEAMS, GAMES")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  # Remove Header
  if [[ $YEAR != "year" ]]; then

    # Check if team already exists
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    echo $OPPONENT_ID

    if [[ -z $OPPONENT_ID ]]; then
      # if not, we gotta assign it
      INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams (name) VALUES('$OPPONENT')")
      echo $INSERT_OPPONENT_TEAM
      if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]; then
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        echo $OPPONENT_ID
      fi
    fi

    # Check if team already exists
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    echo $WINNER_ID

    if [[ -z $WINNER_ID  ]]; then
      # if not, assign it
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams (name) VALUES('$WINNER')")
      echo $INSERT_WINNER_TEAM
      if [[ $INSERT_WINNER_TEAM == 'INSERT 0 1' ]]; then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        echo $WINNER_ID
      fi
    fi

    LOG_GAME=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$WINNER_ID','$OPPONENT_ID',$WINNER_GOALS,$OPPONENT_GOALS)")
    echo $LOG_GAME
  fi
done
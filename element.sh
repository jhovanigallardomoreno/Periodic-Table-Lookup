#!/bin/bash

#script to provide descriptions of periodic table elements

PSQL="psql -X -q --username=freecodecamp --dbname=periodic_table -t --no-align -c"

PRINT_DESC() {
  echo "The element with atomic number $1 is $2 ($3). It's a $4, with a mass of $5 amu. $2 has a melting point of $6 celsius and a boiling point of $7 celsius."
}

GET_DATA() {

  case $1 in
    1) 
      
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $2")
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $2")

      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $2")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")

      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $2")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $2")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $2")

      PRINT_DESC $2 $NAME $SYMBOL $TYPE $MASS $MELTING $BOILING
      ;;
    2)

      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$2'")
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$2'")

      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")

      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

      PRINT_DESC $ATOMIC_NUMBER $NAME $2 $TYPE $MASS $MELTING $BOILING
      ;;
    3)

      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$2'")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$2'")

      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")

      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

      PRINT_DESC $ATOMIC_NUMBER $2 $SYMBOL $TYPE $MASS $MELTING $BOILING
      ;;
  esac


}

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else

  regex='^[0-9]+$'
  if ! [[ $1 =~ $regex ]] ; then
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  fi

  if [[ $ATOMIC_NUMBER ]]
  then

    GET_DATA 1 $ATOMIC_NUMBER

  elif [[ $SYMBOL ]]
  then

    GET_DATA 2 $SYMBOL

  elif [[ $NAME ]]
  then

    GET_DATA 3 $NAME
    
  else
    # if no element could not find message
    echo I could not find that element in the database.
  fi

fi

#!/bin/bash
# Script to output information from the periodic table database

# Variable to query the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Enable extglob shell option for extended pattern matching.
shopt -s extglob

MAIN() {
  if [[ -z $INPUT ]]
  then
    echo Please provide an element as an argument.
  else
    case $INPUT in
      +([0-9])) NUMBERS ;;
      @([A-Z][a-z]|[A-z])) SYMBOLS ;;
      @([A-Z]+([a-z]))) NAMES ;;
      *) NOT_FOUND ;;
    esac
  fi
}

NUMBERS() {
  ATOMIC_NUMBER_QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $INPUT")
  if [[ -z $ATOMIC_NUMBER_QUERY_RESULT ]]
  then
    NOT_FOUND
  else
    ELEMENT_QUERY_RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $INPUT;")
    echo $ELEMENT_QUERY_RESULT | sed 's/|/ /g' | while read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}

SYMBOLS() {
  SYMBOL_QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol = '$INPUT'")
  if [[ -z $SYMBOL_QUERY_RESULT ]]
  then
    NOT_FOUND
  else
    ELEMENT_QUERY_RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$INPUT';")
    echo $ELEMENT_QUERY_RESULT | sed 's/|/ /g' | while read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}

NAMES() {
  NAME_QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE name = '$INPUT'")
  if [[ -z $NAME_QUERY_RESULT ]]
  then
    NOT_FOUND
  else
    ELEMENT_QUERY_RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$INPUT';")
    echo $ELEMENT_QUERY_RESULT | sed 's/|/ /g' | while read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}

NOT_FOUND() {
  echo I could not find that element in the database.
}

FOUND() {
  echo TODO: This one DOES exist in the DB
}

# main program
INPUT=$1
MAIN
#!/bin/bash
#tool to get chemical substance data
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [ $# -eq 0 ]
  then
    echo "Please provide an element as an argument."
    exit
fi

PARSE_QUERY_RESULT()
{
  if ! [[ -z $QUERY ]]
  then
    IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $1
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    exit
  fi
}

QUERY=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$1;")
PARSE_QUERY_RESULT $QUERY
QUERY=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol='$1';")
PARSE_QUERY_RESULT $QUERY
QUERY=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where name='$1';")
PARSE_QUERY_RESULT $QUERY
echo "I could not find that element in the database."

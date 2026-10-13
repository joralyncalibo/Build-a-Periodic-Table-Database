#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
lookup=$(printf '%s' "$1" | sed "s/'/''/g")
element=$($PSQL "SELECT 'The element with atomic number ' || e.atomic_number || ' is ' || e.name || ' (' || e.symbol || '). It''s a ' || t.type || ', with a mass of ' || p.atomic_mass || ' amu. ' || e.name || ' has a melting point of ' || p.melting_point_celsius || ' celsius and a boiling point of ' || p.boiling_point_celsius || ' celsius.' FROM elements e JOIN properties p USING (atomic_number) JOIN types t USING (type_id) WHERE e.atomic_number::text = '$lookup' OR LOWER(e.symbol) = LOWER('$lookup') OR LOWER(e.name) = LOWER('$lookup');")

if [[ -z "$element" ]]; then
  echo "I could not find that element in the database."
else
  echo "$element"
fi

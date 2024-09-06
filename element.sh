#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."

#si l'argument passé est un nbre atomic
elif [[ $1 =~ ^[0-9]+$ ]]; then
  atomic_number=$1
  symbol=$($PSQL "select symbol from elements where atomic_number=$atomic_number")
  name=$($PSQL "select name from elements where atomic_number=$atomic_number")
  mass=$($PSQL "select atomic_mass from properties where atomic_number=$atomic_number")
  melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number=$atomic_number")
  boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number=$atomic_number")
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a nonmetal, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
#verifier si l'argument est un symbol
elif [[ "$1" =~ ^[a-zA-Z]+$ && ${#1} -le 2 ]];then
  symbol=$1
  atomic_number=$($PSQL "select atomic_number from elements where symbol ='$symbol'")
  name=$($PSQL "select name from elements where symbol ='$symbol'")
  mass=$($PSQL "select atomic_mass from properties where atomic_number=$atomic_number")
  melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number=$atomic_number")
  boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number=$atomic_number")
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a nonmetal, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
elif [[ "$1" =~ ^[a-zA-Z]+$ && ${#1} -gt 2 ]];then
  name=$1
  atomic_number=$($PSQL "select atomic_number from elements where name ='$name'")
  symbol=$($PSQL "select symbol from elements where atomic_number =$atomic_number")
  mass=$($PSQL "select atomic_mass from properties where atomic_number=$atomic_number")
  melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number=$atomic_number")
  boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number=$atomic_number")
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a nonmetal, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
else
  echo "I could not find that element in the database."
fi

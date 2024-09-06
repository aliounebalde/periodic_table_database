#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
print(){
if [[ $# != 8 ]];then
  echo "I need all  arguments!"
else
    echo "The element with atomic number $1 is $2 ($3). It's a $4, with a mass of $5 amu. $6 has a melting point of $7 celsius and a boiling point of $8 celsius."
fi
}

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."

#si l'argument passé est un nbre atomic
elif [[ $1 =~ ^[0-9]+$ ]]; then

  atomic_number=$($PSQL "select atomic_number from elements where atomic_number =$1")
#test if that element exist
if [[ -z $atomic_number ]];then
  echo "I could not find that element in the database."
  exit 1
fi
  type=$($PSQL "select t.type from types t inner join properties p on t.type_id=p.type_id where p.atomic_number=1")
  symbol=$($PSQL "select symbol from elements where atomic_number=$atomic_number")
  name=$($PSQL "select name from elements where atomic_number=$atomic_number")
  mass=$($PSQL "select atomic_mass from properties where atomic_number=$atomic_number")
  melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number=$atomic_number")
  boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number=$atomic_number")
  print $atomic_number $name $symbol $type $mass $name $melting_point $boiling_point

#verifier si l'argument est un symbol
elif [[ "$1" =~ ^[a-zA-Z]+$ && ${#1} -le 2 ]];then
  symbol=$1
  atomic_number=$($PSQL "select atomic_number from elements where symbol ='$symbol'")
  #test if the element exist
  if [[ -z $atomic_number ]];then
    echo "I could not find that element in the database."
    exit 1
  fi
  type=$($PSQL "select t.type from types t inner join properties p on t.type_id=p.type_id where p.atomic_number=1")
  name=$($PSQL "select name from elements where symbol ='$symbol'")
  mass=$($PSQL "select atomic_mass from properties where atomic_number=$atomic_number")
  melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number=$atomic_number")
  boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number=$atomic_number")
  
  print $atomic_number $name $symbol $type $mass $name $melting_point $boiling_point

#si l'argument passé est le nom de l'élément
elif [[ "$1" =~ ^[a-zA-Z]+$ && ${#1} -gt 2 ]];then
  name=$1
  atomic_number=$($PSQL "select atomic_number from elements where name ='$name'")
  #test if the element exist
  if [[ -z $atomic_number ]];then
    echo "I could not find that element in the database."
    exit 1
  fi
  type=$($PSQL "select t.type from types t inner join properties p on t.type_id=p.type_id where p.atomic_number=1")
  symbol=$($PSQL "select symbol from elements where atomic_number =$atomic_number")
  mass=$($PSQL "select atomic_mass from properties where atomic_number=$atomic_number")
  melting_point=$($PSQL "select melting_point_celsius from properties where atomic_number=$atomic_number")
  boiling_point=$($PSQL "select boiling_point_celsius from properties where atomic_number=$atomic_number")
  print $atomic_number $name $symbol $type $mass $name $melting_point $boiling_point
else
  echo "I could not find that element in the database."
fi


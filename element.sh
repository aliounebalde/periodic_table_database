#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Fonction pour afficher les informations d'un élément
print_element_info() {
  local atomic_number=$1
  element_data=$($PSQL "SELECT e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
                        FROM elements e 
                        INNER JOIN properties p ON e.atomic_number = p.atomic_number 
                        INNER JOIN types t ON p.type_id = t.type_id 
                        WHERE e.atomic_number = $atomic_number")
  
  # Extraire les données retournées
  IFS="|" read -r name symbol type atomic_mass melting_point boiling_point <<< "$element_data"

  # Imprimer les informations formatées
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
}

# Vérification des arguments
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 1
fi

# Si l'argument est un nombre (numéro atomique)
if [[ $1 =~ ^[0-9]+$ ]]; then
  atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  
  # Vérification si l'élément existe
  if [[ -z $atomic_number ]]; then
    echo "I could not find that element in the database."
    exit 1
  fi
  
  # Appeler la fonction pour afficher les infos de l'élément
  print_element_info $atomic_number

# Si l'argument est un symbole (2 caractères max)
elif [[ "$1" =~ ^[a-zA-Z]+$ && ${#1} -le 2 ]]; then
  symbol=$1
  atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$symbol'")
  
  if [[ -z $atomic_number ]]; then
    echo "I could not find that element in the database."
    exit 1
  fi
  
  # Afficher les infos de l'élément
  print_element_info $atomic_number

# Si l'argument est un nom d'élément
elif [[ "$1" =~ ^[a-zA-Z]+$ && ${#1} -gt 2 ]]; then
  name=$1
  atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$name'")
  
  if [[ -z $atomic_number ]]; then
    echo "I could not find that element in the database."
    exit 1
  fi
  
  # Afficher les infos de l'élément
  print_element_info $atomic_number

else
  echo "I could not find that element in the database."
fi

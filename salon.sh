#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

MY_SALON() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # get services
  GET_SERVICES_RESULT=$($PSQL "SELECT service_id, name FROM services")
  echo "$GET_SERVICES_RESULT" | sed 's/|/) /g'
  # get SERVICE_ID_SELECTED
  read SERVICE_ID_SELECTED
  # check SERVICE_NAME
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  # if not found
  if [[ -z $SERVICE_NAME ]]
  then
    # go to MY_SALON
​    MY_SALON "I could not find that service. What would you like today?"
​    else
    # get CUSTOMER_PHONE
​    echo -e "\nWhat's your phone number?"
​    read CUSTOMER_PHONE
    # get CUSTOMER_NAME
​    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # if customer not exist
​    if [[ -z $CUSTOMER_NAME ]]
​    then
      # insert into customers
​      echo -e "\nI don't have a record for that phone number, what's your name?"
​      read CUSTOMER_NAME
​      INSERT_INTO_CUSTOMERS_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
​    fi
    # get SERVICE_TIME
​    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
​    read SERVICE_TIME
    # get CUSTOMER_ID
​    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
    # insert into appointments
​    INSERT_INTO_APPOINTMENTS_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
​    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MY_SALON "Welcome to My Salon, how can I help you?"
#!/bin/bash
PSQL='psql -X --username=freecodecamp --dbname=salon --tuples-only -c'

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  # print message if provided as arg
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # display available services
  echo -e '1) haircut \n2) manicure \n3) pedicure'
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  
  # if selected service doesn't exist
  if [[ -z $SERVICE_NAME ]]
  then
    # send to main menu
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    BOOK_APPOINTMENT
  fi
}

BOOK_APPOINTMENT(){
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  # get appointment time
  echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  
  # insert appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # print appointment confirmation message
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
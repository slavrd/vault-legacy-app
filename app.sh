#!/usr/bin/env bash
# r/w greetings to a DB

# Read DB credentials from env variables
DB_USER=$DATABASE_CREDS_APP_ROLE_USERNAME
DB_PASS=$DATABASE_CREDS_APP_ROLE_PASSWORD

CHOICE=0 # used to store user choices

# Loop to display menu until user selects exit
while  [ "$CHOICE" -ne 4 ]; do

    # Display menu
    clear
    echo "MAIN MENU:"
    echo "=========="
    echo "1) Add greeting"
    echo "2) Display all greeings"
    echo "3) Get DB access info"
    echo "4) Quit"
    echo ""
    read -p "Select action: " CHOICE

    # Execute actions
    case $CHOICE in
        1)  # Add greeting
            clear
            read -p "Type in greeting to add: " GREETING
            mysql -u $DB_USER -p$DB_PASS -D appdb \
                -e "INSERT INTO greetings (phrase) VALUES ('$GREETING');" 2> /dev/null || {
                    read -p "An error ocurred. Press Enter to continue."
                }
            ;;
        2)  # Display all greetings
            clear
            mysql -u $DB_USER -p$DB_PASS -D appdb \
                -e "SELECT * FROM greetings;" 2> /dev/null && {
                    echo ""
                    read -p "Done. Press Enter to continue."
                } || {
                    read -p "An error ocurred. Press Enter to continue."
                }
                ;;
        3)  # Display DB access information
            clear
            echo "DB access credentials"
            echo "====================="
            echo "Username: $DB_USER"
            echo "Password: $DB_PASS"
            echo ""
            read -p "Press Enter to continue."
            ;;            
    esac

done

clear

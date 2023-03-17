#!/bin/bash
# Ease of use connect variable
SQL_CONNECT='mysql -h localhost -u sql_tutor'
# May use it
SEPARATOR='-------------------------------------------------------------'
# Colors
RED='\033[0;31m'
LGREEN='\033[1;32m'
NC='\033[0m' # No Color
function validate_access_query {
    # First argument is the correct query.
    # Second argument is the user supplied query to check.

    # Queries exactly match, then correct.
    if [ "$1" = "$2" ]; then
        # Execute the query and show the result
        $SQL_CONNECT -e "$1"
        return 0
    else
        # The query does not match the correct one, probably the user is MiXIng cAsE, or just another correct query.
        # Run both queries and check if the output matches.
        EXPECTED_OUTPUT=`$SQL_CONNECT -e "$1"`
        ACTUAL_OUTPUT=`$SQL_CONNECT -e "$2"`
        if [ "$EXPECTED_OUTPUT" = "$ACTUAL_OUTPUT" ]; then
            $SQL_CONNECT -e "$1"
            return 0
        else
            return 1
        fi
    fi

}

function read_query {
    while true ; do
        read -r -p 'MariaDB [sql_tutor]> ' QUERY
        # For debugging purposes
        if [ "$QUERY" = 'skip' ]; then
            return 0
        # Show and execute solution
        elif [ "$QUERY" = 'solution' ]; then
            echo -e "${LGREEN}Solution:${NC} $1"
            $SQL_CONNECT -e "USE sql_tutor; $1"
            # Quick newline
            echo
            return 0;
        fi

        # Add 'USE sql_tutor;' to the queries.
        QUERY=`echo "USE sql_tutor; $QUERY"`
        EXPECTED_QUERY=`echo "USE sql_tutor; $1"`
        validate_access_query "$EXPECTED_QUERY" "$QUERY"
        if [ $? -eq 0 ]; then
            break
        else
            echo -e "${RED}Incorrect query, try again! (Type 'solution' if you're stuck)${NC}\n"
        fi
    done
    echo -e "${LGREEN}Correct!${NC}\n"
}

echo -e 'Welcome to SQL basics interactive tutorial. Verifying your SQL installation...'
command -v mysql &> /dev/null
if [ $? -eq 1 ]; then
    echo "Installing MySQL client and server, please wait."
    sleep 1
    sudo apt-get install mariadb-client -y
    if [ $? -ne 0 ]; then
        echo "Installation failed, please check your network and/or repos."
        exit 1
    fi
fi
echo 'Client found.'
command -v mysqld &> /dev/null
if [ $? -eq 1 ]; then
    echo "Installing MySQL server, please wait."
    sleep 1
    sudo apt-get install mariadb-server -y
    if [ $? -ne 0 ]; then
        echo "Installation failed, please check your network and/or repos."
        exit 1
    fi
fi
echo 'Server Found.'

# Verify if the sql_tutor user exists
$SQL_CONNECT -e "USE sql_tutor; SELECT HP FROM Players;" &> /dev/null
if [ $? -eq 1 ]; then
    echo "Root access required to setup the database."
    sudo mysql -e "CREATE USER 'sql_tutor'@'localhost' IDENTIFIED BY '';" &> /dev/null
    # Create the Table to be used in this demo
    sudo mysql -e "CREATE DATABASE sql_tutor;" &> /dev/null
    sudo mysql -e "USE sql_tutor;
    CREATE TABLE Players (PlayerID int, HP int, Name varchar(255), Strength int, Class varchar(255));
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (8927412, 20, 'steel56', 100, 'light');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (-1635515, 50, 'cloudseeker11', 200, 'medium');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (2121575, 25, 'bastion73', 50, 'light');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (6598247, 110, 'ace1%', 1000, 'heavy');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (-3764183, 15, 'delta732', 100, 'light');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (-1243723, 20, 'epsilon32', 100, 'light');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (5321686, 125, 'chariot746', 1250, 'heavy');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (3178214, 40, 'shadow_flight832', 200, 'medium');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (-5464515, 20, 'anvil153', 100, 'light');
    INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (2843295, 20, 'sparks87', 1000, 'heavy');" &> /dev/null
    # Grant permissions to sql_tutor on its database
    sudo mysql -e " GRANT SELECT ON sql_tutor.* TO 'sql_tutor'@'localhost';"
    echo "Setup done."
fi
clear
echo "Structured Query Language (SQL) is a standarized programming language used to manage Relational Databases.
Multiple Relational Database Management Systems (RDBMS) exist (MySQL, MariaDB, MS SQL...). We will use MariaDB (a fork of MySQL)."

echo -e '\nRDBMS stores databases, each database can have one or more tables, and each table contains data organized in rows and columns.
For this tutorial, we will be accessing the table "Players" of the database "sql_tutor".\n Players table:'
$SQL_CONNECT -e "USE sql_tutor; SELECT * FROM Players;"
echo -e 'The SELECT statement is used to show one or more data columns of a table.
Syntax: SELECT column1, column2,... FROM table_name;
Example: To show the "HP" column: SELECT HP FROM Players;\nTry it out:'
read_query "SELECT HP FROM Players;"
echo "Enter the query to show PlayerID, HP and Name."
read_query "SELECT PlayerID, HP, Name FROM Players;"

echo -e 'What if you want to display all data columns? Writing the names of all columns can be tedious and error prone. In this case we can use the wildcard "*".
The query becomes: SELECT * FROM table_name; Lets use it on our database:'
read_query "SELECT * FROM Players;"

echo 'WHERE statement is used to filter the output depending on specified conditions.'
echo -e 'Supported operations: = < > <= >= BETWEEN LIKE IN
AND, OR, NOT can be used with conditions.
The LIKE operator will be explained in details later.

examples: - To select rows where HP is smaller or equal to 20: SELECT * FROM Players WHERE HP <= 20;
- To select rows where Strength is between 40 and 200: SELECT * FROM Players WHERE Strength BETWEEN 40 AND 200;
- To select rows with specific values (like specific usernames): SELECT * FROM Players WHERE Name IN ("sparks87", "stormheat79");
- To select rows where the Class is not "light": SELECT * FROM Players WHERE CLASS NOT IN ("light");
'
echo 'Practice: Enter a query that shows the HP and Name of light Class players:'
read_query "SELECT HP, Name FROM Players WHERE Class IN ('light');"
echo 'Enter a query that shows the Name of the Players having a negative PlayerID:'
read_query "SELECT Name FROM Players WHERE PlayerID < 0;"
echo 'Enter a query that shows all columns of heavy Class players:'
read_query "SELECT * FROM Players WHERE Class IN ('heavy');"

echo -e 'Followup on the LIKE statement: This operator is used to search for a specific pattern, it supports two wildcards: % and _
% matches zero or more characters, _ matches exactly one character. If you have reserved characters in the data (like _, %),
you can escape them in the query using a backslash \, forcing the character to lose its special meaning.
examples:
- To select rows where Name starts with "c": SELECT * FROM Players WHERE Name LIKE "c%";
- To select rows where Name is exactly 8 characters (those are 8 underscores): SELECT * FROM Players WHERE Name LIKE "________";
Lets practice: Enter a query that shows the HP and PlayerID of players having an "s" anywhere in their Name:'
read_query "SELECT HP, PlayerID FROM Players WHERE Name LIKE '%s%';"
echo 'Enter a query that shows the Class and Name of Players whose name start with an "a" and is exactly 4 characters long:'
read_query "SELECT Class, Name FROM Players WHERE Name LIKE 'a___';"
echo 'Enter a query that shows all columns of Players whose Name starts with a "b" and has an "n" somewhere in the name:'
read_query "SELECT * FROM Players WHERE Name LIKE 'b%s%';"
echo 'Enter a query that shows the Players having underscore somewhere in their name:'
read_query "SELECT Name FROM Players WHERE Name LIKE '%\_%';"

echo 'Sometimes the table have duplicate entries. To show only distinct data, use the DISTINCT statement as follows:
SELECT DISTINCT column1, column2, ... FROM table_name ...;
Lets run two distinct queries:
SELECT DISTINCT HP FROM Players;'

$SQL_CONNECT -e "USE sql_tutor; SELECT DISTINCT HP FROM Players;"
echo -e '\nand: SELECT DISTINCT Name, HP FROM Players;'
$SQL_CONNECT -e "USE sql_tutor; SELECT DISTINCT Name, HP FROM Players;"
echo -e '\nDid you notice something? The first query returned only distinct HP, while the second one returned all rows despite some having identical HP.
The addition of the Name column made the rows unique, so all rows were displayed.'

echo -e 'MySQL has a large collection of built-in functions to handle strings and values. We mention some of them:
CONCAT(str1, str2): Concatenates two strings.
STRCMP(str1, str2): Compares two strings (returns 0 if strings match, -1 if str1 < str2, 1 if str1 > str2).
TRIM(str1): Removes leading and trailing whitespaces from the string.
AVG, MIN, MAX, CEIL, FLOOR: returns the average, min, max, ceil, floor of values in a column.
COUNT(): Counts number of rows.

examples:
- Show the number of rows of the HP column: SELECT COUNT(HP) FROM Players;
- Show player Names concatenated with their ID: SELECT CONCAT(Name, PlayerID) FROM Players;
- Get the average of HP of all players: SELECT AVG(HP) FROM Players;
Practice: Enter a query that shows the maximum Strength among all players:'
read_query "SELECT MAX(Strength) FROM Players;"
echo 'Enter a query that returns the concatenation of Class and Name for all data rows'
read_query "SELECT CONCAT(Class,Name) FROM Players;"
echo 'Enter a query that returns the sum of HP of light Class players:'
read_query "SELECT SUM(HP) FROM Players WHERE Class IN ('light');"

echo -e 'To order rows according to a specific column we use the ORDER BY statement with ASC or DESC.
example: To show all columns ordered by PlayerID in ascending order: SELECT * FROM Players ORDER BY PlayerID ASC;
Practice: Enter a query that shows Name and PlayerID ordered by HP in descending order:'
read_query "SELECT Name, PlayerID FROM Players ORDER BY HP DESC;"

echo -e 'To limit the number of rows in the output, we can use the LIMIT statement as follows:
SELECT * FROM table_name LIMIT nb_of_rows;
Practice: Enter a query that shows the first 5 rows of all columns:'
read_query "SELECT * FROM Players LIMIT 5;"

echo -e '\nA MySQL subquery is a query nested within another query. A subquery is enclosed in parenthesis and is executed before the main query.
example: SELECT * FROM Players WHERE HP = (SELECT MAX(HP) FROM Players);
Practice: Enter a query that shows the maximum HP of players having an "s" in their Name (using a subquery):'
# It can be done without a subquery
read_query "SELECT MAX(HP) FROM Players WHERE Name IN ( SELECT Name FROM Players WHERE Name LIKE '%s%' );"

echo -e '\nYou completed the SQL tutor! Well done!'
# By Ahmad Ismail

## Introduction
SQL tutor is a script that teaches you some of the basics of SQL interactively. Currently only tested on Debian based systems.

## Installation

Supports only Linux systems.

### Debian/Ubuntu

Install required dependencies:

```
sudo apt install mariadb-client mariadb-server dialog yq jq
```

---

Clone the repository, configure the database, make the script executable and execute it:
```
git clone https://github.com/a-h-ismail/sql-tutor.git/
cd sql-tutor

sudo mysql < tutor_db.sql

chmod +x sql_tutor.sh
./sql_tutor.sh
```

## License

- The tutorial script is under GNU Afferno GPL version 3
- The tutorial content (YAML files) is under Creative Commons Attribution-ShareAlike 4.0 International

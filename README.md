## Introduction
SQL tutor is a script that teaches you some of the basics of SQL interactively. Currently only tested on Debian based systems.

## Features

- Simple terminal user interface (using `dialog`).
- Interactive exercises.
- Progress indicator on top.
- Progress save/restore.

## Installation

Tested on Debian systems, it should also work on other distributions as long as dependencies are satisfied.

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

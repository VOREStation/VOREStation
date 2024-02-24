## How to set-up the Docker database


First, open `config/docker/mysql.env.example`, open in notepad or N++, change all the values to something else ~~or don't if you are lazy~~ for security sake.

Then proceed to save the changed version to `mysql.env` and save it in the same directory as the `mysql.env.example` file.

In order to get docker to use the database, it's suggested to change the `config/dbconfig.txt` to include the values in `mysql.env` file, to do this, use the hostname `db` as host!

### Example for `config/dbconfig.txt`:

The default database name is `tgstation` by default. Unless you change the SQL schemas, this cannot be changed.

Keep note of the values, `*LOGIN` and `*PASSWORD`

```
# MySQL Connection Configuration

# Server the MySQL database can be found at
# Examples: localhost, 200.135.5.43, www.mysqldb.com, etc.
ADDRESS db

# MySQL server port (default is 3306)
PORT 3306

# Database the population, death, karma, etc. tables may be found in
DATABASE tgstation

# Username/Login used to access the database
LOGIN sillyusername

# Password used to access the database
PASSWORD somekindofpassword

# The following information is for feedback tracking via the blackbox server
FEEDBACK_DATABASE tgstation
FEEDBACK_LOGIN sillyusernane
FEEDBACK_PASSWORD somekindofpassword

# Track population and death statistics
# Comment this out to disable
#ENABLE_STAT_TRACKING
```

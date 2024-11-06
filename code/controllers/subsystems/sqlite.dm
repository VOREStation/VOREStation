// This holds all the code needed to manage and use a SQLite database.
// It is merely a file sitting inside the data directory, as opposed to a full fledged DB service,
// however this makes it a lot easier to test, and it is natively supported by BYOND.
SUBSYSTEM_DEF(sqlite)
	name = "SQLite"
	init_order = INIT_ORDER_SQLITE
	flags = SS_NO_FIRE
	var/database/sqlite_db = null

/datum/controller/subsystem/sqlite/Initialize(timeofday)
	connect()
	if(sqlite_db)
		init_schema(sqlite_db)
	return ..()

/datum/controller/subsystem/sqlite/proc/connect()
	if(!CONFIG_GET(flag/sqlite_enabled))
		return

	if(!sqlite_db)
		sqlite_db = new("data/sqlite/sqlite.db") // The path has to be hardcoded or BYOND silently fails.


	if(!sqlite_db)
		to_world_log("Failed to load or create a SQLite database.")
		log_debug("ERROR: SQLite database is active in config but failed to load.")
	else
		to_world_log("Sqlite database connected.")

// Makes the tables, if they do not already exist in the sqlite file.
/datum/controller/subsystem/sqlite/proc/init_schema(database/sqlite_object)
	// Feedback table.
	// Note that this is for direct feedback from players using the in-game feedback system and NOT for stat tracking.
	// Player ckeys are not stored in this table as a unique key due to a config option to hash the keys to encourage more honest feedback.
	/*
	 * id			- Primary unique key to ID a specific piece of feedback.
	 					NOT used to id people submitting feedback.
	 * author		- The person who submitted it. Will be the ckey, or a hash of the ckey,
	 					if both the config supports it, and the user wants it.
	 * topic		- A specific category to organize feedback under. Options are defined in the config file.
	 * content		- What the author decided to write to the staff. Limited to MAX_FEEDBACK_LENGTH.
	 * datetime		- When the author submitted their feedback, acts as a timestamp.
	 */
	var/database/query/init_schema = new(
		{"
		CREATE TABLE IF NOT EXISTS [SQLITE_TABLE_FEEDBACK]
		(
			`[SQLITE_FEEDBACK_COLUMN_ID]`		INTEGER NOT NULL UNIQUE,
			`[SQLITE_FEEDBACK_COLUMN_AUTHOR]`	TEXT NOT NULL,
			`[SQLITE_FEEDBACK_COLUMN_TOPIC]`	TEXT NOT NULL,
			`[SQLITE_FEEDBACK_COLUMN_CONTENT]`	TEXT NOT NULL,
			`[SQLITE_FEEDBACK_COLUMN_DATETIME]`	TEXT NOT NULL,
			PRIMARY KEY(`[SQLITE_FEEDBACK_COLUMN_ID]`)
		);
		"}
	)
	init_schema.Execute(sqlite_object)
	sqlite_check_for_errors(init_schema, "Feedback table creation")

	// Add more schemas below this if the SQLite DB gets expanded for things like persistant news, polls, bans, deaths, etc.

// General error checking for SQLite.
// Returns true if something went wrong. Also writes a log.
// The desc parameter should be unique for each call, to make it easier to track down where the error occured.
/datum/controller/subsystem/sqlite/proc/sqlite_check_for_errors(var/database/query/query_used, var/desc)
	if(query_used && query_used.ErrorMsg())
		log_debug("SQLite Error: [desc] : [query_used.ErrorMsg()]")
		return TRUE
	return FALSE


/************
 * Feedback *
 ************/

// Inserts data into the feedback table in a painless manner.
// Returns TRUE if no issues happened, FALSE otherwise.
/datum/controller/subsystem/sqlite/proc/insert_feedback(author, topic, content, database/sqlite_object)
	if(!author || !topic || !content)
		CRASH("One or more parameters was invalid.")

	// Sanitize everything to avoid sneaky stuff.
	var/sqlite_author = sql_sanitize_text(ckey(lowertext(author)))
	var/sqlite_content = sql_sanitize_text(content)
	var/sqlite_topic = sql_sanitize_text(topic)

	var/database/query/query = new(
	"INSERT INTO [SQLITE_TABLE_FEEDBACK] (\
		[SQLITE_FEEDBACK_COLUMN_AUTHOR], \
		[SQLITE_FEEDBACK_COLUMN_TOPIC], \
		[SQLITE_FEEDBACK_COLUMN_CONTENT], \
		[SQLITE_FEEDBACK_COLUMN_DATETIME]) \
		\
		VALUES (\
		?,\
		?,\
		?,\
		datetime('now'))",
		sqlite_author,
		sqlite_topic,
		sqlite_content
		)
	query.Execute(sqlite_object)
	return !sqlite_check_for_errors(query, "Insert Feedback")

/datum/controller/subsystem/sqlite/proc/can_submit_feedback(client/C)
	if(!CONFIG_GET(flag/sqlite_enabled))
		return FALSE
	if(CONFIG_GET(number/sqlite_feedback_min_age) && !is_old_enough(C))
		return FALSE
	if(CONFIG_GET(number/sqlite_feedback_cooldown) > 0 && get_feedback_cooldown(C.key, CONFIG_GET(number/sqlite_feedback_cooldown), sqlite_db) > 0)
		return FALSE
	return TRUE

// Returns TRUE if the player is 'old' enough, according to the config.
/datum/controller/subsystem/sqlite/proc/is_old_enough(client/C)
	if(get_player_age(C.key) < CONFIG_GET(number/sqlite_feedback_min_age))
		return FALSE
	return TRUE


// Returns how many days someone has to wait, to submit more feedback, or 0 if they can do so right now.
/datum/controller/subsystem/sqlite/proc/get_feedback_cooldown(player_ckey, cooldown, database/sqlite_object)
	player_ckey = sql_sanitize_text(ckey(lowertext(player_ckey)))
	var/potential_hashed_ckey = sql_sanitize_text(md5(player_ckey + SSsqlite.get_feedback_pepper()))

	// First query is to get the most recent time the player has submitted feedback.
	var/database/query/query = new({"
		SELECT [SQLITE_FEEDBACK_COLUMN_DATETIME]
		FROM [SQLITE_TABLE_FEEDBACK]
		WHERE [SQLITE_FEEDBACK_COLUMN_AUTHOR] == ? OR [SQLITE_FEEDBACK_COLUMN_AUTHOR] == ?
		ORDER BY [SQLITE_FEEDBACK_COLUMN_DATETIME]
		DESC LIMIT 1;
		"},
		player_ckey,
		potential_hashed_ckey
	)
	query.Execute(sqlite_object)
	sqlite_check_for_errors(query, "Rate Limited Check 1")

	// It is possible this is their first time, so there won't be a next row.
	if(query.NextRow()) // If this is true, the user has submitted feedback at least once.
		var/list/row_data = query.GetRowData()
		var/last_submission_datetime = row_data[SQLITE_FEEDBACK_COLUMN_DATETIME]

		// Now we have the datetime, we need to do something to compare it.
		// Second query is to calculate the difference between two datetimes.
		// This is done on the SQLite side because parsing datetimes with BYOND is probably a bad idea.
		query = new(
			"SELECT julianday('now') - julianday(?) \
			AS 'datediff';",
			last_submission_datetime
			)
		query.Execute(sqlite_object)
		sqlite_check_for_errors(query, "Rate Limited Check 2")

		query.NextRow()
		row_data = query.GetRowData()
		var/date_diff = row_data["datediff"]

		// Now check if it's too soon to give more feedback.
		if(text2num(date_diff) < cooldown) // Too soon.
			return round(cooldown - date_diff, 0.1)
	return 0.0


// A Pepper is like a Salt but only one exists and is supposed to be outside of a database.
// If the file is properly protected, it can only be viewed/copied by sys-admins generating a log, which is much more conspicious than accessing/copying a DB.
// This stops mods/admins/etc from guessing the author by shoving names in an MD5 hasher until they pick the right one.
// Don't use this for things needing actual security.
/datum/controller/subsystem/sqlite/proc/get_feedback_pepper()
	var/pepper_file = file2list("config/sqlite_feedback_pepper.txt")
	var/pepper = null
	for(var/line in pepper_file)
		if(!line)
			continue
		if(length(line) == 0)
			continue
		else if(copytext(line, 1, 2) == "#")
			continue
		else
			pepper = line
			break
	return pepper

/datum/controller/subsystem/sqlite/CanProcCall(procname)
	return procname != "get_feedback_pepper"

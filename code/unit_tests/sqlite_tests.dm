/datum/unit_test/sqlite
	name = "SQLite template" // Template has to be in the name or this test will be ran, and fail.
	var/database/stub_sqlite_db = null

/datum/unit_test/sqlite/proc/setup_stub_db()
	fdel("data/sqlite/testing_[name].db") // In case any remain from a previous local test, so we can have a clean new database.
	stub_sqlite_db = new("data/sqlite/testing_[name].db") // Unfortunately, byond doesn't like having working sqlite stuff w/o a file existing.
	SSsqlite.init_schema(stub_sqlite_db)

// Feedback table tests.
/datum/unit_test/sqlite/feedback/insert
	name = "SQLITE FEEDBACK: Insert and Retrieve Data"

/datum/unit_test/sqlite/feedback/insert/start_test()
	// Arrange.
	setup_stub_db()
	var/test_author = "alice"
	var/test_topic = "Test"
	var/test_content = "Bob is lame."

	// Act.
	SSsqlite.insert_feedback(author = test_author, topic = test_topic, content = test_content, sqlite_object = stub_sqlite_db)
	var/database/query/Q = new("SELECT * FROM [SQLITE_TABLE_FEEDBACK]")
	Q.Execute(stub_sqlite_db)
	SSsqlite.sqlite_check_for_errors(Q, "Sqlite Insert Unit Test")
	Q.NextRow()

	// Assert.
	var/list/row_data = Q.GetRowData()
	if(row_data[SQLITE_FEEDBACK_COLUMN_AUTHOR] == test_author && row_data[SQLITE_FEEDBACK_COLUMN_TOPIC] == test_topic && row_data[SQLITE_FEEDBACK_COLUMN_CONTENT] == test_content)
		pass("No issues found.")
	else
		fail("Data insert and loading failed to have matching information.")
	return TRUE


/datum/unit_test/sqlite/feedback/cooldown
	name = "SQLITE FEEDBACK: Cooldown"

/datum/unit_test/sqlite/feedback/cooldown/start_test()
	// Arrange.
	setup_stub_db()
	var/days_to_wait = 1
	var/issues = 0

	// Act.
	SSsqlite.insert_feedback(author = "Alice", topic = "Testing", content = "This is a test.", sqlite_object = stub_sqlite_db)

	var/alice_cooldown_block = SSsqlite.get_feedback_cooldown("Alice", days_to_wait, stub_sqlite_db)
	var/bob_cooldown = SSsqlite.get_feedback_cooldown("Bob", days_to_wait, stub_sqlite_db)
	days_to_wait = 0
	var/alice_cooldown_allow = SSsqlite.get_feedback_cooldown("Alice", days_to_wait, stub_sqlite_db)

	// Assert.
	if(alice_cooldown_block <= 0)
		issues++
		log_unit_test("User 'Alice' did not receive a cooldown, when they were supposed to.")
	if(bob_cooldown > 0)
		issues++
		log_unit_test("User 'Bob' did receive a cooldown, when they did not do anything.")
	if(alice_cooldown_allow > 0)
		issues++
		log_unit_test("User 'Alice' did receive a cooldown, when no cooldown is supposed to be enforced.")

	if(issues)
		fail("[issues] issues were found.")
	else
		pass("No issues found.")
	return TRUE

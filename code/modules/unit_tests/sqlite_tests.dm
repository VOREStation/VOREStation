/// converted unit test, maybe should be fully refactored

/// Test that inserts and retrieves data from an sqlite database
/datum/unit_test/sqlite_tests_insert

/datum/unit_test/sqlite_tests_insert/Run()
	// Arrange.
	fdel("data/sqlite/testing_sqlite_tests_insert.db") // In case any remain from a previous local test, so we can have a clean new database.
	var/database/stub_sqlite_db = new("data/sqlite/testing_sqlite_tests_insert.db") // Unfortunately, byond doesn't like having working sqlite stuff w/o a file existing.
	SSsqlite.init_schema(stub_sqlite_db)

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
	if(!(row_data[SQLITE_FEEDBACK_COLUMN_AUTHOR] == test_author && row_data[SQLITE_FEEDBACK_COLUMN_TOPIC] == test_topic && row_data[SQLITE_FEEDBACK_COLUMN_CONTENT] == test_content))
		TEST_FAIL("Data insert and loading failed to have matching information.")

/// Test that does a cooldown in a sqlite database
/datum/unit_test/sqlite_tests_cooldown

/datum/unit_test/sqlite_tests_cooldown/Run()
	// Arrange.
	fdel("data/sqlite/testing_sqlite_tests_cooldown.db") // In case any remain from a previous local test, so we can have a clean new database.
	var/database/stub_sqlite_db = new("data/sqlite/testing_sqlite_tests_cooldown.db") // Unfortunately, byond doesn't like having working sqlite stuff w/o a file existing.
	SSsqlite.init_schema(stub_sqlite_db)

	var/days_to_wait = 1
	var/issues = 0

	// Act.
	SSsqlite.insert_feedback(author = "Alice", topic = "Testing", content = "This is a test.", sqlite_object = stub_sqlite_db)

	var/alice_cooldown_block = SSsqlite.get_feedback_cooldown("Alice", days_to_wait, stub_sqlite_db)
	var/bob_cooldown = SSsqlite.get_feedback_cooldown("Bob", days_to_wait, stub_sqlite_db)
	days_to_wait = 0
	var/alice_cooldown_allow = SSsqlite.get_feedback_cooldown("Alice", days_to_wait, stub_sqlite_db)

	// Assert.
	TEST_ASSERT(alice_cooldown_block >= 0, "User 'Alice' did not receive a cooldown, when they were supposed to.")
	TEST_ASSERT(bob_cooldown < 0, "User 'Bob' did receive a cooldown, when they did not do anything.")
	TEST_ASSERT(alice_cooldown_allow < 0, "User 'Alice' did receive a cooldown, when no cooldown is supposed to be enforced.")

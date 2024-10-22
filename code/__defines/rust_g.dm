// rust_g.dm - DM API for rust_g extension library
//
// To configure, create a `rust_g.config.dm` and set what you care about from
// the following options:
//
// #define RUST_G "path/to/rust_g"
// Override the .dll/.so detection logic with a fixed path or with detection
// logic of your own.
//
// #define RUSTG_OVERRIDE_BUILTINS
// Enable replacement rust-g functions for certain builtins. Off by default.

#ifndef RUST_G
// Default automatic RUST_G detection.
// On Windows, looks in the standard places for `rust_g.dll`.
// On Linux, looks in `.`, `$LD_LIBRARY_PATH`, and `~/.byond/bin` for either of
// `librust_g.so` (preferred) or `rust_g` (old).

/* This comment bypasses grep checks */ /var/__rust_g

/proc/__detect_rust_g()
	if (world.system_type == UNIX)
		if (fexists("./librust_g.so"))
			// No need for LD_LIBRARY_PATH badness.
			return __rust_g = "./librust_g.so"
		else if (fexists("./rust_g"))
			// Old dumb filename.
			return __rust_g = "./rust_g"
		else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/rust_g"))
			// Old dumb filename in `~/.byond/bin`.
			return __rust_g = "rust_g"
		else
			// It's not in the current directory, so try others
			return __rust_g = "librust_g.so"
	else
		return __rust_g = "rust_g"

#define RUST_G (__rust_g || __detect_rust_g())
#endif

// Handle 515 call() -> call_ext() changes
#if DM_VERSION >= 515
#define RUSTG_CALL call_ext
#else
#define RUSTG_CALL call
#endif

/// Gets the version of rust_g
/proc/rustg_get_version() return RUSTG_CALL(RUST_G, "get_version")()

#define rustg_dmi_strip_metadata(fname) RUSTG_CALL(RUST_G, "dmi_strip_metadata")(fname)
#define rustg_dmi_create_png(path, width, height, data) RUSTG_CALL(RUST_G, "dmi_create_png")(path, width, height, data)
#define rustg_dmi_resize_png(path, width, height, resizetype) RUSTG_CALL(RUST_G, "dmi_resize_png")(path, width, height, resizetype)
/**
 * input: must be a path, not an /icon; you have to do your own handling if it is one, as icon objects can't be directly passed to rustg.
 *
 * output: json_encode'd list. json_decode to get a flat list with icon states in the order they're in inside the .dmi
 */
#define rustg_dmi_icon_states(fname) RUSTG_CALL(RUST_G, "dmi_icon_states")(fname)

#define rustg_file_read(fname) RUSTG_CALL(RUST_G, "file_read")(fname)
#define rustg_file_exists(fname) (RUSTG_CALL(RUST_G, "file_exists")(fname) == "true")
#define rustg_file_write(text, fname) RUSTG_CALL(RUST_G, "file_write")(text, fname)
#define rustg_file_append(text, fname) RUSTG_CALL(RUST_G, "file_append")(text, fname)
#define rustg_file_get_line_count(fname) text2num(RUSTG_CALL(RUST_G, "file_get_line_count")(fname))
#define rustg_file_seek_line(fname, line) RUSTG_CALL(RUST_G, "file_seek_line")(fname, "[line]")

#ifdef RUSTG_OVERRIDE_BUILTINS
#define file2text(fname) rustg_file_read("[fname]")
#define text2file(text, fname) rustg_file_append(text, "[fname]")
#endif

/// Returns the git hash of the given revision, ex. "HEAD".
#define rustg_git_revparse(rev) RUSTG_CALL(RUST_G, "rg_git_revparse")(rev)

/**
 * Returns the date of the given revision in the format YYYY-MM-DD.
 * Returns null if the revision is invalid.
 */
#define rustg_git_commit_date(rev) RUSTG_CALL(RUST_G, "rg_git_commit_date")(rev)

#define rustg_hash_string(algorithm, text) LIBCALL(RUST_G, "hash_string")(algorithm, text)
#define rustg_hash_file(algorithm, fname) LIBCALL(RUST_G, "hash_file")(algorithm, fname)

#define RUSTG_HASH_MD5 "md5"
#define RUSTG_HASH_SHA1 "sha1"
#define RUSTG_HASH_SHA256 "sha256"
#define RUSTG_HASH_SHA512 "sha512"

#ifdef RUSTG_OVERRIDE_BUILTINS
#define md5(thing) (isfile(thing) ? rustg_hash_file(RUSTG_HASH_MD5, "[thing]") : rustg_hash_string(RUSTG_HASH_MD5, thing))
#endif

#define RUSTG_HTTP_METHOD_GET "get"
#define RUSTG_HTTP_METHOD_PUT "put"
#define RUSTG_HTTP_METHOD_DELETE "delete"
#define RUSTG_HTTP_METHOD_PATCH "patch"
#define RUSTG_HTTP_METHOD_HEAD "head"
#define RUSTG_HTTP_METHOD_POST "post"
#define rustg_http_request_blocking(method, url, body, headers, options) RUSTG_CALL(RUST_G, "http_request_blocking")(method, url, body, headers, options)
#define rustg_http_request_async(method, url, body, headers, options) RUSTG_CALL(RUST_G, "http_request_async")(method, url, body, headers, options)
#define rustg_http_check_request(req_id) RUSTG_CALL(RUST_G, "http_check_request")(req_id)

#define RUSTG_JOB_NO_RESULTS_YET "NO RESULTS YET"
#define RUSTG_JOB_NO_SUCH_JOB "NO SUCH JOB"
#define RUSTG_JOB_ERROR "JOB PANICKED"

#define rustg_json_is_valid(text) (RUSTG_CALL(RUST_G, "json_is_valid")(text) == "true")

#define rustg_log_write(fname, text, format) LIBCALL(RUST_G, "log_write")(fname, text, format)
/proc/rustg_log_close_all() return LIBCALL(RUST_G, "log_close_all")()

#define rustg_noise_get_at_coordinates(seed, x, y) RUSTG_CALL(RUST_G, "noise_get_at_coordinates")(seed, x, y)

/*
 * Takes in a string and json_encode()"d lists to produce a sanitized string.
 * This function operates on whitelists, there is currently no way to blacklist.
 * Args:
 * * text: the string to sanitize.
 * * attribute_whitelist_json: a json_encode()'d list of HTML attributes to allow in the final string.
 * * tag_whitelist_json: a json_encode()'d list of HTML tags to allow in the final string.
 */
#define rustg_sanitize_html(text, attribute_whitelist_json, tag_whitelist_json) RUSTG_CALL(RUST_G, "sanitize_html")(text, attribute_whitelist_json, tag_whitelist_json)

#define rustg_sql_connect_pool(options) LIBCALL(RUST_G, "sql_connect_pool")(options)
#define rustg_sql_query_async(handle, query, params) LIBCALL(RUST_G, "sql_query_async")(handle, query, params)
#define rustg_sql_query_blocking(handle, query, params) LIBCALL(RUST_G, "sql_query_blocking")(handle, query, params)
#define rustg_sql_connected(handle) LIBCALL(RUST_G, "sql_connected")(handle)
#define rustg_sql_disconnect_pool(handle) LIBCALL(RUST_G, "sql_disconnect_pool")(handle)
#define rustg_sql_check_query(job_id) LIBCALL(RUST_G, "sql_check_query")("[job_id]")

#define rustg_time_microseconds(id) text2num(RUSTG_CALL(RUST_G, "time_microseconds")(id))
#define rustg_time_milliseconds(id) text2num(RUSTG_CALL(RUST_G, "time_milliseconds")(id))
#define rustg_time_reset(id) RUSTG_CALL(RUST_G, "time_reset")(id)

/// Returns the timestamp as a string
/proc/rustg_unix_timestamp()
	return RUSTG_CALL(RUST_G, "unix_timestamp")()

#define rustg_raw_read_toml_file(path) json_decode(RUSTG_CALL(RUST_G, "toml_file_to_json")(path) || "null")

/proc/rustg_read_toml_file(path)
	var/list/output = rustg_raw_read_toml_file(path)
	if (output["success"])
		return json_decode(output["content"])
	else
		CRASH(output["content"])

#define rustg_raw_toml_encode(value) json_decode(RUSTG_CALL(RUST_G, "toml_encode")(json_encode(value)))

/proc/rustg_toml_encode(value)
	var/list/output = rustg_raw_toml_encode(value)
	if (output["success"])
		return output["content"]
	else
		CRASH(output["content"])

#define rustg_url_encode(text) RUSTG_CALL(RUST_G, "url_encode")("[text]")
#define rustg_url_decode(text) RUSTG_CALL(RUST_G, "url_decode")(text)

#ifdef RUSTG_OVERRIDE_BUILTINS
	#define url_encode(text) rustg_url_encode(text)
	#define url_decode(text) rustg_url_decode(text)
#endif

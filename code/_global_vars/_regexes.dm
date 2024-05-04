//These are a bunch of regex datums for use /((any|every|no|some|head|foot)where(wolf)?\sand\s)+(\.[\.\s]+\s?where\?)?/i
GLOBAL_DATUM_INIT(is_http_protocol, /regex, regex("^https?://"))

GLOBAL_DATUM_INIT(is_valid_url, /regex, regex("((?:https://)\[-a-zA-Z0-9@:%._+~#=]{1,256}.\[-a-zA-Z0-9@:%._+~#=]{1,256}\\b(?:\[-a-zA-Z0-9@():%_+.,~#?&/=]*\[^.,!?:; ()<>{}\\[]\n\"'´`]))", "gm"))

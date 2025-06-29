#define TOKENIZATION_REGEX @#\s+(?=(?:[^"]*"[^"]*")*[^"]*$)#
/*
The regex above is responsible for splitting up a command into a nice list that we can parse.

> "target command "command argument" test 123"
results in a list containing:
	target, command, command argument, test, 123

> "target command "command argument test 123"
results in a list containing
	target, command, command, argument, test, 123

*/
//TODO: Move this to the network datum?
/proc/TokenizeString(var/input) as list
	if(!istext(input))
		return COMMAND_RESULT_INVALID
	input = CleanTokenInput(input)
	var/list/tokens = list()
	var/regex/r = new(TOKENIZATION_REGEX)
	tokens = splittext(input, r)
	for(var/i = 1 to tokens.len)
		tokens[i] = replacetext_char(tokens[i],"\"","")

	return tokens

#undef TOKENIZATION_REGEX


/proc/ParseTokens(var/list/input) //returns a list if no errors, or a string if there's issues
	if(!islist(input))
		return COMMAND_RESULT_INVALID
	if(input.len < 2) //prefix, command @ minimum. return an error
		return COMMAND_RESULT_TOO_SHORT

	var/prefix = input[TOKEN_INDEX_PREFIX]
	if(!(prefix in ALL_COMMAND_PREFIXES)) //if we don't have a valid prefix(somehow) return an error
		return COMMAND_RESULT_UNKNOWN_PREFIX(input[COMMAND_ARGUMENT_PREFIX])

	var/list/prefix_config = LAZYACCESS(COMMAND_PREFIX_CONFIG,prefix)
	if(!prefix_config)
		return COMMAND_RESULT_UNKNOWN_PREFIX(prefix + " (Invalid Config?)")

	var/ignore_target = prefix_config[COMMAND_CONFIG_CONSUMES_TARGET]
	if(!ignore_target)
		if(input.len < 3)
			return COMMAND_RESULT_TOO_SHORT

	var/list/sorted_tokens = list()

	sorted_tokens[COMMAND_ARGUMENT_PREFIX] = prefix

	/*
	Basically: if our prefix is >< or >@@ (anything that doesn't need a target), we skip the target & fill it in with a dummy value
	(distinct enough that commands can use it to determine the scope they were called from)
	*/

	if(ignore_target)
		sorted_tokens[COMMAND_ARGUMENT_TARGET] = COMMAND_VALUE_TARGET_CONSUMED
		sorted_tokens[COMMAND_ARGUMENT_COMMAND] = input[TOKEN_INDEX_COMMAND-1] //the command is where the target is for the more tightly scoped prefixes

	else
		sorted_tokens[COMMAND_ARGUMENT_TARGET] = input[TOKEN_INDEX_TARGET]
		sorted_tokens[COMMAND_ARGUMENT_COMMAND] = input[TOKEN_INDEX_COMMAND]

	var/list/remaining_tokens = list()
	if(ignore_target)
		if(input.len >= TOKEN_INDEX_COMMAND)
			remaining_tokens = input.Copy(TOKEN_INDEX_COMMAND) //copy everything after
	else
		if(input.len >= TOKEN_INDEX_COMMAND+1)
			remaining_tokens = input.Copy(TOKEN_INDEX_COMMAND+1) //copy everything after

	sorted_tokens[COMMAND_ARGUMENT_ARGUMENTS] = list()
	sorted_tokens[COMMAND_ARGUMENT_FLAGS] = list()
	sorted_tokens[COMMAND_ARGUMENT_FLAGS_GLOBAL] = list()

	if(remaining_tokens.len == 0)
		return sorted_tokens //nothing left to send

	//construct arguments & flags list
	var/last_argument_ind = 0

	for(var/token in remaining_tokens)
		if(starts_with_any(token,list("--","-"))) //it's a flag
			//if there's no valid index, we assume the flag's global. for stuff like >target command -flag argument --flag -argumentflag
			//the result would have -argumentflag assigned to argument, and the first flag assigned to be global
			if(IS_GLOBAL_COMMAND_FLAG(token) || last_argument_ind == 0)
				LAZYADDASSOC(sorted_tokens,COMMAND_ARGUMENT_FLAGS_GLOBAL,token)
			else
				sorted_tokens[COMMAND_ARGUMENT_FLAGS][last_argument_ind][COMMAND_ARGUMENT_FLAGS] |= token //getting a bad index here. why?
			continue
		else //it's an argument
			LAZYADDASSOCLIST(sorted_tokens,COMMAND_ARGUMENT_FLAGS,list(COMMAND_ARGUMENT_NAME = token, COMMAND_ARGUMENT_FLAGS = list()))
			LAZYADDASSOC(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS,token)
			last_argument_ind++

	return sorted_tokens

//TODO: make generic
/proc/starts_with_prefix(var/input_text)
	var trimmed = input_text // make sure you're not altering input unintentionally
	for(var/prefix in ALL_COMMAND_PREFIXES)
		if(copytext(trimmed, 1, LAZYLEN(prefix)+1) == prefix)
			return prefix
	return null

/proc/CleanTokenInput(var/input)
	input = trimtext(input) //fuck you whitespace demon
	var/prefix = starts_with_prefix(input)
	var/prefix_found = TRUE
	//basically just split the prefix so it gets into its own token
	if(!prefix)
		prefix_found = FALSE
		prefix = COMMAND_PREFIX_TARGET_ONCE + " "
		input = prefix + input

	if(prefix_found)
		input = replacetext_char(input,prefix,prefix+" ",1,LAZYLEN(prefix)+1) //clean the prefix so it's always going to be its own token

	return input

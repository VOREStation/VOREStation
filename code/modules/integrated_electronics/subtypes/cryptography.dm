/obj/item/integrated_circuit/cryptography
	complexity = 3
	inputs = list("input" = IC_PINTYPE_STRING)
	outputs = list("result" = IC_PINTYPE_STRING)
	activators = list("compute" = IC_PINTYPE_PULSE_IN, "on computed" = IC_PINTYPE_PULSE_OUT)
	category_text = "Cryptography"
	power_draw_per_use = 10

// HASH FUNCTIONS

/obj/item/integrated_circuit/cryptography/hash_md5
	name = "MD5 hash circuit"
	desc = "Message-Digest Algorithm 5"
	extended_desc = "This circuit will take a string input and generates the MD5 hash of it."
	icon_state = "template"
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/cryptography/hash_md5/do_work()
	var/result = ""
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(!isnull(I.data))
			result = md5(I.data)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/cryptography/hash_sha1
	name = "SHA1 hash circuit"
	desc = "Secure Hash Algorithm 1"
	extended_desc = "This circuit will take a string input and generates the SHA1 hash of it."
	icon_state = "template"
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/cryptography/hash_sha1/do_work()
	var/result = ""
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(!isnull(I.data))
			result = sha1(I.data)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


// ENCRYPTION/DECRYPTION

/obj/item/integrated_circuit/cryptography/rot13
	name = "rot13 circuit"
	desc = "A very simple encryption circuit."
	extended_desc = "The 'rotation' field will default to 13 if no custom number is supplied. This circuit rotates every letter by X in the alphabet."
	icon_state = "template"
	inputs = list(
		"input" = IC_PINTYPE_STRING,
		"rotation" = IC_PINTYPE_NUMBER
		)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/cryptography/rot13/do_work()
	var/result = ""

	var/input = get_pin_data(IC_INPUT, 1)
	var/rotation = get_pin_data(IC_INPUT, 2)

	var/string_len = length(input)

	if(!isnum(rotation))
		rotation = 13

	for(var/i = 1, i <= string_len, i++)
		var/ascii = text2ascii(input, i)
		if(ascii >= 65 && ascii <= 90)
			ascii += rotation
			if(ascii > 90)
				ascii -= 26

		else if(ascii >= 97 && ascii <= 122)
			ascii += rotation
			if(ascii > 122)
				ascii -= 26

		result += ascii2text(ascii)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

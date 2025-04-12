/datum/browser
	var/mob/user
	var/title
	var/window_id // window_id is used as the window name for browse and onclose
	var/width = 0
	var/height = 0
	var/datum/weakref/ref = null
	var/window_options = "can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;" // window option is set using window_id
	var/stylesheets[0]
	var/scripts[0]
	var/head_elements
	var/body_elements
	var/head_content = ""
	var/content = ""

/datum/browser/New(nuser, nwindow_id, ntitle = 0, nwidth = 0, nheight = 0, atom/nref = null)
	user = nuser
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(user_deleted))
	window_id = nwindow_id
	if (ntitle)
		title = format_text(ntitle)
	if (nwidth)
		width = nwidth
	if (nheight)
		height = nheight
	if (nref)
		ref = WEAKREF(nref)

/datum/browser/proc/user_deleted(datum/source)
	SIGNAL_HANDLER
	user = null

/datum/browser/proc/add_head_content(nhead_content)
	head_content = nhead_content

/datum/browser/proc/set_window_options(nwindow_options)
	window_options = nwindow_options

/datum/browser/proc/add_stylesheet(name, file)
	if (istype(name, /datum/asset/spritesheet))
		var/datum/asset/spritesheet/sheet = name
		stylesheets["spritesheet_[sheet.name].css"] = "data/spritesheets/[sheet.name]"
	else if (istype(name, /datum/asset/spritesheet_batched))
		var/datum/asset/spritesheet_batched/sheet = name
		stylesheets["spritesheet_[sheet.name].css"] = "data/spritesheets/[sheet.name]"
	else
		var/asset_name = "[name].css"

		stylesheets[asset_name] = file

		if (!SSassets.cache[asset_name])
			SSassets.transport.register_asset(asset_name, file)

/datum/browser/proc/add_script(name, file)
	scripts["[ckey(name)].js"] = file
	SSassets.transport.register_asset("[ckey(name)].js", file)

/datum/browser/proc/set_content(ncontent)
	content = ncontent

/datum/browser/proc/add_content(ncontent)
	content += ncontent

/datum/browser/proc/get_header()
	var/datum/asset/simple/namespaced/common/common_asset = get_asset_datum(/datum/asset/simple/namespaced/common)
	var/file

	// If a client exists, but they have disabled fancy windowing, disable it!
	if(user?.client?.prefs?.read_preference(/datum/preference/toggle/browser_style))
		head_content += "<link rel='stylesheet' type='text/css' href='[common_asset.get_url_mappings()["common.css"]]'>"
	for (file in stylesheets)
		head_content += "<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url(file)]'>"

	if(user.client?.window_scaling && user.client?.window_scaling != 1 && !user.client?.prefs.read_preference(/datum/preference/toggle/ui_scale) && width && height)
		head_content += {"
			<style>
				body {
					zoom: [100 / user.client?.window_scaling]%;
				}
			</style>
			"}

	for (file in scripts)
		head_content += "<script type='text/javascript' src='[SSassets.transport.get_asset_url(file)]'></script>"

	return {"<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge'>
		[head_content]
	</head>
	<body scroll=auto>
		<div class='uiWrapper'>
			[title ? "<div class='uiTitleWrapper'><div class='uiTitle'><tt>[title]</tt></div></div>" : ""]
			<div class='uiContent'>
	"}
//" This is here because else the rest of the file looks like a string in notepad++.
/datum/browser/proc/get_footer()
	return {"
			</div>
		</div>
	</body>
</html>"}

/datum/browser/proc/get_content()
	return {"
	[get_header()]
	[content]
	[get_footer()]
	"}

/datum/browser/proc/open(use_onclose = TRUE)
	if(isnull(window_id)) //null check because this can potentially nuke goonchat
		WARNING("Browser [title] tried to open with a null ID")
		to_chat(user, span_userdanger("The [title] browser you tried to open failed a sanity check! Please report this on GitHub!"))
		return
	var/window_size = ""
	if(width && height)
		if(user.client?.prefs?.read_preference(/datum/preference/toggle/ui_scale))
			var/scaling = user.client.window_scaling
			window_size = "size=[width * scaling]x[height * scaling];"
		else
			window_size = "size=[width]x[height];"
	var/datum/asset/simple/namespaced/common/common_asset = get_asset_datum(/datum/asset/simple/namespaced/common)
	common_asset.send(user)
	if (stylesheets.len)
		SSassets.transport.send_assets(user, stylesheets)
	if (scripts.len)
		SSassets.transport.send_assets(user, scripts)
	user << browse(get_content(), "window=[window_id];[window_size][window_options]")
	if (use_onclose)
		setup_onclose()

/datum/browser/proc/setup_onclose()
	set waitfor = 0 //winexists sleeps, so we don't need to.
	for (var/i in 1 to 10)
		if (user?.client && winexists(user, window_id))
			var/atom/send_ref
			if(ref)
				send_ref = ref.resolve()
				if(!send_ref)
					ref = null
			onclose(user, window_id, send_ref)
			break

/datum/browser/proc/close()
	if(!isnull(window_id))//null check because this can potentially nuke goonchat
		user << browse(null, "window=[window_id]")
	else
		WARNING("Browser [title] tried to close with a null ID")

/datum/browser/modal/alert/New(User,Message,Title,Button1="Ok",Button2,Button3,StealFocus = 1,Timeout=6000)
	if (!User)
		return

	var/output = {"<center><b>[Message]</b></center><br />
		<div style="text-align:center">
		<a style="font-size:large;float:[( Button2 ? "left" : "right" )]" href='byond://?src=[REF(src)];button=1'>[Button1]</a>"}

	if (Button2)
		output += {"<a style="font-size:large;[( Button3 ? "" : "float:right" )]" href='byond://?src=[REF(src)];button=2'>[Button2]</a>"}

	if (Button3)
		output += {"<a style="font-size:large;float:right" href='byond://?src=[REF(src)];button=3'>[Button3]</a>"}

	output += {"</div>"}

	..(User, ckey("[User]-[Message]-[Title]-[world.time]-[rand(1,10000)]"), Title, 350, 150, src, StealFocus, Timeout)
	set_content(output)

/datum/browser/modal/alert/Topic(href,href_list)
	if (href_list["close"] || !user || !user.client)
		opentime = 0
		return
	if (href_list["button"])
		var/button = text2num(href_list["button"])
		if (button <= 3 && button >= 1)
			selectedbutton = button
	opentime = 0
	close()

/**
 * **DEPRECATED: USE tgui_alert(...) INSTEAD**
 *
 * Designed as a drop in replacement for alert(); functions the same. (outside of needing User specified)
 * Arguments:
 * * User - The user to show the alert to.
 * * Message - The textual body of the alert.
 * * Title - The title of the alert's window.
 * * Button1 - The first button option.
 * * Button2 - The second button option.
 * * Button3 - The third button option.
 * * StealFocus - Boolean operator controlling if the alert will steal the user's window focus.
 * * Timeout - The timeout of the window, after which no responses will be valid.
 */
/proc/tgalert(mob/User, Message, Title, Button1="Ok", Button2, Button3, StealFocus = TRUE, Timeout = 6000)
	if (!User)
		User = usr
	if (!istype(User))
		if (istype(User, /client))
			var/client/client = User
			User = client.mob
		else
			return

	// Get user's response using a modal
	var/datum/browser/modal/alert/A = new(User, Message, Title, Button1, Button2, Button3, StealFocus, Timeout)
	A.open()
	A.wait()
	switch(A.selectedbutton)
		if (1)
			return Button1
		if (2)
			return Button2
		if (3)
			return Button3

/datum/browser/modal
	var/opentime = 0
	var/timeout
	var/selectedbutton = 0
	var/stealfocus

/datum/browser/modal/New(nuser, nwindow_id, ntitle = 0, nwidth = 0, nheight = 0, atom/nref = null, StealFocus = 1, Timeout = 6000)
	..()
	stealfocus = StealFocus
	if (!StealFocus)
		window_options += "focus=false;"
	timeout = Timeout


/datum/browser/modal/close()
	.=..()
	opentime = 0

/datum/browser/modal/open(use_onclose)
	set waitfor = FALSE
	opentime = world.time

	if (stealfocus)
		. = ..(use_onclose = 1)
	else
		var/focusedwindow = winget(user, null, "focus")
		. = ..(use_onclose = 1)

		//waits for the window to show up client side before attempting to un-focus it
		//winexists sleeps until it gets a reply from the client, so we don't need to bother sleeping
		for (var/i in 1 to 10)
			if (user && winexists(user, window_id))
				if (focusedwindow)
					winset(user, focusedwindow, "focus=true")
				else
					winset(user, "mapwindow", "focus=true")
				break
	if (timeout)
		addtimer(CALLBACK(src, PROC_REF(close)), timeout)

/datum/browser/modal/proc/wait()
	while (opentime && selectedbutton <= 0 && (!timeout || opentime+timeout > world.time))
		stoplag(1)

/datum/browser/modal/listpicker
	var/valueslist = list()

/datum/browser/modal/listpicker/New(User,Message,Title,Button1="Ok",Button2,Button3,StealFocus = 1, Timeout = FALSE,list/values,inputtype="checkbox", width, height, slidecolor)
	if (!User)
		return

	var/output = {"<form><input type="hidden" name="src" value="[REF(src)]"><ul class="sparse">"}
	if (inputtype == "checkbox" || inputtype == "radio")
		for (var/i in values)
			var/div_slider = slidecolor
			if(!i["allowed_edit"])
				div_slider = "locked"
			output += {"<li>
						<label class="switch">
							<input type="[inputtype]" value="1" name="[i["name"]]"[i["checked"] ? " checked" : ""][i["allowed_edit"] ? "" : " onclick='return false' onkeydown='return false'"]>
								<div class="slider [div_slider ? "[div_slider]" : ""]"></div>
									<span>[i["name"]]</span>
						</label>
						</li>"}
	else
		for (var/i in values)
			output += {"<li><input id="name="[i["name"]]"" style="width: 50px" type="[type]" name="[i["name"]]" value="[i["value"]]">
			<label for="[i["name"]]">[i["name"]]</label></li>"}
	output += {"</ul><div style="text-align:center">
		<button type="submit" name="button" value="1" style="font-size:large;float:[( Button2 ? "left" : "right" )]">[Button1]</button>"}

	if (Button2)
		output += {"<button type="submit" name="button" value="2" style="font-size:large;[( Button3 ? "" : "float:right" )]">[Button2]</button>"}

	if (Button3)
		output += {"<button type="submit" name="button" value="3" style="font-size:large;float:right">[Button3]</button>"}

	output += {"</form></div>"}
	..(User, ckey("[User]-[Message]-[Title]-[world.time]-[rand(1,10000)]"), Title, width, height, src, StealFocus, Timeout)
	set_content(output)

/datum/browser/modal/listpicker/Topic(href,href_list)
	if (href_list["close"] || !user || !user.client)
		opentime = 0
		return
	if (href_list["button"])
		var/button = text2num(href_list["button"])
		if (button <= 3 && button >= 1)
			selectedbutton = button
	for (var/item in href_list)
		switch(item)
			if ("close", "button", "src")
				continue
			else
				valueslist[item] = href_list[item]
	opentime = 0
	close()

/proc/presentpicker(mob/User,Message, Title, Button1="Ok", Button2, Button3, StealFocus = 1,Timeout = 6000,list/values, inputtype = "checkbox", width, height, slidecolor)
	if (!istype(User))
		if (istype(User, /client/))
			var/client/C = User
			User = C.mob
		else
			return
	var/datum/browser/modal/listpicker/A = new(User, Message, Title, Button1, Button2, Button3, StealFocus,Timeout, values, inputtype, width, height, slidecolor)
	A.open()
	A.wait()
	if (A.selectedbutton)
		return list("button" = A.selectedbutton, "values" = A.valueslist)

/proc/input_bitfield(var/mob/User, title, bitfield, current_value, nwidth = 350, nheight = 350, nslidecolor, allowed_edit_list = null)
	if (!User || !(bitfield in GLOB.bitfields))
		return
	var/list/pickerlist = list()
	for (var/i in GLOB.bitfields[bitfield])
		var/can_edit = 1
		if(!isnull(allowed_edit_list) && !(allowed_edit_list & GLOB.bitfields[bitfield][i]))
			can_edit = 0
		if (current_value & GLOB.bitfields[bitfield][i])
			pickerlist += list(list("checked" = 1, "value" = GLOB.bitfields[bitfield][i], "name" = i, "allowed_edit" = can_edit))
		else
			pickerlist += list(list("checked" = 0, "value" = GLOB.bitfields[bitfield][i], "name" = i, "allowed_edit" = can_edit))
	var/list/result = presentpicker(User, "", title, Button1="Save", Button2 = "Cancel", Timeout=FALSE, values = pickerlist, width = nwidth, height = nheight, slidecolor = nslidecolor)
	if (islist(result))
		if (result["button"] == 2) // If the user pressed the cancel button
			return
		. = 0
		for (var/flag in result["values"])
			. |= GLOB.bitfields[bitfield][flag]
	else
		return
//
/proc/onclose(mob/user, windowid, atom/ref=null)
	if(!user.client)
		return
	var/param = "null"
	if(ref)
		param = "[REF(ref)]"

	winset(user, windowid, "on-close=\".windowclose [param]\"")



// the on-close client verb
// called when a browser popup window is closed after registering with proc/onclose()
// if a valid atom reference is supplied, call the atom's Topic() with "close=1"
// otherwise, just reset the client mob's machine var.
//
/client/verb/windowclose(atomref as text)
	set hidden = TRUE // hide this verb from the user's panel
	set name = ".windowclose" // no autocomplete on cmd line

	if(atomref != "null") // if passed a real atomref
		var/hsrc = locate(atomref) // find the reffed atom
		var/href = "close=1"
		if(hsrc)
			usr = src.mob
			src.Topic(href, params2list(href), hsrc) // this will direct to the atom's
			return // Topic() proc via client.Topic()


/datum/browser/modal/color_matrix_picker
	var/color_matrix

/datum/browser/modal/color_matrix_picker/New(mob/user, message, title, button1 = "Ok", button2, button3, stealfocus = TRUE, timeout = 0, list/values)
	if(!user)
		return
	if(!values)
		values = list(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)
	if(values.len < 12)
		values.len = 12
	var/list/output = list()
	output += "<form><input type='hidden' name='src' value='[REF(src)]'>"
	output += "[message]"
#define MATRIX_FIELD(field, default) "<b><label for='[##field]'>[##field]</label></b> <input type='number' step='0.001' name='[field]' value='[default]'>"
	output += "<br><br>"
	output += MATRIX_FIELD("rr", values[1])
	output += MATRIX_FIELD("gr", values[4])
	output += MATRIX_FIELD("br", values[7])
	output += "<br><br>"
	output += MATRIX_FIELD("rg", values[2])
	output += MATRIX_FIELD("gg", values[5])
	output += MATRIX_FIELD("bg", values[8])
	output += "<br><br>"
	output += MATRIX_FIELD("rb", values[3])
	output += MATRIX_FIELD("gb", values[6])
	output += MATRIX_FIELD("bb", values[9])
	output += "<br><br>"
	output += MATRIX_FIELD("cr", values[10])
	output += MATRIX_FIELD("cg", values[11])
	output += MATRIX_FIELD("cb", values[12])
	output += "<br><br>"
#undef MATRIX_FIELD

	output += {"</ul><div style="text-align:center">
		<button type="submit" name="button" value="1" style="font-size:large;float:[( button2 ? "left" : "right" )]">[button1]</button>"}

	if (button2)
		output += {"<button type="submit" name="button" value="2" style="font-size:large;[( button3 ? "" : "float:right" )]">[button2]</button>"}

	if (button3)
		output += {"<button type="submit" name="button" value="3" style="font-size:large;float:right">[button3]</button>"}
	output += {"</form></div>"}

	..(user, ckey("[user]-[message]-[title]-[world.time]-[rand(1,10000)]"), title, 800, 400, src, stealfocus, timeout)
	set_content(output.Join(""))

/datum/browser/modal/color_matrix_picker/Topic(href, list/href_list)
	if(href_list["close"] || !user)
		opentime = 0
		return
	if(href_list["button"])
		var/button = text2num(href_list["button"])
		if(ISINRANGE(button, 1, 3))
			selectedbutton = button
	var/list/cm = rgb_construct_color_matrix(
		text2num(href_list["rr"]),
		text2num(href_list["rg"]),
		text2num(href_list["rb"]),
		text2num(href_list["gr"]),
		text2num(href_list["gg"]),
		text2num(href_list["gb"]),
		text2num(href_list["br"]),
		text2num(href_list["bg"]),
		text2num(href_list["bb"]),
		text2num(href_list["cr"]),
		text2num(href_list["cg"]),
		text2num(href_list["cb"])
	)
	if(cm)
		color_matrix = cm
	opentime = 0
	close()

/proc/color_matrix_picker(mob/user, message, title, button1 = "Ok", button2, button3, stealfocus, timeout = 10 MINUTES, list/values)
	if(!istype(user))
		if(istype(user, /client))
			var/client/C = user
			user = C.mob
		else
			return
	var/datum/browser/modal/color_matrix_picker/B = new(user, message, title, button1, button2, button3, stealfocus, timeout, values)
	B.open()
	B.wait()
	return list("button" = B.selectedbutton, "matrix" = B.color_matrix)

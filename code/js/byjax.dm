/*
sends data to control_id:replaceContent

receiver - mob
control_id - window id (for windows opened with browse(), it'll be "windowname.browser")
target_element - HTML element id
new_content - HTML content
callback - js function that will be called after the data is sent
callback_args - arguments for callback function

Be sure to include required js functions in your page, or it'll raise an exception.
*/
/proc/send_byjax(receiver, control_id, target_element, new_content=null, callback=null, list/callback_args=null)
	if(receiver && target_element && control_id) // && winexists(receiver, control_id))
		var/list/argums = list(target_element, new_content)
		if(callback)
			argums += callback
			if(callback_args)
				argums += callback_args
		argums = list2params(argums)
/*		if(callback_args)
			argums += "&[list2params(callback_args)]"
*/
		receiver << output(argums,"[control_id]:replaceContent")
	return

//The 'V' is for 'VORE' but you can pretend it's for Vue.js if you really want.

//Options for vchat
var vchat_opts = {
	crush_messages: 3, //How many messages back should we try to combine if crushing is on
	pingThisOften: 10000, //ms
	pingDropsAllowed: 2,
	cookiePrefix: "vst-" //If you're another server, you can change this if you want.
};

var DARKMODE_COLORS = {
	buttonBgColor: "#40628a",
	buttonTextColor: "#FFFFFF",
	windowBgColor: "#272727",
	highlightColor: "#009900",
	tabTextColor: "#FFFFFF",
	tabBackgroundColor: "#272727"
};

var LIGHTMODE_COLORS = {
	buttonBgColor: "none",
	buttonTextColor: "#000000",
	windowBgColor: "none",
	highlightColor: "#007700",
	tabTextColor: "#000000",
	tabBackgroundColor: "none"
};


/***********
*
* Setup Methods
*
************/

var set_storage = set_cookie;
var get_storage = get_cookie;
var domparser = new DOMParser();

//Upgrade to LS
if (storageAvailable('localStorage')) {
	set_storage = set_localstorage;
	get_storage = get_localstorage;
}

//State-tracking variables
var vchat_state = {
	ready: false,

	//Userinfo as reported by byond
	byond_ip: null,
	byond_cid: null,
	byond_ckey: null,

	//Ping status
	lastPingAttempt: 0,
	lastPingReply: 0,
	missedPings: 0,
	latency: 0,
	reconnecting: false
}

function start_vchat() {
	//Instantiate Vue.js
	start_vue();

	//Inform byond we're done
	vchat_state.ready = true;
	push_Topic('done_loading');

	//I'll do my own winsets
	doWinset("htmloutput", {"is-visible": true});
	doWinset("oldoutput", {"is-visible": false});
	doWinset("chatloadlabel", {"is-visible": false});
	
	//Commence the pingening
	send_ping();
	setInterval(send_ping, vchat_opts.pingThisOften);
}

//Loads vue for chat usage
var vueapp;
function start_vue() {
	vueapp = new Vue({
		el: '#app',
		data: {
			messages: [], //List o messages from byond
			tabs: [ //Our tabs
				{name: "Main", classes: ["vc_showall"], immutable: true, active: true}
			],
			always_show: ["vc_looc", "vc_system"], //Classes to always display on every tab
			unread_messages: {}, //Message categories that haven't been looked at since we got one of them
			editing: false, //If we're in settings edit mode
			paused: false, //Autoscrolling
			latency: 0, //Not necessarily network latency, since the game server has to align the responses into ticks
			ext_styles: "", //Styles for chat downloaded files
			is_admin: false,

			//Settings
			inverted: false, //Dark mode
			crushing: true, //Combine similar messages
			showingnum: 200, //How many messages to show
			animated: true, //Small CSS animations for new messages
			fontsize: "zoom_normal", //Font size nudging

			//The table to map game css classes to our vchat classes
			type_table: [
				{
					matches: ".say, .emote",
					becomes: "vc_localchat",
					pretty: "Local Chat",
					required: false,
					admin: false
				},
				{
					matches: ".alert, .syndradio, .centradio, .airadio, .entradio, .comradio, .secradio, .engradio, .medradio, .sciradio, .supradio, .srvradio, .expradio, .radio, .deptradio, .newscaster",
					becomes: "vc_radio",
					pretty: "Radio Comms",
					required: false,
					admin: false
				},
				{
					matches: ".notice, .adminnotice, .info, .sinister, .cult",
					becomes: "vc_info",
					pretty: "Notices",
					required: false,
					admin: false
				},
				{
					matches: ".critical, .danger, .userdanger, .warning, .italics",
					becomes: "vc_warnings",
					pretty: "Warnings",
					required: false,
					admin: false
				},
				{
					matches: ".deadsay",
					becomes: "vc_deadchat",
					pretty: "Deadchat",
					required: false,
					admin: false
				},
				{
					matches: ".ooc:not(.looc)",
					becomes: "vc_globalooc",
					pretty: "Global OOC",
					required: false,
					admin: false
				},
				{
					matches: ".pm",
					becomes: "vc_adminpm",
					pretty: "Admin PMs",
					required: false,
					admin: false
				},
				{
					matches: ".admin_channel",
					becomes: "vc_adminchat",
					pretty: "Admin Chat",
					required: false,
					admin: true
				},
				{
					matches: ".mod_channel",
					becomes: "vc_modchat",
					pretty: "Mod Chat",
					required: false,
					admin: true
				},
				{
					matches: ".event_channel",
					becomes: "vc_eventchat",
					pretty: "Event Chat",
					required: false,
					admin: true
				},
				{
					matches: ".ooc.looc, .ooc .looc", //Dumb game
					becomes: "vc_looc",
					pretty: "Local OOC",
					required: true
				},
				{
					matches: ".boldannounce",
					becomes: "vc_system",
					pretty: "System Messages",
					required: true
				}
			],
		},
		created: function() {
			/*Dog mode
			setTimeout(function(){
				document.body.className += " woof";
			},5000);
			*/
			/* Stress test
			var varthis = this;
			setInterval( function() {
				if(varthis.messages.length > 10000) {
					return;
				}
				var stringymessages = JSON.stringify(varthis.messages);
				var unstringy = JSON.parse(stringymessages);
				unstringy.forEach( function(message) {
					message.id = (varthis.messages.length + 1);
					varthis.messages.push(message);	
				});
				varthis.internal_message("Now have " + varthis.messages.length + " messages in array.");
			}, 10000);
			*/
		},
		mounted: function() {
			//Load our settings
			this.load_settings();

			var xhr = new XMLHttpRequest();
			xhr.open('GET', 'ss13styles.css');
			xhr.onreadystatechange = (function() {
				this.ext_styles = xhr.responseText;
			}).bind(this);
			xhr.send();
		},
		updated: function() {
			if(!this.editing && !this.paused) {
				window.scrollTo(0,document.getElementById("messagebox").scrollHeight);
			}
		},
		watch: {
			//Save the inverted setting to LS
			inverted: function (newSetting) {
				set_storage("darkmode",newSetting);
				if(newSetting) { //Special treatment for <body> which is outside Vue's scope and has custom css
					document.body.classList.add("inverted");
					switch_ui_mode(DARKMODE_COLORS);
				} else {
					document.body.classList.remove("inverted");
					switch_ui_mode(LIGHTMODE_COLORS);
				}
			}, 
			crushing: function (newSetting) {
				set_storage("crushing",newSetting);
			},
			animated: function (newSetting) {
				set_storage("animated",newSetting);
			},
			fontsize: function (newSetting) {
				set_storage("fontsize",newSetting);
			},
			showingnum: function (newSetting, oldSetting) {
				if(!isFinite(newSetting)) {
					this.showingnum = oldSetting;
					return;
				}
				
				newSetting = Math.floor(newSetting);
				if(newSetting <= 50) {
					this.showingnum = 50;
				} else if(newSetting > 2000) {
					this.showingnum = 2000;
				}
				set_storage("showingnum",this.showingnum);
			}
		},
		computed: {
			//Which tab is active?
			active_tab: function() {
				//Had to polyfill this stupid .find since IE doesn't have EC6
				let tab = this.tabs.find( function(tab) {
					return tab.active;
				});
				return tab;
			},
			//Which classes does the active tab need?
			active_classes: function() {
				let classarray = this.active_tab.classes;
				let classtext = classarray.toString(); //Convert to a string
				let classproper = classtext.replace(/,/g," ");
				if(this.inverted) classproper += " inverted";
				return classproper; //Swap commas for spaces
			},
			//What color does the latency pip get?
			ping_classes: function() {
				if(this.latency === 0) { return "grey"; }
				else if(this.latency < 0 ) {return "red"; }
				else if(this.latency <= 200) { return "green"; }
				else if(this.latency <= 400) { return "yellow"; }
				else { return "red"; }
			},
			shown_messages: function() {
				if(this.messages.length <= this.showingnum) {
					return this.messages;
				} else {
					return this.messages.slice(-1*this.showingnum);
				}
			}
		},
		methods: {
			//Load the chat settings
			load_settings: function() {
				this.inverted = get_storage("darkmode", false);
				this.crushing = get_storage("crushing", true);
				this.showingnum = get_storage("showingnum", 200);
				this.animated = get_storage("animated", true);
				this.fontsize = get_storage("fontsize", 'zoom_normal');
			},
			//Change to another tab
			switchtab: function(tab) {
				if(tab == this.active_tab) return;
				this.active_tab.active = false;
				tab.active = true;

				tab.classes.forEach( function(cls) {
					this.unread_messages[cls] = false;
				}, this);
			},
			//Toggle edit mode
			editmode: function() {
				this.editing = !this.editing;
			},
			//Toggle autoscroll
			pause: function() {
				this.paused = !this.paused;
			},
			//Create a new tab (stupid lack of classes in ES5...)
			newtab: function() {
				this.tabs.push({
					name: "New Tab",
					classes: this.always_show,
					immutable: false,
					active: false
				});
				this.switchtab(this.tabs[this.tabs.length - 1]);
			},
			//Rename an existing tab
			renametab: function() {
				if(this.active_tab.immutable) {
					return;
				}
				var tabtorename = this.active_tab;
				var newname = window.prompt("Type the desired tab name:", tabtorename.name);
				if(newname === null || newname === "" || tabtorename === null) {
					return;
				}
				tabtorename.name = newname;
			},
			//Delete the currently active tab
			deltab: function() {
				if(this.active_tab.immutable) {
					return;
				}
				var doomed_tab = this.active_tab;
				this.switchtab(this.tabs[0]);
				this.tabs.splice(this.tabs.indexOf(doomed_tab), 1);
			},
			tab_unread_classes: function(tab) {
				var unreads = false;
				var thisum = this.unread_messages;
				tab.classes.find( function(cls){
					if(thisum[cls]) {
						unreads = true;
						return true;
					}
				});

				return { red: unreads, grey: !unreads};
			},
			//Push a new message into our array
			add_message: function(message) {
				//IE doesn't support the 'class' syntactic sugar so we're left making our own object.
				let newmessage = {
					time: message.time,
					category: "error",
					content: message.message,
					repeats: 1
				};
				//Get a category
				newmessage.category = this.get_category(newmessage.content);
				if(!this.active_tab.classes.some(function(cls) { return (cls == newmessage.category || cls == "vc_showall"); })) {
					this.unread_messages[newmessage.category] = true;
				}

				//Try to crush it with one of the last few
				if(this.crushing) {
					let crushwith = this.messages.slice(-(vchat_opts.crush_messages));
					for (let i = crushwith.length - 1; i >= 0; i--) {
						let oldmessage = crushwith[i];
						if(oldmessage.content == newmessage.content) {
							newmessage.repeats += oldmessage.repeats;
							this.messages.splice(this.messages.indexOf(oldmessage), 1);
						}
					}
				}

				//Append to vue's messages
				newmessage.id = (this.messages.length + 1);
				this.messages.push(newmessage);
			},
			//Push an internally generated message into our array
			internal_message: function(message) {
				let newmessage = {
					time: this.messages.length ? this.messages.slice(-1).time+1 : 0,
					category: "vc_system",
					content: "<span class='notice'>[VChat Internal] " + message + "</span>"
				};
				newmessage.id = (this.messages.length + 1);
				this.messages.push(newmessage);
			},
			on_mouseup: function(event) {
				// Focus map window on mouseup so hotkeys work.  Exception for if they highlighted text or clicked an input.
				let ele = event.target;
				let textSelected = ('getSelection' in window) && window.getSelection().isCollapsed === false;
				if (!textSelected && !(ele && (ele.tagName === 'INPUT' || ele.tagName === 'TEXTAREA'))) {
					focusMapWindow();
					// Okay focusing map window appears to prevent click event from being fired.  So lets do it ourselves.
					event.preventDefault();
					event.target.click();
				}
			},
			click_message: function(event) {
				let ele = event.target;
				if(ele.tagName === "A") {
					event.stopPropagation();
					event.preventDefault ? event.preventDefault() : (event.returnValue = false); //The second one is the weird IE method.

					var href = ele.getAttribute('href'); // Gets actual href without transformation into fully qualified URL
					
					if (href[0] == '?' || (href.length >= 8 && href.substring(0,8) == "byond://")) {
						window.location = href; //Internal byond link
					} else { //It's an external link
						window.location = "byond://?action=openLink&link="+encodeURIComponent(href);
					}
				}
			},
			//Derive a vchat category based on css classes
			get_category: function(message) {
				if(!vchat_state.ready) {
					push_Topic('not_ready');
					return;
				}

				let doc = domparser.parseFromString(message, 'text/html');
				let evaluating = doc.querySelector('span');

				let category = "nomatch"; //What we use if the classes aren't anything we know.
				if(!evaluating) return category;
				this.type_table.find( function(type) {
					if(evaluating.msMatchesSelector(type.matches)) {
						category = type.becomes;
						return true;
					}
				});

				return category;
			},
			save_chatlog: function() {
				var textToSave = "<html><head><style>"+this.ext_styles+"</style></head><body>";
				this.messages.forEach( function(message) {
					textToSave += message.content;
					if(message.repeats > 1) {
						textToSave += "(x"+message.repeats+")";
					}
					textToSave += "<br>\n";
				});
				textToSave += "</body></html>";
				var hiddenElement = document.createElement('a');
				hiddenElement.href = 'data:attachment/text,' + encodeURI(textToSave);
				hiddenElement.target = '_blank';

				var filename = "chat_export.html";

				//Unlikely to work unfortunately, not supported in any version of IE, only Edge
				if (hiddenElement.download !== undefined){
            		hiddenElement.download = filename;
            		hiddenElement.click();
        		//Probably what will end up getting used
        		} else {
        			let blob = new Blob([textToSave], {type: 'text/html;charset=utf8;'});
        			saved = window.navigator.msSaveBlob(blob, filename);
        		}
			}
		}
	});
}

/***********
*
* Actual Methods
*
************/
//Send a 'ping' to byond and check to see if we got the last one back in a timely manner
function send_ping() {
	vchat_state.latency = (Math.min(Math.max(vchat_state.lastPingReply - vchat_state.lastPingAttempt, -1), 999));
	//If their last reply was in the previous ping window or earlier.
	if(vchat_state.latency < 0) {
		vchat_state.missedPings++;
		if((vchat_state.missedPings >= vchat_opts.pingDropsAllowed) && !vchat_state.reconnecting) {
			system_message("Your client has lost connection with the server. It will reconnect automatically if possible.");
			vchat_state.reconnecting = true;
		}
	}

	vueapp.latency = vchat_state.latency;
	push_Topic("keepalive_client");
	vchat_state.lastPingAttempt = Date.now();
}

//We accept double-url-encoded JSON strings because Byond is garbage and UTF-8 encoded url_encode() text has crazy garbage in it.
function byondDecode(message) {
	
	//Byond encodes spaces as pluses?! This is 1998 I guess.
	message = message.replace(/\+/g, "%20");
	try { 
		message = decodeURIComponent(message);
	} catch (err) {
		message = unescape(message);
	}
	return JSON.parse(message);
}

//This is the function byond actually communicates with using byond's client << output() method.
function putmessage(messages) {
	messages = byondDecode(messages);
	if (Array.isArray(messages)) {
		messages.forEach(function(message) {
			vueapp.add_message(message);
		});
	} else if (typeof messages === 'object') {
		vueapp.add_message(messages);
	}
}

//Send an internal message generated in the javascript
function system_message(message) {
	vueapp.internal_message(message);
}

//This is the other direction of communication, to push a Topic message back
function push_Topic(topic_uri) {
	window.location = '?_src_=chat&proc=' + topic_uri; //Yes that's really how it works.
}

//Tells byond client to focus the main map window.
function focusMapWindow() {
	window.location = 'byond://winset?mapwindow.map.focus=true';
}

//A side-channel to send events over that aren't just chat messages, if necessary.
function get_event(event) {
	if(!vchat_state.ready) {
		push_Topic('not_ready');
		return;
	}

	var parsed_event = {evttype: 'internal_error', event: event};
	parsed_event = byondDecode(event);

	switch(parsed_event.evttype) {
		//We didn't parse it very well
		case 'internal_error':
			system_message("Event parse error: " + event);
			break;
		
		//They provided byond data.
		case 'byond_player':
			send_client_data();
			vueapp.is_admin = (parsed_event.admin === 'true');
			vchat_state.byond_ip = parsed_event.address;
			vchat_state.byond_cid = parsed_event.cid;
			vchat_state.byond_ckey = parsed_event.ckey;
			set_storage("ip",vchat_state.byond_ip);
			set_storage("cid",vchat_state.byond_cid);
			set_storage("ckey",vchat_state.byond_ckey);
			break;

		//Just a ping.
		case 'keepalive_server':
			vchat_state.lastPingReply = Date.now();
			vchat_state.missedPings = 0;
			reconnecting = false;
			break;
	
		default: 
			system_message("Didn't know what to do with event: " + event);
	}
}

//Send information retrieved from storage
function send_client_data() {
	let client_data = {
		ip: get_storage("ip"),
		cid: get_storage("cid"),
		ckey: get_storage("ckey")
	};
	push_Topic("ident&param[clientdata]="+JSON.stringify(client_data));
}

//Newer localstorage methods
function set_localstorage(key, value) {
	let localstorage = window.localStorage;
	localstorage.setItem(vchat_opts.cookiePrefix+key,value);
}

function get_localstorage(key, deffo) {
	let localstorage = window.localStorage;
	let value = localstorage.getItem(vchat_opts.cookiePrefix+key);
	
	//localstorage only stores strings.
	if(value === "null" || value === null) {
		value = deffo;
	} else if(value === "true") {
		value = true;
	} else if(value === "false") {
		value = false;
	}
	return value;
}

//Older cookie methods
function set_cookie(key, value) {
	let now = new Date();
	now.setFullYear(now.getFullYear() + 1);
	let then = now.toUTCString();
	document.cookie = vchat_opts.cookiePrefix+key+"="+value+";expires="+then+";path=/";
}

function get_cookie(key, deffo) {
	var candidates = {cookie: null, localstorage: null, indexeddb: null};
	let cookie_array = document.cookie.split(';');
	let cookie_object = {};
	cookie_array.forEach( function(element) {
		let clean = element.replace(vchat_opts.cookiePrefix,"").trim(); //Strip the prefix, trim whitespace
		let equals = clean.search("="); //Find the equals
		let left = decodeURIComponent(clean.substring(0,equals)); //From start to one char before equals
		let right = decodeURIComponent(clean.substring(equals+1)); //From one char after equals to end
		//cookies only stores strings.
		if(right == "null" || right === null) {
			right = deffo;
		} else if(right === "true") {
			right = true;
		} else if(right === "false") {
			right = false;
		}
		cookie_object[left] = right; //Stick into object
	});
	candidates.cookie = cookie_object[key]; //Return value of that key in our object (or undefined)
}

// Button Controls that need background-color and text-color set.
var SKIN_BUTTONS = [
	/* Rpane */ "rpane.textb", "rpane.infob", "rpane.wikib", "rpane.forumb", "rpane.rulesb", "rpane.github", "rpane.mapb", "rpane.changelog",
	/* Mainwindow */ "mainwindow.saybutton", "mainwindow.mebutton", "mainwindow.hotkey_toggle"
	
];
// Windows or controls that need background-color set.
var SKIN_ELEMENTS = [
	/* Mainwindow */ "mainwindow", "mainwindow.mainvsplit", "mainwindow.tooltip",
	/* Rpane */ "rpane", "rpane.rpanewindow", "rpane.mediapanel",
];

function switch_ui_mode(options) {
	doWinset(SKIN_BUTTONS.reduce(function(params, ctl) {params[ctl + ".background-color"] = options.buttonBgColor; return params;}, {}));
	doWinset(SKIN_BUTTONS.reduce(function(params, ctl) {params[ctl + ".text-color"] = options.buttonTextColor; return params;}, {}));
	doWinset(SKIN_ELEMENTS.reduce(function(params, ctl) {params[ctl + ".background-color"] = options.windowBgColor; return params;}, {}));
	doWinset("infowindow", {
		"background-color": options.tabBackgroundColor,
		"text-color": options.tabTextColor
	});
	doWinset("infowindow.info", {
		"background-color": options.tabBackgroundColor,
		"text-color": options.tabTextColor,
		"highlight-color": options.highlightColor,
		"tab-text-color": options.tabTextColor,
		"tab-background-color": options.tabBackgroundColor
	});
}

function doWinset(control_id, params) {
	if (typeof params === 'undefined') {
		params = control_id;  // Handle single-argument use case.
		control_id = null;
	}
	var url = "byond://winset?";
	if (control_id) {
		url += ("id=" + control_id + "&");
	}
	url += Object.keys(params).map(function(ctl) {
		return ctl + "=" + encodeURIComponent(params[ctl]);
	}).join("&");
	window.location = url;
}

/***********
*
* Vue Components
*
************/


/*
	Classes of note (02-06-2020 vorestation):
	------ 'Local Chat' ------
	.say = say (includes whispers which just have <i>)
	.emote = emote (includes subtles which just have <i>)
	.ooc .looc = looc

	------ 'Radio' ------
	.alert = global announcer (join messages, etc, the fake radios)
	.syndradio
	.centradio
	.airadioc
	.entradio
	.comradio
	.secradio
	.engradio
	.medradio
	.sciradio
	.supradio
	.srvradio
	.expradio
	.radio = radio fallback

	------ 'Warnings' ------
	.critical = BIGGEST warnings?? rarely used
	.danger = generally BIG warnings
	.userdanger = ??
	.warning = generally smol warnings
	.italics = stupid, should be replaced with warning

	------ 'Info' ------
	.notice = generally notifications
	.adminnotice = server malfunctions
	.info = antag role info only?
	.sinister = cult things, equivalent of fancy notice
	.cult = cult things, equivalent of fancy notice

	------ 'Deadchat' ------
	.deadsay = dsay

	------ 'Global OOC' ------
	.ooc :not(.looc) = ooc (global)

	------ 'Admin PM' ------
	.pm = adminpm

	------ 'Admin Chat' ------
	.admin_channel = asay

	------ 'Mod Chat' ------
	.mod_channel = msay

	------ 'Event Chat' ------
	.event_channel = esay

	------ 'System' ------
	.boldannounce = server announcements/bootup messages

	//Unused for now
	.ooc .aooc = aooc
	.ooc .admin = admin speaking in ooc
	.ooc .event_manager = em speaking in ooc
	.ooc .developer = dev speaking in ooc
	.ooc .moderator = mod speaking in ooc
	.ooc .elevated = staff that it can't find a style for speaking in ooc
*/
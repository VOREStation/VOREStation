// Sorted by however I felt like it

// Adds a generic box around whatever message you're sending in chat. Really makes things stand out.
#define examine_block(str) ("<div class='examine_block'>" + str + "</div>")

// Filtered both under OOC!
#define span_ooc(str) ("<span class='ooc'>" + str + "</span>")
#define span_aooc(str) ("<span class='aooc'>" + str + "</span>")

// All of those have unique filters, be wary!
#define span_looc(str) ("<span class='looc'>" + str + "</span>")
#define span_rlooc(str) ("<span class='rlooc'>" + str + "</span>")

// Ghostchat filter
#define span_deadsay(str) ("<span class='deadsay'>" + str + "</span>")
#define span_ghostalert(str) ("<span class='ghostalert'>" + str + "</span>")

// FIltered under radio
#define span_radio(str) ("<span class='radio'>" + str + "</span>")
#define span_deptradio(str) ("<span class='deptradio'>" + str + "</span>")
#define span_newscaster(str) ("<span class='newscaster'>" + str + "</span>")

#define span_comradio(str) ("<span class='comradio'>" + str + "</span>")
#define span_syndradio(str) ("<span class='syndradio'>" + str + "</span>")
#define span_centradio(str) ("<span class='centradio'>" + str + "</span>")
#define span_airadio(str) ("<span class='airadio'>" + str + "</span>")
#define span_entradio(str) ("<span class='entradio'>" + str + "</span>")

#define span_secradio(str) ("<span class='secradio'>" + str + "</span>")
#define span_engradio(str) ("<span class='engradio'>" + str + "</span>")
#define span_medradio(str) ("<span class='medradio'>" + str + "</span>")
#define span_sciradio(str) ("<span class='sciradio'>" + str + "</span>")
#define span_supradio(str) ("<span class='supradio'>" + str + "</span>")
#define span_srvradio(str) ("<span class='srvradio'>" + str + "</span>")
#define span_expradio(str) ("<span class='expradio'>" + str + "</span>")
// Those are in the radio filter...
#define span_alien(str) ("<span class='alien'>" + str + "</span>")
#define span_changeling(str) ("<span class='changeling'>" + str + "</span>")
// Stop using alert for anything other than announcements! It's filtered under the radio tab
#define span_alert(str) ("<span class='alert'>" + str + "</span>")

// Filtered under global languages
#define span_binarysay(str) ("<span class='binarysay'>" + str + "</span>")
#define span_hivemind(str) ("<span class='hivemind'>" + str + "</span>")

// Filtered under local IC!
#define span_say(str) ("<span class='say'>" + str + "</span>")
#define span_emote(str) ("<span class='emote'>" + str + "</span>")
#define span_emote_subtle(str) ("<span class='emotesubtle'>" + str + "</span>")
#define span_filter_say(str) ("<span class='filter_say'>" + str + "</span>")

// Filtered as NPC messages
#define span_npc_say(str) ("<span class='npcsay'>" + str + "</span>")
#define span_npc_emote(str) ("<span class='npcemote'>" + str + "</span>")

// Filtered as messages visible through multiple Z levels
#define span_multizsay(str) ("<span class='multizsay'>" + str + "</span>")

// Unfiltered, only style!
#define span_name(str) ("<span class='name'>" + str + "</span>")
#define span_game(str) ("<span class='game'>" + str + "</span>")
#define span_message(str) ("<span class='message'>" + str + "</span>") // TODO: This makes no sense, check it!
#define span_notify(str) ("<span class='notify'>" + str + "</span>") // TODO: This makes no sense, check it!
#define span_body(str) ("<span class='body'>" + str + "</span>")

// Filtered under combat!
#define span_attack(str) ("<span class='attack'>" + str + "</span>")
#define span_disarm(str) ("<span class='disarm'>" + str + "</span>")
#define span_passive(str) ("<span class='passive'>" + str + "</span>")
#define span_danger(str) ("<span class='danger'>" + str + "</span>")
#define span_bolddanger(str) ("<span class='bolddanger'>" + str + "</span>")
#define span_filter_combat(str) ("<span class='filter_combat'>" + str + "</span>")

// Filtered under warning messages
#define span_critical(str) ("<span class='critical'>" + str + "</span>")
#define span_userdanger(str) ("<span class='userdanger'>" + str + "</span>")
#define span_warning(str) ("<span class='warning'>" + str + "</span>")
#define span_warningplain(str) ("<span class='warningplain'>" + str + "</span>")
#define span_boldwarning(str) ("<span class='boldwarning'>" + str + "</span>")
#define span_filter_warning(str) ("<span class='filter_warning'>" + str + "</span>") // Close to warning plain, maybe replace

// FIltered under info
#define span_info(str) ("<span class='info'>" + str + "</span>")
#define span_infoplain(str) ("<span class='infoplain'>" + str + "</span>")
#define span_suicide(str) ("<span class='suicide'>" + str + "</span>")
#define span_unconscious(str) ("<span class='unconscious'>" + str + "</span>")
#define span_hear(str) ("<span class='hear'>" + str + "</span>")
#define span_notice(str) ("<span class='notice'>" + str + "</span>")
#define span_filter_notice(str) ("<span class='filter_notice'>" + str + "</span>") // Close to infoplain, maybe replace
#define span_boldnotice(str) ("<span class='boldnotice'>" + str + "</span>")
#define span_adminnotice(str) ("<span class='adminnotice'>" + str + "</span>")
#define span_alium(str) ("<span class='alium'>" + str + "</span>")
#define span_cult(str) ("<span class='cult'>" + str + "</span>")

#define span_pnarrate(str) ("<span class='pnarrate'>" + str + "</span>")

/* Direct communication spans */
// Local pred / prey filter
#define span_psay(str) ("<span class='psay'>" + str + "</span>")
#define span_pemote(str) ("<span class='pemote'>" + str + "</span>")

/* Export spans */
// chatexport filter
#define span_chatexport(str) ("<span class='chatexport'>" + str + "</span>")

/* Vore messages */
// All of thse are filtered under the Vorgan Messages tab!
#define span_valert(str) ("<span class='valert'>" + str + "</span>")
#define span_vdanger(str) ("<span class='vdanger'>" + str + "</span>")
#define span_vwarning(str) ("<span class='vwarning'>" + str + "</span>")
#define span_vnotice(str) ("<span class='vnotice'>" + str + "</span>")

// Filtered under nif!
#define span_nif(str) ("<span class='nif'>" + str + "</span>")
#define span_filter_nif(str) ("<span class='filter_nif'>" + str + "</span>") // Currently not sorted in

/* Languages */
// No filter!
#define span_tajaran(str) ("<span class='tajaran'>" + str + "</span>")
#define span_tajaran_signlang(str) ("<span class='tajaran_signlang'>" + str + "</span>")
#define span_akhani(str) ("<span class='akhani'>" + str + "</span>")
#define span_skrell(str) ("<span class='skrell'>" + str + "</span>")
#define span_skrellfar(str) ("<span class='skrellfar'>" + str + "</span>")
#define span_soghun(str) ("<span class='soghun'>" + str + "</span>")
#define span_solcom(str) ("<span class='solcom'>" + str + "</span>")
#define span_sergal(str) ("<span class='sergal'>" + str + "</span>")
#define span_birdsongc(str) ("<span class='birdsongc'>" + str + "</span>")
#define span_vulpkanin(str) ("<span class='vulpkanin'>" + str + "</span>")
#define span_enochian(str) ("<span class='enochian'>" + str + "</span>")
#define span_daemon(str) ("<span class='daemon'>" + str + "</span>")
#define span_bug(str) ("<span class='bug'>" + str + "</span>")
#define span_vox(str) ("<span class='vox'>" + str + "</span>")
#define span_zaddat(str) ("<span class='zaddat'>" + str + "</span>")
#define span_promethean(str) ("<span class='promethean'>" + str + "</span>")
#define span_rough(str) ("<span class='rough'>" + str + "</span>")
#define span_say_quote(str) ("<span class='say_quote'>" + str + "</span>")
#define span_terminus(str) ("<span class='terminus'>" + str + "</span>")
#define span_interface(str) ("<span class='interface'>" + str + "</span>")
#define span_spacer(str) ("<span class='spacer'>" + str + "</span>")
#define span_blob(str) ("<span class='blob'>" + str + "</span>")
#define span_teppi(str) ("<span class='teppi'>" + str + "</span>")

// Colours only!
#define span_white(str) ("<span class='white'>" + str + "</span>")
#define span_black(str) ("<span class='black'>" + str + "</span>")
#define span_darkgray(str) ("<span class='darkgray'>" + str + "</span>")
#define span_gray(str) ("<span class='gray'>" + str + "</span>")
#define span_red(str) ("<span class='red'>" + str + "</span>")
#define span_orange(str) ("<span class='orange'>" + str + "</span>")
#define span_blue(str) ("<span class='blue'>" + str + "</span>")
#define span_green(str) ("<span class='green'>" + str + "</span>")
#define span_darkgreen(str) ("<span class='darkgreen'>" + str + "</span>") // Do not use regularly!
#define span_purple(str) ("<span class='purple'>" + str + "</span>")
#define span_yellow(str) ("<span class='yellow'>" + str + "</span>")
#define span_pink(str) ("<span class='pink'>" + str + "</span>")
#define span_cyan(str) ("<span class='cyan'>" + str + "</span>")
#define span_crimson(str) ("<span class='crimson'>" + str + "</span>")
#define span_maroon(str) ("<span class='maroon'>" + str + "</span>")
#define span_brown(str) ("<span class='brown'>" + str + "</span>")
#define span_lightpurple(str) ("<span class='lightpurple'>" + str + "</span>")
#define span_darkpink(str) ("<span class='darkpink'>" + str + "</span>")
#define span_rose(str) ("<span class='rose'>" + str + "</span>")

/* System and Debug */
// System filter
#define span_boldannounce(str) ("<span class='boldannounce'>" + str + "</span>")
#define span_world(str) ("<span class='world'>" + str + "</span>") // Bold system messages, use this for important world messages to make sure players can't filter them!
#define span_filter_system(str) ("<span class='filter_system'>" + str + "</span>") // Plain system filter
#define span_sinister(str) ("<span class='sinister'>" + str + "</span>")

// Unfiltered
#define span_prefix(str) ("<span class='prefix'>" + str + "</span>")
#define span_admin(str) ("<span class='admin'>" + str + "</span>")
#define span_linkOn(str) ("<span class='linkOn'>" + str + "</span>")
#define span_linkOff(str) ("<span class='linkOff'>" + str + "</span>")
#define span_filter_pray(str) ("<span class='filter_pray'>" + str + "</span>") // (Uses the chat message type directly)

// Admin log filters
#define span_log_message(str) ("<span class='log_message'>" + str + "</span>")
#define span_filter_adminlog(str) ("<span class='filter_adminlog'>" + str + "</span>") // (Uses the chat message type directly)

// Attack log filter
#define span_filter_attacklog(str) ("<span class='filter_attacklog'>" + str + "</span>") // (Uses the chat message type directly)

// Debug filter
#define span_debug_error(str) ("<span class='debug_error'>" + str + "</span>")
#define span_debug_warning(str) ("<span class='debug_warning'>" + str + "</span>")
#define span_debug_info(str) ("<span class='debug_info'>" + str + "</span>")
#define span_debug_debug(str) ("<span class='debug_debug'>" + str + "</span>")
#define span_debug_trace(str) ("<span class='debug_trace'>" + str + "</span>")
#define span_filter_debuglogs(str) ("<span class='filter_debuglogs'>" + str + "</span>") // (Uses the chat message type directly)

/* Admin only usage */
// Admin pm filter
#define span_pm(str) ("<span class='pm'>" + str + "</span>")
#define span_adminhelp(str) ("<span class='adminhelp'>" + str + "</span>")
#define span_admin_pm_notice(str) ("<span class='pm notice'>" + str + "</span>")
#define span_admin_pm_warning(str) ("<span class='pm warning'>" + str + "</span>")
#define span_filter_pm(str) ("<span class='filter_pm'>" + str + "</span>")

// Mentor pm filter
#define span_mentor(str) ("<span class='mentor'>" + str + "</span>")
#define span_mentor_pm_notice(str) ("<span class='mentor notice'>" + str + "</span>")
#define span_mentor_pm_warning(str) ("<span class='mentor warning'>" + str + "</span>")

/* Adminchat */
// All of those have their own filter
#define span_admin_channel(str) ("<span class='admin_channel'>" + str + "</span>")
#define span_mod_channel(str) ("<span class='mod_channel'>" + str + "</span>")
#define span_event_channel(str) ("<span class='event_channel'>" + str + "</span>")
#define span_mentor_channel(str) ("<span class='mentor_channel'>" + str + "</span>")

/* Byond Sizes */
// Sizes only!
#define span_small(str) "<font size='1'>" + str + "</font>"

#define span_normal(str) "<font size='2'>" + str + "</font>"

#define span_large(str) "<font size='3'>" + str + "</font>"

#define span_huge(str) "<font size='4'>" + str + "</font>"

#define span_giant(str) "<font size='5'>" + str + "</font>"

#define span_giganteus(str) "<font size='6'>" + str + "</font>"

#define span_massive(str) "<font size='7'>" + str + "</font>"

#define span_narsie(str) "<font size='15'>" + str + "</font>"

#define span_cascade(str) "<span style='font-size:22pt'>" + str + "</span>"

/* Style spans */
// text style only
#define span_italics(str) ("<span class='italics'>" + str + "</span>")
#define span_bold(str) ("<span class='bold'>" + str + "</span>")
#define span_underline(str) ("<span class='underline'>" + str + "</span>")

// Links!
#define span_linkify(str) ("<span class='linkify'>" + str + "</span>")

// Just used downstream
#define span_wingdings(str) ("<span class='wingdings'>" + str + "</span>")

#define span_maptext(str) ("<span class='maptext'>" + str + "</span>")

/// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/// !!!!!!!!!!HEY LISTEN!!!!!!!!!!!!!!!!!!!!!!!!
/// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// If you modify this file you ALSO need to modify tgui/packages/tgui-panel/styles/tgchat/chat-light.scss and chat-dark.scss
// BUT you have to use PX font sizes with are on a x8 scale of these font sizes
// Sample font-size: DM: 8 CSS: 64px

/client/script = {"<style>
body					{font-family: Verdana, sans-serif;}

h1, h2, h3, h4, h5, h6	{color: #0000ff;font-family: Georgia, Verdana, sans-serif;}

em						{font-style: normal;font-weight: bold;}

.motd					{color: #638500;font-family: Verdana, sans-serif;}
.motd h1, .motd h2, .motd h3, .motd h4, .motd h5, .motd h6
						{color: #638500;text-decoration: underline;}
.motd a, .motd a:link, .motd a:visited, .motd a:active, .motd a:hover
						{color: #638500;}

.italics				{font-style: italic;}

.bold					{font-weight: bold;}

.underline				{text-decoration: underline;}

.prefix					{font-weight: bold;}
.log_message			{color: #386AFF;	font-weight: bold;}

/* OOC */
.ooc					      {font-weight: bold;}
.looc					      {color: #3A9696; font-weight: bold}
.rlooc					    {color: #3ABB96; font-weight: bold}
.ooc img.text_tag		{width: 32px; height: 10px;}

.ooc .everyone			{color: #002eb8;}
.ooc .elevated			{color: #2e78d9;}
.ooc .moderator			{color: #184880;}
.ooc .developer			{color: #1b521f;}
.ooc .admin				{color: #b82e00;}
.ooc .event_manager		{color: #660033;}
.ooc .aooc				{color: #960018;}

/* Admin: Private Messages */
.pm  .howto				{color: #ff0000;	font-weight: bold;		font-size: 200%;}
.pm  .in				{color: #ff0000;}
.pm  .out				{color: #ff0000;}
.pm  .other				{color: #0000ff;}

/* Admin: Channels */
.mentor_channel			{color: #808000;	font-weight: bold;}
.mentor					{color: #808000;}
.mod_channel			{color: #735638;	font-weight: bold;}
.mod_channel .admin		{color: #b82e00;	font-weight: bold;}
.admin_channel			{color: #9611D4;	font-weight: bold;}
.event_channel			{color: #cc3399;	font-weight: bold;}

/* Radio: Misc */
.deadsay				{color: #530FAD;}
.radio					{color: #008000;}
.deptradio				{color: #ff00ff;}	/* when all other department colors fail */
.newscaster				{color: #750000;}

/* Radio Channels */
.comradio				{color: #193A7A;}
.syndradio				{color: #6D3F40;}
.centradio				{color: #5C5C8A;}
.airadio				{color: #FF00FF;}
.entradio				{color: #339966;}

.secradio				{color: #A30000;}
.engradio				{color: #A66300;}
.medradio				{color: #008160;}
.sciradio				{color: #993399;}
.supradio				{color: #5F4519;}
.srvradio				{color: #6eaa2c;}
.expradio				{color: #555555;}

/* Global Languages */
.hivemind				{font-style: italic;}
.binarysay				{font-style: italic;}

/* Miscellaneous */
.name					{font-weight: bold;}
.say					{}
.alert, .valert			{color: #ff0000;}
h1.alert, h2.alert		{color: #000000;}
.ghostalert				{color: #5c00e6;	font-style: italic; font-weight: bold;}
.wingdings				{font-family: Wingdings, Webdings}

/* VOREStation Edit Start */
.emote					{}
.emotesubtle			{font-style: italic;}
/* VOREStation Edit End */

/* Game Messages */

.attack					{color: #ff0000;}
.moderate				{color: #CC0000;}
.disarm					{color: #990000;}
.passive				{color: #660000;}

.critical				{color: #ff0000; font-weight: bold; font-size: 150%;}
.danger, .vdanger		{color: #ff0000; font-weight: bold;}
.warning, .vwarning		{color: #ff0000; font-style: italic;}
.boldwarning			{color: #ff0000; font-style: italic; font-weight: bold;}
.rose					{color: #ff5050;}
.info					{color: #0000CC;}
.notice, .vnotice		{color: #000099;}
.boldnoitce				{color: #000099; font-weight: bold;}
.alium					{color: #00ff00;}
.cult					{color: #800080; font-weight: bold; font-style: italic;}

.reflex_shoot			{color: #000099; font-style: italic;}

/* Languages */

.alien					{color: #543354;font-style: italic;}
.tajaran				{color: #803B56;}
.tajaran_signlang		{color: #941C1C;}
.akhani					{color: #AC398C;}
.skrell					{color: #00B0B3;}
.skrellfar				{color: #70FCFF;}
.soghun					{color: #50BA6C;}
.solcom					{color: #22228B;}
.changeling, .psay, .pemote		{color: #800080;font-style: italic;}
.sergal					{color: #0077FF;}
.birdsongc				{color: #CC9900;}
.vulpkanin				{color: #B97A57;}
.tavan					{color: #f54298; font-family: Arial}
.drudakar				{color: #bb2463; word-spacing:0pt; font-family: "High Tower Text", monospace;}
.echosong				{color: #826D8C;}
.enochian				{color: #848A33; letter-spacing:-1pt; word-spacing:4pt; font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;}
.daemon					{color: #5E339E; letter-spacing:-1pt; word-spacing:0pt; font-family: "Courier New", Courier, monospace;}
.bug                                    {color: #9e9e39;}
.vox					{color: #AA00AA;}
.zaddat					{color: #941C1C;}
.promethean				{color: #5A5A5A;}
.rough					{font-family: "Trebuchet MS", cursive, sans-serif;}
.say_quote				{font-family: Georgia, Verdana, sans-serif;}
.say_quote_italics		{font-style: italic; font-family: Georgia, Verdana, sans-serif;}
.terminus				{font-family: "Times New Roman", Times, serif, sans-serif}
.psionic                {color: #993399;}
.spacer					{color: #9c660b;}
.blob					{color: #ff950d; font-weight: bold; font-style: italic;}
.teppi					{color: #816540; word-spacing:4pt; font-family: "Segoe Script Bold","Segoe Script",sans-serif,Verdana;}
.marish 				{color: #9e31a4;}
.shadekin				{color: #be3cc5; font-size: 150%; font-weight: bold; font-family: "Gabriola", cursive, sans-serif;}
.rainbow-text			{color: #ff00ff;}

BIG IMG.icon 			{width: 32px; height: 32px;}

/* Debug Logs */
.debug_error					{color:#FF0000; font-weight:bold}
.debug_warning					{color:#FF0000;}
.debug_info						{}
.debug_debug					{color:#0000FF;}
.debug_trace					{color:#888888;}

.interface				{color: #330033;}

.black					{color: #000000;}
.darkgray				{color: #808080;}
.gray					{color: #A9A9A9;}
.red					{color: #FF0000;}
.orange					{color: #FF8C00;}
.blue					{color: #0000FF;}
.green					{color: #00DD00;}
.darkgreen				{color: #008000;}
.purple					{color: #800080;}
.yellow					{color: #ffcc00;}
.pink					{color: #ffc0cb;}
.cyan					{color: #00ffff;}
.maroon					{color: #800000;}
.crimson				{color: #DC143C;}
.brown					{color: #8D4925;}
.lightpurple			{color: #AD5AAD;}
.darkpink				{color: #E3209B;}
.white					{color: #FFFFFF;}

.pnarrate				{color: #009AB2;}

.spoiler				{background-color: gray;color: transparent;user-select: none;}

.spoiler:hover			{background-color: inherit;color: inherit;}

.brute					{color: #FF3333;}
.burn					{color: #FF9933;}
.tox					{color: #00CC66;}
.oxy					{color: #0053FA;}
.clone					{color: #00CCCC;}

</style>"}

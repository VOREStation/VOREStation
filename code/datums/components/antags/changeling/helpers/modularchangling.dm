// READ: Don't use the apostrophe in name or desc. Causes script errors.

//Ling power's evolution menu entry datum should be contained alongside the mob proc for the actual power, in their own file.

var/list/powers = subtypesof(/datum/power/changeling) //needed for the badmin verb for now
var/list/datum/power/changeling/powerinstances = list()

/datum/power			//Could be used by other antags too
	var/name = "Power"
	var/desc = "Placeholder"
	var/helptext = ""
	var/enhancedtext = ""
	var/isVerb = 1 	// Is it an active power, or passive?
	var/verbpath // Path to a verb that contains the effects.
	var/make_hud_button = 1 // Is this ability significant enough to dedicate screen space for a HUD button?
	var/ability_icon_state = null // icon_state for icons for the ability HUD.  Must be in screen_spells.dmi.

/datum/power/changeling
	var/allowduringlesserform = 0
	var/genomecost = 500000 // Cost for the changeling to evolve this power.


/mob/proc/EvolutionMenu() //Needs to be replaced w/ TGUI because LMAO
	set name = "-Evolution Menu-"
	set category = "Changeling"
	set desc = "Adapt yourself carefully."

	var/datum/component/antag/changeling/comp = GetComponent(/datum/component/antag/changeling)

	if(!powerinstances.len)
		for(var/changeling_power in powers)
			powerinstances += new changeling_power()

	var/dat = "<html><head><title>Changeling Evolution Menu</title></head>"

	//javascript, the part that does most of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch(){


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{

						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for ( var i = 0; i < ltr.length; ++i )
						{
							try{
								var tr = ltr\[i\];
								if(tr.getAttribute("id").indexOf("data") != 0){
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								//var inner_span = li.getElementsByTagName("span")\[1\] //Should only ever contain one element.
								//document.write("<p>"+search.innerText+"<br>"+filter+"<br>"+search.innerText.indexOf(filter))
								if ( search.innerText.toLowerCase().indexOf(filter) == -1 )
								{
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,name,desc,helptext,enhancedtext,power,ownsthis){

					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";

					body += "</td><td align='center'>";

					body += "<font size='2'><b>"+desc+"</b></font> <BR>"

					body += "<font size='2'><font color = 'red'><b>"+helptext+"</b></font></font><BR>"

					if(enhancedtext)
					{
						body += "<font size='2'><font color = 'blue'>Recursive Enhancement Effect: <b>"+enhancedtext+"</b></font></font><BR>"
					}

					if(!ownsthis)
					{
						body += "<a href='byond://?src=\ref[src];changeling_power="+power+"'>Evolve</a>"
					}

					body += "</td><td align='center'>";

					body += "</td></tr></table>";


					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(!(id.indexOf("item")==0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++){
							if(locked_tabs\[j\]==id){
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;




						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1"){
						link.setAttribute("name","2");
					}else{
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<font color='red'>Locked</font> ";
					//link.setAttribute("onClick","attempt('"+id+"','"+link_id+"','"+notice_span_id+"');");
					//document.write("removeFromLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
					//document.write("aa - "+link.getAttribute("onClick"));
				}

				function attempt(ab){
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
					//var link = document.getElementById(link_id);
					//link.setAttribute("onClick","addToLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Changeling Evolution Menu</b></font><br>
					Hover over a power to see more information<br>
					Current evolution points left to evolve with: [comp.geneticpoints]<br>
					Absorb other changelings to acquire more evolution points
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/i = 1
	for(var/datum/power/changeling/changeling_power in powerinstances)
		var/ownsthis = 0

		if(changeling_power in comp.purchased_powers)
			ownsthis = 1


		var/color = "#e6e6e6"
		if(i%2 == 0)
			color = "#f2f2f2"


		dat += {"

			<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
				<td align='center' bgcolor='[color]'>
					<span id='notice_span[i]'></span>
					<a id='link[i]'
					onmouseover='expand("item[i]","[changeling_power.name]","[changeling_power.desc]","[changeling_power.helptext]","[changeling_power.enhancedtext]","[changeling_power]",[ownsthis])'
					>
					<span id='search[i]'><b>Evolve [changeling_power] - Cost: [ownsthis ? "Purchased" : changeling_power.genomecost]</b></span>
					</a>
					<br><span id='item[i]'></span>
				</td>
			</tr>

		"}

		i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}

	usr << browse(dat, "window=powers;size=900x480")


/mob/Topic(href, href_list) //Needs to be replaced w/ TGUI because LMAO
	..()
	var/datum/component/antag/changeling/comp = usr.GetComponent(/datum/component/antag/changeling)
	if(!comp)
		return
	if(href_list["changeling_power"])
		comp.purchasePower(comp.owner, href_list["changeling_power"])
		comp.owner.EvolutionMenu()



/datum/component/antag/changeling/proc/purchasePower(var/mob/owner, var/Pname, var/remake_verbs = 1)

	var/datum/power/changeling/Thepower = Pname

	for (var/datum/power/changeling/P in powerinstances)
		//to_world("[P] - [Pname] = [P.name == Pname ? "True" : "False"]")
		if(P.name == Pname)
			Thepower = P
			break


	if(Thepower == null)
		to_chat(owner, "This is awkward.  Changeling power purchase failed, please report this bug to a coder!")
		return

	if(Thepower in purchased_powers)
		to_chat(owner, "We have already evolved this ability!")
		return


	if(geneticpoints < Thepower.genomecost)
		to_chat(owner, "We cannot evolve this... yet.  We must acquire more DNA.")
		return

	geneticpoints -= Thepower.genomecost

	purchased_powers += Thepower

	if(Thepower.genomecost > 0)
		purchased_powers_history.Add("[Pname] ([Thepower.genomecost] points)")

	if(Thepower.make_hud_button && Thepower.isVerb)
		if(owner.ability_master)
			owner.ability_master = new /obj/screen/movable/ability_master(owner)
		owner.ability_master.add_ling_ability(
			object_given = owner,
			verb_given = Thepower.verbpath,
			name_given = Thepower.name,
			ability_icon_given = Thepower.ability_icon_state,
			arguments = list()
			)

	if(!Thepower.isVerb && Thepower.verbpath)
		call(owner, Thepower.verbpath)()
	else if(remake_verbs)
		owner.make_changeling()

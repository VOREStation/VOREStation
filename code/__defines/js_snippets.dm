#define PLAYER_HTML5_HTML "<!DOCTYPE html>\n \
<html>\n \
<head>\n \
<meta http-equiv=\"X-UA-Compatible\" content=\"IE=11\">\n \
<script type=\"text/javascript\">\n \
function noErrorMessages() { return true; }\n \
window.onerror = noErrorMessages;\n \
function SetMusic(url, time, volume) {\n \
    var player = document.getElementById('player');\n \
    // IE can't handle us setting the time before it loads, so we must wait for asynchronous load\n \
    var setTime = function () {\n \
        player.removeEventListener(\"canplay\", setTime);\n \
        player.volume = volume;\n \
        player.currentTime = time;\n \
        player.play();\n \
    };\n \
    if(url != \"\") player.addEventListener(\"canplay\", setTime, false);\n \
    player.src = url;\n \
}\n \
</script>\n \
</head>\n \
<body>\n \
    <audio id=\"player\"></audio>\n \
</body>\n \
</html>\n"

#define JS_BYJAX "function replaceContent() {\n \
	var args = Array.prototype.slice.call(arguments);\n \
	var id = args\[0\];\n \
	var content = args\[1\];\n \
	var callback  = null;\n \
	if(args\[2\]){\n \
		callback = args\[2\];\n \
		if(args\[3\]){\n \
			args = args.slice(3);\n \
		}\n \
	}\n \
	var parent = document.getElementById(id);\n \
	if(typeof(parent)!=='undefined' && parent!=null){\n \
		parent.innerHTML = content?content:'';\n \
	}\n \
	if(callback && window\[callback\]){\n \
		window\[callback\].apply(null,args);\n \
	}\n \
}"

#define JS_DROPDOWN "function dropdowns() {\n \
	var divs = document.getElementsByTagName('div');\n \
	var headers = new Array();\n \
	var links = new Array();\n \
	for(var i=0;i<divs.length;i++){\n \
		if(divs\[i\].className=='header') {\n \
			divs\[i\].className='header closed';\n \
			divs\[i\].innerHTML = divs\[i\].innerHTML+' +';\n \
			headers.push(divs\[i\]);\n \
		}\n \
		if(divs\[i\].className=='links') {\n \
			divs\[i\].className='links hidden';\n \
			links.push(divs\[i\]);\n \
		}\n \
	}\n \
	for(var i=0;i<headers.length;i++){\n \
		if(typeof(links\[i\])!== 'undefined' && links\[i\]!=null) {\n \
			headers\[i\].onclick = (function(elem) {\n \
				return function() {\n \
					if(elem.className.search('visible')>=0) {\n \
						elem.className = elem.className.replace('visible','hidden');\n \
						this.className = this.className.replace('open','closed');\n \
						this.innerHTML = this.innerHTML.replace('-','+');\n \
					}\n \
					else {\n \
						elem.className = elem.className.replace('hidden','visible');\n \
						this.className = this.className.replace('closed','open');\n \
						this.innerHTML = this.innerHTML.replace('+','-');\n \
					}\n \
				return false;\n \
				}\n \
			})(links\[i\]);\n \
		}\n \
	}\n \
}"

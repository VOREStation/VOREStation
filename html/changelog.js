/*
REMOVEDction dropdowns() {
    var divs = document.getElementsByTagName('div');
    var headers = new Array();
    var links = new Array();
    for(var i=0;i<divs.length;i++){
        if(divs[i].className=='drop') {
            divs[i].className='drop closed';
            headers.push(divs[i]);
        }
        if(divs[i].className=='indrop') {
            divs[i].className='indrop hidden';
            links.push(divs[i]);
        }
    }
    for(var i=0;i<headers.length;i++){
        if(typeof(links[i])!== 'undefined' && links[i]!=null) {
            headers[i].onclick = (REMOVEDction(elem) {
                return REMOVEDction() {
                    if(elem.className.search('visible')>=0) {
                        elem.className = elem.className.replace('visible','hidden');
                        this.className = this.className.replace('open','closed');
                    }
                    else {
                        elem.className = elem.className.replace('hidden','visible');
                        this.className = this.className.replace('closed','open');
                    }
                return false;
                }
            })(links[i]);
        }
    }
}
*/
/*
REMOVEDction filterchanges(type){
	var lists = document.getElementsByTagName('ul');
	for(var i in lists){
		if(lists[i].className && lists[i].className.search('changes')>=0) {
			for(var j in lists[i].childNodes){
				if(lists[i].childNodes[j].nodeType == 1){
					if(!type){
						lists[i].childNodes[j].style.display = 'block';
					}
					else if(lists[i].childNodes[j].className!=type) {
						lists[i].childNodes[j].style.display = 'none';
					}
					else {
						lists[i].childNodes[j].style.display = 'block';
					}
				}
			}
		}
	}
}
*/
REMOVEDction dropdowns() {
    var drops = $('div.drop');
	var indrops = $('div.indrop');
	if(drops.length!=indrops.length){
		alert("Some coder fucked up with dropdowns");
	}
	drops.each(REMOVEDction(index){
		$(this).toggleClass('closed');
		$(indrops[index]).hide();
		$(this).click(REMOVEDction(){
			$(this).toggleClass('closed');
			$(this).toggleClass('open');
			$(indrops[index]).toggle();
		});
	});
}

REMOVEDction filterchanges(type){
	$('ul.changes li').each(REMOVEDction(){
		if(!type || $(this).hasClass(type)){
			$(this).show();
		}		
		else {
			$(this).hide();
		}
	});
}

$(document).ready(REMOVEDction(){
	dropdowns();
});
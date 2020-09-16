NanoStatePDAClass.inheritsFrom(NanoStateClass);
var NanoStatePDA = new NanoStatePDAClass();

function NanoStatePDAClass() {
    this.key = 'pda';
    this.key = this.key.toLowerCase();
	this.current_template = "";

    NanoStateManager.addState(this);
}
	
NanoStatePDAClass.prototype.onUpdate = function(data) {
	NanoStateClass.prototype.onUpdate.call(this, data);
	var state = this;
	
	try {
		if(data['data']['app'] != null) {
			var template = data['data']['app']['template'];
			if(template != null && template != state.current_template) {
				var templateMarkup = nanouiTemplateBundle()[template + ".tmpl"];
				if (templateMarkup) {
					templateMarkup += '<div class="clearBoth"></div>';

					try {
						NanoTemplate.addTemplate('app', templateMarkup);
						NanoTemplate.resetTemplate('app');
						$("#uiApp").html(NanoTemplate.parse('app', data));
						state.current_template = template;
						
						if(data['config']['status'] == 2) {
							$('#uiApp .linkActive').addClass('linkPending');
							$('#uiApp .linkActive').oneTime(400, 'linkPending', function () {
								$('#uiApp .linkActive').removeClass('linkPending inactive');
							});
						}
					} catch(error) {
						reportError('ERROR: An error occurred while loading the PDA App UI: ' + error.message);
						return;
					}
				}
			} else {
				if (NanoTemplate.templateExists('app')) {
					$("#uiApp").html(NanoTemplate.parse('app', data));
				}
			}
		}
	} catch(error) {
		reportError('ERROR: An error occurred while rendering the PDA App UI: ' + error.message);
		return;
	}
}
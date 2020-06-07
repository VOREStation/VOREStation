
var NanoTemplate = REMOVEDction () {

    var _templateData = {};
    var _templateSources = {};

    var _templates = {};
    var _compiledTemplates = {};
	
	var _helpers = {};

    var init = REMOVEDction () {
        // We store templateData in the body tag, it's as good a place as any
		_templateData = $('body').data('templateData');

		if (_templateData == null)
		{
			alert('Error: Template data did not load correctly.');
        }

        if (('nanouiTemplateBundle' in window) && (typeof nanouiTemplateBundle === 'REMOVEDction')) {
            _templateSources = nanouiTemplateBundle(); // From nanoui_templates.js
        }
        var templateLoadingPromises = $.map(_templateData, REMOVEDction(filename, key) {
            var fetchSourcePromise;
            if (_templateSources && _templateSources.hasOwnProperty(filename)) {
                // Its in the bundle, just do it
                fetchSourcePromise = $.Deferred().resolve(_templateSources[filename]).promise();
            } else {
                // Otherwise fetch from ze network
                fetchSourcePromise = $.ajax({
                    url: filename,
                    cache: false,
                    dataType: 'text'
                });
            }

            return fetchSourcePromise.done(REMOVEDction(templateMarkup) {
                templateMarkup += '<div class="clearBoth"></div>';
                try {
                    NanoTemplate.addTemplate(key, templateMarkup);
                } catch(error) {
                    alert('ERROR: An error occurred while loading the UI: ' + error.message);
                    return;
                }
            }).fail(REMOVEDction () {
                alert('ERROR: Loading template ' + key + '(' + _templateData[key] + ') failed!');
            });
        });

        // Wait for all of them to be done and then trigger the event.
        $.when.apply(this, templateLoadingPromises).done(REMOVEDction() {
            $(document).trigger('templatesLoaded');
        });
    };

    var compileTemplates = REMOVEDction () {

        for (var key in _templates) {
            try {
                _compiledTemplates[key] = doT.template(_templates[key], null, _templates)
            }
            catch (error) {
                alert(error.message);
            }
        }
    };

    return {
        init: REMOVEDction () {
            init();
        },
        addTemplate: REMOVEDction (key, templateString) {
            _templates[key] = templateString;
        },
        templateExists: REMOVEDction (key) {
            return _templates.hasOwnProperty(key);
        },
        parse: REMOVEDction (templateKey, data) {
            if (!_compiledTemplates.hasOwnProperty(templateKey) || !_compiledTemplates[templateKey]) {
                if (!_templates.hasOwnProperty(templateKey)) {
                    alert('ERROR: Template "' + templateKey + '" does not exist in _compiledTemplates!');
                    return '<h2>Template error (does not exist)</h2>';
                }
                compileTemplates();
            }
            if (typeof _compiledTemplates[templateKey] != 'REMOVEDction') {
                alert(_compiledTemplates[templateKey]);
                alert('ERROR: Template "' + templateKey + '" failed to compile!');
                return '<h2>Template error (failed to compile)</h2>';
            }
            return _compiledTemplates[templateKey].call(this, data['data'], data['config'], _helpers);
        },
		addHelper: REMOVEDction (helperName, helperREMOVEDction) {
			if (!jQuery.isREMOVEDction(helperREMOVEDction)) {
				alert('NanoTemplate.addHelper failed to add ' + helperName + ' as it is not a REMOVEDction.');
				return;	
			}
			
			_helpers[helperName] = helperREMOVEDction;
		},
		addHelpers: REMOVEDction (helpers) {		
			for (var helperName in helpers) {
				if (!helpers.hasOwnProperty(helperName))
				{
					continue;
				}
				NanoTemplate.addHelper(helperName, helpers[helperName]);
			}
		},
		removeHelper: REMOVEDction (helperName) {
			if (helpers.hasOwnProperty(helperName))
			{
				delete _helpers[helperName];
			}	
		}
    }
}();
 


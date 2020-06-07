// NanoBaseCallbacks is where the base callbacks (common to all templates) are stored
NanoBaseCallbacks = REMOVEDction ()
{
	// _canClick is used to disable clicks for a short period after each click (to avoid mis-clicks)
	var _canClick = true;
	
	var _baseBeforeUpdateCallbacks = {}
	
	var _baseAfterUpdateCallbacks = {
		// this callback is triggered after new data is processed
		// it updates the status/visibility icon and adds click event handling to buttons/links		
		status: REMOVEDction (updateData) {
			var uiStatusClass;
			if (updateData['config']['status'] == 2)
			{
				uiStatusClass = 'icon24 uiStatusGood';
				$('.linkActive').removeClass('inactive');
			}
			else if (updateData['config']['status'] == 1)
			{
				uiStatusClass = 'icon24 uiStatusAverage';
				$('.linkActive').addClass('inactive');
			}
			else
			{
				uiStatusClass = 'icon24 uiStatusBad'
				$('.linkActive').addClass('inactive');
			}
			$('#uiStatusIcon').attr('class', uiStatusClass);

			$('.linkActive').stopTime('linkPending');
			$('.linkActive').removeClass('linkPending');

			$('.linkActive')
                .off('click')
			    .on('click', REMOVEDction (event) {
                    event.preventDefault();
                    var href = $(this).data('href');
                    if (href != null && _canClick)
                    {
                        _canClick = false;
                        $('body').oneTime(300, 'enableClick', REMOVEDction () {
                            _canClick = true;
                        });
                        if (updateData['config']['status'] == 2)
                        {
                            $(this).oneTime(300, 'linkPending', REMOVEDction () {
                                $(this).addClass('linkPending');
                            });
                        }
                        window.location.href = href;
                    }
                });

            return updateData;
		},
        nanomap: REMOVEDction (updateData) {
            $('.mapIcon')
                .off('mouseenter mouseleave')
                .on('mouseenter',
                    REMOVEDction (event) {
                        var self = this;
                        $('#uiMapTooltip')
                            .html($(this).children('.tooltip').html())
                            .show()
                            .stopTime()
                            .oneTime(5000, 'hideTooltip', REMOVEDction () {
                                $(this).fadeOut(500);
                            });
                    }
                );

            $('.zoomLink')
                .off('click')
                .on('click', REMOVEDction (event) {
                    event.preventDefault();
                    var zoomLevel = $(this).data('zoomLevel');
                    var uiMapObject = $('#uiMap');
                    var uiMapWidth = uiMapObject.width() * zoomLevel;
                    var uiMapHeight = uiMapObject.height() * zoomLevel;

                    uiMapObject.css({
                        zoom: zoomLevel,
                        left: '50%',
                        top: '50%',
                        marginLeft: '-' + Math.floor(uiMapWidth / 2) + 'px',
                        marginTop: '-' + Math.floor(uiMapHeight / 2) + 'px'
                    });
                });

            $('#uiMapImage').attr('src', 'nanomap_z' + updateData['config']['mapZLevel'] + '.png');

            return updateData;
        }
	};

	return {
		addCallbacks: REMOVEDction () {
			NanoStateManager.addBeforeUpdateCallbacks(_baseBeforeUpdateCallbacks);
			NanoStateManager.addAfterUpdateCallbacks(_baseAfterUpdateCallbacks);
		},
		removeCallbacks: REMOVEDction () {
			for (var callbackKey in _baseBeforeUpdateCallbacks)
			{
				if (_baseBeforeUpdateCallbacks.hasOwnProperty(callbackKey))
				{
					NanoStateManager.removeBeforeUpdateCallback(callbackKey);
				}
			}
            for (var callbackKey in _baseAfterUpdateCallbacks)
            {
                if (_baseAfterUpdateCallbacks.hasOwnProperty(callbackKey))
                {
                    NanoStateManager.removeAfterUpdateCallback(callbackKey);
                }
            }
        }
	};
} ();
 







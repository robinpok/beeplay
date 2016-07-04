var ErrorUI = (function ()
{
	var errorUI ={};

	var errorTemplate = '<h4 class="alert-title"></h4>\
						<p class="alert-message"></p>';

	/*
	* Fills and displays an alert with id
	*/
	errorUI.show = function (id, alertTitle, alertMessage)
	{
		var alertElement = $(id + '.alert.alert-danger');
		if (!alertElement || (alertElement.length === 0)) {
			alertElement = $(id);
			alertElement.addClass('alert alert-danger');
			alertElement.append(errorTemplate);
		}

		$(id + ' > .alert-title').text(alertTitle);
		$(id + ' > .alert-message').text(alertMessage);
		$(id).show();
	};

	/*
	* Hides the alert with id
	*/
	errorUI.hide = function (id)
	{
		$(id).hide();
	};

	return errorUI;
}());

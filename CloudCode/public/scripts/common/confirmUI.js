var ConfirmUI = (function ()
{
	var confirmTemplate =	'<div id="beeplay-confirm" class="modal in" data-backdrop="static" data-keyboard="false" aria-hidden="true">\
	  							<div class="modal-dialog">\
	    							<div class="modal-content">\
										<div class="modal-header">\
	        								<h4 class="modal-title">{TITLE_KEY}</h4>\
	      								</div>\
	      								<div class="modal-body">\
	        								<p>{BODY_KEY}</p>\
	      								</div>\
	      								<div class="modal-footer">\
											<button id="confirmCancelButton" type="button" class="btn btn-default">{CANCEL_BUTTON_KEY}</button>\
	        								<button id="confirmOkButton" type="button" class="btn btn-primary">{OK_BUTTON_KEY}</button>\
	      								</div>\
	    							</div>\
	 							</div>\
							</div>';

	var confirm = {};

	/*
	* Appends a loader in html body and displays it
	*/
	confirm.show = function (title, message, cancelText, okText, okCallback, cancelCallback)
	{
		var confirm = confirmTemplate.replace('{TITLE_KEY}', title);
		confirm = confirm.replace('{BODY_KEY}', message);
		confirm = confirm.replace('{CANCEL_BUTTON_KEY}', cancelText);
		confirm = confirm.replace('{OK_BUTTON_KEY}', okText);

		$('body').append(confirm);
		$('#confirmCancelButton').bind('click', removeConfirm);
		$('#confirmCancelButton').bind('click', cancelCallback);
		$('#confirmOkButton').bind('click', removeConfirm);
		$('#confirmOkButton').bind('click', okCallback);
		$('#beeplay-confirm').modal('show');
	};

	function removeConfirm ()
	{
		$('#beeplay-confirm').modal('hide');
		$('#beeplay-confirm').remove();
	}

	return confirm;
}());
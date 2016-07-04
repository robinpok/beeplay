var Loading = (function ()
{
	var loading = {},
	loadingTemplate =	'<div class="modal in" id="beeplay-loading" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="static" data-keyboard="false" aria-hidden="true">\
							<div class="modal-dialog beeplay-loader">\
								<div class="modal-content">\
									<div class="modal-body">\
										<img src="img/loader.gif"></img>\
									</div>\
								</div>\
							</div>\
						</div>';

	/*
	* Appends a loader in html body and displays it
	*/
	loading.show = function ()
	{
		$('body').append(loadingTemplate);
		$('#beeplay-loading').modal('show');
	};

	/*
	* Removes loader from html body
	*/
	loading.hide = function ()
	{
		$('#beeplay-loading').modal('hide');
		$('#beeplay-loading').remove();
	};

	return loading;
}());
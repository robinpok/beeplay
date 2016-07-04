(function ()
{
	/*
	 * List of Beeps templating
	 */
	var beepsListElementTemplate = '<li id={ID_KEY} class="list-group-item beep-item">' +
										'<div class="row">' +
											'<div class="col-md-2">' +
												'<h1 class="list-group-item-heading pull-right beeps-list-element-price">{PRICE_KEY} €</h1>' +
											'</div>' +
											'<div class="col-md-6">' +
												'<h4 class="list-group-item-heading beeps-list-element-title">{TITLE_KEY}</h4>' +
												'<p class="list-group-item-text beeps-list-element-address">{ADDRESS_KEY}</p>' +
											'</div>' +
											'<div class="col-md-4 beeps-list-element-buttons">' +
												'{BUTTONS_KEY}' +
											'</div>' +
										'</div>' +
									'</li>';

	var beepsWithoutUsersButtonsTemplate =	'<button class="btn pull-right btn-danger beeps-list-element-button beeps-list-element-delete-button">' +
												'<span class="glyphicon glyphicon-trash"></span> Eliminar' +
											'</button>' +
											'<button class="btn pull-right btn-info beeps-list-element-button beeps-list-element-edit-button">' +
												'<span class="glyphicon glyphicon-pencil"></span> Editar' +
											'</button>' +
											'<button class="btn pull-right btn-warning beeps-list-element-button beeps-list-element-duplicate-button">' +
												'<span class="glyphicon glyphicon-file"></span> Duplicar' +
											'</button>';

	// var beepsWithUserButtonsTemplate =	'<button class="btn btn-info pull-right beeps-list-element-button beeps-list-element-edit-button">' +
	// 										'<span class="glyphicon glyphicon-pencil"></span> Editar' +
	// 									'</button>' +
	// 									'<button class="btn pull-right btn-warning beeps-list-element-button beeps-list-element-duplicate-button">' +
	// 										'<span class="glyphicon glyphicon-file"></span> Duplicar' +
	// 									'</button>';

	var completedBeepsButtonsTemplate =	'<button class="btn btn-danger pull-right beeps-list-element-button beeps-list-element-delete-button">' +
											'<span class="glyphicon glyphicon-trash"></span> Eliminar' +
										'</button>' +
										'<button class="btn pull-right btn-warning beeps-list-element-button beeps-list-element-duplicate-button">' +
											'<span class="glyphicon glyphicon-file"></span> Duplicar' +
										'</button>';

	var beepsWithoutUsersKey = Backend.PropertyValues.Beep.Status.NoUsers;
	var beepsWithUsersKey = Backend.PropertyValues.Beep.Status.Users;
	var beepsWithFeedbackKey = Backend.PropertyValues.Beep.Status.WithFeedback;
	var completedBeepsKey = Backend.PropertyValues.Beep.Status.Completed;

	var beepsWithoutUsersCount = 0;
	var beepsWithUsersCount = 0;
	var beepsWithFeedbackCount = 0;
	var completedBeepsCount = 0;

	function getIdForBeepStatus (beepStatus)
	{
		var id;
		switch (beepStatus) {
			case beepsWithoutUsersKey:
				id = '#beepsWithoutUsersList';
				break;
			case beepsWithUsersKey:
				id = '#beepsWithUsersList';
				break;
			case beepsWithFeedbackKey:
				id = '#beepsWithFeedbackList';
				break;
			case completedBeepsKey:
				id = '#completedBeepsList';
				break;
		}
		return id;
	}

	function getButtonTemplateForBeepStatus (beepStatus)
	{
		var template;
		switch (beepStatus) {
			case beepsWithoutUsersKey:
			case beepsWithUsersKey:
			case beepsWithFeedbackKey:
				template = beepsWithoutUsersButtonsTemplate;
				break;
			case completedBeepsKey:
				template = completedBeepsButtonsTemplate;
				break;
		}
		return template;
	}

	function updateCount (beepStatus)
	{
		switch (beepStatus) {
			case beepsWithoutUsersKey:
				beepsWithoutUsersCount += 1;
				break;
			case beepsWithUsersKey:
				beepsWithUsersCount += 1;
				break;
			case beepsWithFeedbackKey:
				beepsWithFeedbackCount += 1;
				break;
			case completedBeepsKey:
				completedBeepsCount += 1;
				break;
		}
	}

	/*
	 *	Display Beeps
	 */
	function displayBeeps (beeps)
	{
		for (var beepIndex in beeps) {
			var beep = beeps[beepIndex];
			var beepStatus = beep.get(Backend.Properties.Beep.Status);
			var listId = getIdForBeepStatus(beepStatus);
			var listElement = $(listId);

			var buttonTemplate = getButtonTemplateForBeepStatus(beepStatus);
			var elementTemplate = beepsListElementTemplate.replace('{BUTTONS_KEY}', buttonTemplate);

			elementTemplate = elementTemplate.replace('{ID_KEY}', beep.id);
			// Using the plus (+) operator on the price, which we get as a String, to convert it to a Number
			elementTemplate = elementTemplate.replace('{PRICE_KEY}', (+beep.get(Backend.Properties.Beep.Price)).toFixed(2));
			elementTemplate = elementTemplate.replace('{TITLE_KEY}', beep.get(Backend.Properties.Beep.Title));
			elementTemplate = elementTemplate.replace('{ADDRESS_KEY}', beep.get(Backend.Properties.Beep.Address));

			listElement.append(elementTemplate);

			if (!beep.get(Backend.Properties.Beep.Visibility)) {
				$('#' + beep.id).addClass('beep-invisible');
			}

			updateCount(beepStatus);
		}

		$('#beepsWithoutUsersBadge').text(beepsWithoutUsersCount);
		$('#beepsWithUsersBadge').text(beepsWithUsersCount);
		$('#beepsWithFeedbackCount').text(beepsWithFeedbackCount);
		$('#completedBeepsBadge').text(completedBeepsCount);

		$('.beeps-list-element-edit-button').bind('click', editBeep);
		$('.beeps-list-element-delete-button').bind('click', showDeleteBeep);
		$('.beeps-list-element-duplicate-button').bind('click', duplicateBeep);

		Loading.hide();
	}

	function listError (error)
	{
		Loading.hide();
	}

	/*
	 *	Edit Beep
	 */
	function editBeep (event)
	{
		var selectedListElement = event.target;
		var editId = $(selectedListElement).closest('.beep-item').attr('id');
		console.log(editId);
		Navigation.goToWithParameters(Navigation.map.beepdetails, 'editId=' + editId);
	}

	/*
	 *	Duplicate Beep
	 */
	function duplicateBeep (event)
	{
		var selectedListElement = event.target;
		var duplicateId = $(selectedListElement).closest('.beep-item').attr('id');
		console.log(duplicateId);
		Navigation.goToWithParameters(Navigation.map.beepdetails, 'duplicateId=' + duplicateId);
	}

	/*
	 *	Delete Beep
	 */
	var beepDeletingId;

	function showDeleteBeep (event)
	{
		var selectedListElement = event.target;
		beepDeletingId = $(selectedListElement).closest('.beep-item').attr('id');
		ConfirmUI.show('Eliminar Beep', 'El Beep será eliminado del sistema y dejará de estar visible por los usuarios. ¿Desea continuar?', 'Cancelar', 'OK', deleteBeep);
	}

	function deleteBeep ()
	{
		BeepsListCloud.deleteBeepById(beepDeletingId, deleteSuccess, deleteError);
	}

	function deleteSuccess ()
	{
		location.reload(false);
	}

	function deleteError (error)
	{
		console.log(error);
	}

	/*
	 *	Buttons
	 */
	function logOut ()
	{
		Backend.logOut();
		Navigation.goTo(Navigation.map.index);
	}

	function settings ()
	{
		Navigation.goTo(Navigation.map.settings);
	}

	function newBeep ()
	{
		Navigation.goTo(Navigation.map.beepdetails);
	}

	/*
	 * Run this on page load
	 */
	$(function main()
	{
		if (Backend.isLoggedIn()) {
			Loading.show();
			BeepsListCloud.list(displayBeeps, listError);
			$('#newBeepButton').bind('click', newBeep);
			$('#settingsButton').bind('click', settings);
			$('#logOutButton').bind('click', logOut);
		}
		else {
			Navigation.goTo(Navigation.map.index);
		}
	});
}());
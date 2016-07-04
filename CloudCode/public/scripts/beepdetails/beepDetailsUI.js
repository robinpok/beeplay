(function() {
	/*
	 * Obtain beep data from the web form
	 */
	function beepFromForm()
	{
		var companyNameField = $('#companyName');
		var titleField = $('#title');
		var priceField = $('#price');
		var pointsField = $('#points');
		var addressField = $('#address');
		var addressLine1Field = $('#addressLine1');
		var addressLine2Field = $('#addressLine2');
		var latitudeField = $('#latitude');
		var longitudeField = $('#longitude');
		var descriptionField = $('#description');
		var responseEmailField = $('#responseEmail');
		var maximumNumberOfParticipantsField = $('#maximumNumberOfParticipants');
		var beepSubscriptionTimeoutField = $('#beepSubscriptionTimeout');
		var geolocationRequiredField = $('input[name=geolocationRequiredRadio]:checked');
		var photoRequiredField = $('input[name=photoRequiredRadio]:checked');
		var cameraRollField = $('input[name=cameraRollRadio]:checked');
		var visibilityField = $('input[name=visibilityRadio]:checked');

		var companyName = companyNameField.val();
		var title = titleField.val();
		var price = +priceField.val();
		var points = +pointsField.val();
		var address = addressField.val();
		var addressLine1 = addressLine1Field.val();
		var addressLine2 = addressLine2Field.val();
		var latitude = +latitudeField.val();
		var longitude = +longitudeField.val();
		var description = descriptionField.val();
		var responseEmail = responseEmailField.val();
		var maximumNumberOfParticipants = +maximumNumberOfParticipantsField.val();
		var beepSubscriptionTimeout = +beepSubscriptionTimeoutField.val();
		var geolocationRequired = geolocationRequiredField.val() === 'true';
		var photoRequired = photoRequiredField.val() === 'true';
		var cameraRoll = photoRequired === true ? cameraRollField.val() === 'true' : false;
		var visibility = visibilityField.val() === 'true';

		if (!companyName) {
			companyNameField.focus();
			ErrorUI.show('#detailsAlert', 'Nombre de la empresa vacío', 'Por favor, introduce el nombre de la empresa.');
			return;
		}

		if (!title) {
			ErrorUI.show('#detailsAlert', 'Título del Beep vacío', 'Por favor, introduce el título del Beep.');
			titleField.focus();
			return;
		}

		if (!price) {
			ErrorUI.show('#detailsAlert', 'Precio del Beep vacío', 'Por favor, introduce el precio del Beep.');
			priceField.focus();
			return;
		}

		if (!points) {
			ErrorUI.show('#detailsAlert', 'Puntuación del Beep vacío', 'Por favor, introduce la puntuación del Beep.');
			pointsField.focus();
			return;
		}

		if (!address) {
			ErrorUI.show('#detailsAlert', 'Dirección vacía', 'Por favor, introduce la dirección.');
			addressField.focus();
			return;
		}

		if (!addressLine1) {
			ErrorUI.show('#detailsAlert', 'Línea 1 de la dirección vacía', 'Por favor, introduce la línea 1 de la dirección vacía.');
			addressLine1Field.focus();
			return;
		}

		if (!addressLine2) {
			ErrorUI.show('#detailsAlert', 'Línea 2 de la dirección vacía', 'Por favor, introduce la línea 2 de la dirección vacía.');
			addressLine2Field.focus();
			return;
		}

		if (!latitude) {
			ErrorUI.show('#detailsAlert', 'Latitud vacía', 'Por favor, introduce la latitud.');
			latitudeField.focus();
			return;
		}

		if (!longitude) {
			ErrorUI.show('#detailsAlert', 'Longitud vacía', 'Por favor, introduce la longitud.');
			longitudeField.focus();
			return;
		}

		if (!description) {
			ErrorUI.show('#detailsAlert', 'Descripción vacía', 'Por favor, introduce la descripción.');
			descriptionField.focus();
			return;
		}

		if (!responseEmail) {
			ErrorUI.show('#detailsAlert', 'E-mail de respuesta vacío', 'Por favor, introduce el e-mail de respuesta.');
			responseEmailField.focus();
			return;
		}

		if (!maximumNumberOfParticipants) {
			ErrorUI.show('#detailsAlert', 'Número máximo de asignados vacío', 'Por favor, introduce el número máximo de asignados.');
			maximumNumberOfParticipantsField.focus();
			return;
		}
		else if (maximumNumberOfParticipants <= 0) {
			ErrorUI.show('#detailsAlert', 'Número máximo de asignados menor que uno', 'Por favor, introduce un número máximo de asignados mayor o igual a uno.');
			maximumNumberOfParticipantsField.focus();
			return;
		}

		if (!beepSubscriptionTimeout) {
			ErrorUI.show('#detailsAlert', 'Tiempo máximo de inscripción vacío', 'Por favor, introduce el tiempo máximo de inscripción.');
			beepSubscriptionTimeoutField.focus();
			return;
		}
		else if (beepSubscriptionTimeout < 0) {
			ErrorUI.show('#detailsAlert', 'Tiempo máximo de inscripción negativo', 'Por favor, introduce un tiempo máximo de inscripción positivo o cero.');
			beepSubscriptionTimeout.focus();
			return;
		}

		return BeepDetailsCloud.newBeep(companyName, title, price, points, address, addressLine1, addressLine2, latitude, longitude, description, responseEmail, maximumNumberOfParticipants, beepSubscriptionTimeout, geolocationRequired, photoRequired, cameraRoll, visibility);
	}

	/*
	 * Create Beep
	 */
	function createBeep()
	{
		beep = beepFromForm();
		if (beep) {
			saveBeep();
		}
	}

	/*
	 * Update Beep
	 */
	function updateBeep()
	{
		var updatedBeep = beepFromForm();
		if (updateBeep) {
			BeepDetailsCloud.updateBeepFromBeep(beep, updatedBeep);
			saveBeep();
		}
	}

	/*
	 * Save Beep
	 */
	function saveBeep()
	{
		ErrorUI.hide('#detailsAlert');
		var saveButton = $('#saveBeepButton');
		saveButton.button('loading');
		Loading.show();
		BeepDetailsCloud.saveBeep(beep, saveBeepSuccess, saveBeepError);
	}

	function saveBeepSuccess() {
		$('#saveBeepButton').button('reset');
		Loading.show();
		Navigation.goTo(Navigation.map.beepslist);
	}

	function saveBeepError() {
		ErrorUI.show('#detailAlert', 'Error', 'No se ha podido crear el Beep.');
		$('#saveBeepButton').button('reset');
		Loading.hide();
	}

	/*
	 * Geocode the address
	 */
	function geocodeAddress()
	{
		var searchAddressButton = $("#searchAddressButton");
		var addressField = $("#address");

		var address = addressField.val();

		if (!address) {
			ErrorUI.show('#addressAlert', 'Dirección vacia', 'Por favor, introduce una dirección.');
			addressField.focus();
			clearLocation();
			return;
		}
		var APIURL = 'http://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&sensor=false';

		searchAddressButton.button('loading');
		Loading.show();
		var jqxhr = $.getJSON(APIURL)
		.done(function(data) {
			if (data.status === 'OK') {
				if (data.results.length > 1) {
					ErrorUI.show('#addressAlert', 'Multiples resultados', 'Se ha encontrado más de un resultado para esta dirección. Por favor, introduce la dirección exacta.');
					addressField.focus();
					clearLocation();
					return;
				}
				else {
					ErrorUI.hide('#addressAlert');
					var formattedAddress = data.results[0].formatted_address;
					$('#address').val(formattedAddress);

					var addressElements = formattedAddress.split(',');
					var addressLine1 = addressElements.length > 3 ? addressElements[0].trim() + ', ' + addressElements[1].trim() : addressElements[0].trim();
					var addressLine2 = addressElements.length > 3 ? addressElements[2].trim() : addressElements[1].trim();

					$('#addressLine1').val(addressLine1);
					$('#addressLine2').val(addressLine2);

					var location = data.results[0].geometry.location;
					$('#latitude').val(location.lat);
					$('#longitude').val(location.lng);
				}
			}
			else if (data.status === 'ZERO_RESULTS') {
				ErrorUI.show('#addressAlert', 'Ningún resultado', 'No se ha encontrado ninguna dirección. Por favor, revisa que la dirección introducida es correcta.');
				addressField.focus();
				clearLocation();
			}
		})
		.fail(function(data) {
			ErrorUI.show('#addressAlert', 'Error', 'Se ha producido un error.');
			addressField.focus();
			clearLocation();
		})
		.always(function() {
			searchAddressButton.button('reset');
			Loading.hide();
		});
	}

	function clearLocation()
	{
		$('#latitude').val(undefined);
		$('#longitude').val(undefined);
	}

	/*
	 * Managing photo radio changes
	 */
	function photoRequiredRadioDidChange()
	{
		var photoField = $('input[name=photoRequiredRadio]:checked');
		var photoAllowed = photoField.val() === 'true';
		setupCameraRollRadio(photoAllowed);
	}

	function setupCameraRollRadio(cameraRollVisible)
	{
		if (cameraRollVisible) {
			$('#cameraRollRadioContainer').removeClass('hide');
		}
		else {
			$('#cameraRollRadioContainer').addClass('hide');
		}
	}

	function fillForm()
	{
		var companyNameField = $('#companyName');
		var titleField = $('#title');
		var priceField = $('#price');
		var pointsField = $('#points');
		var addressField = $('#address');
		var addressLine1Field = $('#addressLine1');
		var addressLine2Field = $('#addressLine2');
		var latitudeField = $('#latitude');
		var longitudeField = $('#longitude');
		var descriptionField = $('#description');
		var responseEmailField = $('#responseEmail');
		var maximumNumberOfParticipantsField = $('#maximumNumberOfParticipants');
		var beepSubscriptionTimeoutField = $('#beepSubscriptionTimeout');

		companyNameField.val(beep.get(Backend.Properties.Beep.CompanyName));
		titleField.val(beep.get(Backend.Properties.Beep.Title));
		priceField.val(beep.get(Backend.Properties.Beep.Price));
		pointsField.val(beep.get(Backend.Properties.Beep.Points));
		addressField.val(beep.get(Backend.Properties.Beep.Address));
		addressLine1Field.val(beep.get(Backend.Properties.Beep.AddressLine1));
		addressLine2Field.val(beep.get(Backend.Properties.Beep.AddressLine2));
		latitudeField.val(beep.get(Backend.Properties.Beep.Latitude));
		longitudeField.val(beep.get(Backend.Properties.Beep.Longitude));
		descriptionField.val(beep.get(Backend.Properties.Beep.Description));
		responseEmailField.val(beep.get(Backend.Properties.Beep.ResponseEmail));
		maximumNumberOfParticipantsField.val(beep.get(Backend.Properties.Beep.MaximumNumberOfParticipants));
		beepSubscriptionTimeoutField.val(beep.get(Backend.Properties.Beep.BeepSubscriptionTimeout));

		if (beep.get(Backend.Properties.Beep.GeolocationRequired)){
			$('#geolocationAllow').prop('checked', true);
		}
		else {
			$('#geolocationDeny').prop('checked', true);
		}

		if (beep.get(Backend.Properties.Beep.PhotoRequired)) {
			$('#photoAllow').prop('checked', true);
			setupCameraRollRadio(true);
		}
		else {
			$('#photoDeny').prop('checked', true);
			setupCameraRollRadio(false);
		}

		if (beep.get(Backend.Properties.Beep.CameraRollAllowed)) {
			$('#cameraRollAllow').prop('checked', true);
		}
		else {
			$('#cameraRollDeny').prop('checked', true);
		}

		if (beep.get(Backend.Properties.Beep.Visibility)) {
			$('#visibilityShow').prop('checked', true);
		}
		else {
			$('#visibilityHide').prop('checked', true);
		}
	}

	/*
	 * Edit beep
	 */
	function fetchEditSuccess(fetchedBeep)
	{
		beep = fetchedBeep;
		BeepDetailsCloud.subscriptions(beep, displaySubscriptions, listError);
		fillForm();
	}

	function fetchEditError(error)
	{
		Loading.hide();
	}

	/*
	 * Duplicate beep
	 */
	function fetchDuplicateSuccess(fetchedBeep)
	{
		beep = fetchedBeep;

		// Clean up the address field, because we don't want it to duplicate
		beep.set(Backend.Properties.Beep.Address, '');
		beep.set(Backend.Properties.Beep.AddressLine1, '');
		beep.set(Backend.Properties.Beep.AddressLine2, '');
		beep.set(Backend.Properties.Beep.Latitude, '');
		beep.set(Backend.Properties.Beep.Longitude, '');

		fillForm();
		Loading.hide();
	}

	function fetchDuplicateError(error)
	{
		Loading.hide();
	}

	/*
	 * List of subscribed users
	 */
	var beepSubcriptionsElementTemplate =	'<li id={ID_KEY} class="list-group-item subscription-item">' +
												'<div class="row">' +
													'<div class="col-md-7">' +
														'<h4 class="list-group-item-heading subscriptions-list-element-name">{NAME_KEY}</h4>' +
														'<p class="list-group-item-text subscriptions-list-element-description">{DESCRIPTION_KEY}</p>' +
													'</div>' +
													'<div class="col-md-2">' +
														'<h4 class="list-group-item-heading subscriptions-list-element-status">{STATUS_KEY}</h4>' +
														'<p class="list-group-item-text subscriptions-list-element-description">{DATE_KEY}</p>' +
													'</div>' +
													'<div class="col-md-3 subscriptions-list-element-buttons">' +
														'{BUTTONS_KEY}' +
													'</div>' +
												'</div>' +
											'</li>';

	var beepSubscribedButtonsTemplate =		'<button class="btn btn-warning pull-right beeps-list-element-button subscriptions-list-element-unsubscribe-button">' +
												'<span class="glyphicon glyphicon-minus"></span> Dar de baja' +
											'</button>';

	var beepFeedbackSentButtonsTemplate =	'<button type="button" class="btn btn-success pull-right beeps-list-element-button subscriptions-list-element-accept-button">' +
												'<span class="glyphicon glyphicon-ok"></span> Aceptar' +
											'</button>' +
											'<button class="btn btn-danger pull-right beeps-list-element-button subscriptions-list-element-reject-button">' +
												'<span class="glyphicon glyphicon-remove"></span> Rechazar' +
											'</button>';

	var beepFeedbackApprovedButtonsTemplate =	'';

	var beepFeedbackDeclinedButtonsTemplate =	'';

	var subscribedBeepsKey = Backend.PropertyValues.BeepSubscription.Status.Subscribed;
	var feedbackSentBeepsKey = Backend.PropertyValues.BeepSubscription.Status.FeedbackSent;
	var feedbackApprovedBeepsKey = Backend.PropertyValues.BeepSubscription.Status.FeedbackApproved;
	var feedbackDeclinedBeepsKey = Backend.PropertyValues.BeepSubscription.Status.FeedbackDeclined;

	function getIdForSubscriptionStatus(subscriptionStatus)
	{
		var id = '#subscriptionsList';
		return id;
	}

	function getButtonTemplateForSubscriptionStatus(subscriptionStatus)
	{
		var template;
		switch (subscriptionStatus) {
			case subscribedBeepsKey:
				template = beepSubscribedButtonsTemplate;
				break;
			case feedbackSentBeepsKey:
				template = beepFeedbackSentButtonsTemplate;
				break;
			case feedbackApprovedBeepsKey:
				template = beepFeedbackApprovedButtonsTemplate;
				break;
			case feedbackDeclinedBeepsKey:
				template = beepFeedbackDeclinedButtonsTemplate;
				break;
		}
		return template;
	}

	function getMessageForSubscriptionStatus(subscriptionStatus)
	{
		var message;
		switch (subscriptionStatus) {
			case subscribedBeepsKey:
				message = 'Inscrito';
				break;
			case feedbackSentBeepsKey:
				message = 'Informe enviado';
				break;
			case feedbackApprovedBeepsKey:
				message = 'Informe aprobado';
				break;
			case feedbackDeclinedBeepsKey:
				message = 'Informe rechazado';
				break;
		}
		return message;
	}

	function bindSubscriptionsButtonEvents(id)
	{
		$(id).find('.subscriptions-list-element-unsubscribe-button').bind('click', unsubscribe);
		$(id).find('.subscriptions-list-element-accept-button').bind('click', acceptFeedback);
		$(id).find('.subscriptions-list-element-reject-button').bind('click', rejectFeedback);
	}

	function getGenderLabel(gender)
	{
		return gender === Backend.PropertyValues.User.Gender.Male ? 'Chico' : 'Chica';
	}

	function getEducationalAttainmentLabel(educationalAttainment)
	{
		var label;
		switch (educationalAttainment) {
			case Backend.PropertyValues.User.EducationalAttainment.None:
				label = 'Sin estudios';
				break;
			case Backend.PropertyValues.User.EducationalAttainment.BasicStudies:
				label = 'Estudios básicos';
				break;
			case Backend.PropertyValues.User.EducationalAttainment.HighSchool:
				label = 'Bachillerato';
				break;
			case Backend.PropertyValues.User.EducationalAttainment.VocationalTraining:
				label = 'Formación profesional';
				break;
			case Backend.PropertyValues.User.EducationalAttainment.UniversityStudies:
				label = 'Estudios universitarios';
				break;
			case Backend.PropertyValues.User.EducationalAttainment.MastersDegree:
				label = 'Estudios universitarios superiores';
				break;
		}

		return label;
	}

	function getOccupationLabel(index)
	{
		var occupationArray = ['Admin. Pública',
			'Actividades primarias',
			'Arquitectura y construcción',
			'Arte',
			'Banca',
			'Comercio',
			'Comunicación',
			'Deporte',
			'Derecho',
			'Educación',
			'Gran Consumo',
			'Hostelería y turismo',
			'Inmobiliaria',
			'Internet y tecnologías',
			'Salud',
			'Transporte',
			'Otro'];

		return occupationArray[index];
	}

	function getInterestsLabel(indexes)
	{
		var interestsArray = ['Animales',
			'Arte',
			'Cine',
			'Deporte',
			'Fiesta',
			'Gastronomía',
			'Literatura',
			'Moda',
			'Música',
			'Política',
			'Salud',
			'Tecnología',
			'Viajes',
			'Otro'];

		var str = '';

		for (var i = 0; i < indexes.length; i++)
			if (indexes[i])
			{
				str = str + ', ' + interestsArray[i];
			}

		if (str != '')	str = str.substring(2);
		return str;
	}

	function getBirthdayLabel(date)
	{
		return date.toDateString();
	}
	/*
	 *	Display Subscriptions
	 */
	function displaySubscriptions(subscriptions)
	{
		var subscribedCount = 0;
		var listId = getIdForSubscriptionStatus(subscriptionStatus);
		var listElement = $(listId);

		for (var subscriptionIndex in subscriptions) {
			var subscription = subscriptions[subscriptionIndex];
			var subscriptionStatus = subscription.get(Backend.Properties.Beep.Status);

			var buttonTemplate = getButtonTemplateForSubscriptionStatus(subscriptionStatus);
			var elementTemplate = beepSubcriptionsElementTemplate.replace('{BUTTONS_KEY}', buttonTemplate);

			var user = subscription.get(Backend.Properties.BeepSubscription.User);
			elementTemplate = elementTemplate.replace('{ID_KEY}', subscription.id);

			var name = user.get(Backend.Properties.User.Name);
			var firstSurname = user.get(Backend.Properties.User.FirstSurname);
			var secondSurname = user.get(Backend.Properties.User.SecondSurname);
			var email = user.get(Backend.Properties.User.Email);
			elementTemplate = elementTemplate.replace('{NAME_KEY}', name + ' ' + firstSurname + ' ' + secondSurname + ' (' + email + ')');

			var gender = getGenderLabel(user.get(Backend.Properties.User.Gender));
			var birthday = getBirthdayLabel(user.get(Backend.Properties.User.Birthday));
			var occupation = getOccupationLabel(user.get(Backend.Properties.User.Occupation));
			var interests = getInterestsLabel(user.get(Backend.Properties.User.Interests));
			var educationalAttainment = getEducationalAttainmentLabel(user.get(Backend.Properties.User.EducationalAttainment));
			elementTemplate = elementTemplate.replace('{DESCRIPTION_KEY}', gender + ', ' + birthday + ', ' + occupation + ', ' + interests + ', ' + educationalAttainment);
			elementTemplate = elementTemplate.replace('{STATUS_KEY}', getMessageForSubscriptionStatus(subscription.get(Backend.Properties.BeepSubscription.Status)));

			var updatedAt = subscription.updatedAt;
			var day = ("0" + updatedAt.getDate()).substring((""+updatedAt.getDate()).length - 1);
			var month = ("0" + (updatedAt.getMonth() + 1)).substring((""+updatedAt.getMonth()).length - 1);
			var date = day + "/" + month + "/" + updatedAt.getFullYear();

			var hour = ("0" + updatedAt.getHours()).substring((""+updatedAt.getHours()).length - 1);
			var minute = ("0" + updatedAt.getMinutes()).substring((""+updatedAt.getMinutes()).length - 1);
			var time = hour + ":" + minute;

			elementTemplate = elementTemplate.replace('{DATE_KEY}', date + " " + time);

			listElement.append(elementTemplate);

			subscribedCount += 1;
		}

		$('#subscriptionsBadge').text(subscribedCount);

		bindSubscriptionsButtonEvents(listId);

		Loading.hide();
	}

	function listError(error)
	{
		Loading.hide();
	}

	function unsubscribe(event)
	{
		Loading.show();
		var selectedListElement = event.target;
		var subscriptionId = $(selectedListElement).closest('.subscription-item').attr('id');
		BeepDetailsCloud.unsubscribe(subscriptionId, subscriptionUnsubscribeSuccess, subscriptionUpdateError);
	}

	function subscriptionUnsubscribeSuccess(subscription)
	{
		// Update the UI element
		var id = subscription.id;
		var statusLabel = $('#' + id);
		statusLabel.remove();

		Loading.hide();
	}

	function acceptFeedback(event)
	{
		Loading.show();
		var selectedListElement = event.target;
		var subscriptionId = $(selectedListElement).closest('.subscription-item').attr('id');
		BeepDetailsCloud.acceptFeedback(subscriptionId, subscriptionUpdateSuccess, subscriptionUpdateError);
	}

	function rejectFeedback(event)
	{
		Loading.show();
		var selectedListElement = event.target;
		var subscriptionId = $(selectedListElement).closest('.subscription-item').attr('id');
		BeepDetailsCloud.rejectFeedback(subscriptionId, subscriptionUpdateSuccess, subscriptionUpdateError);
	}

	function subscriptionUpdateSuccess(subscription)
	{
		// Update the UI element
		var id = subscription.id;
		var statusLabel = $('#' + id).find('.subscriptions-list-element-status');
		statusLabel.text(getMessageForSubscriptionStatus(subscription.get(Backend.Properties.BeepSubscription.Status)));

		var buttonsContainer = $('#' + id).find('.subscriptions-list-element-buttons');
		buttonsContainer.html(getButtonTemplateForSubscriptionStatus(subscription.get(Backend.Properties.BeepSubscription.Status)));

		bindSubscriptionsButtonEvents('#' + id);

		Loading.hide();
	}

	function subscriptionUpdateError(error)
	{
		Loading.hide();
	}

	/*
	 * Get value from URL
	 */
	function getUrlVars()
	{
		var vars = {};
		var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value)
		{
			vars[key] = value;
		});
		return vars;
	}

	/*
	 * Run this on page load
	 */
	$(function main()
	{
		if (Backend.isLoggedIn()) {
			$('#searchAddressButton').bind('click', geocodeAddress);
			$('input[name="photoRequiredRadio"]').bind('change', photoRequiredRadioDidChange);

			var beepId = getUrlVars().editId;
			var duplicateId = getUrlVars().duplicateId;

			if (beepId) {
				// Editing mode
				$('#saveBeepButton').text('Actualizar');
				$('#saveBeepButton').attr('data-loading-text', 'Actualizando...');
				$('#saveBeepButton').bind('click', updateBeep);
				Loading.show();
				BeepDetailsCloud.fetchBeepById(beepId, fetchEditSuccess, fetchEditError);
			}
			else if (duplicateId) {
				// Duplicate mode
				$('#saveBeepButton').text('Publicar');
				$('#saveBeepButton').attr('data-loading-text', 'Publicando...');
				$('#saveBeepButton').bind('click', createBeep);
				Loading.show();
				BeepDetailsCloud.fetchBeepById(duplicateId, fetchDuplicateSuccess, fetchDuplicateError);
			}
			else {
				// Creation mode
				beepId = null;
				$('#subscriptions').remove();
				$('#saveBeepButton').text('Publicar');
				$('#saveBeepButton').attr('data-loading-text', 'Publicando...');
				$('#saveBeepButton').bind('click', createBeep);
			}
		}
		else {
			Navigation.goTo(Navigation.map.index);
		}
	});
})();
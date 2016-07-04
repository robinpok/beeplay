(function() {
	/*
	 * Obtain beep data from the web form
	 */
	function settingsFromForm()
	{
		var minimumMoneyBalanceToReclaimField = $('#minimumMoneyBalanceToReclaim');
		var minimumPointsBalanceToReclaimField = $('#minimumPointsBalanceToReclaim');
		var welcomeMessageSubjectField = $('#welcomeMessageSubject');
		var welcomeMessageBodyField = $('#welcomeMessageBody');
		var timeoutMessageSubjectField = $('#timeoutMessageSubject');
		var timeoutMessageBodyField = $('#timeoutMessageBody');
		var inactivityMessageSubjectField = $('#inactivityMessageSubject');
		var inactivityMessageBodyField = $('#inactivityMessageBody');
		var acceptanceMessageSubjectField = $('#acceptanceMessageSubject');
		var acceptanceMessageBodyField = $('#acceptanceMessageBody');
		var rejectionMessageSubjectField = $('#rejectionMessageSubject');
		var rejectionMessageBodyField = $('#rejectionMessageBody');

		var minimumMoneyBalanceToReclaim = +minimumMoneyBalanceToReclaimField.val();
		var minimumPointsBalanceToReclaim = +minimumPointsBalanceToReclaimField.val();
		var welcomeMessageSubject = welcomeMessageSubjectField.val();
		var welcomeMessageBody = welcomeMessageBodyField.val();
		var timeoutMessageSubject = timeoutMessageSubjectField.val();
		var timeoutMessageBody = timeoutMessageBodyField.val();
		var inactivityMessageSubject = inactivityMessageSubjectField.val();
		var inactivityMessageBody = inactivityMessageBodyField.val();
		var acceptanceMessageSubject = acceptanceMessageSubjectField.val();
		var acceptanceMessageBody = acceptanceMessageBodyField.val();
		var rejectionMessageSubject = rejectionMessageSubjectField.val();
		var rejectionMessageBody = rejectionMessageBodyField.val();

		if (!minimumMoneyBalanceToReclaim) {
			ErrorUI.show('#settingsAlert', 'Cantidad mínima de dinero para poder cobrar', 'Por favor, introduce la cantidad mínima de dinero para poder cobrar.');
			minimumMoneyBalanceToReclaimField.focus();
			return;
		}
		else if (minimumMoneyBalanceToReclaim <= 0) {
			ErrorUI.show('#settingsAlert', 'Cantidad mínima de dinero para poder cobrar menor que uno', 'Por favor, introduce una cantidad mínima de dinero para poder cobrar mayor o igual a uno.');
			minimumMoneyBalanceToReclaimField.focus();
			return;
		}

		// if (!minimumPointsBalanceToReclaim) {
		// 	ErrorUI.show('#settingsAlert', 'Cantidad mínima de puntos para poder cobrar', 'Por favor, introduce la cantidad mínima de puntos para poder cobrar.');
		// 	minimumPointsBalanceToReclaimField.focus();
		// 	return;
		// }
		// else
		if (minimumPointsBalanceToReclaim < 0) {
			ErrorUI.show('#settingsAlert', 'Cantidad mínima de puntos para poder cobrar menor que uno', 'Por favor, introduce una cantidad mínima de puntos para poder cobrar mayor o igual a uno.');
			minimumPointsBalanceToReclaimField.focus();
			return;
		}

		if (!welcomeMessageSubject) {
			ErrorUI.show('#settingsAlert', 'Asunto del mensaje de bienvenida vacío', 'Por favor, introduce el asunto del mensaje de bienvenida.');
			welcomeMessageSubjectField.focus();
			return;
		}

		if (!welcomeMessageBody) {
			ErrorUI.show('#settingsAlert', 'Cuerpo del mensaje de bienvenida vacío', 'Por favor, introduce el cuerpo del mensaje de bienvenida.');
			welcomeMessageBodyField.focus();
			return;
		}

		if (!timeoutMessageSubject) {
			ErrorUI.show('#settingsAlert', 'Asunto del mensaje de timeout vacío', 'Por favor, introduce el asunto del mensaje de timeout.');
			timeoutMessageSubjectField.focus();
			return;
		}

		if (!timeoutMessageBody) {
			ErrorUI.show('#settingsAlert', 'Cuerpo del mensaje de timeout vacío', 'Por favor, introduce el cuerpo del mensaje de timeout.');
			timeoutMessageBodyField.focus();
			return;
		}

		if (!inactivityMessageSubject) {
			ErrorUI.show('#settingsAlert', 'Asunto del mensaje de inactividad vacío', 'Por favor, introduce el asunto del mensaje de inactividad.');
			inactivityMessageSubjectField.focus();
			return;
		}

		if (!inactivityMessageBody) {
			ErrorUI.show('#settingsAlert', 'Cuerpo del mensaje de inactividad vacío', 'Por favor, introduce el cuerpo del mensaje de inactividad.');
			inactivityMessageBodyField.focus();
			return;
		}

		if (!acceptanceMessageSubject) {
			ErrorUI.show('#settingsAlert', 'Asunto del mensaje de aceptación del informe vacío', 'Por favor, introduce el asunto del mensaje de aceptación del informe.');
			acceptanceMessageSubjectField.focus();
			return;
		}

		if (!acceptanceMessageBody) {
			ErrorUI.show('#settingsAlert', 'Cuerpo del mensaje de aceptación del informe vacío', 'Por favor, introduce el cuerpo del mensaje de aceptación del informe.');
			acceptanceMessageBodyField.focus();
			return;
		}

		if (!rejectionMessageSubject) {
			ErrorUI.show('#settingsAlert', 'Asunto del mensaje de rechazo del informe vacío', 'Por favor, introduce el asunto del mensaje de rechazo del informe.');
			rejectionMessageSubjectField.focus();
			return;
		}

		if (!rejectionMessageBody) {
			ErrorUI.show('#settingsAlert', 'Cuerpo del mensaje de rechazo del informe vacío', 'Por favor, introduce el cuerpo del mensaje de rechazo del informe.');
			rejectionMessageBodyField.focus();
			return;
		}

		return SettingsCloud.newSettings(minimumMoneyBalanceToReclaim, minimumPointsBalanceToReclaim, welcomeMessageSubject, welcomeMessageBody, timeoutMessageSubject, timeoutMessageBody, inactivityMessageSubject, inactivityMessageBody, acceptanceMessageSubject, acceptanceMessageBody, rejectionMessageSubject, rejectionMessageBody);
	}

	/*
	 * Save Beep
	 */
	function saveSettings()
	{
		var settings = settingsFromForm();
		if (settings) {
			ErrorUI.hide('#settingsAlert');
			var saveButton = $('#saveSettingsButton');
			saveButton.button('loading');
			Loading.show();
			SettingsCloud.saveSettings(settings, saveSettingsSuccess, saveSettingsError);
		}
	}

	function saveSettingsSuccess()
	{
		$('#saveBeepButton').button('reset');
		Loading.show();
		Navigation.goTo(Navigation.map.beepslist);
	}

	function saveSettingsError()
	{
		ErrorUI.show('#settingsAlert', 'Error', 'No se ha podido actualizar la configuración.');
		$('#saveBeepButton').button('reset');
		Loading.hide();
	}

	function fillForm(settings)
	{
		var minimumMoneyBalanceToReclaimField = $('#minimumMoneyBalanceToReclaim');
		var minimumPointsBalanceToReclaimField = $('#minimumPointsBalanceToReclaim');
		var welcomeMessageSubjectField = $('#welcomeMessageSubject');
		var welcomeMessageBodyField = $('#welcomeMessageBody');
		var timeoutMessageSubjectField = $('#timeoutMessageSubject');
		var timeoutMessageBodyField = $('#timeoutMessageBody');
		var inactivityMessageSubjectField = $('#inactivityMessageSubject');
		var inactivityMessageBodyField = $('#inactivityMessageBody');
		var acceptanceMessageSubjectField = $('#acceptanceMessageSubject');
		var acceptanceMessageBodyField = $('#acceptanceMessageBody');
		var rejectionMessageSubjectField = $('#rejectionMessageSubject');
		var rejectionMessageBodyField = $('#rejectionMessageBody');

		minimumMoneyBalanceToReclaimField.val(settings.get(Backend.Properties.Settings.MinimumMoneyBalanceToReclaim));
		minimumPointsBalanceToReclaimField.val(settings.get(Backend.Properties.Settings.MinimumPointsBalanceToReclaim));
		welcomeMessageSubjectField.val(settings.get(Backend.Properties.Settings.WelcomeMessageSubject));
		welcomeMessageBodyField.val(settings.get(Backend.Properties.Settings.WelcomeMessageBody));
		timeoutMessageSubjectField.val(settings.get(Backend.Properties.Settings.TimeoutMessageSubject));
		timeoutMessageBodyField.val(settings.get(Backend.Properties.Settings.TimeoutMessageBody));
		inactivityMessageSubjectField.val(settings.get(Backend.Properties.Settings.InactivityMessageSubject));
		inactivityMessageBodyField.val(settings.get(Backend.Properties.Settings.InactivityMessageBody));
		acceptanceMessageSubjectField.val(settings.get(Backend.Properties.Settings.AcceptanceMessageSubject));
		acceptanceMessageBodyField.val(settings.get(Backend.Properties.Settings.AcceptanceMessageBody));
		rejectionMessageSubjectField.val(settings.get(Backend.Properties.Settings.RejectionMessageSubject));
		rejectionMessageBodyField.val(settings.get(Backend.Properties.Settings.RejectionMessageBody));
	}

	/*
	 * Edit settings
	 */
	function loadSettingsSuccess(loadedSettings)
	{
		fillForm(loadedSettings);
		Loading.hide();
	}

	function loadSettingsError(error)
	{
		Loading.hide();
	}

	/*
	 * Run this on page load
	 */
	$(function main()
	{
		if (Backend.isLoggedIn()) {
			$('#saveSettingsButton').bind('click', saveSettings);
			Loading.show();
			SettingsCloud.loadSettings(loadSettingsSuccess, loadSettingsError);
		}
		else {
			Navigation.goTo(Navigation.map.index);
		}
	});
})();
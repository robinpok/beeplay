(function()
{
	function onSubmit(ev) {
		ev.preventDefault();

		var emailField = $('#emailInput');
		var passwordField = $('#pwdInput');
		var loginBtn = $('#btn_login');
		var email = emailField.val();
		var password = passwordField.val();

		if (!email) {
			ErrorUI.show('#loginAlert', 'E-mail vacío', 'Por favor, introduce tu dirección de e-mail.');
			emailField.focus();
			return;
		}
		else if (!password) {
			ErrorUI.show('#loginAlert', 'Contraseña vacía', 'Por favor, introduce tu contraseña.');
			passwordField.focus();
			return;
		}

		loginBtn.button('loading');
		Loading.show();
		LoginCloud.performLogin(email, password, loginSuccess, loginError); // loginCloud.js
	}

	function loginSuccess(argument) {
		ErrorUI.hide('#loginAlert');
		$('#loginButton').button('reset');
		Loading.hide();
		Navigation.goTo(Navigation.map.beepslist);
	}

	function loginError(errorMessage) {
		ErrorUI.show('#loginAlert', 'Inicio de sesión fallido', errorMessage);
		$('#loginButton').button('reset');
		Loading.hide();
	}

	// Run this on page load:
	$(function main() {
		if (Backend.isLoggedIn()) {
			Navigation.goTo(Navigation.map.beepslist);
		}
		else {
			$('#form_login').bind('submit', onSubmit);
		}
	});
})();
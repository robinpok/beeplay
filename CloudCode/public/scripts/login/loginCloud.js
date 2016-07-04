var LoginCloud = (function ()
{
	var loginCloud = {};

	loginCloud.performLogin = function (username, password, successCallback, errorCalback) {
		Parse.User.logIn(username, password, {
			success : function(logedUser) {
				var query = new Parse.Query(Parse.Role);
				query.equalTo('name', 'Administrator');
				query.find({
					success: function(results) {
						var roleQuery = results[0].getUsers().query();
						roleQuery.equalTo('username', logedUser.get('username'));
						roleQuery.find({
							success: function(results) {
								if (results.length) {
									successCallback();
								}
								else {
									Parse.User.logOut();
									errorCalback('El usuario no es un administrador.');
								}
							},
							error: function(error) {
								console.log('Error: ' + error.code + ' ' + error.message);
							}
						});
					},
					error: function(error) {
						console.log('Error: ' + error.code + ' ' + error.message);
					}
				});
			},
			error : function(user, err) {
				errorCalback('Usuario o contraseña no válidos.');
			}
		});
	};

	return loginCloud;
}());
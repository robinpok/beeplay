var emailSender = require('cloud/email.js');

var BeepStatusNoUsers = 0;
var BeepStatusUsers = 1;
var BeepStatusWithFeedback = 2;
var BeepStatusCompleted = 3;

var BeepSubscriptionStatusSubscribed = 0;
var BeepSubscriptionStatusFeedbackSent = 1;
var BeepSubscriptionStatusFeedbackApproved = 2;
var BeepSubscriptionStatusFeedbackDeclined = 3;

/*
* Send an email using Mandrill
* The request object needs to contain the following values:
*	@param htmlBody		the body in HTML format
*	@param subject		the email's subject
*	@param userEmail	the user's email address
*	@param userName		the user's full name
*/
Parse.Cloud.define('sendEmailAsAdmin', function(request, response)
{
	var subject = request.params.subject;
	var body = request.params.htmlBody;
	var from_email = 'admin@beeplay.com';
	var from_name = 'Beeplay';
	var to = [
	{
		email: request.params.userEmail,
		name: request.params.userName
	}];

	emailSender.sendEmail(subject, body, from_email, from_name, to, [], response.success, response.error);
});

Parse.Cloud.define('sendBalanceRequest', function(request, response)
{
	var amount = request.params.amount;
	var paypayEmail = request.params.paypalEmail;
	var identityCardNumber = request.params.identitiyCardNumber;
	var state = request.params.state;
	var username = request.params.username;
	var name = request.params.name;

	var subject = 'Solicitud de ingreso';
	var body = '<h3>Solicitud de ingreso</h3>' +
	'<p>El usuario ' + name + ' (' + username + ') con DNI ' + identityCardNumber + ' y residencia en ' + state + ' solicita el ingreso de</p>' +
	'<h4>' + amount + '&euro;</h4>' +
	'<p> en su cuenta de PayPal</p>' +
	'<h4>' + paypayEmail + '</h4>';

	var from_email = 'pagos@beeplay.com';
	var from_name = '[Beeplay] Solicitud de dinero';
	var to = [
	{
		email: 'admin@beeplay.com',
		name: 'Beeplay Admin'
	}];

	emailSender.sendEmail(subject, body, from_email, from_name, to, [], response.success, response.error);
});

Parse.Cloud.define('sendFeedback', function(request, response)
{
	var text = request.params.text;
	var images = request.params.images;
	var beepTitle = request.params.beepTitle;
	var beepCompanyName = request.params.beepCompanyName;
	var username = request.params.username;
	var name = request.params.name;
	var responseEmail = request.params.responseEmail;

	var subject = 'Informe para el beep ' + beepTitle + ' de la empresa ' + beepCompanyName;
	var body = '<h3>Recepción de informe</h3>' +
	'<p>El usuario ' + name + ' (' + username + ') ha enviado el siguiente informe para el beep ' + beepTitle + ' de la empresa ' + beepCompanyName + ':</p>' +
	'<p>' + text + '</p>';

	var from_email = 'informes@beeplay.com';
	var from_name = '[Beeplay] Informes';
	var to = [
	{
		email: responseEmail
	}];

	emailSender.sendEmail(subject, body, from_email, from_name, to, images, response.success, response.error);
});

/*
 * Beep subscription save
 */

Parse.Cloud.beforeSave('BeepSubscription', function(request, response) {
 	request.object.get('beep').fetch({
 		success: function(beep) {
 			var beepSubscription = request.object;

 			if (beep.get('status') === BeepStatusCompleted ||
 				beepSubscription.get('status') === BeepSubscriptionStatusSubscribed && beep.get('isFull') === true) {
 				response.error('BP-1000');
	 		}
	 		else {
	 			var beepStatus = beep.get('status');
	 			var subscriptionStatus = beepSubscription.get('status');
	 			console.log('Beep Status ' + beepStatus);
	 			console.log('Subscription Status ' + subscriptionStatus);

	 			if (beepStatus === BeepStatusNoUsers) {
	 				beep.set('status', BeepStatusUsers);
	 			}
	 			else if (subscriptionStatus === BeepSubscriptionStatusFeedbackSent) {
	 				beep.set('numberOfReportsPending', beep.get('numberOfReportsPending') + 1);
	 				beep.set('status', BeepStatusWithFeedback);
	 			}
	 			else if (subscriptionStatus === BeepSubscriptionStatusFeedbackDeclined) {
	 				beep.set('numberOfReportsPending', beep.get('numberOfReportsPending') - 1);

	 				if (beep.get('numberOfReportsPending') <= 0) {
 						beep.set('status', BeepStatusNoUsers);
 						beep.set('numberOfReportsPending', 0);
	 				}

	 				sendiOSPushNotification(beepSubscription.get('user'), "Vaya, Beep rechazado… ¡No te desanimes!");
	 			}
	 			else if (subscriptionStatus === BeepSubscriptionStatusFeedbackApproved) {
	 				beep.set('numberOfReportsPending', beep.get('numberOfReportsPending') - 1);
	 				beep.set('numberOfReportsApproved', beep.get('numberOfReportsApproved') + 1);
	 				/*
	 				if (beep.get('numberOfReportsApproved') >= beep.get('maximumNumberOfParticipants')) {
	 					beep.set('status', BeepStatusCompleted);
 						beep.set('numberOfReportsApproved', beep.get('maximumNumberOfParticipants'));
 						beep.set('isFull', true);
	 				}
	 				else */
	 				if (beep.get('numberOfReportsPending') <= 0) {
	 					beep.set('status', BeepStatusNoUsers);
 						beep.set('numberOfReportsPending', 0);
					}

					sendiOSPushNotification(beepSubscription.get('user'), "¡Toma ya! Tu Beep ha sido aceptado.");
	 			}

	 			beep.save();
	 			response.success();
	 		}
	 	},
	 	error: function(object, error) {
	 		response.error('BP-0100');
	 	}
	 });
});

Parse.Cloud.afterDelete('BeepSubscription', function(request)
{
	var beep = request.object.get('beep');
	var query = new Parse.Query(Parse.Object.extend('BeepSubscription'));
	query.equalTo('beep', beep);
	query.count({
		success: function(count) {
			if (count === 0) {
				beep.set('status', BeepStatusNoUsers);
				beep.set('isFull', false);
				beep.set('numberOfReportsPending', 0);

				beep.save();
			}
			else {
				query.containedIn('status', [0, 1, 2]);
				query.count({
					success: function(count) {

						if (count >= beep.get('maximumNumberOfParticipants')) {
							beep.set('isFull', true);
						}
						else {
							beep.set('isFull', false);
							beep.set('status', BeepStatusUsers);
						}

						beep.set('numberOfReportsPending', beep.get('numberOfReportsPending') - 1);
		 				if (beep.get('numberOfReportsPending') <= 0) {
	 						beep.set('status', BeepStatusNoUsers);
	 						beep.set('numberOfReportsPending', 0);
		 				}

						beep.save();
					},
					error: function(error) {
						console.log('error ' + error);
					}
				});
			}
		},
		error: function(error) {
			console.log('error ' + error);
		}
	});
});

/*
 * Beep save
 */
 Parse.Cloud.beforeSave('Beep', function(request, response) {
 	if (request.object.id) {
 		var query = new Parse.Query(Parse.Object.extend('BeepSubscription'));
 		query.equalTo('beep', request.object);
 		query.containedIn('status', [0, 1, 2]);
 		query.count({
 			success: function(count) {
 				if (count >= request.object.get('maximumNumberOfParticipants')) {
 					request.object.set('isFull', true);
 				}
 				else {
 					request.object.set('isFull', false);
 				}
 				response.success();
 			},
 			error: function(error) {
 				response.error('BP-0101');
 			}
 		});
 	}
 	else {
 		request.object.set('isFull', false);
 		response.success();
 	}
 });

 Parse.Cloud.afterDelete('Beep', function(request)
 {
 	var beep = request.object;
 	var query = new Parse.Query(Parse.Object.extend('BeepSubscription'));
 	query.equalTo('beep', beep);
 	query.find({
 		success: function(results) {
 			Parse.Object.destroyAll(results, {
 				success: function() {
				  	console.log("Deleted " + results.length + " subscriptions for Beep " + beep.get('beepDescription'));
				},
				error: function(error) {
					// An error occurred while deleting one or more of the objects.
					// If this is an aggregate error, then we can inspect each error
					// object individually to determine the reason why a particular
					// object was not deleted.
	  				if (error.code == Parse.Error.AGGREGATE_ERROR) {
	  					for (var i = 0; i < error.errors.length; i++) {
	  						console.log("Couldn't delete " + error.errors[i].object.id + "due to " + error.errors[i].message);
	  					}
	  				} else {
	  					console.log("Delete aborted because of " + error.message);
	  				}
				}
			});
 		},
 		error: function(error) {
			console.log('error ' + error);
 		}
 	});
 });

/*
 * User management
 */
 Parse.Cloud.afterSave('_User', function(request, response)
 {
 	var user = request.object;
 	if (user.createdAt.getTime() === user.updatedAt.getTime()) {
		// New user, send welcome email
		sendWelcomeMessage(user);
	}
});

 function sendWelcomeMessage(user)
 {
 	var query = new Parse.Query(Parse.Object.extend('Settings'));
 	query.first({
 		success: function (settings) {
 			var subject = settings.get('welcomeMessageSubject');
 			var body = settings.get('welcomeMessageBody');
 			var from_email = 'admin@beeplay.com';
 			var from_name = 'Beeplay';
 			var to = [{
 				email: user.get('email'),
 				name: user.get('name') + ' ' + user.get('firstSurname') + ' ' + user.get('secondSurname')
 			}];

 			emailSender.sendEmail(subject, body, from_email, from_name, to, [], function () { console.log('mail sent'); }, function (error) { console.log('failed ' + error); });
 		},
 		error: function (error) {
 			console.log('Failed to send welcome message. (Error: ' + error.code + ' : ' + error.message);
 		}
 	});
 }

 Parse.Cloud.afterDelete('_User', function(request, response)
 {
 	var user = request.object;
 	console.log('Deleted user with id: ' + user.id);

 	query = new Parse.Query('BeepSubscription');
 	query.equalTo('user', user);
 	query.find({
 		success: function(subscriptions) {
 			Parse.Object.destroyAll(subscriptions, {
 				success: function() {
 					console.log('Deleted all subscriptions for user ' + user.id);
 				},
 				error: function(error) {
 					console.error('Error deleting related subscriptions for user ' + user.id + ' (' + error.code + ' : ' + error.message + ')');
 				}
 			});
 		},
 		error: function(error) {
 			console.error('Error finding related subscriptions for user ' + user.id + ' (' + error.code + ' : ' + error.message + ')');
 		}
 	});

 	var balance = user.get('balance');
 	balance.destroy({
 		success: function(balance) {
 			console.log('Deleted balance for user ' + user.id);
 		},
 		error: function(error) {
 			console.error('Error deleting balance for user ' + user.id + ' (' + error.code + ' : ' + error.message + ')');
 		}
 	});
 });

/*
 * Subscription cleaner
 */

 var jobSettings;

 Parse.Cloud.job('subscriptionCleaner', function(request, status)
 {
	// Set up to modify user data
	Parse.Cloud.useMasterKey();
	var now = new Date();

	jobSettings = undefined;

	// Query for all users

	var query = new Parse.Query(Parse.Object.extend('BeepSubscription'));
	query.equalTo('status', 0);
	query.limit(1000);
	query.include('beep');
	query.include('user');

	query.find({
		success: function(subscriptions) {
			var numberOfDeletedSubscriptions = 0;
			var numberOfFailedSubscriptionDeletions = 0;
			var totalNumberOfDeleted = 0;

			var options = {
					success : function (subscription) {
						numberOfDeletedSubscriptions++;
						console.log('deleting successful : ' + subscription.get('beep').id);
						var allDeleted = (numberOfDeletedSubscriptions+numberOfFailedSubscriptionDeletions == totalNumberOfDeleted);
						sendTimeoutMessage(subscription, status, allDeleted, 'Successfully deleted ' + numberOfDeletedSubscriptions + ' subscriptions, ' + numberOfFailedSubscriptionDeletions + ' subscriptions failed.');
					},
					error : function (subscription, error) {
						console.log('deleting failed : ' + subscription.get('beep').id);
						numberOfFailedSubscriptionDeletions++;
						if (numberOfDeletedSubscriptions+numberOfFailedSubscriptionDeletions == totalNumberOfDeleted)
							status.success('Successfully deleted ' + numberOfDeletedSubscriptions + ' subscriptions, ' + numberOfFailedSubscriptionDeletions + ' subscriptions failed.');
					}
				};

			for (i = 0; i < subscriptions.length; i++) {
				subscription = subscriptions[i];

				var maxHours = subscription.get('beep').get('beepSubscriptionTimeout');
				var subscriptionDate = subscription.createdAt;
				var hoursPassed = (now - subscriptionDate)/3600000.0;

				if (maxHours && subscriptionDate && hoursPassed && maxHours > 0 && hoursPassed > maxHours){
					console.log('destroying id : ' + subscription.get('beep').id);
					totalNumberOfDeleted++;
					subscription.destroy(options);
				}
			}

			if (totalNumberOfDeleted == 0)
				status.success('No subscription has been deleted.');
		},
		error: function(error) {
			// Set the job's error status
			status.error('Error '+ error.code + ' : ' + error.message);
		}
	});
});

function sendTimeoutMessage(subscription, logger, isLastMessage, successMessage)
{
	if (!jobSettings) {
		var query = new Parse.Query(Parse.Object.extend('Settings'));
		query.first({
			success: function (settings) {
				jobSettings = settings;
				sendTimeoutEmail(subscription, settings, logger, isLastMessage, successMessage);
				logger.message('Timeout message sent!');
			},
			error: function (error) {
				logger.message('Failed to send welcome message. (Error: ' + error.code + ' : ' + error.message);
			}
		});
	}
	else {
		sendTimeoutEmail(subscription, jobSettings, logger, isLastMessage, successMessage);
	}
}

function sendTimeoutEmail(subscription, settings, logger, isLastMessage, successMessage)
{
	var user = subscription.get('user');
	var subject = settings.get('timeoutMessageSubject');
	var body = settings.get('timeoutMessageBody').replace('{BEEP_DESCRIPTION_KEY}', subscription.get('beep').get('beepDescription'));
	var from_email = 'admin@beeplay.com';
	var from_name = 'Beeplay';
	var to = [{
		email: user.get('email'),
		name: user.get('name') + ' ' + user.get('firstSurname') + ' ' + user.get('secondSurname')
	}];
	emailSender.sendEmail(subject, body, from_email, from_name, to, [], function () {
		logger.message('mail sent');
		if (isLastMessage)
			logger.success(successMessage);

	}, function (error) { 
		logger.error('failed ' + error); 
		if (isLastMessage)
			logger.success(successMessage);
	});
}

function sendiOSPushNotification(user, text)
{
  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo('deviceType', 'ios');
  pushQuery.equalTo('user', user);
    
  Parse.Push.send({
    where: pushQuery, // Set our Installation query
    data: {
      alert: text,
      badge: "Increment",
      sound: "cheering.caf"
    }
  }, {
    success: function() {
      // Push was successful
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
}

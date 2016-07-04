var BeepDetailsCloud = (function()
{
	var beepDetailsCloud = {};

	/*
	 * The beep whose data we are modifying
	 */
	var currentBeep;

	beepDetailsCloud.newBeep = function(companyName, title, price, points, address, addressLine1, addressLine2, latitude, longitude, description, responseEmail, maximumNumberOfParticipants, beepSubscriptionTimeout, geolocationRequired, photoRequired, cameraRoll, visibility)
	{
		var Beep = Backend.Models.Beep;
		var beep = new Beep();

		beep.set(Backend.Properties.Beep.CompanyName, companyName);
		beep.set(Backend.Properties.Beep.Title, title);
		beep.set(Backend.Properties.Beep.Price, price);
		beep.set(Backend.Properties.Beep.Points, points);
		beep.set(Backend.Properties.Beep.Address, address);
		beep.set(Backend.Properties.Beep.AddressLine1, addressLine1);
		beep.set(Backend.Properties.Beep.AddressLine2, addressLine2);
		beep.set(Backend.Properties.Beep.Latitude, latitude);
		beep.set(Backend.Properties.Beep.Longitude, longitude);
		beep.set(Backend.Properties.Beep.Description, description);
		beep.set(Backend.Properties.Beep.ResponseEmail, responseEmail);
		beep.set(Backend.Properties.Beep.MaximumNumberOfParticipants, maximumNumberOfParticipants);
		beep.set(Backend.Properties.Beep.BeepSubscriptionTimeout, beepSubscriptionTimeout);
		beep.set(Backend.Properties.Beep.Status, Backend.PropertyValues.Beep.Status.NoUsers);
		beep.set(Backend.Properties.Beep.GeolocationRequired, geolocationRequired);
		beep.set(Backend.Properties.Beep.PhotoRequired, photoRequired);
		beep.set(Backend.Properties.Beep.CameraRollAllowed, cameraRoll);
		beep.set(Backend.Properties.Beep.Visibility, visibility);
		beep.set(Backend.Properties.Beep.NumberOfReportsApproved, 0);
		beep.set(Backend.Properties.Beep.NumberOfReportsPending, 0);

		return beep;
	};

	beepDetailsCloud.updateBeepFromBeep = function(beep, updatedBeep)
	{
		if (beep.get(Backend.Properties.Beep.CompanyName) !== updatedBeep.get(Backend.Properties.Beep.CompanyName)) {
			beep.set(Backend.Properties.Beep.CompanyName, updatedBeep.get(Backend.Properties.Beep.CompanyName));
		}
		if (beep.get(Backend.Properties.Beep.Title) !== updatedBeep.get(Backend.Properties.Beep.Title)) {
			beep.set(Backend.Properties.Beep.Title, updatedBeep.get(Backend.Properties.Beep.Title));
		}
		if (beep.get(Backend.Properties.Beep.Price) !== updatedBeep.get(Backend.Properties.Beep.Price)) {
			beep.set(Backend.Properties.Beep.Price, updatedBeep.get(Backend.Properties.Beep.Price));
		}
		if (beep.get(Backend.Properties.Beep.Points) !== updatedBeep.get(Backend.Properties.Beep.Points)) {
			beep.set(Backend.Properties.Beep.Points, updatedBeep.get(Backend.Properties.Beep.Points));
		}
		if (beep.get(Backend.Properties.Beep.Address) !== updatedBeep.get(Backend.Properties.Beep.Address)) {
			beep.set(Backend.Properties.Beep.Address, updatedBeep.get(Backend.Properties.Beep.Address));
		}
		if (beep.get(Backend.Properties.Beep.AddressLine1) !== updatedBeep.get(Backend.Properties.Beep.AddressLine1)) {
			beep.set(Backend.Properties.Beep.AddressLine1, updatedBeep.get(Backend.Properties.Beep.AddressLine1));
		}
		if (beep.get(Backend.Properties.Beep.AddressLine2) !== updatedBeep.get(Backend.Properties.Beep.AddressLine2)) {
			beep.set(Backend.Properties.Beep.AddressLine2, updatedBeep.get(Backend.Properties.Beep.AddressLine2));
		}
		if (beep.get(Backend.Properties.Beep.Latitude) !== updatedBeep.get(Backend.Properties.Beep.Latitude)) {
			beep.set(Backend.Properties.Beep.Latitude, updatedBeep.get(Backend.Properties.Beep.Latitude));
		}
		if (beep.get(Backend.Properties.Beep.Longitude) !== updatedBeep.get(Backend.Properties.Beep.Longitude)) {
			beep.set(Backend.Properties.Beep.Longitude, updatedBeep.get(Backend.Properties.Beep.Longitude));
		}
		if (beep.get(Backend.Properties.Beep.Description) !== updatedBeep.get(Backend.Properties.Beep.Description)) {
			beep.set(Backend.Properties.Beep.Description, updatedBeep.get(Backend.Properties.Beep.Description));
		}
		if (beep.get(Backend.Properties.Beep.ResponseEmail) !== updatedBeep.get(Backend.Properties.Beep.ResponseEmail)) {
			beep.set(Backend.Properties.Beep.ResponseEmail, updatedBeep.get(Backend.Properties.Beep.ResponseEmail));
		}
		if (beep.get(Backend.Properties.Beep.MaximumNumberOfParticipants) !== updatedBeep.get(Backend.Properties.Beep.MaximumNumberOfParticipants)) {
			beep.set(Backend.Properties.Beep.MaximumNumberOfParticipants, updatedBeep.get(Backend.Properties.Beep.MaximumNumberOfParticipants));
		}
		if (beep.get(Backend.Properties.Beep.BeepSubscriptionTimeout) !== updatedBeep.get(Backend.Properties.Beep.BeepSubscriptionTimeout)) {
			beep.set(Backend.Properties.Beep.BeepSubscriptionTimeout, updatedBeep.get(Backend.Properties.Beep.BeepSubscriptionTimeout));
		}
		if (beep.get(Backend.Properties.Beep.GeolocationRequired) !== updatedBeep.get(Backend.Properties.Beep.GeolocationRequired)) {
			beep.set(Backend.Properties.Beep.GeolocationRequired, updatedBeep.get(Backend.Properties.Beep.GeolocationRequired));
		}
		if (beep.get(Backend.Properties.Beep.PhotoRequired) !== updatedBeep.get(Backend.Properties.Beep.PhotoRequired)) {
			beep.set(Backend.Properties.Beep.PhotoRequired, updatedBeep.get(Backend.Properties.Beep.PhotoRequired));
		}
		if (beep.get(Backend.Properties.Beep.CameraRollAllowed) !== updatedBeep.get(Backend.Properties.Beep.CameraRollAllowed)) {
			beep.set(Backend.Properties.Beep.CameraRollAllowed, updatedBeep.get(Backend.Properties.Beep.CameraRollAllowed));
		}
		if (beep.get(Backend.Properties.Beep.Visibility) !== updatedBeep.get(Backend.Properties.Beep.Visibility)) {
			beep.set(Backend.Properties.Beep.Visibility, updatedBeep.get(Backend.Properties.Beep.Visibility));
		}
	};

	beepDetailsCloud.saveBeep = function(beep, successCallback, errorCallback) {
		beep.save(null, {
			success: function(savedBeep) {
				currentBeep = savedBeep;
				successCallback();
			},
			error: function(object, error) {
				console.log('Failed creation with error: ' + error);
				errorCallback();
			}
		});
	};

	beepDetailsCloud.fetchBeepById = function(beepId, successCallback, errorCallback)
	{
		var Beep = Backend.Models.Beep;
		var query = new Parse.Query(Beep);
		query.get(beepId, {
			success: function(beep) {
				currentBeep = beep;
				successCallback(beep);
			},
			error: function(object, error) {
				errorCallback(error);
			}
		});
	};

	var indexedSubscriptions;

	beepDetailsCloud.subscriptions = function(beep, successCallback, errorCallback)
	{
		indexedSubscriptions = {};
		var BeepSubscription = Backend.Models.BeepSubscription;
		var query = new Parse.Query(BeepSubscription);
		query.equalTo('beep', beep);
		query.include('user');
		// Setting the limit to the maximum value in order to get all the results in a single request.
		// Another way to solve this problem would be querying beeps by status, but this would consume
		// 3 requests each time the user accesses the list website.
		query.limit(1000);
		query.find({
			success: function(results)
			{
				if (!results || results.length === 0) {
					successCallback(results);
				}

				for (var subscriptionIndex in results) {
					var subscription = results[subscriptionIndex];
					indexedSubscriptions[subscription.id] = subscription;
				}
				successCallback(results);
			},
			error: function(error)
			{
				console.log('Failed with error: ' + error);
				errorCallback();
			}
		});
	};

	beepDetailsCloud.unsubscribe = function(subscriptionId, successCallback, errorCallback)
	{
		var BeepSubscription = Backend.Models.BeepSubscription;
		var query = new Parse.Query(BeepSubscription);
			query.include('user');
		query.get(subscriptionId, {
			success: function(subscription) {
				subscription.destroy({
					success : function (deletedSubscription) {
						sendSubscriptionStatusMessage(subscription, 'deletedSubscription');
						successCallback(deletedSubscription);
					},
					error : function (nonDeletedSubscription, error) {
						errorCallback(error);
					}
				});
			},
			error: function(object, error) {
				errorCallback(error);
			}
		});
	};

	beepDetailsCloud.acceptFeedback = function(subscriptionId, successCallback, errorCallback)
	{
		updateSubscriptionWithStatus(subscriptionId, Backend.PropertyValues.BeepSubscription.Status.FeedbackApproved, successCallback, errorCallback);
	};

	beepDetailsCloud.rejectFeedback = function(subscriptionId, successCallback, errorCallback)
	{
		updateSubscriptionWithStatus(subscriptionId, Backend.PropertyValues.BeepSubscription.Status.FeedbackDeclined, successCallback, errorCallback);
	};

	function sendSubscriptionStatusMessage(subscription, status)
	{
		var query = new Parse.Query(Parse.Object.extend('Settings'));
		query.first({
			success: function (settings) {
				var user = subscription.get('user');
				var subject;
				var body;

				if (status === Backend.PropertyValues.BeepSubscription.Status.FeedbackApproved) {
					subject = settings.get(Backend.Properties.Settings.AcceptanceMessageSubject);
					body = settings.get(Backend.Properties.Settings.AcceptanceMessageBody).replace('{BEEP_DESCRIPTION_KEY}', currentBeep.get(Backend.Properties.Beep.Description));
				}
				// Feedback rejected
				else if (status === Backend.PropertyValues.BeepSubscription.Status.FeedbackDeclined) {
					subject = settings.get(Backend.Properties.Settings.RejectionMessageSubject);
					body = settings.get(Backend.Properties.Settings.RejectionMessageBody).replace('{BEEP_DESCRIPTION_KEY}', currentBeep.get(Backend.Properties.Beep.Description));
				}
				else if (status === 'deletedSubscription') {
					subject = settings.get(Backend.Properties.Settings.TimeoutMessageSubject);
					body = settings.get(Backend.Properties.Settings.TimeoutMessageBody).replace('{BEEP_DESCRIPTION_KEY}', currentBeep.get(Backend.Properties.Beep.Description));
				}

				var message = {
					htmlBody: body,
					subject: subject,
					userEmail: user.get(Backend.Properties.User.Email),
					userName: user.get(Backend.Properties.User.Name) + ' ' + user.get(Backend.Properties.User.FirstSurname) + ' ' + user.get(Backend.Properties.User.SecondSurname)
				};

				Parse.Cloud.run('sendEmailAsAdmin', message, {
					success: function(result)
					{
						console.log(result);
					},
					error: function(error)
					{
						console.log(error);
					}
				});
			},
			error: function (error) {
				console.log('Failed to send welcome message. (Error: ' + error.code + ' : ' + error.message);
			}
		});
	}

	function updateSubscriptionWithStatus(subscriptionId, newStatus, successCallback, errorCallback)
	{
		var subscription = indexedSubscriptions[subscriptionId];

		subscription.set(Backend.Properties.BeepSubscription.Status, newStatus);
		subscription.save(null, {
			success: function(beepSubscription) {
				indexedSubscriptions[subscriptionId] = beepSubscription;
				if (newStatus == Backend.PropertyValues.BeepSubscription.Status.FeedbackApproved) {
					updateBalance(subscription, function () {
						//sendSubscriptionStatusMessage(beepSubscription, newStatus);
						successCallback(beepSubscription);
					}, function (error) {
						errorCallback(error);
					});
				}
				else {
					//sendSubscriptionStatusMessage(beepSubscription, newStatus);
					successCallback(beepSubscription);
				}
			},
			error: function(object, error) {
				console.log('Failed update with error: ' + error);
				errorCallback();
			}
		});
	}

	function updateBalance(subscription, successCallback, errorCallback)
	{
		var user = subscription.get(Backend.Properties.BeepSubscription.User);
		var balance = user.get(Backend.Properties.User.Balance);
		balance.fetch({
			success: function(balance) {
				var moneyBalance = balance.get(Backend.Properties.Balance.AccountBalance);
				moneyBalance += currentBeep.get(Backend.Properties.Beep.Price);
				balance.set(Backend.Properties.Balance.AccountBalance, moneyBalance);

				var accumulatedMoneyBalance = balance.get(Backend.Properties.Balance.AccumulatedMoneyBalance);
				accumulatedMoneyBalance += currentBeep.get(Backend.Properties.Beep.Price);
				balance.set(Backend.Properties.Balance.AccumulatedMoneyBalance, accumulatedMoneyBalance);

				var pointsBalance = balance.get(Backend.Properties.Balance.PointsBalance);
				pointsBalance += currentBeep.get(Backend.Properties.Beep.Points);
				balance.set(Backend.Properties.Balance.PointsBalance, pointsBalance);

				var accumulatedPointsBalance = balance.get(Backend.Properties.Balance.AccumulatedPointsBalance);
				accumulatedPointsBalance += currentBeep.get(Backend.Properties.Beep.Points);
				balance.set(Backend.Properties.Balance.AccumulatedPointsBalance, accumulatedPointsBalance);

				balance.save(null, {
					success: function(balance) {
						successCallback();
					},
					error: function(error) {
						errorCallback(error);
					}
				});
			}
		});
	}

	return beepDetailsCloud;
}());
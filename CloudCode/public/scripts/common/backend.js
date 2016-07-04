var Backend = (function() {
	var beeplay = {};

	$(function main()
	{
		initParse();
	});

	function initParse()
	{
		// Parse initialization

		// Prod
		// Parse.initialize("uqP6NkjgqzJfmQb4TqqLdpXpauO5TO5PUXii0ydg", "qS1hvepdA51rT850rRFNRfibrOt10McUkSqQyA1r");

		// Test
		Parse.initialize("6usE5O1ka3XKvNsQdWGqCDcRShg8xqp3qP4RhMmZ", "1A7Ys6Xo0VxRQsxjfP4rdd2QkE3TFN8fnIXYdOME");

		// Dev
		// Parse.initialize("8CjiZVMZVIkGYKKQOSUi0lhLdYp0hJC6YBQLxL69", "FapRF3XZcpYdj7QOBasVdWSebkePUjlO9ntQcbBi");
	}

	beeplay.Models = {
		Beep : Parse.Object.extend('Beep'),
		BeepSubscription : Parse.Object.extend('BeepSubscription'),
		Balance : Parse.Object.extend('Balance'),
		Settings : Parse.Object.extend('Settings')
	};

	beeplay.Properties = {
		User : {
			Name : 'name',
			FirstSurname :'firstSurname',
			SecondSurname :'secondSurname',
			Email : 'email',
			Username : 'username',
			Password : 'password',
			Gender : 'gender',
			Birthday : 'birthday',
			Occupation : 'occupation',
			Interests : 'interests',
			EducationalAttainment : 'educationalAttainment',
			Balance : 'balance',
			IdentityCardNumber : 'identityCardNumber',
			State : 'state',
			PaypalEmail : 'paypalEmail'
		},
		Beep : {
			CompanyName : 'companyName',
			Title : 'title',
			Price : 'price',
			Points : 'points',
			Address : 'address',
			AddressLine1 : 'addressLine1',
			AddressLine2 : 'addressLine2',
			Latitude : 'latitude',
			Longitude : 'longitude',
			Description : 'beepDescription',
			ResponseEmail : 'responseEmail',
			MaximumNumberOfParticipants : 'maximumNumberOfParticipants',
			BeepSubscriptionTimeout : 'beepSubscriptionTimeout',
			Status : 'status',
			GeolocationRequired : 'geolocationRequired',
			PhotoRequired : 'photoRequired',
			CameraRollAllowed : 'cameraRollAllowed',
			Visibility : 'visibility',
			NumberOfReportsApproved : 'numberOfReportsApproved',
			NumberOfReportsPending : 'numberOfReportsPending'
		},
		BeepSubscription : {
			Beep : 'beep',
			User : 'user',
			Status : 'status'
		},
		Balance : {
			AccountBalance : 'accountBalance',
			PointsBalance : 'pointsBalance',
			AccumulatedMoneyBalance : 'accumulatedMoneyBalance',
			AccumulatedPointsBalance : 'accumulatedPointsBalance'
		},
		Settings : {
			AcceptanceMessageSubject : 'acceptanceMessageSubject',
			AcceptanceMessageBody : 'acceptanceMessageBody',
			RejectionMessageSubject : 'rejectionMessageSubject',
			RejectionMessageBody : 'rejectionMessageBody',
			TimeoutMessageSubject : 'timeoutMessageSubject',
			TimeoutMessageBody : 'timeoutMessageBody',
			WelcomeMessageSubject : 'welcomeMessageSubject',
			WelcomeMessageBody : 'welcomeMessageBody',
			InactivityMessageSubject : 'inactivityMessageSubject',
			InactivityMessageBody : 'inactivityMessageBody',
			MinimumMoneyBalanceToReclaim : 'minimumMoneyBalanceToReclaim',
			MinimumPointsBalanceToReclaim : 'minimumPointsBalanceToReclaim'
		}
	};

	beeplay.PropertyValues = {
		User : {
			Gender : {
				Male : 0,
				Female : 1
			},
			EducationalAttainment : {
				None : 0,
				BasicStudies : 1,
				HighSchool : 2,
				VocationalTraining : 3,
				UniversityStudies : 4,
				MastersDegree : 5
			}
		},
		Beep : {
			Status : {
				NoUsers : 0,
				Users : 1,
				WithFeedback : 2,
				Completed: 3
			}
		},
		BeepSubscription : {
			Status : {
				Subscribed : 0,
				FeedbackSent : 1,
				FeedbackApproved : 2,
				FeedbackDeclined : 3
			}
		}
	};

	beeplay.isLoggedIn = function ()
	{
		return Parse.User.current();
	};

	beeplay.logOut = function ()
	{
		Parse.User.logOut();
	};

	beeplay.currentUser = function()
	{
		return Parse.User.current();
	};

	return beeplay;
})();
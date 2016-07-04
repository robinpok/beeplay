var SettingsCloud = (function()
{
	var settingsCloud = {};

	/*
	 * The beep whose data we are modifying
	 */
	var currentSettings;

	settingsCloud.newSettings = function(minimumMoneyBalanceToReclaim, minimumPointsBalanceToReclaim, welcomeMessageSubject, welcomeMessageBody, timeoutMessageSubject, timeoutMessageBody, inactivityMessageSubject, inactivityMessageBody, acceptanceMessageSubject, acceptanceMessageBody, rejectionMessageSubject, rejectionMessageBody)
	{
		var Settings = Backend.Models.Settings;
		var settings = new Settings();

		settings.set(Backend.Properties.Settings.MinimumMoneyBalanceToReclaim, minimumMoneyBalanceToReclaim);
		settings.set(Backend.Properties.Settings.MinimumPointsBalanceToReclaim, minimumPointsBalanceToReclaim);
		settings.set(Backend.Properties.Settings.WelcomeMessageSubject, welcomeMessageSubject);
		settings.set(Backend.Properties.Settings.WelcomeMessageBody, welcomeMessageBody);
		settings.set(Backend.Properties.Settings.TimeoutMessageSubject, timeoutMessageSubject);
		settings.set(Backend.Properties.Settings.TimeoutMessageBody, timeoutMessageBody);
		settings.set(Backend.Properties.Settings.InactivityMessageSubject, inactivityMessageSubject);
		settings.set(Backend.Properties.Settings.InactivityMessageBody, inactivityMessageBody);
		settings.set(Backend.Properties.Settings.AcceptanceMessageSubject, acceptanceMessageSubject);
		settings.set(Backend.Properties.Settings.AcceptanceMessageBody, acceptanceMessageBody);
		settings.set(Backend.Properties.Settings.RejectionMessageSubject, rejectionMessageSubject);
		settings.set(Backend.Properties.Settings.RejectionMessageBody, rejectionMessageBody);

		return settings;
	};

	settingsCloud.updateSettingsFromSettings = function(settings, updatedSettings)
	{
		settings.set(Backend.Properties.Settings.MinimumMoneyBalanceToReclaim, updatedSettings.get(Backend.Properties.Settings.MinimumMoneyBalanceToReclaim));
		settings.set(Backend.Properties.Settings.MinimumPointsBalanceToReclaim, updatedSettings.get(Backend.Properties.Settings.MinimumPointsBalanceToReclaim));
		settings.set(Backend.Properties.Settings.WelcomeMessageSubject, updatedSettings.get(Backend.Properties.Settings.WelcomeMessageSubject));
		settings.set(Backend.Properties.Settings.WelcomeMessageBody, updatedSettings.get(Backend.Properties.Settings.WelcomeMessageBody));
		settings.set(Backend.Properties.Settings.TimeoutMessageSubject, updatedSettings.get(Backend.Properties.Settings.TimeoutMessageSubject));
		settings.set(Backend.Properties.Settings.TimeoutMessageBody, updatedSettings.get(Backend.Properties.Settings.TimeoutMessageBody));
		settings.set(Backend.Properties.Settings.InactivityMessageSubject, updatedSettings.get(Backend.Properties.Settings.InactivityMessageSubject));
		settings.set(Backend.Properties.Settings.InactivityMessageBody, updatedSettings.get(Backend.Properties.Settings.InactivityMessageBody));
		settings.set(Backend.Properties.Settings.AcceptanceMessageSubject, updatedSettings.get(Backend.Properties.Settings.AcceptanceMessageSubject));
		settings.set(Backend.Properties.Settings.AcceptanceMessageBody, updatedSettings.get(Backend.Properties.Settings.AcceptanceMessageBody));
		settings.set(Backend.Properties.Settings.RejectionMessageSubject, updatedSettings.get(Backend.Properties.Settings.RejectionMessageSubject));
		settings.set(Backend.Properties.Settings.RejectionMessageBody, updatedSettings.get(Backend.Properties.Settings.RejectionMessageBody));
	};

	settingsCloud.saveSettings = function(settings, successCallback, errorCallback)
	{
		if (currentSettings) {
			settingsCloud.updateSettingsFromSettings(currentSettings, settings);
			settings = currentSettings;
		}

		settings.save(null, {
			success: function(savedSettings) {
				currentSettings = savedSettings;
				successCallback();
			},
			error: function(object, error) {
				console.log('Failed creation with error: ' + error);
				errorCallback();
			}
		});
	};

	settingsCloud.loadSettings = function(successCallback, errorCallback)
	{
		var Settings = Backend.Models.Settings;
		var query = new Parse.Query(Settings);
		query.first({
			success: function(settings) {
				if (settings) {
					currentSettings = settings;
				}
				else {
					currentSettings = new Settings();
				}
				successCallback(currentSettings);
			},
			error: function(object, error) {
				errorCallback(error);
			}
		});
	};

	return settingsCloud;
}());
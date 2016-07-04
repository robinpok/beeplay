var BeepsListCloud = (function ()
{
	var beepsListCloud = {};

	var indexedBeeps;

	beepsListCloud.list = function (successCallback, errorCallback)
	{
		// Reset the global variables
		indexedBeeps = {};

		var Beep = Backend.Models.Beep;
		var query = new Parse.Query(Beep);
		// Setting the limit to the maximum value in order to get all the results in a single request.
		// Another way to solve this problem would be querying beeps by status, but this would consume
		// 3 requests each time the user accesses the list website.
		query.limit(1000);
		query.find({
			success: function(results) {
				console.log('Retrieved beeps: ' + results);

				for (var beepIndex in results) {
					var beep = results[beepIndex];
					indexedBeeps[beep.id] = results[beepIndex];
				}

				successCallback(results);
			},
			error: function(error) {
				console.log('Failed with error: ' + error);
				errorCallback();
			}
		});
	};

	beepsListCloud.deleteBeepById = function (beepId, successCallback, errorCallback)
	{
		var beep = indexedBeeps[beepId];
		beep.destroy({
			success: function(deletedBeep) {
				successCallback();
			},
			error: function(deletedBeep, error) {
				errorCallback(error);
			}
		});
	};

	return beepsListCloud;
}());
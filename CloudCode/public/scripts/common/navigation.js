var Navigation = (function ()
{
	var navigation = {};

	navigation.map = {
		index : 'index.html',
		settings : 'settings.html',
		beepslist : 'beepslist.html',
		beepdetails : 'beepdetails.html'
	};

	navigation.goTo = function (destination)
	{
		window.location = destination;
	};

	navigation.goToWithParameters = function (destination, parameters)
	{
		window.location = destination + '?' + parameters;
	};

	return navigation;
}());
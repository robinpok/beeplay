exports.sendEmail = function(subject, body, from_email, from_name, to, attachments, success, error)
{
	Parse.Cloud.httpRequest({
		method: 'POST',
		headers:
		{
			'Content-Type': 'application/json; charset=utf-8'
		},
		url: 'https://mandrillapp.com/api/1.0/messages/send.json',
		body:
		{
			key: 'OQhm5ve8RMe76W-dSb4v7w',
			message:
			{
				html: body,
				subject: subject,
				from_email: from_email,
				from_name: from_name,
				to: to,
				attachments: attachments
			}
		},
		success: function(httpResponse)
		{
			success(httpResponse);
		},
		error: function(httpResponse)
		{
			error(httpResponse);
		}
	});
};
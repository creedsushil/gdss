$('.toggle').on('click', function() {
	$('.container').stop().addClass('active');
});

$('.close').on('click', function() {
	$('.container').stop().removeClass('active');
});

$('.footer').on('click', function() {
	$('.register').stop().addClass('forgotActive');
	$('.login').stop().addClass('forgotActive');
	$('.passRecovery').stop().show();
});

$('.recoveryClose').on('click', function() {
	$('.register').stop().removeClass('forgotActive');
	$('.login').stop().removeClass('forgotActive');
	$('.passRecovery').stop().hide();
	$('#recoveryEmail').val("");
});

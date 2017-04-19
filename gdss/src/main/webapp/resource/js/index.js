$('.toggle').on('click', function() {
	$('.container').stop().addClass('active');
	$('#image').show();
	document.title = "Register";
});

$('.close').on('click', function() {
	$('.container').stop().removeClass('active');
	$('#image').hide();
	document.title = "Log In";
});

$('.footer').on('click', function() {
	$('.register').stop().addClass('forgotActive');
	$('.login').stop().addClass('forgotActive');
	$('.passRecovery').stop().show();
	document.title = "Recovery";
});

$('.recoveryClose').on('click', function() {
	$('.register').stop().removeClass('forgotActive');
	$('.login').stop().removeClass('forgotActive');
	$('.passRecovery').stop().hide();
	$('#recoveryEmail').val("");
	document.title = "Log In";
});

$("#pp").change(function(e) {

    for (var i = 0; i < e.target.files.length; i++) {

        var file = e.target.files[i];

        var img = document.createElement("img");
        img.height = 100;
        img.width = 100;
        var reader = new FileReader();
        reader.onloadend = function() {
             img.src = reader.result;
        }
        reader.readAsDataURL(file);
        $("#defImage").html(img);
    }
});

$("#defImage").click(function(e) {
	$("#pp").val('');
$("#defImage").html("<i class='fa fa-user' style='font-size: 100px;' aria-hidden='true'></i>");
});
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<html>
<head>
<title>Log in</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css" />

<link rel='stylesheet prefetch'
	href='http://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900|RobotoDraft:400,100,300,500,700,900' />
<link rel='stylesheet prefetch'
	href='http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css' />

<link rel="stylesheet" type="text/css" href="resource/css/style.css" />
</head>

<body>
	<div class="pen-title">
		<h1>Group Decision Support System</h1>
	</div>
	<div class="container ${register?'active':''}">
		<div class="card" style="display: none;"></div>
		<div class="card login">
			<c:if test="${not empty errorMessage && empty register}">
				<h2 class="error">${errorMessage}</h2>
			</c:if>
			<c:if test="${not empty successMessage && empty register}">
				<h2 class="success">${successMessage}</h2>
			</c:if>
			<h1 class="title">Login</h1>
			<form action="login" method="post">
				<div class="input-container">
					<input type="text" name="username" id="userName"
						required="required" /> <label for="#{label}">User name</label>
					<div class="bar"></div>
				</div>
				<div class="input-container">
					<input name="password" id="#{label}" required="required"
						onfocus="this.setAttribute('type','password')" /> <label
						for="#{label}">Password</label>
					<div class="bar"></div>
				</div>
				<div class="button-container">
					<button>
						<span>Go</span>
					</button>
				</div>
				<div class="footer">Forgot your password?</div>
			</form>
		</div>
		<div class="card alt register">
			<div class="toggle"></div>
			<c:if test="${not empty errorMessage && register}">
				<h2 class="error" id="registerError" style="color: black;">${errorMessage}</h2>
			</c:if>
			<h1 class="title">
				Register
				<div class="close" onclick="$('#registerError').hide();"></div>
			</h1>
			<form action="Register" method="POST"  enctype="multipart/form-data">
				<div id="image" style="display: none;">
					<input type="file" id="pp" name="profilePic" style="display: none;" />
					<label for="#{label}" id="defImage" style="color: #f9f2f2;background-color: #fbbec9;position:relative;left:160px;"><i class="fa fa-user"
						style="font-size: 100px;" aria-hidden="true"></i></label>
				</div>
				<div class="input-container">
					<input type="email" id="#{label}" required="required" name="email" />
					<label for="#{label}">Email</label>
					<div class="bar"></div>
				</div>
				<div class="input-container">
					<input type="text" id="#{label}" required="required"
						style="text-transform: uppercase;" name="username" /> <label
						for="#{label}">Username</label>
					<div class="bar"></div>
				</div>

				<div class="input-container">
					<input type="password" id="#{label}" required="required"
						name="password" /> <label for="#{label}">Password</label>
					<div class="bar"></div>
				</div>
				<div class="input-container">
					<input type="password" id="passwordre" required="required" /> <label
						for="#{label}">Repeat Password</label>
					<div class="bar"></div>
				</div>
				<div class="button-container">
					<button>
						<span>Next</span>
					</button>
				</div>
			</form>
		</div>
		<div class="card passRecovery" style="display: none;">
			<h1 class="title">
				Recovery Email
				<div class="close recoveryClose"></div>
			</h1>
			<form method="POST" action="PasswordRecovery">
				<div class="input-container">
					<input type="email" id="recoveryEmail" required="required"
						name="email" /> <label for="#{label}">Email</label> <br />
					<div class="button-container">
						<button>
							<span>Go</span>
						</button>
					</div>
				</div>
			</form>
		</div>

	</div>
<!-- 	<a id="portfolio" href="" title=""><i class="fa fa-link"></i></a>
	<a id="codepen" href="" title=""><i class="fa fa-codepen"></i></a> -->
	<script type="text/javascript"
		src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

	<script type="text/javascript" src="resource/js/index.js"></script>
	<script type="text/javascript">
		$(function() {
			$('#defImage').click(function(e) {
				e.preventDefault();
				$('#pp').click();
			});
		});
	</script>

</body>
</html>

 <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>Log in</title>
<meta charset="UTF-8">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">

<link rel='stylesheet prefetch'
	href='http://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900|RobotoDraft:400,100,300,500,700,900'>
<link rel='stylesheet prefetch'
	href='http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css'>

<link rel="stylesheet" href="resource/css/style.css">


</head>

<body>

	<!-- Mixins-->
	<!-- Pen Title-->
	<div class="pen-title">
		<h1>Group Decision Support System</h1>
	</div>
	<div class="container">
		<div class="card" style="display: none;"></div>
		<div class="card">
			<h1 class="title">Login</h1>
			<form action="login" method="post">
				<div class="input-container">
					<input type="text" name="username" id="userName"
						required="required"/> <label for="#{label}">User
						name</label>
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
				<div class="footer">
					Forgot your password?
				</div>
			</form>
		</div>
		<div class="card alt">
			<div class="toggle"></div>
			<h1 class="title">
				Register
				<div class="close"></div>
			</h1>
			<form>
				<div class="input-container">
					<input type="#{type}" id="#{label}" required="required" style="text-transform: uppercase;"/> <label
						for="#{label}">Username</label>
					<div class="bar"></div>
				</div>
				<div class="input-container">
					<input type="#{type}" id="#{label}" required="required" /> <label
						for="#{label}">Password</label>
					<div class="bar"></div>
				</div>
				<div class="input-container">
					<input type="#{type}" id="#{label}" required="required" /> <label
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
	</div>
	<a id="portfolio" href="" title="View my portfolio!"><i
		class="fa fa-link"></i></a>
	<a id="codepen" href="" title="Follow me!"><i class="fa fa-codepen"></i></a>
	<script
		src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

	<script src="resource/js/index.js"></script>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page isELIgnored="false"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Passwor Recovery</title>
</head>
<body>
	<div class="container active">
		<div class="card" style="display: none;"></div>
		<div class="card alt register">
			<form action="PasswordRecovery" method="POST">

				<div class="input-container">
					<input type="password" id="#{label}" required="required"
						name="password" /> <label for="#{label}">Password</label>
					<div class="bar"></div>
				</div>
				<div class="input-container">
					<input type="password" name="" id="passwordre" required="required" /> <label
						for="#{label}">Repeat Password</label>
					<div class="bar"></div>
				</div>
				<input type="hidden" name="token" value="${token}" />
				<div class="button-container">
					<button>
						<span>Next</span>
					</button>
				</div>
			</form>
		</div>
	</div>

</body>
</html>
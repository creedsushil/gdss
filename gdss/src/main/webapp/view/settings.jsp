
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<h1 class="title">Setting</h1>
<div class="card" style="display: none;"></div>
<div class="card">
	<div class="toggle"></div>
	<c:if test="${not empty errorMessage}">
		<h2 class="error" id="registerError" style="color: black;">${errorMessage}</h2>
	</c:if>
	<form action="Register" method="POST">
		<div id="image" style="">
			<input type="file" id="pp" name="profilePic" style="display: none;" />
			<label id="defImage"
				style="color: #6fab4f; background-color: #fbbec9; position: relative; left: 160px;"><i
				class="fa fa-user" style="font-size: 100px;" aria-hidden="true"></i></label>
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
<script type="text/javascript" src="resource/js/index.js"></script>
<script type="text/javascript">
	$(function() {
		$('#defImage').click(function(e) {
			e.preventDefault();
			$('#pp').click();
		});
	});
</script>
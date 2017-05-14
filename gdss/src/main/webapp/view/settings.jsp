
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<h1 class="title">Setting</h1>
<div class="card" style="display: none;"></div>
<div class="card">
	<div class="toggle"></div>
	<c:if test="${not empty message}">
		<h2 class="error" id="registerError" style="color: red;">${message}</h2>
	</c:if>
	<form action="settings" id="setting" method="POST">
		<div id="image" style="">
			<input type="file" id="pp" name="profilePic" style="display: none;" />
			<label id="defImage"
				style="color: #6fab4f; background-color: #fbbec9; position: relative; left: 160px;"><i
				class="fa fa-user" style="font-size: 100px;" aria-hidden="true"></i></label>
		</div>
		<div class="input-container">
		<label for="#{label}" class="label">Email</label>
			<input type="email" id="#{label}" required="required" value="${email }" style="color:lightblue;" readonly="readonly"/>
			<div class="bar"></div>
		</div>
		<div class="input-container">
		 <label
				for="#{label}" class="label">Username</label>
			<input type="text" id="#{label}" required="required"
				style="text-transform: uppercase;color:lightblue;" value="${username }" readonly="readonly"/>
			<div class="bar"></div>
		</div>

		<div class="input-container">
			<input type="password" id="#{label}" required="required" value="${password }"
				name="password" /> <label for="#{label}">Password</label>
			<div class="bar"></div>
		</div>
		<div class="input-container">
			<input type="password" id="passwordre" required="required" value="${password }"/> <label
				for="#{label}">Repeat Password</label>
			<div class="bar"></div>
		</div>
		<div class="button-container" onclick="submitForm();">
			<button disabled="disabled">
				<span>Update</span>
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
	
	function submitForm(){
		$.ajax({
			url : "settings",
			type : "POST",
			data : $("#setting").serialize(),
			success : function(resp) {
				$("#main").html(resp);
			},
			error:function(){
				
			}
		});
	}
	
</script>
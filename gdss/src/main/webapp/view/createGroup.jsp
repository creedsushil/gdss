<%@ page isELIgnored="false"%>
<%@ taglib uri="http://ckeditor.com" prefix="ckeditor"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<h1 class="title">Create Discussion</h1>
	<h2 class="error" id="message"></h2>
<form onsubmit="return false;" id="discussionForm">
	<div id="discussion">
		<div class="input-container">
			<input type="text" name="title" required="required" value="${title}" />
			<label for="#{label}">Title</label>
			<div class="bar"></div>
		</div>
		<div class="input-container">
			<span>Description</span>
			<ckeditor:editor basePath="resource/ckeditor" editor="description"
				value="" />
		</div>
		<div class="input-container">
			<input type="datetime-local" name="endTime" required="required" />
			<div class="bar"></div>
		</div>
		<!-- <div class="button-container">
					<button disabled="disabled" class="button"
						style="background: #338c0c !important;">
						<span>NEXT</span>
					</button>
				</div> -->
	</div>
	<div>
		<%-- <div class="input-container">
			<input type="text" name="moderator" id="moderator"
				required="required" /> <label for="#{label}">Moderators</label>
			<div class="bar"></div>
		</div> --%>
		<div class="input-container">
			<input type="text" name="participants" id="participants"
				required="required" /> <label for="#{label}">participants</label>
			<div class="bar"></div>
		</div>
		<div class="button-container">
			<button onclick="submitForm()" class="button" style="background: #338c0c !important;">
				<span>Create</span>
			</button>
		</div>
	</div>
</form>

<script>
	$(function() {		
		<%-- $("#moderator").tokenInput("<%=request.getContextPath()%>/group?page=search", {
					propertyToSearch : 'email',
					//preventDuplicates : true,
					tokenValue:'email',
					minChars : 1,
					noResultsText : "No results"
				});
		 --%>
		$("#participants").tokenInput("<%=request.getContextPath()%>/group?page=search", {
					propertyToSearch : 'email',
					//preventDuplicates : true,
					tokenValue : 'email',
					minChars : 1,
					noResultsText : "No results"
				});

	});
	
	function submitForm(){
		debugger;
		$.ajax({
			url:"group?page=createGroup",
			type:"POST",
			data: $("#discussionForm").serialize(),
			success: function(data){
				if(data=="success"){
					window.location.href = "<%=request.getContextPath()%>/index";
					return false;
				}
				$("#message").html(data);
			}
		});
	}
</script>
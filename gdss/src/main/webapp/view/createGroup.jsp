<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:if test="${create == true}">
<h1 class="title">Create Discussion</h1>
</c:if>
<c:if test="${edit == true}">
<h1 class="title">Edit Discussion</h1>
</c:if>
<h2 class="error" id="message"></h2>
<form onsubmit="return false;" id="discussionForm">
	<div id="discussion">
		<div class="input-container">
		<input type="hidden" name="id" id="id" value="${id}">
			<input type="text" name="title" required="required" value="${title}" />
			<label for="#{label}">Title</label>
			<div class="bar"></div>
		</div>
		<div class="input-container">
			<span>Description</span>
			<textarea rows="10" cols="10" name="description" id="description">${description}</textarea>
			<%-- <ckeditor:editor basePath="resource/ckeditor" editor="description"/> --%>
		</div>
		<div class="input-container">
			<input type="text" id="dateTime" name="endTime" required="required"
				value="${endTime }" />
			<div class="bar"></div>
		</div>
	</div>
	<div>
		<c:if test="${create == true}">
			<div class="input-container">
				<input type="text" name="participants" id="participants"
					required="required" /> <label for="#{label}">participants</label>
				<div class="bar"></div>
			</div>
		</c:if>
		<c:if test="${edit == true}">
			<div class="button-container">
				<button onclick="submitFormUpdate()" class="button"
					style="background: #338c0c !important;">
					<span>Update</span>
				</button>
			</div>
		</c:if>
		<c:if test="${create == true}">
			<div class="button-container">
				<button onclick="submitForm()" class="button"
					style="background: #338c0c !important;">
					<span>Create</span>
				</button>
			</div>
		</c:if>

	</div>
</form>
<script>
	$(function() {		
		 $('#dateTime').datetimepicker({
			//format:"yyyy-MM-dd"
		});
		
		CKEDITOR.replace( 'description');
		
		$("#participants").tokenInput("<%=request.getContextPath()%>/group?page=search", {
					propertyToSearch : 'email',
					//preventDuplicates : true,
					tokenValue : 'email',
					minChars : 1,
					noResultsText : "No results"
				});

	});
	
	function submitForm(){
		var value = CKEDITOR.instances['description'].getData();		
		$("#description").val(value);
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
	
	function submitFormUpdate(){
		var value = CKEDITOR.instances['description'].getData();		
		$("#description").val(value);
		$.ajax({
			url:"group?page=updateGroup",
			type:"POST",
			data: $("#discussionForm").serialize(),
			success: function(data){
				console.log(data);
				if(data=="success"){
					window.location.href = "<%=request.getContextPath()%>/index";
					return false;
				}
				$("#message").html(data);
			}
		});
	}
</script>
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
			<input type="hidden" name="id" id="id" value="${id}"> <input
				type="text" name="title" required="required" value="${title}" /> <label
				for="#{label}">Title</label>
			<div class="bar"></div>
		</div>
		<c:if test="${description!=null }">
			<div class="input-container">
				<span>Description</span>

				<div class="description">${description }</div>

				<div class="addedContent">
					<span>Added Contents</span>
					<div id="addedContents"></div>
				</div>
			</div>
			<h1 class="title">Add Content</h1>
			<div style="display: inline-block;">
				<span style="float: left; padding: 5px;">Vote Enable :</span> <input
					name="voteEnable" type="checkbox"
					style="float: right; height: 20px; width: 20px; margin: 5px 5px 30px 5px;" />
			</div>
			<div class="input-container">
				<textarea rows="10" cols="10" name="addedDescription"
					id="addedDescription"></textarea>
			</div>
			<script>
			CKEDITOR.replace( 'addedDescription');
			</script>
		</c:if>
		<c:if test="${description==null }">
			<div class="input-container">
				<textarea rows="10" cols="10" name="description" id="description"></textarea>
			</div>
			<script>
			CKEDITOR.replace( 'description');
			</script>
		</c:if>
		<%-- <ckeditor:editor basePath="resource/ckeditor" editor="description"/> --%>
	</div>
	<div class="input-container">
		<input type="text" id="dateTime" name="endTime" required="required"
			value="${endTime }" />
		<div class="bar"></div>
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
$body = $("body");

	$(function() {		
		 $('#dateTime').datetimepicker({
			//format:"yyyy-MM-dd"
		});
		
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
		$body.addClass("loading");
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
				$body.removeClass("loading");
			}
		});
	}
	
	function submitFormUpdate(){
		var value = CKEDITOR.instances['addedDescription'].getData();		
		$("#addedDescription").val(value);
		$body.addClass("loading");
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
						$body.removeClass("loading");
					}
				});
	}
</script>
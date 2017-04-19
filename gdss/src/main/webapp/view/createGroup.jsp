<%-- <form>
	<input type="text" name="discussionTitle" />
	<div class="input-container">
					<input type="text" name="username" id="userName"
						required="required" /> <label for="#{label}">User name</label>
					<div class="bar"></div>
				</div>
	<textarea id="description" rows="" cols="" name="description"></textarea>
	<input type="datetime-local" name="endTime" /> <input type="text"
		name="moderator"> <input type="text" name="participants" />
</form> --%>

<div class="container" style="max-width: 600px;margin:0 0 0 0;">
		<div class="card" style="display: none;"></div>
		<div class="card login">
			<h1 class="title">Create Discussion</h1>
			<form action="" method="post">
				<div class="input-container">
					<input type="text" name="title"
						required="required" /> <label for="#{label}">Title</label>
					<div class="bar"></div>
				</div>
				<div class="input-container">
				<span>Description</span>
				 <textarea id="description" rows="" cols="" name="description"></textarea>
				</div>
				<div class="input-container">
					<input type="datetime-local" name="endTime" />
					<div class="bar"></div>
				</div>
				<div class="button-container">
					<button class="button" style="background:#338c0c !important;">
						<span>CREATE</span>
					</button>
				</div>
			</form>
		</div>
	</div>
	

<script>
	$(function() {
		$("#description").htmlarea(
				{
					toolbar : [ "forecolor", "|", "bold", "italic",
							"underline", "|" ,/* , "h1", "h2", "h3", "h6", "|", */
							"link", "unlink" ]
				});
	});
</script>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page isELIgnored="false"%>
<%@ taglib uri="http://ckeditor.com" prefix="ckeditor"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Dashboard</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css" />
<link rel='stylesheet prefetch'
	href='http://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900|RobotoDraft:400,100,300,500,700,900' />
<link rel='stylesheet prefetch'
	href='http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css' />
<link rel="stylesheet" type="text/css" href="resource/css/style.css" />

<script
	src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

<script type="text/javascript"
	src="resource/tokenInput/src/jquery.tokeninput.js"></script>
<link rel="stylesheet" type="text/css"
	href="resource/tokenInput/styles/token-input.css" />
<link rel="stylesheet" href="resource/css/stylesMain.css"
	type="text/css" />
<meta name="viewport"
	content="width=device-width, minimum-scale=1.0, maximum-scale=1.0" />
</head>

<body>

	<section id="body" class="width"> <aside id="sidebar"
		class="column-left"> <header> <!-- <img src="images/40fdf46e-dfba-4b17-8271-badcb4bafbcc_1a962197d9133cace9facf1037ffe4b1.jpg" alt="Profile_Pic"/> -->
	<h1>
		<a href="#" style="text-transform: uppercase;">${userName}</a>
	</h1>

	</header> <nav id="mainnav">
	<ul>
		<li class="navBtns" id="home"><a href="#home">Home</a></li>
		<li class="navBtns selected-item" id="group"><a href="#group">My
				Group</a></li>
		<li class="navBtns" id="createGroup"><a href="#createGroup">Create
				New Group</a></li>
		<li class="navBtns" id="settings"><a href="#settings">Settings</a></li>
		<li><a href="<%=request.getContextPath()%>/logout">Sign out</a></li>
	</ul>
	</nav> </aside> <section id="content" class="column-right"> <article>
	<div class="container"
		style="max-width: 65%; margin: 0 0 0 0; float: left;">
		<div class="card" style="display: none;"></div>
		<div class="card" style="padding: 0 !important;">
			<div id="main">
				<jsp:include page="createGroup.jsp"></jsp:include>
				<br /> <br />

				<h1 class="title">Participants</h1>

				<div class="participantsContainer"></div>
				<br />
				<br /> <label
					style="left: 20px; position: relative; margin-bottom: 5px;">Add</label>

				<div class="input-container"
					style="width: 48%; margin: 10px 20px 50px !important;">
					<input type="text" id="addParticipants" required="required" />
					<div class="bar"></div>
				</div>
				<h1 class="title">Comments</h1>
				<div id="commentsDiv" style="margin-bottom: 20px;"></div>
				<div class="input-container">
					<ckeditor:editor basePath="resource/ckeditor" editor="comment"
						value="" />
					<div class="button-container">
						<button onclick="comment()" class="button"
							style="background: #338c0c !important; font-size: 15px !important; width: 110px; padding: 6px 0; bottom: 30px; left: 235px;">
							<span>Comment</span>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container-right card">
		<img src="Report?id=${id }&&action='display'" />
		<div class="button-container">
			<button onclick="downloadReport(${id})" class="button" style="background: #338c0c !important; font-size: 15px !important; width: 110px; padding: 6px 0;">
				<span>Download</span>
			</button>
		</div>
	</div>
	</article> <footer class="clear">
	<p>&copy; Group decesion support system</p>
	</footer> </section>

	<div class="clear"></div>
	</section>
	<script type="text/javascript">
	var current = "group";
	var commentInterval=null;
	$(function(){
		var currentPage = document.location.hash;
		updateComment();
		getParticipants();
		commentInterval = setInterval(function(){updateComment();}, 2000);
		if(currentPage.includes("#") && currentPage !="home"){
			$("#main").hide();
			currentPage = currentPage.split("#")[1];
			var data = {page : currentPage};
			var url = "<%=request.getContextPath()%>/" + (currentPage=="createGroup"?"group":currentPage);
			$.ajax({
				url : url,
				type : "POST",
				data : data,
				success : function(resp) {
					$("#home").removeClass("selected-item");
					$("#" + currentPage).addClass("selected-item");
					current = currentPage;
					document.location.hash = currentPage;
					
					$("#main").html(resp);
					$("#main").slideDown(600);
				},
				error:function(){
					$("#main").slideDown(600);
				}
			});
		};
		
		$("#addParticipants").tokenInput("<%=request.getContextPath()%>/group?page=search", {
			propertyToSearch : 'email',
			//preventDuplicates : true,
			tokenValue : 'email',
			minChars : 1,
			noResultsText : "No results",
			onAdd:function(item){
				addParticipant(item.email);
				$("#addParticipants").tokenInput("clear");
			}
		});
		
		
	});
	
	
		function mousePointed(event) {
			event.target.parentElement.setAttribute("class", "pointed");
		}

		function mouseRemoved(event) {
			event.target.parentElement.removeAttribute("class");
		}
		
		$(".navBtns").click(function(event) {
			var next = event.target.parentElement.getAttribute("id");
			var data = {page : next == "createGroup"?"createGroup":"getGroup"};
			var nextPage = next;
			next = next == "createGroup"?"group":next;
			var url = "<%=request.getContextPath()%>/" + next;
			if (next == "home") {
				document.location.hash = null;
				window.location.href = "index";
				return false;
			}

			if (nextPage == current) {
				return false;
			} else {
				$("#main").hide();
				$.ajax({
					url : url,
					type : "POST",
					data : data,
					success : function(resp) {
						$("#" + current).removeClass("selected-item");
						$("#" + nextPage).addClass("selected-item");
						current = nextPage;
						document.location.hash = nextPage;

						$("#main").html(resp);

						$("#main").slideDown(600);
					},
					error : function() {
						$("#main").slideDown(600);
					}
				});
			}
		});

		function comment() {
			var comment = CKEDITOR.instances['comment'].getData();
			if (comment == "" || comment == null) {
				return false;
			}
			data = {
				comment : comment,
				id : $("#id").val(),
				action : "addComment"
			};
			$.ajax({
				url : "comment",
				data : data,
				type : "POST",
				success : function() {
					CKEDITOR.instances['comment'].setData("");
				}
			});
		}

		function updateComment() {
			data = {
				action : "updateComment",
				id : $("#id").val(),
				count : $("#commentsDiv").children().length
			};
			$.ajax({
				url : "comment",
				data : data,
				type : "POST",
				success : function(data) {
					//var text= data.response.venue.tips.groups.items.text;
					if (data == null) {
						return false;
					}
					var divContent = "";

					$.each(data, function(index, item) {
						var newDiv = "<div class='comment'>" + item.comment
								+ "</div>"
						divContent = divContent + newDiv;
					});
					$("#commentsDiv").html(divContent);
				}
			});
		}

		function getParticipants() {
			data = {
				id : $("#id").val(),
				action : "get"
			}
			$
					.ajax({
						url : "participants",
						type : "POST",
						data : data,
						success : function(data) {
							var divItem = "";
							$
									.each(
											data,
											function(index, item) {
												divItem = divItem
														+ "<div class='participants'><span class='partSpan'>"
														+ item.participant
														+ "</span><i class='fa fa-times' onclick=deletePart("
														+ item.id
														+ ") aria-hidden='true'></i></div>";
											})

							$(".participantsContainer").html(divItem);

						}

					});
		}

		function deletePart(id) {
			data = {
				id : id,
				action : "delete"
			}
			$.ajax({
				url : "participants",
				type : "POST",
				data : data,
				success : function(data) {
					getParticipants();
				}

			})
		}

		function addParticipant(email) {
			data = {
				id : $("#id").val(),
				email : email,
				action : "add"
			}
			$.ajax({
				url : "participants",
				type : "POST",
				data : data,
				success : function(data) {
					getParticipants();
				}

			})
		}
		
		function downloadReport(id){
			/* var data = {
					id:id,
					action:"download"
			}
			$.ajax({
				url:"Report",
				type:"GET",
				data:data,
				success: function(){
					
				}
			}); */
			window.open("Report?id="+id+"&action=download", '_blank');
		}
		
	</script>

</body>
</html>

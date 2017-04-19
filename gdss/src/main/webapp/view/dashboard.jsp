
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page isELIgnored="false"%>
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


<link rel="stylesheet"
	href="resource/jhtmlarea/style/jHtmlArea.Editor.css" type="text/css" />
<link rel="stylesheet" href="resource/jhtmlarea/style/jHtmlArea.css"
	type="text/css" />
<link rel="stylesheet" href="resource/jhtmlarea/style/cpm.css"
	type="text/css" />
<link rel="stylesheet"
	href="resource/jhtmlarea/style/jqueryui/ui-lightness/jquery-ui-1.7.2.custom.css"
	type="text/css" />
<script
	src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script type="text/javascript" src="resource/jhtmlarea/jHtmlArea.js"></script>
<script type="text/javascript" src="resource/jhtmlarea/cpm.js"></script>
<link rel="stylesheet" href="resource/css/stylesMain.css"
	type="text/css" />
<link rel="stylesheet" href="resource/jhtmlarea/style/jHtmlArea.css"
	type="text/css" />
<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> -->
<meta name="viewport"
	content="width=device-width, minimum-scale=1.0, maximum-scale=1.0" />
</head>

<body>

	<section id="body" class="width"> <aside id="sidebar"
		class="column-left"> <header>
	<h1>
		<a href="#" style="text-transform: uppercase;">${userName}</a>
	</h1>

	</header> <nav id="mainnav">
	<ul>
		<li class="navBtns selected-item" id="home"><a href="#home">Home</a></li>
		<li class="navBtns" id="group"><a href="#group">My Group</a></li>
		<li class="navBtns" id="createGroup"><a href="#createGroup">Create New
				Group</a></li>
		<li class="navBtns" id="settings"><a href="#settings">Settings</a></li>
		<li><a href="<%=request.getContextPath()%>/logout">Sign out</a></li>
	</ul>
	</nav> </aside> <section id="content" class="column-right"> <article>

	<div id="main">
		<table>
			<thead>
				<th>Name</th>
				<th>Title</th>
				<th>Time Remaining</th>
			</thead>
			<tbody>
				<tr>
					<td>My Group</td>
					<td class="tdTitle" onclick="loadDiscussion();"
						onmouseover="mousePointed(event);"
						onmouseout="mouseRemoved(event);">Title of the discussion
						Title of the discussion Title of the discussion Title of the
						discussion Title of the discussion Title of the discussion Title
						of the discussion Title of the discussion Title of the discussion
						Title of the discussion Title of the discussion Title of the
						discussion Title of the discussion Title of the discussion</td>
					<td>3:40:44</td>
				</tr>
				<tr>
					<td>My Group</td>
					<td class="tdTitle">Title of the discussion</td>
					<td>3:40:44</td>
				</tr>
				<tr>
					<td>Create New Group</td>
					<td class="tdTitle" onclick="loadDiscussion();">Title of the
						discussion</td>
					<td>3:40:44</td>
				</tr>
				<tr>
					<td>Settings</td>
					<td class="tdTitle" onclick="loadDiscussion();">Title of the
						discussion</td>
					<td>3:40:44</td>
				</tr>
				<tr>
					<td>Sign out</td>
					<td class="tdTitle" onclick="loadDiscussion();">Title of the
						discussion</td>
					<td>3:40:44</td>
				</tr>
			</tbody>

		</table>
	</div>
 </article> <footer class="clear">
	<p>&copy; Group decesion support system</p>
	</footer> </section>

	<div class="clear"></div>
	</section>
	<script type="text/javascript">
	var current = "home";
	$(function(){
		var currentPage = document.location.hash;
		if(currentPage.includes("#")){
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
	});
	
	
		function loadDiscussion() {
			console.log("NOT IMPLEMENTED");
		}

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
					error:function(){
						$("#main").slideDown(600);
					}
				});
			}
		});
	</script>

</body>
</html>

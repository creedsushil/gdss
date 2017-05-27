
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

<script
	src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
	<script
	src='webjars/ckeditor/4.4.7/standard/ckeditor.js'></script>
	<script
	src='webjars/ckeditor/4.4.7/standard/config.js'></script>
	<script
	src='webjars/ckeditor/4.4.7/standard/build-config.js'></script>
	
	<script
	src='webjars/datetimepicker/2.3.4/jquery.js'></script>
<script
	src='webjars/datetimepicker/2.3.4/jquery.datetimepicker.js'></script>

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
		class="column-left"> <header>
		<!-- <img src="images/40fdf46e-dfba-4b17-8271-badcb4bafbcc_1a962197d9133cace9facf1037ffe4b1.jpg" alt="Profile_Pic"/> -->
	<h1>
		<a href="#" style="text-transform: uppercase;">${userName}</a>
	</h1>

	</header> <nav id="mainnav">
	<ul>
		<li class="navBtns selected-item" id="home"><a href="#home">Home</a></li>
		<li class="navBtns" id="group"><a href="#group">My Group</a></li>
		<li class="navBtns" id="createGroup"><a href="#createGroup">Create
				New Group</a></li>
		<li class="navBtns" id="settings"><a href="#settings">Settings</a></li>
		<li class="navBtns" id="chat"><a href="#chat">Chat</a></li>
		<li><a href="<%=request.getContextPath()%>/logout">Sign out</a></li>
	</ul>
	</nav> </aside> <section id="content" class="column-right"> <article>
	<div class="container" style="max-width: 700px; margin: 0 0 0 0;">
		<div class="card" style="display: none;"></div>
		<div class="card" style="padding: 0 !important;">
			<div id="main">
			<jsp:include page="recentGroups.jsp"></jsp:include>
			</div>
		</div>
	</div>
	<div class="modal"><!-- overlay or cover --></div>
	</div>
	</article> 
	<div class="chatBox">
		<div class="chatHead">
			<span class="chatSpan"></span><span
				style="top: 5px; left: 25px; position: relative;"><i
				class='fa fa-times' style="position: fixed; cursor: pointer;"
				onclick="closeChat()"></i></span>
		</div>
		<div class="chatBody"></div>
		<div style="margin-left: 5px;">
			<textarea class="chatMsg" id="chatMessage" style="resize: none"></textarea>
			<button class="chatBtn" id="send" onclick="submitChat();">Send</button>
		</div>
	</div>
	<footer class="clear">
	<p>&copy; Group decesion support system</p>
	</footer> </section>

	<div class="clear"></div>
	</section>
	<script type="text/javascript">
	var current = "home";
	
	$body = $("body");

	/* $(document).on({
	    ajaxStart: function() { $body.addClass("loading");    },
	     ajaxStop: function() { $body.removeClass("loading"); }    
	}); */
	
	$(function(){
		var currentPage = document.location.hash;
		if(currentPage.includes("#") && currentPage !="home"){
			$("#main").hide();
			currentPage = currentPage.split("#")[1];
			var data = {page : currentPage};
			var url = "<%=request.getContextPath()%>/" + (currentPage=="createGroup"?"group":currentPage);
			$body.addClass("loading");
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
					$body.removeClass("loading");
				},
				error:function(){
					$("#main").slideDown(600);
					$body.removeClass("loading");
				}
			});
		};
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
			if(next == "home"){
				document.location.hash = null;
				window.location.href = "index";
				return false;
			}

			if (nextPage == current) {
				return false;
			} else {
				$("#main").hide();
				$body.addClass("loading");
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
						$body.removeClass("loading");
					},
					error : function() {
						$("#main").slideDown(600);
						$body.removeClass("loading");
					}
				});
			}
		});
		
		function filterList(clicked){
			$body.addClass("loading");
			var checked = $("#"+clicked+":checked").attr("checked");
			if(clicked=="open"){
				var open = $(".open");
				if(checked!=undefined){
					$(".open").parent().show();
				}else{
					$(".open").parent().hide();
				}
				
			}else{
				var closed = $(".closed");
				if(checked!=undefined){
					$(".closed").parent().show();
				}else{
					$(".closed").parent().hide();
				}
			}
			$body.removeClass("loading");
		}
		
	</script>

</body>
</html>

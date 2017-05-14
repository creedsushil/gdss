
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
		class="column-left"> <header> <img
		src="<%=request.getContextPath()%>/image/5840eb5b-7a9e-417c-8b61-6311c1c4575e_angry-wolf-pictures-pretty"
		alt="Profile_Pic" />
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
	<div class="container" style="max-width: 700px; margin: 0 0 0 0;">
		<div class="card" style="display: none;"></div>
		<div class="card" style="padding: 0 !important;">
			<div id="main">
				<h1 class="title">${title }
					<span id="timer" style="float: right;"></span>
					<input type="hidden" id="time" value="${endTime }">
				</h1>
				<div class="description">${descreption }
				<br/>
				<br/>
				<span class="voteCount" id="up">0</span>
				<i class="fa fa-thumbs-up voteUp" id="voteType_1" aria-hidden="true" onclick="vote(1);" style=""></i>
				<span class="voteCount"  id="mayBe">0</span>
				<i class="fa fa-hand-o-up voteMayBe" id="voteType_2" aria-hidden="true" onclick="vote(2);" style=""></i>
				
				<span class="voteCount"  id="mayBeNot">0</span>
				<i class="fa fa-hand-o-down voteMayBeNot" id="voteType_3" aria-hidden="true" onclick="vote(3);" style=""></i>
				<span class="voteCount"  id="down">0</span>
				<i class="fa fa-thumbs-down voteDown" id="voteType_4" aria-hidden="true" onclick="vote(4);" style=""></i>
				</div>
				<div id="commentsDiv" style="margin-bottom: 20px;">
					
				</div>
				<div class="input-container">
					<input type="hidden" id="id" value="${id }">
					<ckeditor:editor basePath="resource/ckeditor" editor="description"
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

	</article> <footer class="clear">
	<p>&copy; Group decesion support system</p>
	</footer> </section>

	<div class="clear"></div>
	</section>
	<script type="text/javascript">
	var current = "group";
	var commentInterval=null;
	$(function(){
		var voteType = ${voteType};
		countVote(voteType);
		updateComment();
		commentInterval = setInterval(function(){updateComment();}, 100);
		setInterval(function(){ setTimer()
		 }, 1000)
		var currentPage = document.location.hash;
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
					$("#group").removeClass("selected-item");
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
	
	function setTimer(){
			var time = (document.getElementById("time").value).split('.')[0];
			var date = new Date(time).getTime();			
			
		var now = new Date().getTime();
	    
	    // Find the distance between now an the count down date
	    var distance = date - now;
	    if (distance < 0 || isNaN(distance)) {
	    	document.getElementById("timer").innerHTML = "00:00:00";
	    	return false;
	    }
	    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
	    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
	    var seconds = Math.floor((distance % (1000 * 60)) / 1000);
	    document.getElementById("timer").innerHTML = days + "d " + hours + "h "
	    + minutes + "m " + seconds + "s ";
	    
	}
	
	
		function loadDiscussion(id) {
			var data = {id:id};
			$.ajax({
				url : "<%=request.getContextPath()%>/group?page=group",
				type : "POST",
				data : data,
				success : function(resp) {					
					$("#main").html(resp);
					$("#main").slideDown(600);
				},
				error:function(){
					$("#main").slideDown(600);
				}
			}); 
		}

		function mousePointed(event) {
			event.target.parentElement.setAttribute("class", "pointed");
		}

		function mouseRemoved(event) {
			event.target.parentElement.removeAttribute("class");
		}
		
		$(".navBtns").click(function(event) {
			if(commentInterval != null) clearInterval(commentInterval);
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
			var comment = CKEDITOR.instances['description'].getData();
			if (comment == "" || comment == null) {
				return false;
			}
			data = {
				comment : comment,
				id : $("#id").val(),
				action:"addComment"
			};
			$.ajax({
				url : "comment",
				data : data,
				type : "POST",
				success : function() {
					CKEDITOR.instances['description'].setData("");
				}
			});
		}

		function updateComment() {
			data = {
					action:"updateComment",
					id : $("#id").val(),
					count:$("#commentsDiv").children().length
				};
				$.ajax({
					url : "comment",
					data : data,
					type : "POST",
					success : function(data) {
						//var text= data.response.venue.tips.groups.items.text;
						if(data==null){
							return false;
						}
						var divContent = $("#commentsDiv").html();
						
						  $.each(data,function(index,item){
							 var newDiv = "<div class='comment'>"+item.comment+"</div>"
							 divContent = divContent+newDiv;
						}); 
						 $("#commentsDiv").html(divContent); 
					}
				});
		}
		
		function vote(voteValue){
			 data = {
					action:"vote",
					id : $("#id").val(),
					type:voteValue
				};
				$.ajax({
					url : "comment",
					data : data,
					type : "POST",
					success : function(data) {
						
						if(data == true){
							countVote(voteValue);
						}
						
					}
				}); 
		}
		
		function countVote(voted){
			var sameVote = $("#voteType_"+voted).hasClass("voted_"+voted);
			$(".voteUp").removeClass("voted_1");
			$(".voteMayBe").removeClass("voted_2");
			$(".voteMayBeNot").removeClass("voted_3");
			$(".voteDown").removeClass("voted_4");
			
			if(!sameVote) $("#voteType_"+voted).addClass("voted_"+voted);
			
			data = {
					page:"countVote",
					id : $("#id").val()
				};
				$.ajax({
					url : "group",
					data : data,
					type : "POST",
					success : function(data) {
						var up = 0;
						var mayBe = 0;
						var mayBeNot = 0;
						var down = 0 ;
						$("#up").html(0);
						$("#mayBe").html(0);
						$("#mayBeNot").html(0);
						$("#down").html(0);
						$.each(data,function(index,item){
							if(item.vote_type=="1"){
								up = item.voteCount;
								$("#up").html(up);
							}else if(item.vote_type=="2"){
								mayBe = item.voteCount;
								$("#mayBe").html(mayBe);
							}else if(item.vote_type=="3"){
								mayBeNot = item.voteCount;
								$("#mayBeNot").html(mayBeNot);
							}else if(item.vote_type=="4"){
								down = item.voteCount;
								$("#down").html(down);
							}
						}); 
					}
				}); 
		}
		
	</script>

</body>
</html>

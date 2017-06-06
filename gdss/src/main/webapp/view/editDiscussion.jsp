
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page isELIgnored="false"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Dashboard</title>
<script src='webjars/ckeditor/4.4.7/standard/ckeditor.js'></script>
<script src='webjars/ckeditor/4.4.7/standard/config.js'></script>
<script src='webjars/ckeditor/4.4.7/standard/build-config.js'></script>

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

<script src='webjars/datetimepicker/2.3.4/jquery.datetimepicker.js'></script>



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
		<li class="navBtns selected-item" id="home"><a>Home</a></li>
		<li class="navBtns" id="group"><a href="group?page=getGroup">My
				Discussion</a></li>
		<li class="navBtns" id="createGroup"><a href="group?page=createGroup">Create
				New Discussion</a></li>
		<li class="navBtns" id="settings"><a href="<%=request.getContextPath()%>/settings">Settings</a></li>
		<li class="navBtns" id="chat"><a href="<%=request.getContextPath()%>/chat?action=list">Chat</a></li>
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
				<br /> <br /> <label
					style="left: 20px; position: relative; margin-bottom: 5px; margin-left: 35px;">Add</label>

				<div class="input-container"
					style="width: 48%; margin: 10px 20px 50px 35px !important;">
					<input type="text" id="addParticipants" required="required" />
					<div class="bar"></div>
				</div>
				<h1 class="title">Comments</h1>
				<div id="commentsDiv"
					style="margin-bottom: 20px; margin-left: 35px;"></div>
				<div class="input-container">
					<textarea rows="8" cols="11" id="comment"></textarea>
					<script>
			CKEDITOR.replace( 'comment');
			</script>
					<div class="button-container">
						<button onclick="comment();" class="button"
							style="background: #338c0c !important; font-size: 15px !important; width: 110px; padding: 6px 0; bottom: 30px; left: 224px;">
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
			<button onclick="downloadReport(${id})" class="button"
				style="background: #338c0c !important; font-size: 15px !important; width: 110px; padding: 6px 0;">
				<span>Download</span>
			</button>
		</div>
	</div>
	</article> <footer class="clear">
	<p>&copy; Group decesion support system</p>
	</footer> </section>

	<div class="clear"></div>
	<div class="modal">
		<!-- overlay or cover -->
	</div>

	<div id="chat" class="chatBox">
		<div class="chatHead">
			<span class="chatSpan">sherryyang@gmil.com</span><span
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

	</section>
	<script type="text/javascript">
	
	$body = $("body");

	/* $(document).on({
	     ajaxStart: function() { $body.addClass("loading");    },
	     ajaxStop: function() { $body.removeClass("loading"); }    
	}); */
	
	var current = "group";
	var commentInterval=null;
	var seenInterval = null;
	$(function(){
		var currentPage = document.location.hash;
		updateComment();
		getParticipants();
		getAddedContent()
		seenInterval = setInterval(function(){updateSeenStatus();}, 2000);
		commentInterval = setInterval(function(){updateComment();}, 2000);
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
		
		<%-- $(".navBtns").click(function(event) {
			if(commentInterval != null) clearInterval(commentInterval);
			if(seenInterval !=null) clearInterval(seenInterval)
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
				$body.addClass("loading");
				$("#main").hide();
				$.ajax({
					url : url,
					type : "POST",
					data : data,
					success : function(resp) {
						$(".container-right").html("");
						$body.removeClass("loading");
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
 --%>
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
			$body.addClass("loading");
			$.ajax({
				url : "comment",
				data : data,
				type : "POST",
				success : function() {
					CKEDITOR.instances['comment'].setData("");
					$body.removeClass("loading");
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
						var newDiv = "<div class='comment'><span class='user' onclick=startChat('"
							+ item.user
							+ "')>"+item.user+" :</span>" + item.comment
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
			$body.addClass("loading");
			$.ajax({
						url : "participants",
						type : "POST",
						data : data,
						success : function(data) {
							var divItem = "";
							$.each(
											data,
											function(index, item) {
												if(item.isSeen>0){
												divItem = divItem
														+ "<div class='participants'><span class='partSpan'onclick=chat('"+ 
														item.participant
														+"')>"
														+ item.participant
														+ "</span><i class='fa fa-times' onclick=deletePart("
														+ item.id
														+ ") aria-hidden='true'></i><span style='color:red' id='seen_"+item.id+"'>"+
														item.isSeen
														+
														"</span></div>";
												}
												else{
													divItem = divItem
													+ "<div class='participants'><span class='partSpan'onclick=chat('"+ 
													item.participant
													+"')>"
													+ item.participant
													+ "</span><i class='fa fa-times' onclick=deletePart("
													+ item.id
													+ ") aria-hidden='true'></i><span style='color:red' id='seen_"+item.id+"'></span></div>";
											}
											});

							$(".participantsContainer").html(divItem);
							$body.removeClass("loading");
						}

					});
		}

		function deletePart(id) {
			data = {
				id : id,
				action : "delete"
			}
			$body.addClass("loading");
			$.ajax({
				url : "participants",
				type : "POST",
				data : data,
				success : function(data) {
					$body.removeClass("loading");
					getParticipants();
					
				}

			})
		}

		function addParticipant(email) {
			debugger;
			data = {
				id : $("#id").val(),
				email : email,
				action : "add"
			}
			$body.addClass("loading");
			$.ajax({
				url : "participants",
				type : "POST",
				data : data,
				success : function(data) {
					$body.removeClass("loading");
					getParticipants();
				}

			})
		}
		
		function downloadReport(id){
			window.open("Report?id="+id+"&action=download", '_blank');
		}
		
		
		
		var updateChatInterval = null;
		function chat(participant){
			if(updateChatInterval!=null) clearInterval(updateChatInterval);
			$(".chatBox").show();
			$("#send").attr("onclick","submitChat()");
			var disId = $("#id").val();
			var data = {
					discussionId : disId,
					part : participant,
					action:'edit'
			}
			
			$.ajax({
				url:"chat",
				type:"GET",
				data:data,
				success: function(resp){
					$(".chatSpan").text(participant);
					$(".chatBody").html(resp);					
					$(".chatBody").scrollTop($(".chatBody")[0].scrollHeight);
					updateChatInterval = setInterval(function(){updateChat()},1000);
					updateSeenStatus();
				}
			});
			
		}
		
		function closeChat(){
			clearInterval(updateChatInterval);
			$('.chatBox').hide();
			
		}
		
		function submitChat(){
			if($("#chatMessage").val()=="" || $("#chatMessage").val() == null || $("#chatMessage").val() == undefined){
				return false;
			}
			
			var data = {
					discussionId : $("#disId").val(),
					part : $("#part").val(),
					message:$("#chatMessage").val(),
					isByCreator:"true",
					action:"chat"
			}
			
			$.ajax({
				url:"chat",
				type:"POST",
				data:data,
				success: function(){
					$("#chatMessage").val("");
					updateChat(true);
				}
			});
			
		}
		
		
		function updateChat(sendDown){
			if(!($("#disId").val() && $("#part").val())){
				return false;
			}
			var data = {
					discussionId : $("#disId").val(),
					part : $("#part").val(),
					action:'edit'
			}
			
			$.ajax({
				url:"chat",
				type:"GET",
				data:data,
				success: function(resp){
					if($(".chatBody").html()!=resp){
						$(".chatBody").html(resp)

					}	
					
					if(sendDown){
						$(".chatBody").scrollTop($(".chatBody")[0].scrollHeight);
					}
					
				}
			});
		}
		
		
		function updateSeenStatus(){
			data = {
					id : $("#id").val(),
					action : "get"
				}
				$.ajax({
							url : "participants",
							type : "POST",
							data : data,
							success : function(data) {
								var divItem = "";
								$.each(
												data,
												function(index, item) {
													if(item.isSeen>0)
													$("#seen_"+item.id).html(item.isSeen);
													else
														$("#seen_"+item.id).html("");
												});
							}

						});
		}
		
		function getAddedContent(){
			var data = {
					id : $("#id").val(),
					page: "getAddedContents",
					edit:"true"
			};
			
			$.ajax({
				url:"group",
				type:"GET",
				data:data,
				success: function(resp){
				$("#addedContents").html(resp);
				}				
			})
		}
		
		function startChat(user) {
			//if (updateChatInterval != null)
			//clearInterval(updateChatInterval);
			$("#send").attr("onclick","submitParticipantsChat()");
			 var data = {
				discussionId : $("#id").val(),
				part : user,
				action : 'chatFromParticipants'
			}
			 
			$.ajax({
				url : "chat",
				type : "GET",
				data : data,
				success : function(resp) {
					console.log(resp);
					$(".chatBox").show();
					$(".chatSpan").html(user);
					$(".chatBody").html(resp);

					$(".chatBody").scrollTop($(".chatBody")[0].scrollHeight);
					updateChatInterval = setInterval(function() {
						updateParticipantsChat()
					}, 1000);
					//updateSeenStatus(); 
				}
			}); 

		}
		
		function updateParticipantsChat(sendDown) {
			if (!($("#disId").val() && $("#part").val())) {
				return false;
			}
			var data = {
				discussionId : $("#disId").val(),
				part : $("#part").val(),
				action : 'chatFromParticipants'
			}

			$.ajax({
				url : "chat",
				type : "GET",
				data : data,
				success : function(resp) {
					if ($(".chatBody").html() != resp) {
						$(".chatBody").html(resp)

					}

					if (sendDown) {
						$(".chatBody")
								.scrollTop($(".chatBody")[0].scrollHeight);
					}

				}
			});
		}
		
		function submitParticipantsChat(){
			if($("#chatMessage").val()=="" || $("#chatMessage").val() == null || $("#chatMessage").val() == undefined){
				return false;
			}
			
			var data = {
					discussionId : $("#disId").val(),
					part : $("#part").val(),
					message:$("#chatMessage").val(),
					action:"chatFromParticipants"
			}
			
			$.ajax({
				url:"chat",
				type:"POST",
				data:data,
				success: function(){
					$("#chatMessage").val("");
					updateParticipantsChat(true);
				}
			});
			
		}
		
		
	</script>

</body>
</html>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Create</title>

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
		class="column-left"> <header><%--  <img
		src="<%=request.getContextPath()%>/image/5840eb5b-7a9e-417c-8b61-6311c1c4575e_angry-wolf-pictures-pretty"
		alt="Profile_Pic" /> --%>
	<h1>
		<a href="#" style="text-transform: uppercase;">${userName}</a>
	</h1>

	</header> <nav id="mainnav">
	<ul>
		<li class="navBtns" id="home"><a
			href="<%=request.getContextPath()%>/index">Home</a></li>
		<li class="navBtns" id="group"><a href="group?page=getGroup">My
				Discussion</a></li>
		<li class="navBtns" id="createGroup"><a
			href="group?page=createGroup">Create New Discussion</a></li>
		<li class="navBtns" id="settings"><a
			href="<%=request.getContextPath()%>/settings">Settings</a></li>
		<li class="navBtns selected-item" id="chat"><a>Chat</a></li>
		<li><a href="<%=request.getContextPath()%>/logout">Sign out</a></li>
	</ul>
	</nav> </aside> <section id="content" class="column-right"> <article>
	<div class="container"
		style="max-width: 700px; margin: 0 0 0 0; float: left;">
		<div class="card" style="display: none;"></div>
		<div class="card" style="padding: 0 !important;">
			<div id="main">
				<h1 class="title">Your messages</h1>


				<button class="topButton">
					<span> Read </span> <input type="checkbox" id="read"
						checked="checked" onclick="filterMessageList('read')" />
				</button>

				<button class="topButton">
					<span> unread </span> <input type="checkbox" id="unread"
						checked="checked" onclick="filterMessageList('unread')" />
				</button>

				<table style="width: 100%;">
					<thead>
						<th>SN</th>
						<th>Title</th>
						<th>Read</th>
					</thead>
					<tbody id="tBody">
						<c:if test="${chat.length() >0 }">
							<c:forEach begin="0" end="${chat.length() -1}" var="item">
								<c:if test="${chat.getJSONObject(item).getInt('isSeen')>0 }">
									<tr class="unread">
										<td>${item +1 }</td>
										<td class="tdTitle" onmouseover="mousePointedMes(event);"
											onmouseout="mouseRemovedMes(event);"
											onclick="chat(${chat.getJSONObject(item).getInt('dis_id')},'${chat.getJSONObject(item).getString('part')}','${chat.getJSONObject(item).getString('dis_title')}')">${chat.getJSONObject(item).getString("dis_title")}</td>
										<td><i class="fa fa-dot-circle-o" style="color: #ed2553;"
											aria-hidden="true"></i></td>
									</tr>
								</c:if>
								<c:if test="${chat.getJSONObject(item).getInt('isSeen')==0 }">
									<tr class="read">
										<td>${item +1 }</td>
										<td class="tdTitle" onmouseover="mousePointedMes(event);"
											onmouseout="mouseRemovedMes(event);"
											onclick="chat(${chat.getJSONObject(item).getInt('dis_id')},'${chat.getJSONObject(item).getString('part')}','${chat.getJSONObject(item).getString('dis_title')}')">${chat.getJSONObject(item).getString("dis_title")}</td>
										<td><i class="fa fa-check" style="color: #80b763;"
											aria-hidden="true"></i></td>
									</tr>
								</c:if>

							</c:forEach>
						</c:if>
					</tbody>

				</table>

			</div>
		</div>
	</div>

	</article> <footer class="clear">
	<p>&copy; Group decesion support system</p>
	</footer> </section>

	<div class="clear"></div>
	<div class="modal">
		<!-- overlay or cover -->
	</div>
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
	</section>

	<script type="text/javascript">
	$body = $("body");
var updateChatInterval = null;
var updateSeenInterval = setInterval(function(){updateSeenStatus();}, 10000);
function chat(disId,participant,title){
	if(updateChatInterval!=null) clearInterval(updateChatInterval);
	$(".chatBox").show();
	$("#send").attr("onclick","submitChat()");
	var data = {
			discussionId : disId,
			part : participant,
			action:'chat'
	}
	
	$.ajax({
		url:"chat",
		type:"GET",
		data:data,
		success: function(resp){
			$(".chatSpan").html(title);
			$(".chatBody").html(resp);
			
			$(".chatBody").scrollTop($(".chatBody")[0].scrollHeight);
			updateChatInterval = setInterval(function(){updateChat()},1000);
			updateSeenStatus();
		}
	});
	
}

function submitChat(){
	if($("#chatMessage").val()=="" || $("#chatMessage").val() == null || $("#chatMessage").val() == undefined){
		return false;
	}
	var data = {
			discussionId : $("#disId").val(),
			part : $("#part").val(),
			message:$("#chatMessage").val(),
			isByCreator:false,
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
			action:'chat'
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

function mousePointedMes(event) {
	jQuery(event.target).closest("tr").addClass("pointed");
}

function mouseRemovedMes(event) {
	jQuery(event.target).closest("tr").removeClass("pointed");
}

function updateSeenStatus(){
	var data = {
			action:'updateSeenStatus'
	}
	
	$.ajax({
		url:"chat",
		type:"GET",
		data:data,
		success: function(resp){
			$("#tBody").html(resp);
		}
	});
}

function filterMessageList(clicked){
	$body.addClass("loading");
	var checked = $("#"+clicked+":checked").attr("checked");
	if(clicked=="read"){
		if(checked!=undefined){
			$(".read").show();
		}else{
			$(".read").hide();
		}
		
	}else{
		if(checked!=undefined){
			$(".unread").show();
		}else{
			$(".unread").hide();
		}
	}
	$body.removeClass("loading");
}

function closeChat(){
	$('.chatBox').hide();
	clearInterval(updateChatInterval);
}
</script>
</body>
</html>
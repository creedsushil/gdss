
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
		<li class="navBtns selected-item" id="group"><a>My Discussion</a></li>
		<li class="navBtns" id="createGroup"><a  href="group?page=createGroup">Create New Discussion</a></li>
		<li class="navBtns" id="settings"><a href="<%=request.getContextPath()%>/settings">Settings</a></li>
		<li class="navBtns" id="chat"><a href="#chat">Chat</a></li>
		<li><a href="<%=request.getContextPath()%>/logout">Sign out</a></li>
	</ul>
	</nav> </aside> <section id="content" class="column-right"> <article>
	<div class="container"
		style="max-width: 700px; margin: 0 0 0 0; float: left;">
		<div class="card" style="display: none;"></div>
		<div class="card" style="padding: 0 !important;">
			<div id="main">
				<h1 class="title">Discussions You Are Participated</h1>


				<button class="topButton">
					<span> Open </span> <input type="checkbox" id="open"
						checked="checked" onclick="filterList('open')" />
				</button>

				<button class="topButton">
					<span> Closed </span> <input type="checkbox" id="closed"
						checked="checked" onclick="filterList('closed')" />
				</button>

				<table style="width: 100%;">
					<thead>
						<th>SN</th>
						<th>Title</th>
						<th>Time Remaining</th>
					</thead>
					<tbody>
						<%-- ${currentGroup } --%>
						<c:if test="${currentGroup.length() >0 }">
							<c:forEach begin="0" end="${currentGroup.length() -1}" var="item">
								<tr>
									<form
										id="tdForm_${currentGroup.getJSONObject(item).get('dis_id')}"
										action="<%=request.getContextPath()%>/group?page=groupWithId&&id=${currentGroup.getJSONObject(item).get('dis_id')}"
										method="POST">
										<input type="hidden" name="id"
											value="${currentGroup.getJSONObject(item).get('dis_id')}" />
										<input type="hidden" id="page" name="page" value="groupWithId" />
									</form>
									<td>${item +1 }</td>
									<td class="tdTitle"
										onclick="loadDiscussion(${currentGroup.getJSONObject(item).get('dis_id')});"
										onmouseover="mousePointed(event);"
										onmouseout="mouseRemoved(event);">${currentGroup.getJSONObject(item).getString("dis_title")}</td>
									<td class="timer" id="${item}" style="display: none;">${currentGroup.getJSONObject(item).get("dis_endDate")}</td>
									<td id="timer_${item}" style="min-width: 157px"></td>
								</tr>
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
$(function(){
		setInterval(function(){ setTimer()
		 }, 1000)
});



function setTimer(){
	$(".timer").each(function(){
		var time = (this.textContent).split('.')[0];
		var countDownDate = new Date(time).getTime();
		displayTimer(this,countDownDate);
	});
}

	function displayTimer(data,date){
		    // Get todays date and time
		    var now = new Date().getTime();		    
		    // Find the distance between now an the count down date
		    var distance = date - now;
		    if (distance < 0 || isNaN(distance)) {
		    	document.getElementById("timer_"+data.id).innerHTML = "00:00:00";
		    	$("#timer_"+data.id).addClass("closed");
		    	if(!$("#closed:checked").attr("checked")){
		    		$(".closed").parent().hide();
		    	}
		    	return false;
		    }
		    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
		    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
		    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
		    var seconds = Math.floor((distance % (1000 * 60)) / 1000);
		    document.getElementById("timer_"+data.id).innerHTML = days + "d " + hours + "h "
		    + minutes + "m " + seconds + "s ";
		    $("#timer_"+data.id).addClass("open");
		    if(!$("#open:checked").attr("checked")){
	    		$(".open").parent().hide();
	    	}
	}
	
	function loadDiscussion(id) {
		if($("#page").val()==null){
			return false;
		}
		$("#tdForm_"+id).submit();
	}
	
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
	
	function mousePointed(event) {
		event.target.parentElement.setAttribute("class", "pointed");
	}

	function mouseRemoved(event) {
		event.target.parentElement.removeAttribute("class");
	}
	
</script>
</body>
</html>


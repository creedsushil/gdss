<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<h1 class="title">Your messages</h1>


<button class="topButton">
	<span> Read </span> <input type="checkbox" id="read" checked="checked"
		onclick="filterMessageList('read')" />
</button>

<button class="topButton">
	<span> unread </span> <input type="checkbox" id="unread"
		checked="checked" onclick="filterMessageList('unread')" />
</button>

<table style="width:100%;">
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
					<td class="tdTitle" 
					onmouseover="mousePointedMes(event);"
						onmouseout="mouseRemovedMes(event);"
					onclick="chat(${chat.getJSONObject(item).getInt('dis_id')},'${chat.getJSONObject(item).getString('part')}','${chat.getJSONObject(item).getString('dis_title')}')">${chat.getJSONObject(item).getString("dis_title")}</td>
					<td><i class="fa fa-dot-circle-o" style="color:#ed2553;" aria-hidden="true"></i></td>
					</tr>
					</c:if>
					<c:if test="${chat.getJSONObject(item).getInt('isSeen')==0 }">
					<tr class="read">
					<td>${item +1 }</td>
					<td class="tdTitle" 
					onmouseover="mousePointedMes(event);"
						onmouseout="mouseRemovedMes(event);"
					onclick="chat(${chat.getJSONObject(item).getInt('dis_id')},'${chat.getJSONObject(item).getString('part')}','${chat.getJSONObject(item).getString('dis_title')}')">${chat.getJSONObject(item).getString("dis_title")}</td>
					<td><i class="fa fa-check" style="color:#80b763;" aria-hidden="true"></i></td>
					</tr>
					</c:if>
				
			</c:forEach>
		</c:if>
	</tbody>

</table>
<script type="text/javascript">
var updateChatInterval = null;
var updateSeenInterval = setInterval(function(){updateSeenStatus();}, 10000);
function chat(disId,participant,title){
	if(updateChatInterval!=null) clearInterval(updateChatInterval);
	$(".chatBox").show();
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

function closeChat(){
	$('.chatBox').hide();
	clearInterval(updateChatInterval);
}

function submitChat(){
	if($("#chatMessage").val()=="" || $("#chatMessage").val() == null || $("#chatMessage").val() == undefined){
		return false;
	}
	var data = {
			discussionId : $("#disId").val(),
			part : $("#part").val(),
			message:$("#chatMessage").val(),
			isByCreator:false
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


</script>



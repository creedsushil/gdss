<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>
<h1 class="title">Groups You Are Participated</h1>
<table>
	<thead>
		<th>Name</th>
		<th>Title</th>
		<th>Time Remaining</th>
	</thead>
	<tbody>
		<%-- ${currentGroup } --%>
		<c:if test="${currentGroup.length() >0 }">
			<c:forEach begin="0" end="${currentGroup.length() -1}" var="item">
				<tr>
					<form id="tdForm_${currentGroup.getJSONObject(item).get('dis_id')}"
						action="<%=request.getContextPath()%>/group?page=groupWithId&&id=${currentGroup.getJSONObject(item).get('dis_id')}"
						method="POST">
						<input type="hidden" name="id"
							value="${currentGroup.getJSONObject(item).get('dis_id')}" /> <input
							type="hidden" id="page" name="page" value="groupWithId" />
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

<script type="text/javascript">
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
		    	return false;
		    }
		    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
		    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
		    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
		    var seconds = Math.floor((distance % (1000 * 60)) / 1000);
		    document.getElementById("timer_"+data.id).innerHTML = days + "d " + hours + "h "
		    + minutes + "m " + seconds + "s ";
		    
		    // If the count down is over, write some text 
	}
	
	function loadDiscussion(id) {
		debugger;
		console.log($("#page").val());
		if($("#page").val()==null){
			return false;
		}
		$("#tdForm_"+id).submit();
	}
	
</script>



<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="false"%>

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
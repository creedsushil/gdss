<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:if test="${content!=null }">
	<c:if test="${content.length()>0}">
		<c:forEach begin="0" end="${content.length() -1}" var="item">
			<div class="description" style=>
				<h3>
					Added Date :<span style='float: right;'>${content.getJSONObject(item).get('addedDate')}</span>
				</h3>
				<p>${content.getJSONObject(item).get('description')}</p>
				<c:if
					test="${!edit}">
					<br />
					<br />

					<c:forEach begin="0"
						end="${content.getJSONObject(item).get('vote').length() -1}"
						var="voteItem">

						<c:if
							test="${content.getJSONObject(item).get('vote').getJSONObject(voteItem).getInt('voteType') ==1}">

							<span class="voteCount"
								id="up_${content.getJSONObject(item).getInt('id')}">
								${content.getJSONObject(item).get('vote').getJSONObject(voteItem).getInt('voteCount')}
							</span>
							<c:if test="${content.getJSONObject(item).getInt('voted')==1}">
								<i
									class="
								fa fa-thumbs-up voteUp
								voteBtn voted_1"
									id="voteType_1_${content.getJSONObject(item).getInt('id')}"
									aria-hidden="true"
									onclick="voteContent(1,${content.getJSONObject(item).getInt('id')});"
									style=""> </i>
							</c:if>
							<c:if test="${content.getJSONObject(item).getInt('voted')!=1}">
								<i class="
								fa fa-thumbs-up voteUp
								voteBtn"
									id="voteType_1_${content.getJSONObject(item).getInt('id')}"
									aria-hidden="true"
									onclick="voteContent(1,${content.getJSONObject(item).getInt('id')});"
									style=""> </i>
							</c:if>
						</c:if>
					</c:forEach>
					<c:forEach begin="0"
						end="${content.getJSONObject(item).get('vote').length() -1}"
						var="voteItem">
						<c:if
							test="${content.getJSONObject(item).get('vote').getJSONObject(voteItem).getInt('voteType') ==2}">

							<span class="voteCount"
								id="mayBe_${content.getJSONObject(item).getInt('id')}">${content.getJSONObject(item).get('vote').getJSONObject(voteItem).getInt('voteCount')}
							</span>
							<c:if test="${content.getJSONObject(item).getInt('voted')==2}">
								<i class="fa fa-hand-o-up voteMayBe voteBtn voted_2"
									id="voteType_2_${content.getJSONObject(item).getInt('id')}"
									aria-hidden="true"
									onclick="voteContent(2,${content.getJSONObject(item).getInt('id')});"
									style=""></i>
							</c:if>
							<c:if test="${content.getJSONObject(item).getInt('voted')!=2}">
								<i class="fa fa-hand-o-up voteMayBe voteBtn"
									id="voteType_2_${content.getJSONObject(item).getInt('id')}"
									aria-hidden="true"
									onclick="voteContent(2,${content.getJSONObject(item).getInt('id')});"
									style=""></i>
							</c:if>
						</c:if>
					</c:forEach>
					<c:forEach begin="0"
						end="${content.getJSONObject(item).get('vote').length() -1}"
						var="voteItem">
						<c:if
							test="${content.getJSONObject(item).get('vote').getJSONObject(voteItem).getInt('voteType') ==3}">

							<span class="voteCount"
								id="mayBeNot_${content.getJSONObject(item).getInt('id')}">${content.getJSONObject(item).get('vote').getJSONObject(voteItem).getInt('voteCount')}
							</span>
							<c:if test="${content.getJSONObject(item).getInt('voted')==3}">
								<i class="fa fa-hand-o-down voteMayBeNot voteBtn voted_3"
									id="voteType_3_${content.getJSONObject(item).getInt('id')}"
									aria-hidden="true"
									onclick="voteContent(3,${content.getJSONObject(item).getInt('id')});"
									style=""></i>
							</c:if>
							<c:if test="${content.getJSONObject(item).getInt('voted')!=3}">
								<i class="fa fa-hand-o-down voteMayBeNot voteBtn"
									id="voteType_3_${content.getJSONObject(item).getInt('id')}"
									aria-hidden="true"
									onclick="voteContent(3,${content.getJSONObject(item).getInt('id')});"
									style=""></i>
							</c:if>
						</c:if>
					</c:forEach>
					<c:forEach begin="0"
						end="${content.getJSONObject(item).get('vote').length() -1}"
						var="voteItem">
						<c:if
							test="${content.getJSONObject(item).get('vote').getJSONObject(voteItem).getInt('voteType') ==4}">

							<span class="voteCount"
								id="down_${content.getJSONObject(item).getInt('id')}">${content.getJSONObject(item).get('vote').getJSONObject(voteItem).getInt('voteCount')}
							</span>
							<c:if test="${content.getJSONObject(item).getInt('voted')==4}">
								<i class="fa fa-thumbs-down voteDown voteBtn voted_4"
									id="voteType_4_${content.getJSONObject(item).getInt('id')}"
									aria-hidden="true"
									onclick="voteContent(4,${content.getJSONObject(item).getInt('id')});"
									style=""></i>
							</c:if>
							<c:if test="${content.getJSONObject(item).getInt('voted')!=4}">
								<i class="fa fa-thumbs-down voteDown voteBtn"
									id="voteType_4_${content.getJSONObject(item).getInt('id')}"
									aria-hidden="true"
									onclick="voteContent(4,${content.getJSONObject(item).getInt('id')});"
									style=""></i>
							</c:if>
						</c:if>
					</c:forEach>
				</c:if>
				<c:if test="${edit}">
					<div style="display: inline-block;">
						<span style="float: left; padding: 5px;">Vote Enabled :</span>
						<c:if
							test="${content.getJSONObject(item).getBoolean('voteEnabled')}">
							<input name="voteEnable" type="checkbox" disabled="disabled"
								checked="checked"
								style="float: right; height: 20px; width: 20px; margin: 5px 5px 30px 5px;" />
						</c:if>
						<c:if
							test="${!content.getJSONObject(item).getBoolean('voteEnabled')}">
							<input name="voteEnable" type="checkbox" disabled="disabled"
								style="float: right; height: 20px; width: 20px; margin: 5px 5px 30px 5px;" />
						</c:if>
					</div>
				</c:if>
			</div>
		</c:forEach>
	</c:if>

</c:if>

<script>

function voteContent(voteValue,disContId) {
	data = {
		id : disContId,
		type : voteValue
	};
	$body.addClass("loading");
	$.ajax({
		url : "vote",
		data : data,
		type : "POST",
		success : function(data) {

				getAddedContent();

			$body.removeClass("loading");
		}
	});
}


</script>

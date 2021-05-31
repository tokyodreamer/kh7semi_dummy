<%@page import="semi.challenge.beans.ChallengeListDto"%>
<%@page import="semi.challenge.beans.ChallengeListDao"%>
<%@page import="semi.member.beans.MemberDto"%>
<%@page import="semi.member.beans.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int challengeNo = Integer.parseInt(request.getParameter("challengeNo"));	
	int memberNo = (int) session.getAttribute("memberNo");
	
	MemberDao memberDao = new MemberDao();
	MemberDto memberDto = memberDao.find(memberNo);
	
	ChallengeListDao challengeListDao = new ChallengeListDao();
	ChallengeListDto challengeListDto = challengeListDao.getChallenge(challengeNo);
	
%>
<jsp:include page="/template/header.jsp"></jsp:include>
<style>
.donate-container {
}

.donate-form {
}

.donate-input {
	width: 30%;
	padding: 1rem;
	outline: none;
}

.donate-input.donate-input-underline {
	border: none;
	font-size: 20px;
	font-weight:bold;
}

.donate-input.donate-input-underline:focus {
	border-bottom: 3px solid black;
	border-bottom-color: black;
}

.donate-input.donate-input-inline {
	width: auto;
}

/* 후원 보유 포인트 (완료) */
.donate-checkPoint{
	display:none;
	font-size: 20px;
	font-weight: bold;
}

/* 후원 라벨 (완료) */
.donate-label {
	font-size: 25px;
	font-weight:bold;
}

/* 후원 안내 (완료)*/
.donate-span {
	font-size: 20px;
	font-weight: bold;
}
/* 후원 에러 메세지 (완료) : */
.fail-message-01 {
	display: none;
	color: red;
	font-size: 20px;
	font-weight: bold;
}

.fail-message-02 {
	display: none;
	color: red;
	font-size: 20px;
	font-weight: bold;
}

/* 후원 성공 메세지 (완료) : */
.success-message {
	display: none;
	color: green;
	font-size: 20px;
	font-weight: bold;
}
/* 후원하기 버튼 (완료)*/
.donate-btn {
	margin-top: 20px;
	width: 30%;
	border: none;
	background-color: black;
	color: white;
	height: 50px;
	font-size: 20px;
	font-weight: bold;
}

/* 후원하기 버튼 : HOVER (완료)*/
.donate-btn:hover {
	background-color: rgb(46, 163, 79);
	color: white;
}

/* 목록 버튼 (완료) */
.donate-btn.donate-btn-list {
	margin-left: 10%;
	width: 30%;
	background-color: white;
	color: black;
	border: 1px solid black;
	height: 50px;
	font-size: 20px;
	font-weight: bold;
}

/* 목록 버튼 : HOVER (완료) */
.donate-btn.donate-btn-list:hover {
	background-color: lightgrey;
}

</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script type="text/javascript">
	$(function(){
		// 참가비 :
		
		$("#donatePoint").focus(function(){
			$(this).nextAll(".fail-message-01").hide();
			$(this).nextAll(".fail-message-02").hide();
			$(this).nextAll(".success-message").hide();
			$(this).nextAll(".donate-checkPoint").show();
		});
	
		$("#donatePoint").blur(function(){
			$(this).nextAll(".donate-checkPoint").hide();
			
			// 후원금은 참가비의 1%까지만 가능하며 최소 후원 포인트는 100 포인트 이상 (완료)
			if($("#donatePoint").val() > (<%=challengeListDto.getChallengePushPoint()%>*0.01)){
					$(this).nextAll(".donate-checkPoint").hide();
					$(this).nextAll(".success-message").hide();
					$(this).nextAll(".fail-message-02").hide();
					$(this).nextAll(".fail-message-01").show();
					$("#donatePoint").val(<%=challengeListDto.getChallengePushPoint()%>*0.01);
			// 조건절 : 
			} else if($("#donatePoint").val() == "") {
				$(this).nextAll(".donate-checkPoint").hide();
				$(this).nextAll(".success-message").hide();
				$(this).nextAll(".fail-message-01").hide();
				$(this).nextAll(".fail-message-02").show();
				$("#donatePoint").val(100);
			// 조건절 : 
			} else if( $("#donatePoint").val() < 100){
				$(this).nextAll(".donate-checkPoint").hide();
				$(this).nextAll(".success-message").hide();
				$(this).nextAll(".fail-message-01").hide();
				$(this).nextAll(".fail-message-02").show();
				$("#donatePoint").val(100);
			} else {
				$(this).nextAll(".fail-message-01").hide();
				$(this).nextAll(".fail-message-02").hide();
				$(this).nextAll(".donate-checkPoint").hide();
				$(this).nextAll(".success-message").show();
			}
			
		});
		
		$(".donate-form").submit(function(e){
				
				// 후원금이 참가비의 1% 이상이면 이벤트 중지 (완료)
				if($("#donatePoint").val() > (<%=challengeListDto.getChallengePushPoint()%>*0.01)){
					alert("후원금은 참가비의 1% 포인트까지 후원할 수 있습니다");
					e.preventDefault();
					$("#donatePoint").val(<%=challengeListDto.getChallengePushPoint()%>*0.01);
					$("#donatePoint").focus();
				}
				
		});
		
		// 목록 페이지 이동 (완료)
		$("#list").click(function(e){
			e.preventDefault();
			location.href="<%=request.getContextPath()%>/challenge/challengeList.jsp";
		})
	});
</script>
<div class="container-600">
	<div class="row">
		<h2>후원 페이지</h2>
	</div>
	<br>
	<div class="row">
		<span class="donate-label">참가비 : <%=challengeListDto.getChallengePushPoint() %> 포인트</span>
	</div>
	<br>
	<form action="donateJoin.kh?donateChallengeNo=<%=challengeNo%>&donateMemberNo=<%=memberNo%>&donateCategoryNo=<%=challengeListDto.getCategoryNo()%>" class="donate-form" method="post">
		<div class="row">
			<label class="donate-label">후원금 입력</label><br><br>
			<span class="donate-span">포인트 : </span><input type="number" class="donate-input donate-input-underline" name="donatePushPoint"  id="donatePoint" >
			<br><br>
			<span class="donate-checkPoint">후원 가능한 포인트 : <%=memberDto.getMemberPoint()%> 포인트</span>
			<span class="fail-message-01">후원금은 참가비의 1% 포인트까지 후원할 수 있습니다</span>
			<span class="fail-message-02">최소 후원금은 100 포인트 입니다</span>
			<span class="success-message">후원 가능합니다</span>
		</div>
		<div class="row">
			<input type="submit"  class="donate-btn" value="후원하기">
			<button class="donate-btn donate-btn-list" id="list">목록</button>
		</div>
	</form>
</div>
<jsp:include page="/template/footer.jsp"></jsp:include>
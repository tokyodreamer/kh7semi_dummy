<%@page import="semi.challenge.beans.ChallengeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%
 	ChallengeDao challengeDao = new ChallengeDao();
 	
 	int checkMemberPoint = challengeDao.checkMemberPoint((int) request.getSession().getAttribute("memberNo"));
 %>
<jsp:include page="/template/header.jsp"></jsp:include>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script type="text/javascript">
	$(function(){
		//제이쿼리 구현 예정 : ~ 2021.05.30 까지
		
		// 등록시점 제어
		
		// 시작일 : 현재 날짜보다 지난 날짜는 비활성화 (완료)
		$("#startDate").attr('min', new Date().toISOString().substring(0, 10));
		
		// 시작일 : 현재 날짜에서 일주일 이내만 선택 가능 (완료)
		$("#startDate").attr('max', new Date(Date.parse(new Date()) + 7 * 1000 * 60 * 60 * 24).toISOString().substring(0, 10));
		
		// 종료일 : 
		$("#endDate").on("focus", function(e){
			
			// 제어 : 시작일이 입력되어 있지 않다면 메세지 출력 (완료)
			if($("#startDate").val() == ""){
				alert("시작일을 먼저 입력해 주세요");
				$("#startDate").focus();
			}
			
			// 종료일 : 시작일을 기준으로 지난 날짜는 비활성화 (완료)
			$("#endDate").attr('min', $("#startDate").val());
		
			// 종료일 : 시작일을 기준으로 100일까지 선택 가능 (완료) : 회의 필요!
			$("#endDate").attr('max', new Date(Date.parse($("#startDate").val()) + 100 * 1000 * 60 * 60 * 24).toISOString().substring(0, 10))
		});
		
	});
</script>
<div class="container-600">
	<div class="row">
		<h2>도전글 작성 게시판 (임시 템플릿)</h2>
	</div>
	<form action="challengeJoin.kh" method="post" class="join-form">
		<div class="row text-left">
			<label for="title">제목</label>
			<input type="text" class="form-input" name="challengeTitle" placeholder="도전글 제목" id="title" required>
		</div>
		<div class="selectbox">
			<select id="ex_select" name="categoryNo">
				<option selected>참가종목 선택</option>
				<option value="1">운동</option>
				<option value="2">공부</option>
			</select>
		</div>
		<div class="row text-left">
			<label for="pushPoint">참가비</label>
			<input type="number" class="form-input" name="challengePushPoint" id="pushPoint" required>
		</div>
		<div class="row text-left">
			<label for="startDate">시작일</label>
			<input type="date" class="form-input" name="challengeStartDate" id="startDate"  required>
		</div>
		<div class="row text-left">
			<label for="endDate">종료일</label>
			<input type="date" class="form-input" name="challengeEndDate" id="endDate" required>
		</div>
		<div class="row text-left">
			<label>도전글 내용</label>
			<textarea name="challengeContent" rows="" cols="" id="content" required></textarea>
		</div>
		<div class="row">
			<input type="submit" class="form-btn form-btn-positive"  value="도전하기" >
		</div>
		<div class="row">
			<input type="reset"  class="form-btn form-btn-negative"  value="초기화">
		</div>
	</form>
</div>
<jsp:include page="/template/footer.jsp"></jsp:include>
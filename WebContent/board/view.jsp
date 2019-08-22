<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/include/jquery-3.4.1.min.js"></script>
<script>
$(function () {
	comment_list();
	$("#btnSave").click(function() {
			comment_add();
	});
	//수정/삭제 버튼을 누르면 비밀번호 체크로 이동
	$("#btnEdit").click(function() {
		document.form1.action="/board_servlet/pass_check.do";
		document.form1.submit(); //서버에 제출
	});
	//목록 버튼 클릭
	$("#btnList").click(function() {
		location.href="/board_servlet/list.do";
	});
	//답변 버튼 클릭
	$("#btnReply").click(function() {
		document.form1.action="/board_servlet/reply.do";
		document.form1.submit();
	});
});
function comment_list() { // 댓글 목록 요청
	$.ajax({
		url: "/board_servlet/commentList.do",
		data: "num=${dto.num}",
		success: function(result) {
			//댓글 목록을 id가 commentList 태그 부분에 html 형식으로 출력
			$("#commentList").html(result);
		}
	});
}
function comment_add() { // 댓글 저장 
	var param="board_num=${dto.num}&writer="+$("#writer").val()
	+"&content="+$("#content").val(); // 서버에 넘길 값
	$.ajax({
		type: "post",
		url: "/board_servlet/comment_add.do",
		data: param,
		success: function() {
			$("#writer").val(""); // 태그에 입력된 값을 지움
			$("#content").val("");
			comment_list();
		}
	});
}
</script>

</head>
<body>
<h2>게시물</h2>
<form name="form1" method="post">
<table border="1" width="700px">
	<tr>
		<td>날짜</td>
		<td>${dto.reg_date}</td>
		<td>조회수</td>
		<td>${dto.readcount}</td>
	</tr>	
	<tr>
		<td>이름</td>
		<td colspan="3">${dto.writer}</td>	
	</tr>
	<tr>
		<td>제목</td>
		<td colspan="3">${dto.subject}</td>	
	</tr>
	<tr>
		<td>본문</td>	
		<td colspan="3">${dto.content}</td>
	</tr>
	<tr>
		<td>비밀번호</td>	
		<td colspan="3">
		<input type="password" name="passwd" id="passwd">
 		<!--비밀번호가 틀릴 경우 출력할 메시지 
 		request.getparameter("변수") 대신 param.변수 사용 가능	--> 		
		<c:if test="${param.message == 'error' }">
			<span style="color:red;">비밀번호를 확인하세요</span>
		</c:if>
		</td>		
	</tr>
	<tr>
		<td>첨부파일</td>
		<td colspan="3">
			<c:if test="${dto.filesize > 0 }">
				${dto.filename} ( ${dto.filesize} bytes)
				<a href="/board_servelt/download.do?num=${dto.num}">[다운로드]</a>				
			</c:if>
		</td>	
	</tr>
	<tr>
		<td colspan="4" align="center">
			<input type="hidden" name="num" value="${dto.num}">
			<input type="button" value="수정/삭제" id="btnEdit">
			<input type="button" value="답변" id="btnReply">
			<input type="button" value="목록" id="btnList">
 		</td>
	</tr>			
</table>
</form>
<!-- 댓글 쓰기  -->
<table width="700px">
	<tr>
		<td><input type="text" id="writer" placeholder="이름"></td>
		<td rowspan="2">
			<button id="btnSave" type="button">확인</button>
		</td>
	</tr>
	<tr>
		<td><textarea rows="5" cols="80" placeholder="댓글 내용을 입력하세요."
			id="content"></textarea></td>
	</tr>
</table>
<!-- 댓글 목록을 출력할 태그 -->
<div id="commentList"></div>

</body>
</html>

















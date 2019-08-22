<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/include/jquery-3.4.1.min.js"></script>
<script>
$(function(){
	$("#btnSave").click(function(){
		var writer=$("#writer").val();
		var subject=$("#subject").val();
		var content=$("#content").val();
		var passwd=$("#passwd").val();
		if(writer == ""){ // 입력값이 없으면 
			alert("이름을 입력하세요."); // 경고창 (이벤트 )띄우고
			$("#writer").focus(); // 커서 깜빡여주고
			return; // 종료
		}
		if(subject == ""){
			alert("제목을 입력하세요.");
			$("#subject").focus();
			return;
		}
		if(content == ""){
			alert("내용을 입력하세요.");
			$("#content").focus();
			return;
		}
		if(passwd == ""){
			alert("비번을 입력하세요.");
			$("#passwd").focus();
			return;
		}
		document.form1.submit(); //서버에 전송
	});
	
});
</script>
</head>
<body>
<h2>글쓰기</h2>
<form name="form1" method="post" action="/board_servlet/insert.do"
enctype="multipart/form-data">
<table border="1" width="700px">
	<tr>
		<td>이름</td>
		<td><input type="text" name="writer" id="writer"></td>
	</tr>
	<tr>
		<td>제목</td>
		<td><input type="text" name="subject" id="subject"></td>
	</tr>
	<tr>
		<td>본문</td>
		<td><textarea rows="5" cols="60" name="content"
		id="content"></textarea></td>
	</tr>
	<tr>
		<td>첨부파일</td>
		<td><input type="file" name="filename" id="filename"></td>
	</tr>
	<tr>
		<td>비밀번호</td>
		<td><input type="password" name="passwd" id="passwd"></td>
	</tr>
	<tr>
		<td colspan="2" align="center">
		<input type="button" value="확인" id="btnSave"></td>		
	</tr>
</table>
</form>
</body>
</html>
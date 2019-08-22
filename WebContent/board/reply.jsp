<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/include/jquery-3.4.1.min.js"></script>
<script>
$(function() { // 페이지가 시작되면 자동으로 호출되는 함수
	$("#btnSave").click(function() { // 버튼을 누르면 실행
		var writer=$("#writer").val(); // id가 writer인 태그에 입력한 값
		var subject=$("#subject").val();
		var content=$("#content").val();
		var passwd=$("#passwd").val();
		if(writer == ""){ //빈값 체크
			alert("이름을 입력하세요.");
			$("#writer").focus();	
			return;		
		}
		if(subject == ""){ //빈값 체크
			alert("제목을 입력하세요.");
			$("#subject").focus();	
			return;		
		}
		if(content == ""){ //빈값 체크
			alert("내용을 입력하세요.");
			$("#content").focus();	
			return;		
		}
		if(passwd == ""){ //빈값 체크
			alert("비밀번호를 입력하세요.");
			$("#passwd").focus();	
			return;		
		}
		document.form1.submit();
	});
});

</script>
</head>
<body>
<form name="form1" method="post" action="/board_servlet/insertReply.do">
<table border="1" width="700px">
	<tr>
		<td>이름</td>
		<td><input type="text" name="writer" id="writer"></td>
	</tr>
	<tr>
		<td>제목</td>
		<td><input type="text" name="subject" id="subject"
			value="Re: ${dto.subject}" size="60"></td>
	</tr>
	<tr>
		<td>본문</td>
		<td>
			<textarea rows="5" cols="60" name="content" id="content">${dto.content}</textarea>
		</td>
	</tr>
	<tr>
		<td>비밀번호</td>
		<td><input type="password" name="passwd" id="passwd"></td>		
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="hidden" name="num" value="${dto.num}">
			<input type="button" value="확인" id="btnSave"> 
		</td>
	</tr>
</table>

</form>
</body>
</html>
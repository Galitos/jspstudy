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
$(function() {
	// 수정 버튼을 클릭할 때 실행되는 코드
	$("#btnUpdate").click(function() {
		document.form1.action="/board_servlet/update.do";
		document.form1.submit();
	});
	// 삭제 버튼을 클릭할 때 실행되는 코드
	$("#btnDelete").click(function() {
		if(confirm("삭제하시겠습니까?")){
			document.form1.action="/board_servlet/delete.do";
			document.form1.submit();	
		}			
	});
});

</script>

</head>
<body>
<h2>게시물 수정</h2>
<form name="form1" method="post" enctype="multipart/form-data">
<table border="1" width="700px">
	<tr>
		<td>이름</td>
		<td><input type="text" name="writer" id="writer"
		 value="${dto.writer}"></td>
	</tr>
	<tr>
		<td>제목</td>
		<td><input type="text" name="subject" id="subject" size="60"
		 value="${dto.subject}"></td>
	</tr>
	<tr>
		<td>본문</td>
		<td><textarea rows="5" cols="60" name="content"
		id="content">${dto.content}</textarea></td>
	</tr>
	<tr>
		<td>첨부파일</td>
		<td>
			<c:if test="${dto.filesize > 0 }">
				${dto.filename} ( ${dto.filesize / 1024} KB)<br>
			</c:if>
			<input type="file" name="file1">
		</td>
	</tr>
	<tr>
		<td>비밀번호</td>
		<td><input type="password" name="passwd" id="passwd">
			<c:if test="${param.pwd_error == 'y'}">
				<span style="color:red;">비밀번호가 일치하지 않습니다.</span>
			</c:if>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="hidden" name="num" value="${dto.num}">
			<input type="button" value="수정" id="btnUpdate">
			<input type="button" value="삭제" id="btnDelete">
		</td>
	</tr>	
</table>
</form>







</body>
</html>
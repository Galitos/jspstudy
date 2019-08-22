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
$(function(){ //페이지가 로딩된후 자동으로 실행되는 함수
	// id가 btnWrite인  태그를 클릭하면 실행되는 코드
	$("#btnWrite").click(function(){
		location.href="/board/write.jsp";
	});	
});

</script>
</head>
<body>
<h2>게시판</h2>

<form name="form1" method="post" action="/board_servlet/search.do">
<select name="search_option">
	<option value="writer">이름</option>
	<option value="subject">제목</option>
	<option value="content">본문</option>
	<option value="all">이름+제목+본문</option>
</select>
<input type="text" name="keyword">
<input type="submit" value="조회">
</form>
	


<button id="btnWrite">글쓰기</button>
<table border="1" width="900px">
	<tr> <!-- <tr>태그 한줄 <th>제목셀 <td>셀 -->
		<th>번호</th>
		<th>이름</th>
		<th>제목</th>
		<th>날짜</th>
		<th>조회수</th>
		<th>첨부파일</th>
		<th>다운로드</th>
	</tr>
<c:forEach var="dto" items="${list}">
	<tr>
		<td>${dto.num}</td>
		<td>${dto.writer}</td>
		<td>
		<!-- 답변글의 경우 들여쓰기 처리 -->
		<c:forEach var="i" begin="1" end="${dto.re_revel}">
			&nbsp;&nbsp;
		</c:forEach>
		<a href="/board_servlet/view.do?num=${dto.num}">${dto.subject}</a>
		<c:if test="${dto.comment_count > 0 }">
		<span style="color:red;">( ${dto.comment_count} )</span>
		</c:if>
		</td>
		<td>${dto.reg_date}</td>
		<td>${dto.readcount}</td>
		<td>
<!-- 첨부파일 크기가 0보다 크면 아이콘 표시, 아이콘을 누르면 다운로드 -->
		<c:if test="${dto.filesize > 0}">
		  <a href="/board_servlet/download.do?num=${dto.num}">
		  <img src="/images/file.gif"></a>
		</c:if>		
		</td>
		<td>${dto.down}</td>
	</tr>
</c:forEach>
</table>
</body>
</html>
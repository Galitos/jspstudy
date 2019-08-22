<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<!-- cos.jar 내용들 -->
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String upload_path="d:/upload";// 파일을 업로드할 디렉토리(미리 만들어야 함)
int size=10*1024*1024; // 파일 업로드 제한 용량
String name="";
String subject="";
String filename="", filename2="";
int filesize=0, filesize2=0;
try{
	//request 객체를 확장하여 파일 업로드가 가능한 객체 
	MultipartRequest multi=new  MultipartRequest(request, upload_path, size, "utf-8",
			new DefaultFileRenamePolicy());
	name=multi.getParameter("name");
	subject=multi.getParameter("subject");
	Enumeration files= multi.getFileNames(); // 첨부파일 집합
	String file1=(String)files.nextElement();
	String file2=(String)files.nextElement();
	filename=multi.getFilesystemName(file1);
	File f1=multi.getFile(file1);
	filesize=(int)f1.length();
	filename2=multi.getFilesystemName(file2);
	File f2=multi.getFile(file2);
	filesize2=(int)f2.length();
}catch(Exception e){
	e.printStackTrace();
}
%>
이름 : <%=name%><br>
제목 : <%=subject%><br>
파일1 이름 : <%=filename%><br>
파일1 크기 : <%=filesize%><br>
파일2 이름 : <%=filename2%><br>
파일2 크기 : <%=filesize2%><br>
</body>
</html>







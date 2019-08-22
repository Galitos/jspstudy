package board;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import board.dao.BoardDAO;
import board.dto.BoardCommentDTO;
import board.dto.BoardDTO;
import common.Constants;

@WebServlet("/board_servlet/*")
public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		// 사용자가 호출한 url을 가져옴
		String url=request.getRequestURI().toString();
		BoardDAO dao= new BoardDAO();  //dao 객체 생성
		if(url.contains("list.do")) {
			System.out.println("#####");
			List<BoardDTO> list=dao.list();
			// request 로 저장
			request.setAttribute("list", list);
			String page="/board/list.jsp";
			RequestDispatcher rd=request.getRequestDispatcher(page);
			rd.forward(request, response);
		}else if(url.contains("insert.do")) {
			BoardDTO dto=new BoardDTO();
			File uploadDir=new File(Constants.UPLOAD_PATH); //파일 업로드 디렉토리
			if(!uploadDir.exists()) { // exists()->디렉토리가 존재하면 true, 아니면 false
				uploadDir.mkdir(); //디렉토리 만들기
			}
			MultipartRequest multi= new MultipartRequest(request,
					Constants.UPLOAD_PATH, Constants.MAX_UPLOAD, "utf-8",
			new DefaultFileRenamePolicy()); //파일업로드를 위한 객체 생성
			String filename="";
			int filesize=0;
			try {
				Enumeration files=multi.getFileNames();// 첨부파일 목록
				while(files.hasMoreElements()) { //다음 요소가 있으면
					String file1=(String)files.nextElement(); //다음 요소를 조회함
					filename=multi.getFilesystemName(file1); //파일의 이름
					File f1=multi.getFile(file1);
					if(f1 != null) filesize=(int)f1.length();// 파일의 사이즈
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			//폼에 작성한 내용들을 읽어서 dto에 저장
			String writer=multi.getParameter("writer");
			String subject=multi.getParameter("subject");
			String content=multi.getParameter("content");
			String passwd=multi.getParameter("passwd");
			String ip=request.getRemoteAddr(); //ip주소
			dto.setWriter(writer);
			dto.setSubject(subject);
			dto.setContent(content);
			dto.setPasswd(passwd);
			dto.setIp(ip);
			if(filename == null || filename.trim().equals("")) {
				filename="-"; // 첨부파일이 없는 경우 -으로 표시
			}
			dto.setFilename(filename);
			dto.setFilesize(filesize);
			dao.insert(dto); // 레코드가 저장됨
			response.sendRedirect("/board_servlet/list.do"); // 목록으로 이동			
		}else if(url.contains("download.do")) {
			System.out.println("22222");
			int num=Integer.parseInt(request.getParameter("num"));
			System.out.println("게시물번호:"+num);
			String filename=dao.getFilename(num);
			System.out.println("첨부파일:"+filename);
			
			String path=Constants.UPLOAD_PATH+filename; //첨부파일 경로
			byte[] b=new byte[4096]; // 바이트 배열 선언
			FileInputStream fis=new FileInputStream(path); //파일입력스트림
			String mimeType=getServletContext().getMimeType(path); //마임타입(파일의 종류)
			if(mimeType == null) {//마임타입이 null이면 기본값 부여
				mimeType="application/octet-stream;charset=utf-8";
			}
			//헤더에 첨부파일 정보 명시
			//파일이름에 한글이 포함된 경우 아래와 같이 처리
			//스트링.getBytes("언어셋") 스트링을 바이트 배열로 저장
			// new String(바이트배열, 언어셋)
			filename=new String(filename.getBytes("ms949"),"8859_1");
			response.setHeader("Content-Disposition", "attachment;filename="+filename);
			ServletOutputStream out=response.getOutputStream(); //클라이언트 출력용 스트림
			int numRead;
			while(true) {
				numRead=fis.read(b, 0, b.length); //파일을 읽음
				if(numRead == -1) break; // 더이상 읽을 내용이 없으면 반복문 종료
				out.write(b, 0, numRead); //클라이언트에 전송
			}
			//리소스 정리
			out.flush();
			out.close();
			fis.close();
			//다운로드 횟수 증가 처리
			dao.plusDown(num);
		}else if(url.contains("view.do")) {
			int num=Integer.parseInt(request.getParameter("num"));
			//조회수 증가 처리
			dao.plusReadCount(num);
			//레코드 내용이 리턴되어 dto에 저장됨
			BoardDTO dto=dao.view(num);
			request.setAttribute("dto", dto);
			String page="/board/view.jsp";
			RequestDispatcher rd=request.getRequestDispatcher(page);
			rd.forward(request, response);
		}else if(url.contains("comment_add.do")) {
			//사용자가 입력한 댓글 내용을 dto에 저장
			BoardCommentDTO dto=new BoardCommentDTO();
			dto.setBoard_num(
				Integer.parseInt(request.getParameter("board_num")));
			dto.setWriter(request.getParameter("writer"));
			dto.setContent(request.getParameter("content"));
			//댓글이 저장됨
			dao.commentAdd(dto);
		}else if(url.contains("commentList.do")) {
			int num=Integer.parseInt(request.getParameter("num"));		
			List<BoardCommentDTO> list=dao.commentList(num);
			request.setAttribute("list", list);
			String page="/board/comment_list.jsp";
			RequestDispatcher rd=request.getRequestDispatcher(page);
			rd.forward(request, response);			
		}else if(url.contains("pass_check.do")) {
			int num=Integer.parseInt(request.getParameter("num"));
			String passwd=request.getParameter("passwd");
			String result=dao.passwdCheck(num, passwd);
			String page="";
			if(result != null) {
				page="/board/edit.jsp";
				request.setAttribute("dto", dao.view(num));
				RequestDispatcher rd=request.getRequestDispatcher(page);
				rd.forward(request, response);
			}else {//비번이 틀리면 view.do로 되돌아가서 메시지 출력
				page="/board_servlet/view.do?num="+num+"&message=error";
				response.sendRedirect(page);
			}
		}else if(url.contains("update.do")){
			BoardDTO dto=new BoardDTO();
			//request 객체에 없는 파일업로드 기능을 구현한 객체
			MultipartRequest multi=new MultipartRequest(request,
					Constants.UPLOAD_PATH, Constants.MAX_UPLOAD, "utf-8",
					new DefaultFileRenamePolicy());
			String filename=" ";
			int filesize=0;
			try {
				Enumeration files=multi.getFileNames();//첨부파일 집합
			while(files.hasMoreElements()) {//다음 요소가 있으면				
				String file1=(String)files.nextElement(); //다음 요소를 읽음
				filename=multi.getFilesystemName(file1); //파일 이름
				File f1=multi.getFile(file1);
			//	System.out.println(f1);
				if(f1 != null) {
					filesize=(int)f1.length(); // 파일의 크기
				}
			}
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			String writer=multi.getParameter("writer");
			String subject=multi.getParameter("subject");
			String content=multi.getParameter("content");
			String passwd=multi.getParameter("passwd");
			String ip=request.getRemoteAddr(); //ip주소
			int num=Integer.parseInt(multi.getParameter("num"));
			dto.setNum(num);
			dto.setWriter(writer);
			dto.setSubject(subject);
			dto.setContent(content);
			dto.setPasswd(passwd);
			dto.setIp(ip);
			//새로운 첨부파일을 올리지 않은 경우(기존 첨부 파일 정보를 사용)
			if(filename == null || filename.trim().equals("")){
				BoardDTO dto2=dao.view(num);
				String fName=dto2.getFilename();
				int fSize=dto2.getFilesize();
				int fDown=dto2.getDown();
				dto.setFilename(fName);
				dto.setFilesize(fSize);
				dto.setDown(fDown);
			}else { //새로운 첨부파일을 올린 경우
				dto.setFilename(filename);
				dto.setFilesize(filesize);
			}
			String result=dao.passwdCheck(num, passwd); //비밀번호 체크
			if(result !=null) {
				dao.update(dto);
				String page="/board_servlet/list.do";
				response.sendRedirect(page);
			}else { //비밀번호 틀리면 되돌아가서 에러메시지가 출력된
				request.setAttribute("dto", dto);
				String page="/board/edit.jsp?pwd_error=y";
				RequestDispatcher rd=request.getRequestDispatcher(page);
				rd.forward(request, response);
			}
			// 삭제 함수 불러오는 코드
		}else if(url.contains("delete.do")) {
			//테이블에 파일이 존재할경우 파일은 request로 가져올수 없기때문에 확장버전인 MultipartRequest 객체를 생성해야함
		MultipartRequest multi=new MultipartRequest(request,
				Constants.UPLOAD_PATH,Constants.MAX_UPLOAD,"utf-8",
				new DefaultFileRenamePolicy());		
			//삭제할 게시물 번호
			int num=Integer.parseInt(multi.getParameter("num"));
			dao.delete(num);
			response.sendRedirect("/board_servlet/list.do");			
		}else if(url.contains("reply.do")) {
			//원글의 번호
			int num=Integer.parseInt(request.getParameter("num"));
			BoardDTO dto=dao.view(num);
			dto.setContent("===게시물의 내용===\n"+dto.getContent());
			request.setAttribute("dto", dto); // 저장
			//작성 페이지로 이동
			String page="/board/reply.jsp";
			RequestDispatcher rd=request.getRequestDispatcher(page);
			rd.forward(request, response);
		}else if(url.contains("insertReply.do")) {
			request.setCharacterEncoding("utf-8");
			int num=Integer.parseInt(request.getParameter("num")); // 원글 번호
			BoardDTO dto=dao.view(num); // 원글 내용
			int ref=dto.getRef(); // 원글의 ref값(게시물 그룹 번호)
			int re_step=dto.getRe_step()+1; // 원글의 출력순번 + 1
			int re_revel=dto.getRe_revel()+1; //원글의 답변단계 +1 
			String writer=request.getParameter("writer");
			String subject=request.getParameter("subject");
			String content=request.getParameter("content");
			String passwd=request.getParameter("passwd");
			dto.setWriter(writer);
			dto.setSubject(subject);
			dto.setContent(content);
			dto.setPasswd(passwd);//첨부파일 관련 정보는 기본값으로 처리(파일 업로드 기능 생략)
			dto.setRef(ref);
			dto.setRe_step(re_step);
			dto.setRe_revel(re_revel);
			dto.setFilename("-"); //첨부파일 관련 정보는 기본값으로 처리(파일 업로드 기능 생략)
			dto.setFilesize(0);
			dto.setDown(0);
			dao.updateStep(ref, re_step);//답변글들의 출력 순번 조정
			dao.reply(dto);// 답변글 저장
			response.sendRedirect("/board_servlet/list.do");// 목록으로 이동
		}else if(url.contains("search.do")) { //게시물 조회 기능
			request.setCharacterEncoding("utf-8");
			//검색 옵션
			String search_option=request.getParameter("search_option");
			//검색 키워드
			String keyword=request.getParameter("keyword");
			//검색된 목록이 list로 넘어옴
			List<BoardDTO> list=dao.searchList(search_option, keyword);
			// 출력 전에 저장
			request.setAttribute("list", list);
			//출력페이지
			String page="/board/list.jsp";
			RequestDispatcher rd=request.getRequestDispatcher(page);
			rd.forward(request, response);
		}
			
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}






















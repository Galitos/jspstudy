package sqlmap;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MybatisManager {
	private static SqlSessionFactory instance;
	private MybatisManager() {} //private 생성자 외부에서 호출 못함
	// 생성자 대신 제공하는 함수
	public static SqlSessionFactory getInstance() {
		Reader reader=null;
		try {
			//mybatis 환경설정 파일을 읽음
			reader=Resources.getResourceAsReader("sqlmap/sqlMapConfig.xml");
			// SqlSessionFactory() 객체를 생성하는 코드
			instance=new SqlSessionFactoryBuilder().build(reader);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(reader != null)reader.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return instance;
	}
}

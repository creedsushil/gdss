package index;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.json.JSONArray;
import org.json.JSONException;

import converter.ResultSetConverter;

public class IndexMethods {
	static DataSource pool;
	public static void main(String[] args) throws ServletException {
		// TODO Auto-generated method stub
	}

	public static void init() throws ServletException {
		try {
			// Create a JNDI Initial context to be able to lookup the DataSource
			InitialContext ctx = new InitialContext();
			// Lookup the DataSource, which will be backed by a pool
			// that the application server provides.
			pool = (DataSource) ctx.lookup("java:comp/env/jdbc/gdss");
			if (pool == null)
				throw new ServletException("Unknown DataSource 'jdbc/gdss'");
		} catch (NamingException ex) {
			ex.printStackTrace();
		}
	}
	
	
	public JSONArray getRecentGroup(HttpServletRequest request, HttpServletResponse response)
			throws JSONException, ServletException, IOException, SQLException {
		int userId = 0;
		init();
		try {
			userId = searchUserByUserName().getJSONObject(0).getInt("id");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Connection conn = null;
		Statement stmt = null;
		JSONArray rs = null;
		conn = pool.getConnection();
		String query = "SELECT * FROM tbl_discussion d where d.creator_id =" + userId;
		stmt = conn.createStatement();

		ResultSet result = stmt.executeQuery(query);
		if (result != null)
			rs = ResultSetConverter.convert(result);

		stmt.close();
		conn.close();
		return rs;
	}

	public JSONArray searchUserByUserName() throws SQLException, ServletException {
		init();
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		Subject currentUser = SecurityUtils.getSubject();
		String query = "Select id,email from tbl_user where userName like '" + currentUser.getPrincipal() + "'";
		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();

		return returnResult;

	}

	
	
}

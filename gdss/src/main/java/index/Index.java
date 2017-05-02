package index;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.shiro.subject.Subject;
import org.json.JSONArray;
import org.json.JSONException;

import converter.ResultSetConverter;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.shiro.SecurityUtils;

/**
 * Servlet implementation class Index
 */
public class Index extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DataSource pool;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Index() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public void init() throws ServletException {
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

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Subject currentUser = SecurityUtils.getSubject();
		request.setAttribute("userName", currentUser.getPrincipal());
		try {
			request.setAttribute("currentGroup", getRecentGroup(request, response));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		getServletContext().getRequestDispatcher("/view/dashboard.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	public JSONArray getRecentGroup(HttpServletRequest request, HttpServletResponse response)
			throws JSONException, ServletException, IOException, SQLException {
		int userId = 0;
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

	public JSONArray searchUserByUserName() throws SQLException {
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

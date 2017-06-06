package group;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.json.JSONArray;
import org.json.JSONException;

import converter.ResultSetConverter;

/**
 * Servlet implementation class Vote
 */
public class Vote extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static DataSource pool;

	/**
	 * @see HttpServlet#HttpServlet()
	 */

	public Vote() {
		super();
		// TODO Auto-generated constructor stub
	}

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

	public Connection establishConnection() throws SQLException, ServletException {
		return pool.getConnection();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			countVote(request, response);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			boolean voted = vote(request);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public boolean vote(HttpServletRequest request) throws SQLException, JSONException, ServletException {

		int userId = searchUserByUserName().getJSONObject(0).getInt("id");
		boolean checkVotedSame = checkVotedSame(request, userId);
		deleteVote(Integer.parseInt(request.getParameter("id")), userId);
		if (!checkVotedSame) {
			addVote(request, userId);
		}
		return true;
	}

	public void addVote(HttpServletRequest request, int userId) throws SQLException, ServletException {
		init();
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "insert into tbl_disContentVote(disContentId,voteType,userId) values('"
				+ Integer.parseInt(request.getParameter("id")) + "','" + (String) request.getParameter("type") + "','"
				+ userId + "')";
		// voteType 1= like
		// voteType 2 = modeLike
		// voteType 3 = modDislike
		// voteType 4 = dislike
		stmt.executeUpdate(query);
		stmt.close();
		conn.close();

	}

	public JSONArray searchUserByUserName() throws SQLException, ServletException {
		init();
		Connection conn = establishConnection();
		Statement stmt = conn.createStatement();
		Subject currentUser = SecurityUtils.getSubject();
		String query = "Select id,email from tbl_user where userName like '" + currentUser.getPrincipal() + "'";
		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();

		return returnResult;

	}

	public boolean checkVotedSame(HttpServletRequest request, int userId) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select * from tbl_discontentVote where disContentId = '"
				+ Integer.parseInt(request.getParameter("id")) + "' and userId=" + userId + " and voteType='"
				+ (String) request.getParameter("type") + "'";
		ResultSet result = stmt.executeQuery(query);
		boolean returnResult = result.next();
		stmt.close();
		conn.close();
		return returnResult;
	}

	public void deleteVote(int disId, int userId) throws SQLException, ServletException {
		init();
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "delete from tbl_discontentVote where disContentId = '" + disId + "' and userId=" + userId;
		stmt.executeUpdate(query);
		stmt.close();
		conn.close();

	}

	public void countVote(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select count(id) as voteCount,votType from tbl_vote where disContentId = '"
				+ Integer.parseInt(request.getParameter("id")) + "' group by voteType";
		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();

		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.print(returnResult);
		out.flush();

	}
	
	public int checkVote(int disContId, int userId) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select * from tbl_discontentVote where disContentId = '" + disContId + "' and userId=" + userId;
		ResultSet result = stmt.executeQuery(query);
		int voteType = 0;
		if (result.next())
			voteType = result.getInt("vote_type");
		stmt.close();
		conn.close();
		return voteType;
	}

}

package group;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.json.JSONArray;
import org.json.JSONException;

import converter.ResultSetConverter;

public class DiscussionMethods {
	static DataSource pool;

	public static void main(String[] args) {
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

	public Connection establishConnection() throws SQLException, ServletException {
		init();
		return pool.getConnection();
	}

	public boolean addComment(HttpServletRequest request) throws ServletException {
		Subject currentUser = SecurityUtils.getSubject();
		int disId = Integer.parseInt(request.getParameter("id"));
		String encryptedUserName = org.apache.commons.codec.digest.DigestUtils
				.sha256Hex(((String) currentUser.getPrincipal()+disId));
		String comment = (String) request.getParameter("comment");
		
		Connection conn = null;
		Statement stmt = null;
		boolean result = false;
		init();
		try {
			conn = establishConnection();
			String query = "insert into tbl_comment(dis_id,user,comment) values(" + disId + ",'" + encryptedUserName
					+ "','" + comment + "')";
			stmt = conn.createStatement();
			result = stmt.execute(query);
		} catch (SQLException ex) {
			request.setAttribute("message", "Something went wrong!");
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close(); // return to pool
			} catch (SQLException ex) {
				ex.printStackTrace();
			}

		}
		return result;
	}

	public JSONArray getComments(HttpServletRequest request) throws ServletException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet result = null;
		JSONArray returnResult = null;
		try {
			init();
			conn = establishConnection();
			String query = "select * from tbl_comment where dis_id="
					+ Integer.parseInt((String) request.getParameter("id")) + " order by id asc";
			stmt = conn.createStatement();
			result = stmt.executeQuery(query);
			returnResult = ResultSetConverter.convert(result);
			if (!(returnResult.length() > Integer.parseInt(request.getParameter("count")))) {
				returnResult = null;
			}
		} catch (SQLException ex) {
			request.setAttribute("message", "Something went wrong!");
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close(); // return to pool
			} catch (SQLException ex) {
				ex.printStackTrace();
			}

		}
		return returnResult;
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

	public void addVote(HttpServletRequest request, int userId) throws SQLException, ServletException {
		init();
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "insert into tbl_vote(dis_id,vote_type,userId) values('"
				+ Integer.parseInt(request.getParameter("id")) + "','" + (String) request.getParameter("type") + "','"
				+ userId + "')";
		//voteType 1= like
		//voteType 2 = modeLike
		//voteType 3 = modDislike
		//voteType 4 = dislike
		stmt.executeUpdate(query);
		stmt.close();
		conn.close();

	}

	public void deleteVote(int disId, int userId) throws SQLException, ServletException {
		init();
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "delete from tbl_vote where dis_id = '" + disId + "' and userId=" + userId;
		stmt.executeUpdate(query);
		stmt.close();
		conn.close();

	}

	public boolean checkVotedSame(HttpServletRequest request, int userId) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select * from tbl_vote where dis_id = '" + Integer.parseInt(request.getParameter("id"))
				+ "' and userId=" + userId + " and vote_type='" + (String) request.getParameter("type") + "'";
		ResultSet result = stmt.executeQuery(query);
		boolean returnResult = result.next();
		stmt.close();
		conn.close();
		return returnResult;
	}

	
	
	
}

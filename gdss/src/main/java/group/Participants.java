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

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import converter.ResultSetConverter;

/**
 * Servlet implementation class Participants
 */
public class Participants extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DataSource pool;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Participants() {
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

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		if (((String) request.getParameter("action")).equals("delete")) {
			deleteParticipant(id);
		}else if(((String) request.getParameter("action")).equals("add")){
			String email = (String) request.getParameter("email");
			addParticipant(id, email, request);
		}else {
			JSONArray participants = getParticipants(id);
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			out.print(participants);
			out.flush();
		}

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

	public JSONArray getParticipants(int id) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet result = null;
		JSONArray returnResult = null;

		try {
			// Get a connection from the pool
			conn = pool.getConnection();
			//Select (select COUNT(*) FROM tbl_chat where part = tbl_participants.participant and isByCreator = 0 and isSeen = 0) as isSeen,tbl_participants.participant,tbl_participants.groupId from tbl_participants inner join tbl_chat on tbl_chat.dis_id = tbl_participants.groupId where tbl_participants.groupId = "+id+" GROUP BY tbl_participants.participant
			String query = "Select (select COUNT(*) FROM tbl_chat where part = tbl_participants.participant and isByCreator = 0 and isSeen = 0) as isSeen,tbl_participants.participant,tbl_participants.id,tbl_participants.groupId from tbl_participants left join tbl_chat on tbl_chat.dis_id = tbl_participants.groupId where tbl_participants.groupId = "+id+" and tbl_participants.isRemoved = 0 GROUP BY tbl_participants.participant";

			stmt = conn.createStatement();
			result = stmt.executeQuery(query);
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			try {
				returnResult = ResultSetConverter.convert(result);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
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

	public void deleteParticipant(int id){
		Connection conn = null;
		Statement stmt = null;

		try {
			// Get a connection from the pool
			conn = pool.getConnection();
			String query = "update tbl_participants set isRemoved = 1 , removedDate = CURRENT_TIMESTAMP where id = " + id;

			stmt = conn.createStatement();
			stmt.executeUpdate(query);
		} catch (SQLException ex) {
			ex.printStackTrace();
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

	}
	
	public void addParticipant(int disId,String email,HttpServletRequest request){
		Connection conn = null;
		Statement stmt = null;
		int result = 0;
		try {
			// Get a connection from the pool
			conn = pool.getConnection();
			String query = "insert into tbl_participants(groupId,participant) values("+disId+",'"+email+"')";

			stmt = conn.createStatement();
			result = stmt.executeUpdate(query);
			if(result>0){
				Group group = new Group();
				group.sendEmailToParticipants(email, request);
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
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
	}
	
	
}

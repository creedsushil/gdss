package group;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.Security;
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
import org.json.JSONObject;

import converter.ResultSetConverter;

/**
 * Servlet implementation class Chat
 */
public class Chat extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DataSource pool;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Chat() {
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
		if (((String) request.getParameter("action")).equals("list")) {
			JSONArray chat = null;
			try {
				chat = getAllChat(1);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			request.setAttribute("chat", chat);

			getServletContext().getRequestDispatcher("/view/chat.jsp").forward(request, response);

		} else {
			if (((String) request.getParameter("action")).equals("updateSeenStatus")) {
				JSONArray chat = null;
				try {
					chat = getAllChat(1);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				request.setAttribute("chat", chat);

				getServletContext().getRequestDispatcher("/view/chatTBody.jsp").forward(request, response);

			} else if (((String) request.getParameter("action")).equals("chatFromParticipants")) {
				int id = Integer.parseInt(request.getParameter("discussionId"));
				String part = (String) request.getParameter("part");

				Subject currentUser = SecurityUtils.getSubject();
				String user = org.apache.commons.codec.digest.DigestUtils
						.sha256Hex(((String) currentUser.getPrincipal() + id));

				JSONArray chat = null;
				try {
					chat = getParticipantsChat(id, part, user);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				response.setContentType("text/html");
				PrintWriter out = response.getWriter();
				String messages = "<input type='hidden' id='part' value='" + part
						+ "'/> <input type='hidden' id='disId' value='" + id + "'/>";
				if (chat.length() > 0) {
					for (int i = 0; i < chat.length(); i++) {
						JSONObject rec = chat.getJSONObject(i);
						if ((rec.getString("sender")).equals(user)) {

							messages = messages
									+ "<div class='fromMe'><span style='float: left; width: 75%; margin-left: 5px;text-align: right;'>"
									+ rec.getString("message") + "</span><span class='me'>: Me</span></div>";

						} else {

							messages = messages + "<div class='toMe'><span style='width: 75%;text-align: left;'>"
									+ rec.getString("message") + "</span></div>";

						}
					}
				}
				out.println(messages);
				out.flush();

			} else {
				int id = Integer.parseInt(request.getParameter("discussionId"));
				String part = (String) request.getParameter("part");
				String action = (String) request.getParameter("action");
				int isByCreator = 1;
				if (action.equals("edit")) {
					isByCreator = 0;
				}
				JSONArray chat = null;
				try {
					chat = getChat(id, part, isByCreator);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				response.setContentType("text/html");
				PrintWriter out = response.getWriter();
				String messages = "<input type='hidden' id='part' value='" + part
						+ "'/> <input type='hidden' id='disId' value='" + id + "'/>";
				if (chat.length() > 0) {
					for (int i = 0; i < chat.length(); i++) {
						JSONObject rec = chat.getJSONObject(i);
						if (rec.getBoolean("isByCreator")) {
							if (((String) request.getParameter("action")).equals("edit")) {
								messages = messages
										+ "<div class='fromMe'><span style='float: left; width: 75%; margin-left: 5px;text-align: right;'>"
										+ rec.getString("message") + "</span><span class='me'>: Me</span></div>";
							} else {
								messages = messages + "<div class='toMe'><span style='width: 75%;text-align: left;'>"
										+ rec.getString("message") + "</span></div>";
							}
						} else {
							if (((String) request.getParameter("action")).equals("edit")) {
								messages = messages + "<div class='toMe'><span style='width: 75%;text-align: left;'>"
										+ rec.getString("message") + "</span></div>";
							} else {
								messages = messages
										+ "<div class='fromMe'><span style='float: left; width: 75%; margin-left: 5px;text-align: right;'>"
										+ rec.getString("message") + "</span><span class='me'>: Me</span></div>";
							}
						}
					}
				}
				out.println(messages);
				out.flush();

			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		if ((String) request.getParameter("discussionId") == null) {
			JSONArray chat = null;
			try {
				chat = getAllChat(1);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			request.setAttribute("chat", chat);

			getServletContext().getRequestDispatcher("/view/chat.jsp").forward(request, response);

		} else {
			int id = Integer.parseInt(request.getParameter("discussionId"));
			String part = (String) request.getParameter("part");
			String message = (String) request.getParameter("message");
			boolean isByCreator = false;
			if (((String) request.getParameter("action")).equals("chatFromParticipants")) {
				Subject currentUser = SecurityUtils.getSubject();
				String user = org.apache.commons.codec.digest.DigestUtils
						.sha256Hex(((String) currentUser.getPrincipal() + id));

				saveParticipantsChat(id, part, message, user);
			} else {
				if (((String) request.getParameter("isByCreator")).equals("true")) {
					isByCreator = true;
				}
				saveChat(id, part, message, isByCreator);

			}
		}
	}

	public void saveChat(int id, String part, String message, boolean isByCreator) {
		Connection conn = null;
		Statement stmt = null;
		int byCreator = isByCreator ? 1 : 0;
		int result = 0;
		try {
			// Get a connection from the pool
			conn = pool.getConnection();
			String query = "insert into tbl_chat(dis_id,part,message,isByCreator) values(" + id + ",'" + part + "','"
					+ message + "'," + byCreator + ")";

			stmt = conn.createStatement();
			result = stmt.executeUpdate(query);

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

	public void saveParticipantsChat(int id, String part, String message, String user) {
		Connection conn = null;
		Statement stmt = null;

		try {
			// Get a connection from the pool
			conn = pool.getConnection();
			String query = "insert into tbl_chatall(disId,sender,reciever,message) values(" + id + ",'" + user + "','"
					+ part + "','" + message + "')";

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

	public JSONArray getChat(int id, String part, int isByCreator) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select * from tbl_chat where dis_id = '" + id + "' and part = '" + part + "'";
		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();
		updateSeenStatus(id, part, isByCreator);
		return returnResult;

	}

	public JSONArray getParticipantsChat(int id, String part, String user) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select * from tbl_chatall where disId = '" + id + "' and sender in('" + part + "','" + user
				+ "') and reciever in('" + part + "','" + user + "')";
		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();
		// updateSeenStatus(id,part,isByCreator);
		return returnResult;

	}

	public void updateSeenStatus(int id, String part, int isByCreator) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "update tbl_chat set isSeen = 1 where dis_id = '" + id + "' and part = '" + part
				+ "' and isByCreator = '" + isByCreator + "'";
		stmt.executeUpdate(query);

		stmt.close();
		conn.close();

	}

	public JSONArray getAllChat(int isCreator) throws SQLException {
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		JSONObject userObj = searchUserByUserName().getJSONObject(0);
		String user = userObj.getString("email");
		// "Select (select COUNT(*) FROM tbl_chat where part =
		// 'sherryyang12321@gmail.com' and isByCreator = 1 and isSeen = 0 and
		// tbl_chat.dis_id = tbl_discussion.dis_id) as
		// isSeen,tbl_chat.id,tbl_chat.dis_id,tbl_chat.part,tbl_discussion.dis_title
		// from tbl_chat inner join tbl_discussion on tbl_discussion.dis_id =
		// tbl_chat.dis_id where part = 'sherryyang12321@gmail.com' group by
		// tbl_chat.dis_id"
		String query = "Select (select COUNT(*) FROM tbl_chat where part = '" + user + "' and isByCreator = '"
				+ isCreator
				+ "' and isSeen = 0 and tbl_chat.dis_id = tbl_discussion.dis_id) as isSeen,tbl_chat.dis_id,tbl_chat.isSeen,tbl_chat.part,tbl_discussion.dis_title from tbl_chat inner join tbl_discussion on tbl_chat.dis_id = tbl_discussion.dis_id where part = '"
				+ user + "' group by tbl_chat.dis_id";

		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();

		return returnResult;
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

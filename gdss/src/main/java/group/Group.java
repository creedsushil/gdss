package group;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
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
import org.json.JSONObject;

import converter.ResultSetConverter;

/**
 * Servlet implementation class Group
 */
public class Group extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DataSource pool;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Group() {
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

	public Connection establishConnection() throws SQLException {
		return pool.getConnection();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String pageData = (String) request.getParameter("page");
		Subject currentUser = SecurityUtils.getSubject();
		request.setAttribute("userName", currentUser.getPrincipal());
		if (pageData.equals("createGroup")) {
			createGroup(request, response);
		} else if (pageData.equals("updateGroup")) {
			updateGroup(request, response);
		}else if (pageData.equals("search")) {
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			out.print(searchEmail(request, response));
			out.flush();
		} else if (pageData.equals("groupWithId")) {
			groupWithId(request, response);
		} else if(pageData.equals("countVote")){
			try {
				countVote(request,response);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else {
			try {
				getGroupList(request, response);
			} catch (SQLException e) {
				e.printStackTrace();
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
		doGet(request, response);
	}

	public void getGroupList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, SQLException {
		request.setAttribute("currentGroup", getAllGroup(request, response));
		getServletContext().getRequestDispatcher("/view/group.jsp").forward(request, response);
	}

	public void createGroup(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if ((String) request.getParameter("title") != null) {
			boolean saved = saveGroup(request, response);
			if (saved) {
				PrintWriter out = response.getWriter();
				out.print("success");
			} else {
				// request.setAttribute("errorMessage", "Cannot create
				// group!!");
				PrintWriter out = response.getWriter();
				out.print("Cannot Create Group!!");
			}
		} else {
			request.setAttribute("create", true);
			getServletContext().getRequestDispatcher("/view/createGroup.jsp").forward(request, response);
		}

	}
	
	public void updateGroup(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
			boolean saved = updateAndSaveGroup(request, response);
			if (saved) {
				PrintWriter out = response.getWriter();
				out.print("success");
			} else {
				// request.setAttribute("errorMessage", "Cannot create
				// group!!");
				PrintWriter out = response.getWriter();
				out.print("Cannot Create Group!!");
			}
		
	}

	public void groupWithId(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet result = null;
		JSONArray returnResult = null;
		int userId = 0;
		int creatorId = 0;
		Object date=null;
		try {
			// Get a connection from the pool
			conn = establishConnection();
			String query = "Select * from tbl_discussion where dis_id="
					+ Integer.parseInt((String) request.getParameter("id"));

			stmt = conn.createStatement();
			result = stmt.executeQuery(query);
		} catch (SQLException ex) {
			request.setAttribute("errorMessage", "Something went wrong!!!!");
			// ex.printStackTrace();
		} finally {
			try {
				returnResult = ResultSetConverter.convert(result);
				userId = searchUserByUserName().getJSONObject(0).getInt("id");
				int voteType = checkVote(Integer.parseInt((String) request.getParameter("id")),userId);
				if (returnResult != null) {
					for (int i = 0; i < returnResult.length(); i++) {
						JSONObject rec = returnResult.getJSONObject(i);
						request.setAttribute("title", rec.get("dis_title"));
						request.setAttribute("description", rec.get("dis_descreption"));
						//request.setAttribute("endTime", rec.get("dis_endDate"));
						date = rec.get("dis_endDate");
						request.setAttribute("id", rec.get("dis_id"));
						creatorId = rec.getInt("creator_id");
					}
				}
				request.setAttribute("voteType", voteType);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JSONException e) {
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
		if(userId == creatorId){
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
	        request.setAttribute("endTime", simpleDateFormat.format(date));	       
			request.setAttribute("edit", true);
			getServletContext().getRequestDispatcher("/view/editDiscussion.jsp").forward(request, response);	
		}
		else{
			request.setAttribute("endTime", date);
			getServletContext().getRequestDispatcher("/view/displayGroup.jsp").forward(request, response);
		}
		// return returnResult;
		
	}

	public JSONArray searchEmail(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet result = null;
		JSONArray returnResult = null;
		try {
			// Get a connection from the pool
			conn = establishConnection();

			// Normal JBDC programming hereafter. Close the Connection to return
			// it to the pool
			// System.out.println((String)request.getParameter("q"));
			String query = "Select id,email from tbl_user where email like '" + (String) request.getParameter("q")
					+ "%'";

			stmt = conn.createStatement();
			result = stmt.executeQuery(query);
		} catch (SQLException ex) {
			request.setAttribute("errorMessage", "Something went wrong!!!!");
			// ex.printStackTrace();
		} finally {
			try {
				returnResult = ResultSetConverter.convert(result);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JSONException e) {
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
		if (returnResult.length() < 1 && ((String) request.getParameter("q")).contains("@")) {
			JSONObject obj = new JSONObject();
			obj.put("id", 0);
			obj.put("email", (String) request.getParameter("q"));
			returnResult.put(0, obj);
		}
		return returnResult;
	}

	public boolean saveGroup(HttpServletRequest request, HttpServletResponse response) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		Timestamp endDate = null;
		try {
			endDate = new java.sql.Timestamp((formatter.parse((String) request.getParameter("endTime"))).getTime());
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int groupId = 0;
		Connection conn = null;
		Statement stmt = null;
		int result = 0;
		try {
			conn = establishConnection();
			int creatorId = 0;
			creatorId = searchUserByUserName().getJSONObject(0).getInt("id");

			String query = "insert into tbl_discussion(creator_id,dis_title,dis_descreption,dis_endDate) values ("
					+ creatorId + ",'" + (String) request.getParameter("title") + "','"
					+ (String) request.getParameter("description") + "','" + endDate + "')";
			stmt = conn.createStatement();
			result = stmt.executeUpdate(query, Statement.RETURN_GENERATED_KEYS);
			ResultSet rs = stmt.getGeneratedKeys();
			if (rs.next()) {
				groupId = rs.getInt(1);
			}
			Statement partStmt = null;
			if (groupId > 0) {
				String participants[] = null;
				if (((String) request.getParameter("participants")).contains(",")) {
					participants = ((String) request.getParameter("participants")).split(",");
				} else {
					participants = new String[1];
					participants[0] =(String) request.getParameter("participants");
				}
				for (String participant : participants) {
					Connection connStmt = establishConnection();
					String queryParticipants = "insert into tbl_participants(groupId,participant) values(" + groupId
							+ ",'" + participant + "')";
					try {
						partStmt = connStmt.createStatement();
						result = partStmt.executeUpdate(queryParticipants);
						if(result>0){
							sendEmailToParticipants(participant,request);
						}
					} catch (SQLException ex) {
						request.setAttribute("errorMessage", "Something went wrong!!!!");
					} finally {
						try {
							if (partStmt != null)
								partStmt.close();
							if (conn != null)
								connStmt.close(); // return to pool
						} catch (SQLException ex) {
							ex.printStackTrace();
						}
					}
				}

			}
		} catch (SQLException ex) {
			request.setAttribute("errorMessage", "Something went wrong!!!!");
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
		return groupId > 0;
	}

	public boolean updateAndSaveGroup(HttpServletRequest request, HttpServletResponse response) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		Timestamp endDate = null;
		try {
			endDate = new java.sql.Timestamp((formatter.parse((String) request.getParameter("endTime"))).getTime());
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int groupId = 0;
		Connection conn = null;
		Statement stmt = null;
		int result = 0;
		try {
			conn = establishConnection();
			int creatorId = 0;
			creatorId = searchUserByUserName().getJSONObject(0).getInt("id");

			String query = "update tbl_discussion set dis_title = '" + (String) request.getParameter("title") + "', dis_descreption ='"
					+ (String) request.getParameter("description") + "', dis_endDate = '" + endDate + "' where dis_id = "+Integer.parseInt(request.getParameter("id"));
			
			
			stmt = conn.createStatement();
			result = stmt.executeUpdate(query);
		} catch (SQLException ex) {
			request.setAttribute("errorMessage", "Something went wrong!!!!");
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
		return result>0;
	}
	
	public JSONArray getAllGroup(HttpServletRequest request, HttpServletResponse response) throws SQLException {
		String email = null;
		try {
			email = searchUserByUserName().getJSONObject(0).getString("email");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		Connection conn = null;
		Statement stmt = null;
		JSONArray rs = null;
		conn = pool.getConnection();
		String query = "SELECT * FROM tbl_discussion d INNER JOIN tbl_participants p on p.groupId = d.dis_id where p.participant = '"
				+ email + "'";
		stmt = conn.createStatement();
		ResultSet result = stmt.executeQuery(query);
		rs = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();
		return rs;
	}

	public JSONArray searchUserByUserName() throws SQLException {
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

	public void countVote(HttpServletRequest request,HttpServletResponse response) throws SQLException, IOException{
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select count(id) as voteCount,vote_type from tbl_vote where dis_id = '" + Integer.parseInt(request.getParameter("id")) + "' group by vote_type";
		ResultSet result = stmt.executeQuery(query);
		JSONArray returnResult = ResultSetConverter.convert(result);
		stmt.close();
		conn.close();
		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.print(returnResult);
		out.flush();

	}
	
	public int checkVote(int disId,int userId) throws SQLException{
		Connection conn = pool.getConnection();
		Statement stmt = conn.createStatement();
		String query = "Select * from tbl_vote where dis_id = '" + disId + "' and userId="+userId;
		ResultSet result = stmt.executeQuery(query);
		int voteType = 0;
		if(result.next()) voteType = result.getInt("vote_type");
		stmt.close();
		conn.close();
		return voteType;
	}

	public void sendEmailToParticipants(String participant,HttpServletRequest request){
			final String username = "creedsushil2@gmail.com";
			final String password = "webdesign@123";
			Properties props = new Properties();
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.starttls.enable", "true");
			props.put("mail.smtp.host", "smtp.gmail.com");
			props.put("mail.smtp.port", "587");
			Session session = Session.getInstance(props, new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username, password);
				}
			});
			try {

				Message message = new MimeMessage(session);
				message.setFrom(new InternetAddress("creedsushil2@gmail.com"));
				message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(participant));
				message.setSubject("You are added to the disscussion in GDSS");
				message.setText("Please click the link below:\n\n" + request.getRequestURL());

				Transport.send(message);

			} catch (MessagingException e) {
				throw new RuntimeException(e);
			}
			
	}
	
}

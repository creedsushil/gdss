package recovery;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import java.util.Properties;
import java.util.Random;
import java.util.UUID;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.naming.InitialContext;
import javax.naming.NamingException;

/**
 * Servlet implementation class PasswordRecovery
 */
public class PasswordRecovery extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DataSource pool;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public PasswordRecovery() {
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
		// TODO Auto-generated method stub
		if ((String) request.getParameter("token") != null) {
			if ((String) request.getParameter("password") != null) {
				boolean recovered = recoverPassword(request);
				if (recovered)
					getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
				else {
					request.setAttribute("errorMessage", "Please try again!!!");
					getServletContext().getRequestDispatcher("/passwordRecovery.jsp").forward(request, response);
				}

			} else {
				request.setAttribute("token", (String) request.getParameter("token"));
				getServletContext().getRequestDispatcher("/passwordRecovery.jsp").forward(request, response);
			}

		} else {
			String email = (String) request.getParameter("email");
			int userId = findUserByEmail(email, request);
			if (userId > 0) {
				boolean mailSent = sendMail(email,
						request/* (String)request.getAttribute("token") */);
				if (mailSent == false) {
					request.setAttribute("errorMessage", "Email couldn't be sent!!");
					request.setAttribute("passRecovery", true);
					getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
				} else {
					getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
				}
			} else {
				request.setAttribute("passRecovery", true);
				getServletContext().getRequestDispatcher("/login.jsp").forward(request, response);
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

	protected boolean sendMail(String email,
			HttpServletRequest request/* String token */) {
		final String username = "creedsushil2@gmail.com";
		final String password = "webdesign@123";
		boolean mailSent = false;
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
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
			message.setSubject("Password Recovery form GDSS");
			message.setText("Please click the link below:\n\n" + request.getRequestURL() + "?token="
					+ (String) request.getAttribute("token"));

			Transport.send(message);
			mailSent = true;

		} catch (MessagingException e) {
			mailSent = false;
			throw new RuntimeException(e);
		}

		return mailSent;
	}

	public int findUserByEmail(String email, HttpServletRequest request) {
		Connection conn = null;
		Statement stmt = null;
		Statement tokenStmt = null;
		ResultSet result = null;
		int userId = 0;
		try {
			// Get a connection from the pool
			conn = pool.getConnection();

			// Normal JBDC programming hereafter. Close the Connection to return
			// it to the pool
			String query = "select id from tbl_user where email='" + email + "'";

			stmt = conn.createStatement();
			result = stmt.executeQuery(query);

			try {
				if (result.next()) {
					userId = result.getInt(1);
				} else {
					request.setAttribute("errorMessage", "Email doesn't match to the record!!");
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				request.setAttribute("errorMessage", "Email doesn't match to the record!!");
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

		boolean tokenCreated = false;
		if (result == null) {
			request.setAttribute("errorMessage", "Couldn't connect to Server!!!");
		} else {
			String token = UUID.randomUUID().toString();
			request.setAttribute("token", token);

			String tokenQuerry = "insert into tbl_passwordrecovery(token,userId) values('" + token + "'," + userId
					+ ")";
			try {
				conn = pool.getConnection();
				tokenStmt = conn.createStatement();
				tokenCreated = tokenStmt.executeUpdate(tokenQuerry) > 0;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		return tokenCreated ? userId : 0;
	}

	public boolean recoverPassword(HttpServletRequest request) {
		Connection conn = null;
		Statement stmt = null;
		boolean result = false;
		try {
			// Get a connection from the pool
			conn = pool.getConnection();

			String query = "update tbl_user inner JOIN tbl_passwordrecovery ON tbl_passwordrecovery.userId = tbl_user.id set password='"
					+ (String) request.getParameter("password") + "' where tbl_passwordrecovery.token = '"
					+ (String) request.getParameter("token") + "'";

			stmt = conn.createStatement();
			result = stmt.execute(query);
		} catch (SQLException ex) {
			request.setAttribute("errorMessage", "Something went wrong!!!!");
			// ex.printStackTrace();
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
}

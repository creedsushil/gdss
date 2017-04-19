package register;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import java.sql.Statement;

/**
 * Servlet implementation class Register
 */
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String userName;
	private String email;
	private String password;
	DataSource pool;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Register() {
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
		// response.getWriter().append("Served at:
		// ").append((String)request.getParameter("username"));
		// Allocate a output writer to write the response message into the
		// network socket

		boolean result = register(request);
		if (result) {
        	getServletContext().getRequestDispatcher("/login.jsp").forward(request,response);
		} else {
			request.setAttribute("register", true);
        	getServletContext().getRequestDispatcher("/login.jsp").forward(request,response);
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

	protected boolean register(HttpServletRequest request){
		Connection conn = null;
		Statement stmt = null;
		boolean result = false;
		try {
			// Get a connection from the pool
			conn = pool.getConnection();

			// Normal JBDC programming hereafter. Close the Connection to return
			// it to the pool
			String query = "INSERT INTO tbl_user(email,userName,password) values('"
					+ (String) request.getParameter("email") + "','" + (String) request.getParameter("username") + "','"
					+ (String) request.getParameter("password") + "')";

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

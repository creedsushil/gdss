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

import converter.ResultSetConverter;

/**
 * Servlet implementation class Comment
 */
public class Comment extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DiscussionMethods dm;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Comment() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public void init() throws ServletException {
		dm = new DiscussionMethods();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		if (((String) request.getParameter("action")).equals("updateComment")) {
			JSONArray comments = dm.getComments(request);
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			out.print(comments);
			out.flush();
		} else if (((String) request.getParameter("action")).equals("vote")) {
			try {
				boolean voted = dm.vote(request);
				response.setContentType("application/json");
				PrintWriter out = response.getWriter();
				out.print(voted);
				out.flush();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			boolean commentAdded = dm.addComment(request);
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			out.print(commentAdded);
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
}

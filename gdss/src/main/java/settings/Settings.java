package settings;

import java.io.IOException;
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
import org.json.JSONObject;

import converter.ResultSetConverter;

/**
 * Servlet implementation class Settings
 */
public class Settings extends HttpServlet {
	private static final long serialVersionUID = 1L;
	DataSource pool;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Settings() {
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
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if((String)request.getParameter("password")!=null){
			boolean updated = updateSetting(request);
			request.setAttribute("message", "Settings updated successfully!");
		}
		JSONArray settings = null;
		try {
			settings = getSettings();
			for (int i = 0; i < settings.length(); ++i) {
			    JSONObject rec = settings.getJSONObject(i);
			    request.setAttribute("username", rec.getString("userName"));
			    request.setAttribute("email", rec.getString("email"));
			    request.setAttribute("password", rec.getString("password"));
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		getServletContext().getRequestDispatcher("/view/settings.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	public JSONArray getSettings() throws JSONException, SQLException{
		Connection conn = null;
		Statement stmt = null;
		ResultSet result = null;
		JSONArray settings = null;
		try {
			// Get a connection from the pool
			conn = pool.getConnection();
			Subject currentUser = SecurityUtils.getSubject();
			// Normal JBDC programming hereafter. Close the Connection to return
			// it to the pool
			String query = "Select * from tbl_user where userName='"+currentUser.getPrincipal()+"'";

			stmt = conn.createStatement();
			result = stmt.executeQuery(query);
		} catch (SQLException ex) {
			//request.setAttribute("errorMessage", "Something went wrong!!!!");
			 ex.printStackTrace();
		} finally {
			settings = ResultSetConverter.convert(result);
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close(); // return to pool
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
		return settings;
	}
	
	public boolean updateSetting(HttpServletRequest request){
		Connection conn = null;
		Statement stmt = null;
		int result = 0;
		try {
			// Get a connection from the pool
			conn = pool.getConnection();
			Subject currentUser = SecurityUtils.getSubject();
			// Normal JBDC programming hereafter. Close the Connection to return
			// it to the pool
			String query = "update tbl_user set password='"+(String)request.getParameter("password")+"' where username='"+currentUser.getPrincipal()+"'";

			stmt = conn.createStatement();
			result = stmt.executeUpdate(query);
		} catch (SQLException ex) {
			//request.setAttribute("errorMessage", "Something went wrong!!!!");
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
		return result==1?true:false;
	}
	
}

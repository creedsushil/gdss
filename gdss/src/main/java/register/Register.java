package register;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import java.sql.Statement;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

/**
 * Servlet implementation class Register
 */
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DATA_DIRECTORY = "image";
    private static final int MAX_MEMORY_SIZE = 1024 * 1024 * 2;
    private static final int MAX_REQUEST_SIZE = 1024 * 1024;
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
		String filePathSaved = null;
		String email = null;
		String username = null;
		String password = null;
		String imagePath = null;
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);

        // Create a factory for disk-based file items
        DiskFileItemFactory factory = new DiskFileItemFactory();

        // Sets the size threshold beyond which files are written directly to
        // disk.
        factory.setSizeThreshold(MAX_MEMORY_SIZE);

        // Sets the directory used to temporarily store files that are larger
        // than the configured size threshold. We use temporary directory for
        // java
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

        // constructs the folder where uploaded file will be stored
        ServletContext context = getServletContext();
        String uploadFolder = getServletContext().getRealPath("")
                + File.separator + DATA_DIRECTORY;
        // Create a new file upload handler
        ServletFileUpload upload = new ServletFileUpload(factory);
        // Set overall request size constraint
        upload.setSizeMax(MAX_REQUEST_SIZE);

        try {
            // Parse the request
            List items = upload.parseRequest(request);
            Iterator iter = items.iterator();
            while (iter.hasNext()) {
                FileItem item = (FileItem) iter.next();
                if(item.getFieldName().equals("email")){
                	email = item.getString();
                }else if(item.getFieldName().equals("password")){
                	password = item.getString();
                }else if(item.getFieldName().equals("username")){
                	username = item.getString();
                }
                
                if (!item.isFormField()) {
                    String fileName = new File(UUID.randomUUID().toString()+"_"+item.getName()).getName();
                    String filePath = uploadFolder + File.separator + fileName;
                    File uploadedFile = new File(filePath);
                    //System.out.println(uploadedFile);
                    // saves the file to upload directory
                    imagePath = filePath;
                    filePathSaved = filePath;
                    item.write(uploadedFile);
                }
            }

            // displays done.jsp page after upload finished
           /* getServletContext().getRequestDispatcher("/done.jsp").forward(
                    request, response);*/

        } catch (FileUploadException ex) {
            throw new ServletException(ex);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
		boolean result = register(email,password,username,imagePath);
		if (result) {
        	getServletContext().getRequestDispatcher("/login.jsp").forward(request,response);
		} else {
			request.setAttribute("errorMessage", "Something went wrong!!!");
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

	protected boolean register(String email,String password,String username,String imagePath){
		Connection conn = null;
		Statement stmt = null;
		int result = 0;
		try {
			// Get a connection from the pool
			conn = pool.getConnection();

			// Normal JBDC programming hereafter. Close the Connection to return
			// it to the pool
			String query = "INSERT INTO tbl_user(email,userName,password,imagePath) values('"
					+ email + "','" + username + "','"
					+ password + "','"+imagePath+"')";

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

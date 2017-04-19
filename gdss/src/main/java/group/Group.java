package group;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Group
 */
public class Group extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Group() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
        //getServletContext().getRequestDispatcher("/view/group.jsp").forward(request,response);
		String pageData= (String)request.getParameter("page");
		if(pageData.equals("createGroup")){
			createGroup(request, response);
		}else{
			getGroupList(request,response);	
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	public void getGroupList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		getServletContext().getRequestDispatcher("/view/group.jsp").forward(request,response);
	}
	
	public void createGroup(HttpServletRequest request, HttpServletResponse response) throws ServletException,IOException{
		getServletContext().getRequestDispatcher("/view/createGroup.jsp").forward(request,response);
	}
	
}

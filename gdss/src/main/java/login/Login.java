package login;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.config.IniSecurityManagerFactory;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.util.Factory;

/**
 * Servlet implementation class Classes
 */
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:shiro.ini");

        //2.
        SecurityManager securityManager = factory.getInstance();

        //3.
        SecurityUtils.setSecurityManager(securityManager);
		//SecurityUtils.setSecurityManager(sm);
        Subject currentUser = SecurityUtils.getSubject();
        if ( !currentUser.isAuthenticated() ) {
            //collect user principals and credentials in a gui specific manner
            //such as username/password html form, X509 certificate, OpenID, etc.
            //We'll use the username/password example here since it is the most common.
            UsernamePasswordToken token = new UsernamePasswordToken(request.getParameter("username"), request.getParameter("password"));
            //this is all you have to do to support 'remember me' (no config - built in!):
            token.setRememberMe(false);
            try {
                currentUser.login( token );
                //if no exception, that's it, we're done!
            } catch ( UnknownAccountException uae ) {
                //username wasn't in the system, show them an error message?
            	/*request.setAttribute("errorMessage", "User Name you provided is Invalid!");
            	request.getHeader("Referer");*/
            	request.setAttribute("errorMessage", "Invalid User Name");
            } catch ( IncorrectCredentialsException ice ) {
                //password didn't match, try again?
            	request.setAttribute("errorMessage", "Invalid Password");

            } catch ( LockedAccountException lae ) {
                //account for that username is locked - can't login.  Show them a message?
            } catch (AuthenticationException ae){
            	//unknown error
            	request.setAttribute("errorMessage", "Something went worng");

            } 
        }
        //System.out.println(request.getAttribute("errorMessage"));
        if(currentUser.isAuthenticated()){
        	//request.setAttribute("userName", currentUser.getPrincipal());
            //getServletContext().getRequestDispatcher("/welcome.jsp").forward(request,response);
        	response.sendRedirect("index");
            }else{
            	//request.setAttribute("register", false);
            	getServletContext().getRequestDispatcher("/login.jsp").forward(request,response);
        }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}

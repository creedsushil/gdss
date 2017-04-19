package security;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

/**
 * Servlet Filter implementation class SecurityCheck
 */
public class SecurityCheck implements Filter {

	/**
	 * Default constructor.
	 */
	public SecurityCheck() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		// TODO Auto-generated method stub
		// place your code here

		// pass the request along the filter chain
		String url = "";
		if (request instanceof HttpServletRequest) {
			url = ((HttpServletRequest) request).getServletPath().toString();
		}
		Subject currentUser = SecurityUtils.getSubject();
		if (!(url.contains("/resource") || url.contains("/Register") || url.contains("/PasswordRecovery"))) {
			if (!url.contains("/login")) {
				if (!currentUser.isAuthenticated()) {
					request.setAttribute("errorMessage", "Please Log in!!");
					RequestDispatcher rdp = request.getRequestDispatcher("/login.jsp");
					rdp.forward(request, response);
					return;
				}
			} else {
				if (currentUser.isAuthenticated()) {
					RequestDispatcher rdp = request.getRequestDispatcher("/index");
					rdp.forward(request, response);
					return;
				}
			}
		}
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}

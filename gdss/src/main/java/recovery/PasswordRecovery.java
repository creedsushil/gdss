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
	PassRecoveryMethods prm;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public PasswordRecovery() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public void init() throws ServletException {
		prm = new PassRecoveryMethods();
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
				boolean recovered = prm.recoverPassword(request);
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
			int userId = prm.findUserByEmail(email, request);
			if (userId > 0) {
				boolean mailSent = prm.sendMail(email,
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
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dao.BusinessDAO;
import dao.CustomerDAO;
import dto.Account;
import dto.Business;
import dto.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("ACCOUNT") != null) {
            request.getRequestDispatcher("MainController?action=dashboard").forward(request, response);
            return;
        }

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getFullAccountByEmail(email);

        if (account == null) {
            request.setAttribute("error", "Email is not exist!");
            request.getRequestDispatcher("MainController?action=home").forward(request, response);
            return;
        }

        if (!account.getPassword().equals(password)) {
            request.setAttribute("error", "Password is incorrect!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("MainController?action=home").forward(request, response);
            return;
        }

        // check status tài khoản 
        String status = account.isStatus();
        if ("Pending".equalsIgnoreCase(status)) {
            request.setAttribute("error", "Account is pending...");
            request.setAttribute("email", email);
            request.getRequestDispatcher("MainController?action=home").forward(request, response);
            return;
        }

        // otp: Chặn Frozen
        // if ("Frozen".equalsIgnoreCase(status)) 
        // update thời gian đăng nhập
        accountDAO.updateLastLogin(account.getAccountID());

        // Lưu account vào session
        HttpSession session = request.getSession();
        session.setAttribute("ACCOUNT", account);

        // Phân luồng theo role
        int roleID = account.getRoleID();

        if (roleID == 1) {
            // Admin
            request.getRequestDispatcher("AdminDashboardController").forward(request, response);
            return;
        }

        // Kiểm tra Business
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());
        BusinessDAO businessDAO = new BusinessDAO();
        Business business = businessDAO.getBussinessByID(customer.getCusID());
        request.getSession().setAttribute("BUS", business);
        if (business != null) {
            request.getRequestDispatcher("BusinessDashboardController")
                    .forward(request, response);
            return;
        }
        request.getRequestDispatcher("CustomerDashBoardController")
                .forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

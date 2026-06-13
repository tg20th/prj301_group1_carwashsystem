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

<<<<<<< Updated upstream
        if (roleID == 1) {
            // Admin
            request.getRequestDispatcher("AdminDashboardController").forward(request, response);
            return;
        }
=======
<<<<<<< Updated upstream
        // THÊM ĐOẠN PHÂN QUYỀN NÀY VÀO:
        if (account.getRoleID() == 1) {
            // 1 là Admin
            request.getRequestDispatcher("admin_dashbroad.jsp").forward(request, response);
        } else if (account.getRoleID() == 3) {
            // 3 là Doanh Nghiệp -> Đẩy về trang Business
            response.sendRedirect("MainController?action=BusinessDashboard");
        } else {
            // Mặc định (2) là Khách hàng cá nhân
            request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
        }
=======
        if (roleID == 1) {
            // Admin
            request.getRequestDispatcher("MainController?action=dashboard").forward(request, response);
            return;
        }
>>>>>>> Stashed changes

        // Kiểm tra Business
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());

        if (customer != null) {
            BusinessDAO businessDAO = new BusinessDAO();
<<<<<<< Updated upstream
            Business business = businessDAO.getBussinessByID(String.valueOf(customer.getCusID()));
            if (business != null) {
                // forward ve trang cua busi
                request.getRequestDispatcher("BusinessDashboardController").forward(request, response);
                return;
            }
        }

        request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
=======
            Business business = businessDAO.getBussinessByID(customer.getCusID());
            if (business != null) {
                // forward ve trang cua busi
                request.getRequestDispatcher("MainController?action=dashboard").forward(request, response);
                return;
            } //
        }

        request.getRequestDispatcher("MainController?action=dashboard").forward(request, response);
>>>>>>> Stashed changes
>>>>>>> Stashed changes
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

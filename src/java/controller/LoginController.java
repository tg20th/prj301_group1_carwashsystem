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
            // Sử dụng sendRedirect thay vì getRequestDispatcher với query string (tránh lỗi 500)
            response.sendRedirect("MainController?action=dashboard");
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
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        if (!account.getPassword().equals(password)) {
            request.setAttribute("error", "Password is incorrect!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }


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
        
        //tung: 14/6 check status tài khoản 
        String status = account.getStatus();
        if ("Rejected".equalsIgnoreCase(status)) {
            // Bắn thẳng đến trang pending thay vì qua MainController (tránh lỗi getRequestDispatcher sai cú pháp)
            request.getRequestDispatcher("ResubmitRegistController").forward(request, response);
            return;
        } else if ("Pending".equalsIgnoreCase(status)) {
            // TODO: replace with direct forward to ResubmitRegistController once implemented
            request.setAttribute("error", "Your business registration is pending approval. Please wait for admin review.");
            request.getRequestDispatcher("pending_page.jsp").forward(request, response);
            return;
        }

        // Kiểm tra an toàn trước khi lấy dữ liệu Customer
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());

        if (customer != null) {
            BusinessDAO businessDAO = new BusinessDAO();
            Business business = businessDAO.getBussinessByCusID(customer.getCusID());

            if (business != null) {
                request.getSession().setAttribute("BUS", business);
                request.getRequestDispatcher("BusinessDashboardController").forward(request, response);
                return;
            }
            // Nếu có customer nhưng không có business -> Đi tới Customer Dashboard
            request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
            return;
        }

        // Trường hợp tài khoản hợp lệ nhưng không tìm thấy data Customer trong DB
        request.setAttribute("error", "Your profile is incomplete. Please contact support.");
        request.getRequestDispatcher("index.jsp").forward(request, response);

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

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dto.Account;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lan
 */
@WebServlet(name = "SaveAccountController", urlPatterns = {"/SaveAccountController"})
public class SaveAccountController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            Account a = (Account) request.getSession().getAttribute("ACCOUNT");
            if (a == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }

            //lay thong tin nguoi dung 
            int accID = a.getAccountID();
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            
            String currentpassword = request.getParameter("currentPassword");
            String flag = request.getParameter("changePasswordToggle");
            

            String msg = "";
            if (firstName.length() == 0 || lastName.length() == 0) {
                msg = "The name cannot be left blank. Please try again!";
                showError(request, response, msg);
                return;
            }
            
            //kiem tra mk hien tai co chinh xac khong
            if(!a.getPassword().equals(currentpassword)) {
                msg = "Wrong password! Cannot verify account changes.";
                showError(request, response, msg);
                return;
            }
            
            //lay mk hien tai
            String password = a.getPassword();
            
            //kiem tra co thay doi mk khong
            if(flag != null && "on".equals(flag)) {
                password = request.getParameter("password");          
            }

            AccountDAO d = new AccountDAO();

            //kiem tra email nay co ton tai hay chua
            Account findEmail = d.getAccountByEmail(email);
            if (findEmail != null && findEmail.getAccountID() != accID) {
                msg = "Email already exists!";
                showError(request, response, msg);
                return;
            }

            //kiem tra phone co ton tai hay khong
            Account findPhone = d.getAccountByPhone(phone);
            if (findPhone != null && findPhone.getAccountID() != accID) {
                msg = "Phone already exists!";
                showError(request, response, msg);
                return;
            }

            int result = 0;
            result = d.updateAccount(accID, firstName, lastName, email, phone, password);

            //kiem tra account da duoc update trong DB chua
            if (result < 1) {
                msg = "Update fail. Please try again!";
                showError(request, response, msg);
                return;
            }

            Account updatedAccount = d.getAccountByEmail(email);
            request.getSession().setAttribute("ACCOUNT", updatedAccount);

            // Tạo thông báo thành công gửi sang JSP hiển thị
            msg = "Update successfully!";
            request.setAttribute("success", msg);
            request.getRequestDispatcher("edit_customer.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.setAttribute("error", "System error occurred while saving account: " + e.getMessage());
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void showError(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {

        request.setAttribute("error", msg);
        request.getRequestDispatcher("edit_customer.jsp").forward(request, response);
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

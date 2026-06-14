package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dto.Account;
import dto.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterController", urlPatterns = {"/RegisterController"})
public class RegisterController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //lay noi dung nguoi dung da nhap

        String firstName = request.getParameter("firstName").trim();
        String lastName = request.getParameter("lastName").trim();
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        //Tao bien in ra thong bao
        String msg = "";
        //kiem tra ten co bi trong hay khong
        if(firstName.length() == 0 || lastName.length() == 0) {
            msg = "The name cannot be left blank. Please try again!";
            showError(request, response, msg);
            return;
        }
        
        //tao ra account
        Account a = new Account(firstName, lastName, password, phone, email);
        AccountDAO d = new AccountDAO();

        //kiem tra email nay co ton tai hay chua
        Account findEmail = d.getAccountByEmail(email);
        if (findEmail != null) {
            msg = "Email already exists!";
            showError(request, response, msg);
            return;
        }

        //kiem tra phone co ton tai hay khong
        Account findPhone = d.getAccountByPhone(phone);
        if (findPhone != null) {
            msg = "Phone already exists!";
            showError(request, response, msg);
            return;
        }

        //tao ra account moi
        int result = 0;
        result = d.createAccount(a);
        //kiem tra account co duoc tao ra hay chưa
        if (result < 1) {
            msg = "Failed to create account. Please try again.";
            showError(request, response, msg);
            return;
        }

        //lay account vua duoc tao ra trong DB
        Account createdAccount = d.getAccountByEmail(email);

        //tao ra mot customer moi dua tren account vua lay duoc
        Customer c = new Customer(createdAccount.getAccountID(), 1, createdAccount.getCreateAt(), 0);

        //them customer do vao DB
        CustomerDAO cd = new CustomerDAO();
        result = cd.createCustomer(c);

        //ktra customer 
        if (result < 1) {
            msg = "Account created but customer profile creation failed.";
            showError(request, response, msg);
            return;
        }

        msg = "Register successfully!";
        request.setAttribute("success", msg);
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    private void showError(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {

        request.setAttribute("error", msg);
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

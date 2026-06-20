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

/**
 *
 * @author Lan
 */
@WebServlet(name = "UpdateRegistrationController", urlPatterns = {"/UpdateRegistrationController"})
public class UpdateRegistrationController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account a = (Account) request.getSession().getAttribute("ACCOUNT");
        if (a == null) {
            request.getRequestDispatcher("MainController").forward(request, response);
            return;
        }

        //lay noi dung nguoi dung nhap (Bussiness)
        String busName = request.getParameter("businessName");
        String tax = request.getParameter("taxCode");
        String address = request.getParameter("companyAddress");

        //Tao bien in ra thong bao
        String msg = "";

        //lay doanh nghiep ra
        CustomerDAO cd = new CustomerDAO();
        Customer c = cd.getCustomerByAccountID(a.getAccountID());
        if (c == null) {
            showError(request, response, "Customer profile not found!", null);
            return;
        }

        BusinessDAO bd = new BusinessDAO();
        Business b = bd.getBussinessByCusID(c.getCusID());
        if (b == null) {
            showError(request, response, "Business profile not found!", null);
            return;
        }

        //Kiem tra ten cty co bi trung khong
        Business findName = bd.getBussinessByName(busName);
        if (findName != null && findName.getCusID() != c.getCusID()) {
            msg = "Company name already exists!";
            showError(request, response, msg, b);
            return;
        }

        Business findTax = bd.getBussinessByTax(tax);
        if (findTax != null && findTax.getCusID() != c.getCusID()) {
            msg = "Company tax already exists!";
            showError(request, response, msg, b);
            return;
        }

        int result = 0;
        result = bd.updateBussiness(c.getCusID(), busName, tax, address);

        if (result < 1) {
            msg = "Update Registration Fail. Please try again!";
            showError(request, response, msg, b);
            return;
        }

        //neu update thong tin cua business sau khi resubmit thanh cong
        AccountDAO ad = new AccountDAO();
        result = ad.updateStatusOfAccount(a.getAccountID(), "Pending", null);

        if (result < 1) {
            msg = "Update status of account fail. Please try again!";
            showError(request, response, msg, b);
            return;
        }

        request.setAttribute("business", b);
        request.setAttribute("success", "Update successfully! Please wait for admin confirmation.");
        request.getRequestDispatcher("resubmit_registration.jsp").forward(request, response);
    }

    private void showError(HttpServletRequest request, HttpServletResponse response, String msg, Business b)
            throws ServletException, IOException {

        request.setAttribute("error", msg);
        request.setAttribute("business", b);
        request.getRequestDispatcher("resubmit_registration.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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

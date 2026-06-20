/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dto.Account;
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
@WebServlet(name = "UserProcessController", urlPatterns = {"/UserProcessController"})
public class UserProcessController extends HttpServlet {

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
        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        
        if (account == null) {
            request.getRequestDispatcher("MainController").forward(request, response);
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("userId"));
        String action = request.getParameter("userAction");
        AccountDAO ad = new AccountDAO();
        int result = 0;
        
        if("freeze".equals(action)) {
            result = ad.updateStatusOfAccount(id, "Frozen", null);
            if (result < 1) {
                request.setAttribute("error", "Update status of account fail. Please try again!");
            } else {
                request.setAttribute("success", "Update successfully!");
            }
        } else if ("activate".equals(action)) {
            result = ad.updateStatusOfAccount(id, "Active", null);
            if (result < 1) {
                request.setAttribute("error", "Update status of account fail. Please try again!");
            } else {
                request.setAttribute("success", "Update successfully!");
            }
        }
        request.getRequestDispatcher("ManageUserController").forward(request, response);
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

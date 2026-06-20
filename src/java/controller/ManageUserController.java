/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dto.Account;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lan
 */
@WebServlet(name = "ManageUserController", urlPatterns = {"/ManageUserController"})
public class ManageUserController extends HttpServlet {

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
        
        Account acc = (Account) request.getSession().getAttribute("ACCOUNT");
        if (acc == null) {
            request.getRequestDispatcher("MainController").forward(request, response);
            return;
        }

        String search = request.getParameter("search");
        String userType = request.getParameter("userType");
        String status = request.getParameter("status");

        if (search == null) {
            search = "";
        }
        if (userType == null) {
            userType = "ALL";
        }
        if (status == null) {
            status = "ALL";
        }

        int page = 1;
        int pageSize = 10;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
        }

        AccountDAO a = new AccountDAO();

        // summary statistics
        int totalUsers = a.getAllUser().size();
        int totalUserActive = a.getUserByStatus("Active").size();
        int totalUserFrozen = a.getUserByStatus("Frozen").size();

        // FILTER + PAGING
        List<Account> list = a.filterUsers(status, userType, search, page, pageSize);
        

        int totalFilteredUsers = a.getTotalFilteredUsers(status, userType, search);
        int totalPages = (int) Math.ceil((double) totalFilteredUsers / pageSize);

        request.setAttribute("LISTOFUSER", list);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedUserType", userType);

        request.setAttribute("totalFilteredUsers", totalFilteredUsers);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeUsers", totalUserActive);
        request.setAttribute("frozenUsers", totalUserFrozen);

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);

        request.getRequestDispatcher("manage_user.jsp").forward(request, response);
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

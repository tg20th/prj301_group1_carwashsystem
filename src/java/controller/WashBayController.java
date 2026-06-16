/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.WashBayDAO;
import dto.Account;
import dto.WashBay;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
@WebServlet(name = "WashBayController", urlPatterns = {"/WashBayController"})
public class WashBayController extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("ACCOUNT") : null;

        // xu ly khi chua log
        if (account == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        //xu ly khi 0 phai ad
        if (account.getRoleID() != 1) {
            response.sendRedirect("error_page");
            return;
        }

        String action = request.getParameter("action");
        WashBayDAO wbDAO = new WashBayDAO();
        if (action == null) {
            action = "list";
        }

        if (action.equalsIgnoreCase("list")) {

            List<WashBay> wbList = wbDAO.getAllWashBays();
            request.setAttribute("WB_LIST", wbList);
            request.getRequestDispatcher("washbay-dashboard.jsp").forward(request, response);
            return;

        }//end if

        else if (action.equalsIgnoreCase("showEditDashboard")) {
            int wbID = Integer.parseInt(request.getParameter("washBayID"));

            WashBay wb = wbDAO.getWashBayByID(wbID);
            request.setAttribute("WB", wb);

            request.getRequestDispatcher("edit-washbay.jsp").forward(request, response);
            return;
        }//end if

        else if (action.equalsIgnoreCase("update")) {
            int id = Integer.parseInt(request.getParameter("washBayID"));
            String bayName = request.getParameter("bayName");
            String description = request.getParameter("description");
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));

            WashBay wb = new WashBay();
            wb.setWashBayID(id);
            wb.setBayName(bayName);
            wb.setDescription(description);
            wb.setIsActive(isActive);

            boolean result = wbDAO.updateWashBay(wb);

            if (result) {
                // Redirect back to list so the new modern page is shown
                response.sendRedirect("WashBayController?action=list");
                return;
            } else {
                request.setAttribute("ERROR", "Update failed!");
                request.setAttribute("WB", wb);
                request.getRequestDispatcher("edit-washbay.jsp").forward(request, response);
                return;
            }

        }

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

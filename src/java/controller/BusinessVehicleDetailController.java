/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.VehicleDAO;
import dto.Account;
import dto.Vehicle;
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
 * @author Minh Khanh
 */
@WebServlet(name = "BusinessVehicleDetailController", urlPatterns = {"/BusinessVehicleDetailController"})
public class BusinessVehicleDetailController extends HttpServlet {

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

        Account acc = (Account) request.getSession().getAttribute("ACCOUNT");
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            int cusID = Integer.parseInt(request.getParameter("customerID"));
            if (request.getAttribute("CUSID") != null) {
                cusID = Integer.parseInt(request.getAttribute("CUSID").toString());
            }
            if (cusID != 0) {
                VehicleDAO dao = new VehicleDAO();
                List<Vehicle> list = dao.getPendingVehiclesByBusiness(cusID);
                request.setAttribute("LIST", list);
                request.getRequestDispatcher("businessVehiclePopup.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.setAttribute("ERROR", "System error: " + e.getMessage());
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
                response.sendRedirect("adminDashboard.jsp");
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

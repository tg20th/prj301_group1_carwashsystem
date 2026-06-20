/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.VehicleDAO;
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
 * @author Minh Khanh
 */
@WebServlet(name = "ApproveVehicleController", urlPatterns = {"/ApproveVehicleController"})
public class ApproveVehicleController extends HttpServlet {

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
            response.sendRedirect("MainController?action=home");
            return;
        }
        try {
            int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
            VehicleDAO dao = new VehicleDAO();
            int result = dao.approveVehicle(vehicleID);
            if (result > 0) {
                request.setAttribute("SUCCESS", "Vehicle approved successfully.");
            } else {
                request.setAttribute("ERROR", "Cannot approve vehicle.");
            }
            String customerID = request.getParameter("customerID");
            if (customerID != null) {
                request.setAttribute("CUSID", customerID);
                request.getRequestDispatcher("BusinessVehicleDetailController").forward(request, response);
            } else {
                response.sendRedirect("VehicleRequestController");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "System error: " + e.getMessage());
            request.getRequestDispatcher("VehicleRequestController").forward(request, response);
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

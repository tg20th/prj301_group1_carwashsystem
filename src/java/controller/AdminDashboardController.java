/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.InvoiceDAO;
import dao.PromotionDAO;
import dao.ServicesDAO;
import dao.TierDAO;
import dao.VehicleDAO;
import dto.Account;
import dto.Booking;
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
@WebServlet(name = "AdminDashboardController", urlPatterns = {"/AdminDashboardController"})
public class AdminDashboardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
//        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
//        
//        if (account == null) {
//            request.getRequestDispatcher("index.jsp");
//            return;
//        }

        CustomerDAO c = new CustomerDAO();

        AccountDAO ad = new AccountDAO();
        
        VehicleDAO v = new VehicleDAO();

        InvoiceDAO i = new InvoiceDAO();
        
        TierDAO t = new TierDAO();
        
        ServicesDAO s = new ServicesDAO();
        
        PromotionDAO p = new PromotionDAO();
        
        BookingDAO b = new BookingDAO();
        
        int result = b.markNoShowBookings();
        result = p.autoUpdateStatus();

        request.setAttribute("TOTALCUSTOMER", c.getTotalCustomer());
        request.setAttribute("TOTALACCPENDING", ad.getTotalPendingAccount());
        request.setAttribute("TOTALVEHICLE", v.getTotalVehicle());
        request.setAttribute("TOTALVEHICLEPENDING", v.getTotalVehiclePending());
        request.setAttribute("REVENUEDAY", i.getTotalRevenueDay());
        request.setAttribute("REVENUEMONTH", i.getTotalRevenueMonth());
        request.setAttribute("LISTOFTIER", t.getAllTier());
        request.setAttribute("LISTSERVICES", s.getAllServices());
        request.setAttribute("LISTOFPROMOTION", p.getAllPromotionActive());
        request.setAttribute("LISTOFBOOKING", b.getAllBookToday());

        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
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

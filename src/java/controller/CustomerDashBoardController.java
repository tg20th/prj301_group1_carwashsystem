/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.PromotionDAO;
import service.InvoiceAutoCancelService;
import dao.RewardDAO;
import dao.TierDAO;
import dao.VehicleDAO;
import dto.Account;
import dto.Customer;
import dto.Reward;
import dto.Tier;
import dto.Vehicle;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author PC
 */
@WebServlet(name = "CustomerDashBoardController", urlPatterns = {"/CustomerDashBoardController"})
public class CustomerDashBoardController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Account account = (Account) request.getSession().getAttribute("ACCOUNT");

            if (account == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }

            new InvoiceAutoCancelService().cancelExpiredPendingInvoices();

            CustomerDAO cusDAO = new CustomerDAO();
            Customer customer = cusDAO.getCustomerByAccountID(account.getAccountID());
            int pointBalance = cusDAO.getPointBalance(account.getAccountID());
            if (customer == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Customer not found");
                return;
            }

            TierDAO tierDAO = new TierDAO();
            Tier customerTier = tierDAO.getTier(customer.getTierID());

            VehicleDAO vehicleDAO = new VehicleDAO();
            List<Vehicle> vehicleList = vehicleDAO.getVehiclesByCustomerID(customer.getCusID());

            RewardDAO rewardDAO = new RewardDAO();

            Reward nextReward = rewardDAO.getNextReward(pointBalance);

            BookingDAO bookingDAO = new BookingDAO();
            int activeBookingCount = bookingDAO.countActiveBookingsByCustomerId(customer.getCusID());

            PromotionDAO promoDAO = new PromotionDAO();
            request.setAttribute("PROMO_LIST", promoDAO.getApplicablePromotions(customer.getCusID(), customer.getTierID()));

            request.getSession().setAttribute("CUSTOMER", customer);
            request.setAttribute("ACCOUNT", account);
            request.setAttribute("CUSTOMER", customer);
            request.setAttribute("TIER", customerTier);
            request.setAttribute("VEHICLES", vehicleList);
            request.setAttribute("NEXTREWARD", nextReward);
            request.setAttribute("POINT_BALANCE", pointBalance);
            request.setAttribute("ACTIVE_BOOKING_COUNT", activeBookingCount);

            request.getRequestDispatcher("customer-dashboard.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.setAttribute("error", "Unable to load dashboard data: " + e.getMessage());
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
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
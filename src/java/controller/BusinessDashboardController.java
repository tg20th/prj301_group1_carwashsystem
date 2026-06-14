/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BusinessDAO;
import dao.CustomerDAO;
import dao.PromotionDAO;
import dao.RewardDAO;
import dao.TierDAO;
import dao.VehicleDAO;
import dto.Account;
import dto.Customer;
import dto.Vehicle;
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
 * @author Minh Khanh
 */
@WebServlet(name = "BusinessDashboardController", urlPatterns = {"/BusinessDashboardController"})
public class BusinessDashboardController extends HttpServlet {

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
        try {
            Account account = (Account) request.getSession().getAttribute("ACCOUNT");
            if (account == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }
            CustomerDAO cusDAO = new CustomerDAO();
            BusinessDAO bizDAO = new BusinessDAO();
            VehicleDAO vDao = new VehicleDAO();
            PromotionDAO promoDAO = new PromotionDAO();
            TierDAO tierDAO = new TierDAO();
            RewardDAO rewardDAO = new RewardDAO();
            
            Customer customer = cusDAO.getCustomerByAccountID(account.getAccountID());
            if (customer != null) {
                int pointBalance = cusDAO.getPointBalance(account.getAccountID());
                request.setAttribute("BUSINESS", bizDAO.getBussinessByCusID(customer.getCusID()));
                request.setAttribute("VEHICLE_LIST", vDao.getVehiclesByCustomerID(customer.getCusID()));
                request.setAttribute("PROMO_LIST", promoDAO.getApplicablePromotions(customer.getCusID(), customer.getTierID()));
                request.setAttribute("POINT_BALANCE", pointBalance);
                request.setAttribute("TIER", tierDAO.getTier(customer.getTierID()));
                request.setAttribute("NEXTREWARD", rewardDAO.getNextReward(pointBalance));
            } else {
                request.setAttribute("ERROR", "Customer information not found.");
            }
            request.getRequestDispatcher("businessDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "Unable to load dashboard data: " + e.getMessage());
            request.getRequestDispatcher("businessDashboard.jsp").forward(request, response);
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
<<<<<<< Updated upstream
=======
        HttpSession session = request.getSession(false);

        // chưa login
        if (session == null || session.getAttribute("ACCOUNT") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // không phải business
        if (session.getAttribute("BUS") == null) {
            response.sendRedirect("MainController?action=dashboard");
            return;
        }

        // đúng business account
>>>>>>> Stashed changes
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

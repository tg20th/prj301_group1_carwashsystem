/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.TierDAO;
import dto.Account;
import dto.Tier;
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
@WebServlet(name = "AddTierController", urlPatterns = {"/AddTierController"})
public class AddTierController extends HttpServlet {

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

        try {
            request.setCharacterEncoding("UTF-8");

            String name = request.getParameter("tierName").trim();
            String description = request.getParameter("description").trim();
            int minSpend = Integer.parseInt(request.getParameter("minSpend"));
            double pointRate = Double.parseDouble(request.getParameter("pointRate"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            if (name.isEmpty()) {
                showError(request, response, "Tier name cannot be empty");
                return;
            }

            TierDAO td = new TierDAO();
            List<Tier> list = td.getAllTier();

            int maxCurrent = getMinSpendMax(list);
            if (minSpend <= maxCurrent) {  
                showError(request, response, "MinSpend must be larger than current maximum (" + maxCurrent + ")");
                return;
            }
            
            double maxPoint = getPointRateMax(list);
            if(pointRate <= maxPoint) {
                showError(request, response, "PointRate must be larger than current maximum (" + maxPoint + ")");
                return;
            }

            Tier t = new Tier(name, minSpend, pointRate, description, status);
            int result = td.createTier(t);

            if (result > 0) {
                request.setAttribute("success", "Add tier successfully!");
                request.getRequestDispatcher("ManageTiersController").forward(request, response);
            } else {
                showError(request, response, "Add tier failed. Please try again!");
            }

        } catch (NumberFormatException e) {
            showError(request, response, "Invalid number format");
        } catch (Exception e) {
            e.printStackTrace();
            try {
                showError(request, response, "System error: " + e.getMessage());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    private void showError(HttpServletRequest request,
            HttpServletResponse response,
            String msg)
            throws ServletException, IOException {

        request.setAttribute("error", msg);

        TierDAO td = new TierDAO();
        request.setAttribute("LISTOFTIER", td.getAllTier());

        request.getRequestDispatcher("ManageTiersController")
                .forward(request, response);
    }

    private int getMinSpendMax(List<Tier> list) {
        int max = 0;
        for (int i = 0; i < list.size(); i++) {
            if (max < list.get(i).getMinSpend()) {
                max = list.get(i).getMinSpend();
            }
        }
        return max;
    }
    
    private double getPointRateMax(List<Tier> list) {
        double max = 0;
        for (int i = 0; i < list.size(); i++) {
            if (max < list.get(i).getPointRate()) {
                max = list.get(i).getPointRate();
            }
        }
        return max;
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

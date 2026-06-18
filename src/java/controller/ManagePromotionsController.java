/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.PromotionDAO;
import dto.Promotion;
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
@WebServlet(name = "ManagePromotionsController", urlPatterns = {"/ManagePromotionsController"})
public class ManagePromotionsController extends HttpServlet {

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
        
        PromotionDAO dao = new PromotionDAO();
        
        //kiem tra tu dong cac promotion het han
        int result = dao.autoUpdateStatus();
        
        String search = request.getParameter("search");
        String targetType = request.getParameter("targetType");
        String status = request.getParameter("status");
        String pageRaw = request.getParameter("page");
        

        if (status == null) status = "ALL";
        if (search == null) search = "";
        if (targetType == null) targetType = "ALL";

        int page = 1;
        int pageSize = 10;

        try {
            if (pageRaw != null) {
                page = Integer.parseInt(pageRaw);
            }
        } catch (Exception e) {
            page = 1;
        }

        if (page <= 0) page = 1;

        // ================= DATA LIST =================
        List<Promotion> list = dao.getAllPromotion(status, search, targetType, page, pageSize);

        // ================= TOTALS =================
        int totalPromo = dao.getTotalPromotion();
        int activePromo = dao.getTotalPromotionByStatus(true);
        int inactivePromo = dao.getTotalPromotionByStatus(false);

        int totalFiltered = dao.getTotalPromotion(status, search, targetType);

        int totalPages = (int) Math.ceil((double) totalFiltered / pageSize);

        if (totalPages == 0) totalPages = 1;

        
        request.setAttribute("LISTOFPROMOTION", list);

        request.setAttribute("TOTAL_PROMO", totalPromo);
        request.setAttribute("ACTIVE_PROMO", activePromo);
        request.setAttribute("EXPIRED_PROMO", inactivePromo);

        request.setAttribute("TOTAL_FILTERED", totalFiltered);

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("status", status);
        request.setAttribute("search", search);
        request.setAttribute("targetType", targetType);

        
        request.getRequestDispatcher("manage_promotions.jsp").forward(request, response);
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

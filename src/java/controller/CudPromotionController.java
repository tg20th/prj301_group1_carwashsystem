/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.PromotionDAO;
import dto.Promotion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CudPromotionController", urlPatterns = {"/CudPromotionController"})
public class CudPromotionController extends HttpServlet {

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
        response.sendRedirect("ManagePromotionsController");
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
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            try {
                String promoCode = request.getParameter("promoCode");
                String promoName = request.getParameter("promoName");
                String targetType = request.getParameter("targetType");
                String discountRaw = request.getParameter("discountPercent");
                String startDateRaw = request.getParameter("startDate");
                String endDateRaw = request.getParameter("endDate");
                String description = request.getParameter("description");

                if (promoCode == null || promoCode.trim().isEmpty()) {
                    backToList(request, response, null, "Promo code can not empty!");
                    return;
                }
                if (promoName == null || promoName.trim().isEmpty()) {
                    backToList(request, response, null, "Campaign name can not empty!");
                    return;
                }

                promoCode = promoCode.trim().toUpperCase();

                int discountPercent = Integer.parseInt(discountRaw);
                if (discountPercent < 1 || discountPercent > 100) {
                    backToList(request, response, null, "Discount must be between 1 and 100!");
                    return;
                }

                Date startDate = Date.valueOf(startDateRaw);
                Date endDate = Date.valueOf(endDateRaw);
                if (startDate.after(endDate)) {
                    backToList(request, response, null, "Start date must be before end date!");
                    return;
                }

                Integer tierId = null;
                if ("Tier".equalsIgnoreCase(targetType)) {
                    tierId = Integer.parseInt(request.getParameter("tierId"));
                    if (tierId <= 0) {
                        backToList(request, response, null, "Please select a tier!");
                        return;
                    }
                }

                Promotion p = new Promotion();
                p.setPromoCode(promoCode);
                p.setPromotionName(promoName);
                p.setTargetType(targetType);
                p.setDiscountPercent(discountPercent);
                p.setStartDate(startDate);
                p.setEndDate(endDate);
                p.setDescription(description);

                PromotionDAO pdao = new PromotionDAO();

                if (pdao.isPromoCodeExists(promoCode)) {
                    backToList(request, response, null, "Promo code already exists!");
                    return;
                }

                int result = pdao.createPromotion(p, tierId);
                if (result > 0) {
                    backToList(request, response, "Create promotion successfully!", null);
                } else {
                    backToList(request, response, null, "Create promotion failed!");
                }

            } catch (Exception e) {
                e.printStackTrace();
                backToList(request, response, null, "Invalid input data!");
            }
            return;
        }

        if ("edit".equalsIgnoreCase(action)) {
            try {
                String promoIdRaw = request.getParameter("promoId");
                String promoCode = request.getParameter("promoCode");
                String promoName = request.getParameter("promoName");
                String targetType = request.getParameter("targetType");
                String discountRaw = request.getParameter("discountPercent");
                String startDateRaw = request.getParameter("startDate");
                String endDateRaw = request.getParameter("endDate");
                String description = request.getParameter("description");

                int promoId = Integer.parseInt(promoIdRaw);

                if (promoCode == null || promoCode.trim().isEmpty()) {
                    backToList(request, response, null, "Promo code can not empty!");
                    return;
                }
                if (promoName == null || promoName.trim().isEmpty()) {
                    backToList(request, response, null, "Campaign name can not empty!");
                    return;
                }

                promoCode = promoCode.trim().toUpperCase();

                int discountPercent = Integer.parseInt(discountRaw);
                if (discountPercent < 1 || discountPercent > 100) {
                    backToList(request, response, null, "Discount must be between 1 and 100!");
                    return;
                }

                Date startDate = Date.valueOf(startDateRaw);
                Date endDate = Date.valueOf(endDateRaw);
                if (startDate.after(endDate)) {
                    backToList(request, response, null, "Start date must be before end date!");
                    return;
                }

                Integer tierId = null;
                if ("Tier".equalsIgnoreCase(targetType)) {
                    tierId = Integer.parseInt(request.getParameter("tierId"));
                    if (tierId <= 0) {
                        backToList(request, response, null, "Please select a tier!");
                        return;
                    }
                }

                Promotion p = new Promotion();
                p.setPromotionID(promoId);
                p.setPromoCode(promoCode);
                p.setPromotionName(promoName);
                p.setTargetType(targetType);
                p.setDiscountPercent(discountPercent);
                p.setStartDate(startDate);
                p.setEndDate(endDate);
                p.setDescription(description);

                PromotionDAO pdao = new PromotionDAO();

                if (pdao.isExistPromoCode(promoCode, promoId)) {
                    backToList(request, response, null, "Promo code already exists!");
                    return;
                }

                int result = pdao.updatePromo(p, tierId);
                if (result > 0) {
                    backToList(request, response, "Update promotion successfully!", null);
                } else {
                    backToList(request, response, null, "Update promotion failed!");
                }

            } catch (Exception e) {
                e.printStackTrace();
                backToList(request, response, null, "Invalid input data!");
            }
            return;
        }

            if ("toogleStatus".equalsIgnoreCase(action)) {
            try {
                int promoId = Integer.parseInt(request.getParameter("id"));
                String isActiveRaw = request.getParameter("isActive");
                boolean isActive;
                if ("true".equals(isActiveRaw)) {
                    isActive = true;
                } else {
                    isActive = false;
                }

                PromotionDAO pdao = new PromotionDAO();
                int result;

                if (isActive) {
                    result = pdao.deactivatePromo(promoId);
                } else {
                    if (pdao.isPromotionExpired(promoId)) {
                        backToList(request, response, null, "Cannot start expired promotion");
                        return;
                    }
                    result = pdao.activatePromo(promoId);
                }

                if (result > 0) {
                    backToList(request, response, "Update status successfully!", null);
                } else {
                    backToList(request, response, null, "Update status failed!");
                }

            } catch (Exception e) {
                e.printStackTrace();
                backToList(request, response, null, "Invalid promotion ID!");
            }
            return;
        }

        //xu ly sai action
        backToList(request, response, null, "Invalid action!");
    }

    //xu ly thanh cong /eror
    private void backToList(HttpServletRequest request, HttpServletResponse response,
            String success, String error)
            throws ServletException, IOException {

        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }

        request.getRequestDispatcher("ManagePromotionsController").forward(request, response);

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

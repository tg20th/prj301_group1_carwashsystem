/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RevenueDAO;
import dto.Payment;
import dto.Revenue;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.Collections;
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
@WebServlet(name = "RevenueController", urlPatterns = {"/RevenueController"})
public class RevenueController extends HttpServlet {

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
            RevenueDAO dao = new RevenueDAO();
            String yearStr = request.getParameter("year");
            int selectedYear = LocalDate.now().getYear();
            if (yearStr != null && !yearStr.trim().isEmpty()) {
                selectedYear = Integer.parseInt(yearStr);
            }
            List<Revenue> stats = dao.getMonthlyRevenueByYear(selectedYear);
            List<Payment> paymentStats = dao.getPaymentStatsByYear(selectedYear);
            List<Integer> availableYears = dao.getAvailableYears();
            if (!availableYears.contains(selectedYear)) {
                availableYears.add(selectedYear);
                Collections.sort(availableYears,Collections.reverseOrder());
            }
            // Logic tính toán KPI (Thực hiện ở Controller, View chỉ việc hiển thị)
            long totalRevenue = 0;
            int totalBookings = 0;
            long previousMonthRevenue = 0;

            int currentYear = LocalDate.now().getYear();
            int currentMonth = LocalDate.now().getMonthValue();
        
            for (Revenue ve : stats) {
                totalRevenue += ve.getTotalRevenue();
                totalBookings += ve.getTotalBooking();
                
                // KIỂM TRA THÁNG TƯƠNG LAI: 
                // Nếu đang xem năm tương lai, hoặc năm nay nhưng tháng lớn hơn tháng hiện tại
                if (selectedYear > currentYear || (selectedYear == currentYear && ve.getMonth() > currentMonth)) {
                    ve.setGrowthRate(0.0); // Gán bằng 0 để giao diện in ra dấu "-"
                } else {
                    // Logic tính % tăng trưởng bình thường cho các tháng đã qua
                    if (previousMonthRevenue == 0) {
                        if (ve.getTotalRevenue() > 0) {
                            ve.setGrowthRate(100.0);
                        } else {
                            ve.setGrowthRate(0.0);
                        }
                    } else {
                        double growth = ((double) (ve.getTotalRevenue() - previousMonthRevenue) / previousMonthRevenue) * 100;
                        ve.setGrowthRate(growth);
                    }
                }
                previousMonthRevenue = ve.getTotalRevenue();
            }
            long avgValue = 0;
            if (totalBookings > 0) {
                avgValue = totalRevenue / totalBookings;
            }
            String topPayment = "N/A";
            if (!paymentStats.isEmpty()) {
                topPayment = paymentStats.get(0).getMethod();
            }

            request.setAttribute("STATS_LIST", stats);
            request.setAttribute("PAYMENT_STATS", paymentStats);
            request.setAttribute("AVAILABLE_YEARS", availableYears);
            request.setAttribute("SELECTED_YEAR", selectedYear);
            request.setAttribute("TOTAL_REVENUE", totalRevenue);
            request.setAttribute("TOTAL_BOOKINGS", totalBookings);
            request.setAttribute("AVG_VALUE", avgValue);
            request.setAttribute("TOP_PAYMENT", topPayment);

            request.getRequestDispatcher("revenue.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard");
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

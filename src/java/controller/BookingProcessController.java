/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDAO;
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
 * @author Lan
 */
@WebServlet(name = "BookingProcessController", urlPatterns = {"/BookingProcessController"})
public class BookingProcessController extends HttpServlet {

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
        
        String action = request.getParameter("action");
        String bookingID = request.getParameter("id");

        if (bookingID != null && !bookingID.isEmpty()) {
            int bookingId = Integer.parseInt(bookingID);
            BookingDAO bd = new BookingDAO();
            int result = 0;

            // 1. KHI NHẤN CHECK-IN
            if ("checkin".equals(action)) {

                result = bd.checkInBooking(bookingId);
                if (result == -2) {
                    request.setAttribute("error", "Only confirmed (paid) bookings can be checked in.");
                } else if (result < 1) {
                    request.setAttribute("error", "Check in fail. Please try again!");

                } else {
                    //Dùng để tự động update trạng thái của Booking sau khi đã checkin
                    Thread autoCheckoutThread = new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                Thread.sleep(60000);

                                int points = bd.completeBookingWithPayment(bookingId, "Cash");
                                System.out.println("Auto checkout booking " + bookingId
                                        + (points >= 0 ? ", points earned: " + points : ", checkout failed"));

                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                        }
                    });

                    autoCheckoutThread.start();
                    request.setAttribute("success", "Check in successfully!");
                }
            } else if ("checkout".equals(action)) {
                String paymentMethod = request.getParameter("paymentMethod");
                int points = bd.completeBookingWithPayment(bookingId, paymentMethod);
                if (points < 0) {
                    request.setAttribute("error", "Check out fail. Please try again!");
                } else {
                    String msg = "Payment completed successfully!";
                    if (points > 0) {
                        msg += " Customer earned " + points + " loyalty points (1,000 VND = 1 point).";
                    }
                    request.setAttribute("success", msg);
                }
            } else if ("confirm".equals(action)) {
                result = bd.confirmBooking(bookingId);
                if (result < 1) {
                    request.setAttribute("error", "Confirm booking failed. Please try again!");
                } else {
                    request.setAttribute("success", "Booking confirmed successfully!");
                }
            } else if ("cancel".equals(action)) {
                result = bd.cancelBooking(bookingId);
                if (result < 1) {
                    request.setAttribute("error", "Cancel booking failed. Please try again!");
                } else {
                    request.setAttribute("success",
                            "Booking cancelled. Wash bay released and loyalty points reversed if payment was completed.");
                }
            }
        }
        request.getRequestDispatcher("ManageBookingsController").forward(request, response);
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

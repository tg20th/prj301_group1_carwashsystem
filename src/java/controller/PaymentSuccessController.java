package controller;

import config.PayOSConfig;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PaymentSuccessController", urlPatterns = {"/PaymentSuccessController"})
public class PaymentSuccessController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PayOSConfig.load(getServletContext());
        String bookingId = request.getParameter("bookingId");
        request.setAttribute("BOOKING_ID", bookingId);
        request.setAttribute("SANDBOX", "1".equals(request.getParameter("sandbox")));
        request.getRequestDispatcher("payment_success.jsp").forward(request, response);
    }
}
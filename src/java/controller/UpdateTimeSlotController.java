package controller;

import dao.TimeSlotDAO;
import dto.TimeSlotDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateTimeSlotController", urlPatterns = {"/UpdateTimeSlotController"})
public class UpdateTimeSlotController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        boolean isAjax = "json".equals(request.getParameter("responseType"))
                || "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        LocalDate slotDate = LocalDate.now();
        sendResponse(request, response, isAjax, false,
                "Time slots are auto-managed by bookings. Use booking management to cancel reservations.",
                slotDate);
    }

    private void sendResponse(HttpServletRequest request, HttpServletResponse response,
            boolean isAjax, boolean success, String message, LocalDate date)
            throws IOException, ServletException {

        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"success\":" + success + ",\"message\":\"" + escapeJson(message) + "\"}");
            out.flush();
            return;
        }

        if (success) {
            request.setAttribute("success", message);
        } else {
            request.setAttribute("error", message);
        }
        response.sendRedirect("TimeSlotController?date=" + date);
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
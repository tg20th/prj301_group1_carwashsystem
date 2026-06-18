package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CreateTimeSlotController", urlPatterns = {"/CreateTimeSlotController"})
public class CreateTimeSlotController extends HttpServlet {

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ISO_LOCAL_DATE;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        boolean isAjax = "json".equals(request.getParameter("responseType"));

        LocalDate slotDate = LocalDate.now();
        try {
            slotDate = LocalDate.parse(request.getParameter("slotDate"), DATE_FMT);
        } catch (Exception ignored) {
        }

        sendResponse(request, response, isAjax, false,
                "Time slots are fixed (08:00-20:00, 30 minutes). Use Auto Generate to create default slots.",
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

        request.setAttribute("error", message);
        request.getRequestDispatcher("TimeSlotController?date=" + date).forward(request, response);
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
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
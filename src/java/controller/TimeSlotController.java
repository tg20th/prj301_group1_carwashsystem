package controller;

import dao.TimeSlotDAO;
import dto.Booking;
import dto.TimeSlotDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "TimeSlotController", urlPatterns = {"/TimeSlotController"})
public class TimeSlotController extends HttpServlet {

    private static final DateTimeFormatter DATE_PARAM = DateTimeFormatter.ISO_LOCAL_DATE;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("booking".equals(action)) {
            handleBookingDetails(request, response);
            return;
        }

        if ("generate".equals(action) || "regenerate".equals(action)) {
            handleAutoGenerate(request, response);
            return;
        }

        LocalDate selectedDate = parseDate(request.getParameter("date"));
        TimeSlotDAO dao = new TimeSlotDAO();

        String schemaError = dao.ensureSchema();
        if (schemaError != null) {
            request.setAttribute("error", schemaError);
        }

        List<TimeSlotDTO> slots = dao.getAllSlotsByDate(selectedDate);
        if ((slots == null || slots.isEmpty()) && dao.getLastError() != null && request.getAttribute("error") == null) {
            request.setAttribute("error", "Could not load slots: " + dao.getLastError());
        }
        request.setAttribute("SLOTS", slots);
        request.setAttribute("SELECTED_DATE", selectedDate);
        request.setAttribute("PREV_DATE", selectedDate.minusDays(1));
        request.setAttribute("NEXT_DATE", selectedDate.plusDays(1));

        request.getRequestDispatcher("timeslot_management.jsp").forward(request, response);
    }

    private void handleBookingDetails(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            TimeSlotDAO dao = new TimeSlotDAO();
            Booking booking = dao.getBookingBySlotId(slotId);

            if (booking == null) {
                out.print("{\"success\":false,\"message\":\"No active booking found for this slot.\"}");
            } else {
                String bookingTime = "";
                if (booking.getTimeslot() != null) {
                    bookingTime = booking.getTimeslot().getStart().toLocalTime().toString()
                            + " - " + booking.getTimeslot().getEnd().toLocalTime().toString();
                }
                String vehicleInfo = escapeJson(booking.getVehicleName())
                        + " (" + escapeJson(booking.getVehicleType()) + ")";
                out.print("{"
                        + "\"success\":true,"
                        + "\"data\":{"
                        + "\"bookingId\":" + booking.getBookingID() + ","
                        + "\"customerName\":\"" + escapeJson(booking.getCusName()) + "\","
                        + "\"service\":\"" + escapeJson(booking.getService()) + "\","
                        + "\"vehicleInfo\":\"" + vehicleInfo + "\","
                        + "\"licensePlate\":\"" + escapeJson(booking.getLicensePlate()) + "\","
                        + "\"bookingTime\":\"" + escapeJson(bookingTime) + "\","
                        + "\"status\":\"" + escapeJson(booking.getStatus()) + "\""
                        + "}"
                        + "}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid slot ID.\"}");
        }

        out.flush();
    }

    private void handleAutoGenerate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        LocalDate date = parseDate(request.getParameter("date"));
        TimeSlotDAO dao = new TimeSlotDAO();
        String schemaError = dao.ensureSchema();
        if (schemaError != null) {
            if ("json".equals(request.getParameter("responseType"))) {
                response.setContentType("application/json;charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false,\"message\":\"" + escapeJson(schemaError) + "\",\"created\":0}");
                out.flush();
                return;
            }
            request.setAttribute("error", schemaError);
            processRequest(request, response);
            return;
        }

        int created = dao.generateDefaultSlots(date);
        int totalAfter = dao.countSlotsByDate(date);
        boolean success = created > 0;
        String message;

        if (created > 0) {
            message = "Generated " + created + " slots for this date.";
        } else if (totalAfter > 0) {
            success = true;
            message = "All default time slots already exist for this date.";
        } else if (dao.getLastError() != null) {
            message = "Auto generate failed: " + dao.getLastError();
        } else {
            message = "Could not generate slots for this date.";
        }

        if ("json".equals(request.getParameter("responseType"))) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"success\":" + success + ",\"message\":\"" + escapeJson(message)
                    + "\",\"date\":\"" + date + "\",\"created\":" + created + "}");
            out.flush();
            return;
        }

        if (success) {
            request.setAttribute("success", message);
        } else {
            request.setAttribute("error", message);
        }
        request.setAttribute("date", date.toString());
        processRequest(request, response);
    }

    private LocalDate parseDate(String dateParam) {
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                return LocalDate.parse(dateParam, DATE_PARAM);
            } catch (Exception ignored) {
            }
        }
        return LocalDate.now();
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

    @Override
    public String getServletInfo() {
        return "Time Slot Management Controller";
    }
}
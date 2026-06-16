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
        String updateAction = request.getParameter("updateAction");

        try {
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            TimeSlotDAO dao = new TimeSlotDAO();
            TimeSlotDTO existing = dao.getSlotById(slotId);

            if (existing == null) {
                sendResponse(request, response, isAjax, false, "Time slot not found.", LocalDate.now());
                return;
            }

            if ("maintenance".equals(updateAction)) {
                String note = request.getParameter("maintenanceNote");
                int result = dao.markSlotAsMaintenance(slotId, note);
                if (result > 0) {
                    String message = TimeSlotDTO.AVAILABLE.equals(existing.getStatus())
                            ? "Slot marked as maintenance successfully."
                            : "Maintenance note updated.";
                    sendResponse(request, response, isAjax, true, message, existing.getSlotDate());
                } else if (result == -2) {
                    sendResponse(request, response, isAjax, false,
                            "Cannot change status. This slot is already booked.", existing.getSlotDate());
                } else if (result == -3) {
                    sendResponse(request, response, isAjax, false,
                            "Maintenance reason is required.", existing.getSlotDate());
                } else {
                    String err = dao.getLastError() != null ? dao.getLastError() : "Failed to update maintenance.";
                    sendResponse(request, response, isAjax, false, err, existing.getSlotDate());
                }
                return;
            }

            if ("restore".equals(updateAction)) {
                int result = dao.restoreSlotToAvailable(slotId);
                if (result > 0) {
                    sendResponse(request, response, isAjax, true,
                            "Slot restored to available successfully.", existing.getSlotDate());
                } else if (result == -2) {
                    sendResponse(request, response, isAjax, false,
                            "Cannot restore. This slot is already booked.", existing.getSlotDate());
                } else if (result == -4) {
                    sendResponse(request, response, isAjax, false,
                            "Only maintenance slots can be restored to available.", existing.getSlotDate());
                } else {
                    String err = dao.getLastError() != null ? dao.getLastError() : "Failed to restore slot.";
                    sendResponse(request, response, isAjax, false, err, existing.getSlotDate());
                }
                return;
            }

            LocalDate slotDate = existing.getSlotDate() != null ? existing.getSlotDate() : LocalDate.now();
            sendResponse(request, response, isAjax, false,
                    "Time slots are fixed and cannot be edited. Only maintenance notes can be updated.",
                    slotDate);
        } catch (Exception e) {
            e.printStackTrace();
            LocalDate fallbackDate = LocalDate.now();
            sendResponse(request, response, isAjax, false, "Invalid input: " + e.getMessage(), fallbackDate);
        }
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
        request.getRequestDispatcher("TimeSlotController?date=" + date).forward(request, response);
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
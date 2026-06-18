package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.ServicePricesDAO;
import dao.ServicesDAO;
import dao.TierDAO;
import dao.TimeSlotDAO;
import dao.VehicleDAO;
import dao.WashBayDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;
import dto.Service;
import dto.ServicePrices;
import dto.Tier;
import dto.TimeSlotDTO;
import dto.Vehicle;
import dto.WashBaySlotDTO;
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

@WebServlet(name = "CustomerBookingController", urlPatterns = {"/CustomerBookingController"})
public class CustomerBookingController extends HttpServlet {

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ISO_LOCAL_DATE;
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "page";
        }

        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        if (account == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());
        if (customer == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            return;
        }

        switch (action) {
            case "slots":
                handleSlots(request, response, customer);
                return;
            case "bays":
                handleBays(request, response, customer);
                return;
            case "price":
                handlePrice(request, response);
                return;
            case "submit":
                handleSubmit(request, response, customer);
                return;
            default:
                handlePage(request, response, customer);
        }
    }

    private void handlePage(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        VehicleDAO vehicleDAO = new VehicleDAO();
        ServicesDAO servicesDAO = new ServicesDAO();
        List<Vehicle> vehicles = vehicleDAO.getVehiclesByCustomerID(customer.getCusID());
        List<Service> services = servicesDAO.getAllServices();

        enrichTierBookingLimits(request, customer);
        request.setAttribute("VEHICLES", vehicles);
        request.setAttribute("SERVICES", services);
        request.getRequestDispatcher("booking_customer.jsp").forward(request, response);
    }

    private void enrichTierBookingLimits(HttpServletRequest request, Customer customer) {
        TierDAO tierDAO = new TierDAO();
        Tier tier = tierDAO.getTier(customer.getTierID());
        int maxDays = tierDAO.getMaxBookingDaysAhead(customer.getTierID());
        request.setAttribute("MAX_BOOKING_DAYS", maxDays);
        request.setAttribute("TIER_NAME", tier != null ? tier.getTierName() : "Member");
    }

    private String validateBookingDate(Customer customer, LocalDate date) {
        TierDAO tierDAO = new TierDAO();
        int maxDays = tierDAO.getMaxBookingDaysAhead(customer.getTierID());
        LocalDate today = LocalDate.now();
        LocalDate lastAllowed = today.plusDays(maxDays - 1L);
        if (date.isBefore(today)) {
            return "Cannot book dates in the past.";
        }
        if (date.isAfter(lastAllowed)) {
            Tier tier = tierDAO.getTier(customer.getTierID());
            String tierName = tier != null ? tier.getTierName() : "your membership";
            return "Your " + tierName + " tier allows booking up to " + maxDays + " days ahead only.";
        }
        return null;
    }

    private LocalDate resolveSlotDate(int slotId) {
        TimeSlotDTO slot = new TimeSlotDAO().getSlotById(slotId);
        if (slot == null) {
            return null;
        }
        if (slot.getSlotDate() != null) {
            return slot.getSlotDate();
        }
        if (slot.getStartTime() != null) {
            return slot.getStartTime().toLocalDate();
        }
        return null;
    }

    private void handleSlots(HttpServletRequest request, HttpServletResponse response, Customer customer) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        LocalDate date = parseDate(request.getParameter("date"));
        String dateError = validateBookingDate(customer, date);
        if (dateError != null) {
            out.print("{\"success\":false,\"message\":\"" + escapeJson(dateError) + "\"}");
            out.flush();
            return;
        }
        TimeSlotDAO dao = new TimeSlotDAO();
        String schemaError = dao.ensureSchema();
        if (schemaError != null) {
            out.print("{\"success\":false,\"message\":\"" + escapeJson(schemaError) + "\"}");
            out.flush();
            return;
        }

        List<TimeSlotDTO> slots = dao.getAvailableSlotsByDate(date);
        StringBuilder json = new StringBuilder("{\"success\":true,\"date\":\"").append(date).append("\",\"slots\":[");
        for (int i = 0; i < slots.size(); i++) {
            TimeSlotDTO slot = slots.get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{")
                    .append("\"slotId\":").append(slot.getSlotId()).append(",")
                    .append("\"start\":\"").append(slot.getStartTime().toLocalTime().format(TIME_FMT)).append("\",")
                    .append("\"end\":\"").append(slot.getEndTime().toLocalTime().format(TIME_FMT)).append("\",")
                    .append("\"availableBays\":").append(slot.getAvailableBayCount()).append(",")
                    .append("\"totalBays\":").append(slot.getTotalBayCount())
                    .append("}");
        }
        json.append("]}");
        out.print(json.toString());
        out.flush();
    }

    private void handleBays(HttpServletRequest request, HttpServletResponse response, Customer customer) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            LocalDate slotDate = resolveSlotDate(slotId);
            if (slotDate == null) {
                out.print("{\"success\":false,\"message\":\"Time slot not found.\"}");
                out.flush();
                return;
            }
            String dateError = validateBookingDate(customer, slotDate);
            if (dateError != null) {
                out.print("{\"success\":false,\"message\":\"" + escapeJson(dateError) + "\"}");
                out.flush();
                return;
            }
            WashBayDAO dao = new WashBayDAO();
            List<WashBaySlotDTO> bays = dao.getAvailableWashBaysForTimeSlot(slotId);
            StringBuilder json = new StringBuilder("{\"success\":true,\"slotId\":")
                    .append(slotId).append(",\"bays\":[");
            for (int i = 0; i < bays.size(); i++) {
                WashBaySlotDTO bay = bays.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{")
                        .append("\"washBayId\":").append(bay.getWashBayID()).append(",")
                        .append("\"bayName\":\"").append(escapeJson(bay.getBayName())).append("\",")
                        .append("\"description\":\"").append(escapeJson(bay.getDescription())).append("\",")
                        .append("\"slotStatus\":\"").append(escapeJson(bay.getSlotStatus())).append("\"")
                        .append("}");
            }
            json.append("]}");
            out.print(json.toString());
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid slot ID.\"}");
        }
        out.flush();
    }

    private void handlePrice(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            VehicleDAO vehicleDAO = new VehicleDAO();
            Integer vehicleTypeId = vehicleDAO.getVehicleTypeIdByVehicleId(vehicleId);
            if (vehicleTypeId == null) {
                out.print("{\"success\":false,\"message\":\"Vehicle not found.\"}");
                out.flush();
                return;
            }
            ServicePricesDAO priceDAO = new ServicePricesDAO();
            ServicePrices price = priceDAO.getPriceByServiceAndVehicleType(serviceId, vehicleTypeId);
            if (price == null) {
                out.print("{\"success\":false,\"message\":\"Price not configured for this vehicle type.\"}");
            } else {
                out.print("{\"success\":true,\"price\":" + price.getPrice().longValue()
                        + ",\"duration\":" + price.getDurations() + "}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid service or vehicle.\"}");
        }
        out.flush();
    }

    private void handleSubmit(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws IOException, ServletException {
        try {
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            int washBayId = Integer.parseInt(request.getParameter("washBayId"));
            String notes = request.getParameter("notes");

            LocalDate slotDate = resolveSlotDate(slotId);
            if (slotDate == null) {
                forwardError(request, response, "Selected time slot was not found.");
                return;
            }
            String dateError = validateBookingDate(customer, slotDate);
            if (dateError != null) {
                forwardError(request, response, dateError);
                return;
            }

            VehicleDAO vehicleDAO = new VehicleDAO();
            if (!vehicleDAO.isVehicleOwnedByCustomer(vehicleId, customer.getCusID())) {
                forwardError(request, response, "Invalid vehicle selection.");
                return;
            }

            Integer vehicleTypeId = vehicleDAO.getVehicleTypeIdByVehicleId(vehicleId);
            ServicePricesDAO priceDAO = new ServicePricesDAO();
            ServicePrices price = priceDAO.getPriceByServiceAndVehicleType(serviceId, vehicleTypeId);
            if (price == null) {
                forwardError(request, response, "Price not found for selected service and vehicle.");
                return;
            }

            Booking booking = new Booking();
            booking.setCustomerID(customer.getCusID());
            booking.setVehicleID(vehicleId);
            booking.setServiceID(serviceId);
            booking.setWashBayId(washBayId);
            booking.setTimeSlotID(slotId);
            booking.setQuantity(1);
            booking.setPriceAtOrder(price.getPrice().doubleValue());
            booking.setDurationAtOrder(price.getDurations());
            booking.setStatus("Pending");
            booking.setNotes(notes);

            BookingDAO bookingDAO = new BookingDAO();
            int result = bookingDAO.createCustomerBooking(booking);
            if (result > 0) {
                response.sendRedirect("PaymentController?bookingId=" + booking.getBookingID());
                return;
            }

            String error;
            switch (result) {
                case -1:
                    error = "Selected time slot was not found.";
                    break;
                case -2:
                    error = "Selected time slot is already full.";
                    break;
                case -4:
                    error = "Selected wash bay is no longer available for this time slot.";
                    break;
                default:
                    error = "Could not create booking. Please try again.";
            }
            forwardError(request, response, error);
        } catch (NumberFormatException e) {
            forwardError(request, response, "Please complete all booking fields.");
        }
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("ERROR_MSG", message);
        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
        handlePage(request, response, customer);
    }

    private LocalDate parseDate(String dateParam) {
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                return LocalDate.parse(dateParam, DATE_FMT);
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
}
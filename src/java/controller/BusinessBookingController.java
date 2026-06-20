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
import dto.Business;
import dto.Customer;
import dto.DiscountRequest;
import dto.DiscountResult;
import dto.Promotion;
import dto.Service;
import dto.ServicePrices;
import dto.Tier;
import dto.TimeSlotDTO;
import dto.Vehicle;
import dto.WashBaySlotDTO;
import java.io.IOException;
import java.io.PrintWriter;
import service.DiscountEngine;
import service.InvoiceAutoCancelService;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "BusinessBookingController", urlPatterns = {"/BusinessBookingController"})
public class BusinessBookingController extends HttpServlet {

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
        Business business = (Business) request.getSession().getAttribute("BUS");
        if (account == null || business == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByAccountID(account.getAccountID());
        if (customer == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Business customer not found");
            return;
        }

        switch (action) {
            case "slots":
                handleSlots(request, response, customer);
                return;
            case "bays":
                handleBays(request, response, customer);
                return;
            case "prices":
                handlePrices(request, response, customer);
                return;
            case "previewDiscount":
                handlePreviewDiscount(request, response, customer);
                return;
            case "submit":
                handleSubmit(request, response, customer);
                return;
            default:
                handlePage(request, response, customer, business);
        }
    }

    private void handlePage(HttpServletRequest request, HttpServletResponse response,
            Customer customer, Business business)
            throws ServletException, IOException {
        new InvoiceAutoCancelService().cancelExpiredPendingInvoices();

        VehicleDAO vehicleDAO = new VehicleDAO();
        ServicesDAO servicesDAO = new ServicesDAO();
        List<Vehicle> allVehicles = vehicleDAO.getVehiclesByCustomerID(customer.getCusID());
        List<Vehicle> vehicles = new ArrayList<>();
        for (Vehicle v : allVehicles) {
            if ("Active".equalsIgnoreCase(v.getStatus())) {
                vehicles.add(v);
            }
        }
        List<Service> services = servicesDAO.getAllServices();

        enrichTierBookingLimits(request, customer);
        DiscountEngine discountEngine = new DiscountEngine();
        request.setAttribute("PROMO_LIST", discountEngine.getEligiblePromotions(customer.getCusID(), customer.getTierID()));
        request.setAttribute("VEHICLES", vehicles);
        request.setAttribute("SERVICES", services);
        request.setAttribute("BUSINESS_NAME", business.getBusinessName());
        request.getRequestDispatcher("business_booking.jsp").forward(request, response);
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

    private String validateSlotLeadTime(int slotId) {
        TimeSlotDAO slotDAO = new TimeSlotDAO();
        TimeSlotDTO slot = slotDAO.getSlotById(slotId);
        if (slot == null) {
            return "Selected time slot was not found.";
        }
        if (!slotDAO.isSlotBookable(slot)) {
            return "Please choose a time slot at least "
                    + TimeSlotDAO.BOOKING_LEAD_MINUTES + " minutes from now.";
        }
        return null;
    }

    private void handleSlots(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws IOException {
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

    private void handleBays(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            int vehicleCount = Integer.parseInt(request.getParameter("vehicleCount"));
            String slotError = validateSlotLeadTime(slotId);
            if (slotError != null) {
                out.print("{\"success\":false,\"message\":\"" + escapeJson(slotError) + "\"}");
                out.flush();
                return;
            }
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
            boolean enough = bays.size() >= vehicleCount;
            StringBuilder json = new StringBuilder("{\"success\":true,\"slotId\":")
                    .append(slotId)
                    .append(",\"availableCount\":").append(bays.size())
                    .append(",\"enough\":").append(enough)
                    .append(",\"bays\":[");
            for (int i = 0; i < bays.size(); i++) {
                WashBaySlotDTO bay = bays.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{")
                        .append("\"washBayId\":").append(bay.getWashBayID()).append(",")
                        .append("\"bayName\":\"").append(escapeJson(bay.getBayName())).append("\"")
                        .append("}");
            }
            json.append("]}");
            out.print(json.toString());
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid parameters.\"}");
        }
        out.flush();
    }

    private void handlePrices(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String[] vehicleIdParams = request.getParameterValues("vehicleIds");
            if (vehicleIdParams == null || vehicleIdParams.length == 0) {
                out.print("{\"success\":false,\"message\":\"Select at least one vehicle.\"}");
                out.flush();
                return;
            }

            VehicleDAO vehicleDAO = new VehicleDAO();
            ServicePricesDAO priceDAO = new ServicePricesDAO();
            long total = 0;
            int maxDuration = 0;
            StringBuilder items = new StringBuilder("[");
            for (int i = 0; i < vehicleIdParams.length; i++) {
                int vehicleId = Integer.parseInt(vehicleIdParams[i]);
                if (!vehicleDAO.isVehicleOwnedByCustomer(vehicleId, customer.getCusID())) {
                    out.print("{\"success\":false,\"message\":\"Invalid vehicle selection.\"}");
                    out.flush();
                    return;
                }
                Integer vehicleTypeId = vehicleDAO.getVehicleTypeIdByVehicleId(vehicleId);
                ServicePrices price = priceDAO.getPriceByServiceAndVehicleType(serviceId, vehicleTypeId);
                if (price == null) {
                    out.print("{\"success\":false,\"message\":\"Price not configured for a selected vehicle.\"}");
                    out.flush();
                    return;
                }
                Vehicle vehicle = vehicleDAO.getVehicleByID(vehicleId);
                if (i > 0) {
                    items.append(",");
                }
                long unitPrice = price.getPrice().longValue();
                total += unitPrice;
                maxDuration = Math.max(maxDuration, price.getDurations());
                items.append("{")
                        .append("\"vehicleId\":").append(vehicleId).append(",")
                        .append("\"plate\":\"").append(escapeJson(vehicle != null ? vehicle.getLicensePlate() : "")).append("\",")
                        .append("\"name\":\"").append(escapeJson(vehicle != null
                                ? vehicle.getBrandName() + " " + vehicle.getModelName() : "")).append("\",")
                        .append("\"price\":").append(unitPrice).append(",")
                        .append("\"duration\":").append(price.getDurations())
                        .append("}");
            }
            items.append("]");
            out.print("{\"success\":true,\"total\":" + total + ",\"maxDuration\":" + maxDuration
                    + ",\"items\":" + items + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid service or vehicle.\"}");
        }
        out.flush();
    }

    private void handlePreviewDiscount(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String[] vehicleIdParams = request.getParameterValues("vehicleIds");
            Integer promotionId = parseOptionalPromotionId(request.getParameter("promotionId"));
            if (vehicleIdParams == null || vehicleIdParams.length == 0) {
                out.print("{\"success\":false,\"message\":\"Select at least one vehicle.\"}");
                out.flush();
                return;
            }

            VehicleDAO vehicleDAO = new VehicleDAO();
            ServicePricesDAO priceDAO = new ServicePricesDAO();
            long subTotal = 0;
            int maxDuration = 0;
            StringBuilder items = new StringBuilder("[");
            for (int i = 0; i < vehicleIdParams.length; i++) {
                int vehicleId = Integer.parseInt(vehicleIdParams[i]);
                if (!vehicleDAO.isVehicleOwnedByCustomer(vehicleId, customer.getCusID())) {
                    out.print("{\"success\":false,\"message\":\"Invalid vehicle selection.\"}");
                    out.flush();
                    return;
                }
                Integer vehicleTypeId = vehicleDAO.getVehicleTypeIdByVehicleId(vehicleId);
                ServicePrices price = priceDAO.getPriceByServiceAndVehicleType(serviceId, vehicleTypeId);
                if (price == null) {
                    out.print("{\"success\":false,\"message\":\"Price not configured for a selected vehicle.\"}");
                    out.flush();
                    return;
                }
                Vehicle vehicle = vehicleDAO.getVehicleByID(vehicleId);
                if (i > 0) {
                    items.append(",");
                }
                long unitPrice = price.getPrice().longValue();
                subTotal += unitPrice;
                maxDuration = Math.max(maxDuration, price.getDurations());
                items.append("{")
                        .append("\"vehicleId\":").append(vehicleId).append(",")
                        .append("\"plate\":\"").append(escapeJson(vehicle != null ? vehicle.getLicensePlate() : "")).append("\",")
                        .append("\"name\":\"").append(escapeJson(vehicle != null
                                ? vehicle.getBrandName() + " " + vehicle.getModelName() : "")).append("\",")
                        .append("\"price\":").append(unitPrice).append(",")
                        .append("\"duration\":").append(price.getDurations())
                        .append("}");
            }
            items.append("]");

            DiscountEngine discountEngine = new DiscountEngine();
            DiscountResult result = discountEngine.calculate(
                    new DiscountRequest(customer.getCusID(), customer.getTierID(), subTotal, promotionId));

            int remainingUses = 0;
            if (result.getAppliedPromotionId() != null) {
                List<Promotion> eligible = discountEngine.getEligiblePromotions(
                        customer.getCusID(), customer.getTierID());
                for (Promotion promo : eligible) {
                    if (promo.getPromotionID() == result.getAppliedPromotionId()) {
                        remainingUses = promo.getRemainingUses();
                        break;
                    }
                }
            }

            out.print("{\"success\":true"
                    + ",\"total\":" + result.getSubTotal()
                    + ",\"subTotal\":" + result.getSubTotal()
                    + ",\"discountAmount\":" + result.getDiscountAmount()
                    + ",\"finalAmount\":" + result.getFinalAmount()
                    + ",\"discountPercent\":" + result.getDiscountPercent()
                    + ",\"promotionId\":" + (result.getAppliedPromotionId() != null ? result.getAppliedPromotionId() : "null")
                    + ",\"promotionName\":\"" + escapeJson(result.getPromotionName() != null ? result.getPromotionName() : "") + "\""
                    + ",\"remainingUses\":" + remainingUses
                    + ",\"maxDuration\":" + maxDuration
                    + ",\"items\":" + items
                    + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid service or vehicle.\"}");
        }
        out.flush();
    }

    private void handleSubmit(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws IOException, ServletException {
        try {
            String[] vehicleIdParams = request.getParameterValues("vehicleIds");
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            String notes = request.getParameter("notes");
            Integer promotionId = parseOptionalPromotionId(request.getParameter("promotionId"));

            if (vehicleIdParams == null || vehicleIdParams.length == 0) {
                forwardError(request, response, customer, "Please select at least one vehicle.");
                return;
            }

            List<Integer> vehicleIds = new ArrayList<>();
            for (String param : vehicleIdParams) {
                vehicleIds.add(Integer.parseInt(param));
            }

            String slotError = validateSlotLeadTime(slotId);
            if (slotError != null) {
                forwardError(request, response, customer, slotError);
                return;
            }
            LocalDate slotDate = resolveSlotDate(slotId);
            if (slotDate == null) {
                forwardError(request, response, customer, "Selected time slot was not found.");
                return;
            }
            String dateError = validateBookingDate(customer, slotDate);
            if (dateError != null) {
                forwardError(request, response, customer, dateError);
                return;
            }

            WashBayDAO bayDAO = new WashBayDAO();
            if (bayDAO.getAvailableWashBaysForTimeSlot(slotId).size() < vehicleIds.size()) {
                forwardError(request, response, customer,
                        "Not enough wash bays available for " + vehicleIds.size() + " vehicles.");
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();
            BookingDAO.BusinessBookingResult result = bookingDAO.createBusinessBookings(
                    customer.getCusID(), customer.getTierID(), slotId, serviceId, vehicleIds, notes, promotionId);
            if (result != null) {
                response.sendRedirect("BusinessPaymentController?invoiceId=" + result.getInvoiceId());
                return;
            }

            forwardError(request, response, customer,
                    "Could not create bookings. Bays may no longer be available — please try again.");
        } catch (NumberFormatException e) {
            forwardError(request, response, customer, "Please complete all booking fields.");
        }
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response,
            Customer customer, String message)
            throws ServletException, IOException {
        request.setAttribute("ERROR_MSG", message);
        Business business = (Business) request.getSession().getAttribute("BUS");
        handlePage(request, response, customer, business);
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

    private Integer parseOptionalPromotionId(String raw) {
        if (raw == null || raw.trim().isEmpty() || "auto".equalsIgnoreCase(raw.trim())) {
            return null;
        }
        try {
            int id = Integer.parseInt(raw.trim());
            return id > 0 ? id : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
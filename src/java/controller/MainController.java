/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BusinessDAO;
import dao.VehicleBrandDAO;
import dao.VehicleDAO;
import dao.VehicleModelDAO;
import dto.Account;
import dao.VehicleModelDAO;
import dto.Business;
import dto.Vehicle;
import dto.VehicleBrand;
import dto.VehicleModel;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lan
 */
@WebServlet("/MainController")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class MainController extends HttpServlet {

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
        String url = "index.jsp";
        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "home";
            }
            switch (action) {
                case "home":
                    url = "index.jsp";
                    break;
                case "register_page":
                    url = "register.jsp";
                    break;
                case "register":
                    url = "RegisterController";
                    break;
                case "login":
                    url = "LoginController";
                    break;
                case "logout":
                    url = "LogoutController";
                    break;
                case "dashboard":
                    Account acc = (Account) request.getSession().getAttribute("ACCOUNT");
                    if (acc == null) {
                        url = "index.jsp";
                        break;
                    }
                    Business bus = (Business) request.getSession().getAttribute("BUS");
                    if (bus != null) {
                        url = "BusinessDashboardController";
                    } else {
                        url = "CustomerDashBoardController";
                    }
                    break;
                case "pending_page":
                    url = "pending_page.jsp";
                    break;
                case "AddVehicle_page":
                    url = "addVehicle.jsp";
                    break;
                case "getVehicleData":
                    response.setContentType("application/json;charset=UTF-8");
                    try ( PrintWriter out = response.getWriter()) {
                        VehicleBrandDAO brandDAO = new VehicleBrandDAO();
                        VehicleModelDAO modelDAO = new VehicleModelDAO();

                        ArrayList<VehicleBrand> brands = brandDAO.getAllBrands();
                        ArrayList<VehicleModel> models = modelDAO.getAllModels();

                        StringBuilder json = new StringBuilder();
                        json.append("{\"brands\":[");

                        for (int i = 0; i < brands.size(); i++) {
                            VehicleBrand b = brands.get(i);
                            String name = b.getBrandName().replace("\"", "\\\"");
                            json.append("{\"brandID\":").append(b.getBrandID())
                                    .append(",\"brandName\":\"").append(name).append("\"}");
                            if (i < brands.size() - 1) {
                                json.append(",");
                            }
                        }
                        json.append("],\"models\":[");

                        for (int i = 0; i < models.size(); i++) {
                            VehicleModel m = models.get(i);
                            String name = m.getModelName().replace("\"", "\\\"");
                            json.append("{\"modelID\":").append(m.getModelID())
                                    .append(",\"brandID\":").append(m.getBrandID())
                                    .append(",\"modelName\":\"").append(name).append("\"}");
                            if (i < models.size() - 1) {
                                json.append(",");
                            }
                        }
                        json.append("]}");

                        out.print(json.toString());
                    }
                    return; // prevent forward, we already wrote JSON response
                case "AddVehicle":
                    url = "AddVehicleController";
                    break;
                case "RemoveVehicle":
                    url = "RemoveVehicleController";
                    break;
                case "UpdateVehicle_page":
                    String vIDStr = request.getParameter("vehicleID");
                    if (vIDStr != null) {
                        int vehicleID = Integer.parseInt(vIDStr);
                        VehicleDAO dao = new VehicleDAO();
                        Vehicle v = dao.getVehicleByID(vehicleID);
                        VehicleBrandDAO brandDAO = new VehicleBrandDAO();
                        VehicleModelDAO modelDAO = new VehicleModelDAO();
                        ArrayList<VehicleBrand> brandList = brandDAO.getAllBrands();
                        ArrayList<VehicleModel> modelList = modelDAO.getAllModels();
                        request.setAttribute("VEHICLE", v);
                        request.setAttribute("BRAND_LIST", brandList);
                        request.setAttribute("MODEL_LIST", modelList);
                        url = "updateVehicle.jsp";
                    } else {
                        url = "CustomerDashBoardController";
                    }
                    break;
                case "UpdateVehicle":
                    url = "UpdateVehicleController";
                    break;
                case "editprofile":
                    url = "edit_customer.jsp";
                    break;
                case "saveaccount":
                    url = "SaveAccountController";
                    break;
                case "AddBusinessVehicle_page":
                    url = "addBusinessVehicle.jsp";
                    break;
                case "AddBusinessVehicles":
                    url = "AddBusinessVehiclesController";
                    break;
                case "resubmit_registration":
                    url = "UpdateRegistrationController";
                    break;
                case "admin_dashboard":
                    url = "AdminDashboardController";
                    break;
                case "booking_admin":
                    url = "ManageBookingsController";
                    break;
                case "timeslot_schedule":
                    url = "TimeSlotController";
                    break;
                case "vehicle_request":
                    url = "VehicleRequestController";
                    break;
                case "business_request":
                    url = "BusinessRequestsController";
                    break;
                case "manage_user":
                    url = "ManageUserController";
                    break;
                case "manage_tier":
                    url = "ManageTiersController";
                    break;
                case "manage_promotion":
                    url = "ManagePromotionsController";
                    break;
                case "process_user":
                    url = "UserProcessController";
                    break;
                case "process_booking":
                    url = "BookingProcessController";
                    break;
                case "reject":
                    url = "RejectBusinessController";
                    break;
                case "approve":
                    url = "ApproveBusinessController";
                    break;
                case "add_tier":
                    url = "AddTierController";
                    break;
                case "update_tier":
                    url = "UpdateTierController";
                    break;
                case "update_status_tier":
                    url = "RemoveTierController";
                    break;
                case "Revenue":
                    url = "RevenueController";
                    break;
                case "vehicle_bus_request":
                    url = "VehicleRequestBusController";
                    break;
                case "approve_vehicle":
                    url = "ApproveVehicleController";
                    break;
                case "reject_vehicle":
                    url = "RejectVehicleController";
                case "viewcustomerhistory":
                    url = "CustomerBookingHistoryController";
                    break;
                case "customerbooking":
                    url = "CustomerBookingController";
                    break;
                case "customer_dashboard":
                    url = "CustomerDashBoardController";
                    break;
                case "customer_payment":
                    url = "PaymentController";
                    break;
                case "customer_payment_status":
                    url = "PaymentStatusController";
                    break;
                case "customer_payment_success":
                    url = "PaymentSuccessController";
                    break;
                case "customer_payment_sandbox":
                    url = "PaymentSandboxController";
                    break;
                case "customer_invoice_print":
                    url = "InvoicePrint";
                    break;
                case "business_dashboard":
                    url = "BusinessDashboardController";
                    break;
                case "business_booking":
                    url = "BusinessBookingController";
                    break;
                case "viewbusinesshistory":
                    url = "BusinessBookingHistoryController";
                    break;
                case "business_payment":
                    url = "BusinessPaymentController";
                    break;
                case "business_payment_status":
                    url = "BusinessPaymentStatusController";
                    break;
                case "business_payment_success":
                    url = "BusinessPaymentSuccessController";
                    break;
                case "business_payment_sandbox":
                    url = "BusinessPaymentSandboxController";
                    break;
                case "business_invoice_print":
                    url = "InvoicePrint";
                    break;
                case "invoice_admin":
                    url = "ManageInvoiceController";
                    break;
                default:
                    url = "index.jsp";
                    break;
            }
            request.getRequestDispatcher(url).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error: " + e.getMessage());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
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

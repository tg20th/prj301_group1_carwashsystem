/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.VehicleBrandDAO;
import dao.VehicleDAO;
import dao.VehicleModelDAO;
import dto.Account;
import dao.VehicleModelDAO;
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
                    url = "/register.jsp";
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
                    if (acc.getRoleID() == 3) {
                        url = "BusinessDashboardController";
                    } else if (acc.getRoleID() == 1) {
                        url = "admin_dashbroad.jsp";
                    } else {
                        url = "CustomerDashBoardController";
                    }
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
                            if (i < brands.size() - 1) json.append(",");
                        }
                        json.append("],\"models\":[");

                        for (int i = 0; i < models.size(); i++) {
                            VehicleModel m = models.get(i);
                            String name = m.getModelName().replace("\"", "\\\"");
                            json.append("{\"modelID\":").append(m.getModelID())
                                .append(",\"brandID\":").append(m.getBrandID())
                                .append(",\"modelName\":\"").append(name).append("\"}");
                            if (i < models.size() - 1) json.append(",");
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
                case "BusinessDashboard":
                    url = "BusinessDashboardController";
                    break;
                case "AddBusinessVehicle_page":
                    url = "addBusinessVehicle.jsp";
                    break;
                case "AddBusinessVehicles":
                    url = "AddBusinessVehiclesController";
                    break;

                default:
                    url = "index.jsp";
                    break;
            }
            request.getRequestDispatcher(url).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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

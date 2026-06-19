/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BusinessDAO;
import dao.CustomerDAO;
import dao.VehicleBrandDAO;
import dao.VehicleDAO;
import dao.VehicleModelDAO;
import dto.Account;
import dto.Business;
import dto.Customer;
import dto.Vehicle;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author Minh Khanh
 */
@WebServlet(name = "UpdateVehicleController", urlPatterns = {"/UpdateVehicleController"})
public class UpdateVehicleController extends HttpServlet {

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
        Account acc = (Account) request.getSession().getAttribute("ACCOUNT");
        if (acc == null) {
            request.getRequestDispatcher("MainController").forward(request, response);
            return;
        }
        String url;
        try {
            int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
            int modelID = Integer.parseInt(request.getParameter("modelID"));
            String licensePlate = request.getParameter("licensePlate").trim().toUpperCase();
            String color = request.getParameter("color");
            Integer manufactureYear = null;
            String yearStr = request.getParameter("manufactureYear");
            if (yearStr != null && !yearStr.trim().isEmpty()) {
                manufactureYear = Integer.parseInt(yearStr);
            }
            VehicleDAO dao = new VehicleDAO();
            Vehicle oldVehicle = dao.getVehicleByID(vehicleID);
            boolean exists = dao.isLicensePlateExistsForOther(licensePlate, vehicleID);
            if (exists) {
                VehicleBrandDAO brandDAO = new VehicleBrandDAO();
                VehicleModelDAO modelDAO = new VehicleModelDAO();
                request.setAttribute("ERROR", "License plate already exists.");
                request.setAttribute("VEHICLE", oldVehicle);
                request.setAttribute("BRAND_LIST", brandDAO.getAllBrands());
                request.setAttribute("MODEL_LIST", modelDAO.getAllModels());
                request.getRequestDispatcher("updateVehicle.jsp").forward(request, response);
                return;
            }
            String imageURL = oldVehicle.getImageURL();
            Part imagePart = request.getPart("vehicleImage");
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("/") + "vehicleImages";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                imagePart.write(uploadPath + File.separator + uniqueFileName);
                imageURL = "vehicleImages/" + uniqueFileName;
            }
            Vehicle updatedVehicle = new Vehicle();
            updatedVehicle.setVehicleID(vehicleID);
            updatedVehicle.setCustomerID(oldVehicle.getCustomerID());
            updatedVehicle.setModelID(modelID);
            updatedVehicle.setLicensePlate(licensePlate);
            updatedVehicle.setColor(color);
            updatedVehicle.setManufactureYear(manufactureYear);
            updatedVehicle.setImageURL(imageURL);
            updatedVehicle.setStatus("Pending");
            int result = dao.updateVehicle(updatedVehicle);

            if (result <= 0) {
                VehicleBrandDAO brandDAO = new VehicleBrandDAO();
                VehicleModelDAO modelDAO = new VehicleModelDAO();
                request.setAttribute("ERROR", "Cannot update vehicle.");
                request.setAttribute("VEHICLE", oldVehicle);
                request.setAttribute("BRAND_LIST", brandDAO.getAllBrands());
                request.setAttribute("MODEL_LIST", modelDAO.getAllModels());

                request.getRequestDispatcher("updateVehicle.jsp").forward(request, response);
                return;
            }
            request.setAttribute("SUCCESS", "Vehicle updated successfully."); 
            Business business = (Business)request.getSession().getAttribute("BUS");
            if (business != null) {
            
                request.getRequestDispatcher("BusinessDashboardController").forward(request, response);
                return;
            }
            request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.setAttribute("ERROR", "System error: " + e.getMessage());
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
                // last resort recovery
                try {
                    CustomerDAO customerDAO = new CustomerDAO();
                    Customer customer = customerDAO.getCustomerByAccountID(acc.getAccountID());
                    BusinessDAO d = new BusinessDAO();
                    Business business = d.getBussinessByCusID(customer.getCusID());
                    if (business != null) {
                        request.getRequestDispatcher("BusinessDashboardController").forward(request, response);
                        return;
                    }
                    request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
                } catch (Exception ignored) {}
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

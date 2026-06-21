package controller;

import dbutils.LicensePlateUtils;
import dao.VehicleBrandDAO;
import dao.VehicleDAO;
import dao.VehicleModelDAO;
import dto.Account;
import dto.Business;
import dto.Vehicle;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "UpdateVehicleController", urlPatterns = {"/UpdateVehicleController"})
public class UpdateVehicleController extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        Account acc = (Account) request.getSession().getAttribute("ACCOUNT");
        if (acc == null) {
            request.getRequestDispatcher("MainController").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        if ("UpdateVehicle_page".equals(action)) {
            showUpdatePage(request, response, acc);
            return;
        }

        handleUpdate(request, response, acc);
    }

    private void showUpdatePage(HttpServletRequest request, HttpServletResponse response, Account acc)
            throws ServletException, IOException {
        String vehicleIdParam = request.getParameter("vehicleID");
        if (vehicleIdParam == null || vehicleIdParam.trim().isEmpty()) {
            forwardDashboard(request, response, acc);
            return;
        }

        try {
            int vehicleID = Integer.parseInt(vehicleIdParam);
            VehicleDAO vehicleDAO = new VehicleDAO();
            Vehicle vehicle = vehicleDAO.getVehicleByID(vehicleID);
            if (vehicle == null) {
                forwardDashboard(request, response, acc);
                return;
            }

            VehicleBrandDAO brandDAO = new VehicleBrandDAO();
            VehicleModelDAO modelDAO = new VehicleModelDAO();
            request.setAttribute("VEHICLE", vehicle);
            request.setAttribute("BRAND_LIST", brandDAO.getAllBrands());
            request.setAttribute("MODEL_LIST", modelDAO.getAllModels());
            request.getRequestDispatcher("updateVehicle.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            forwardDashboard(request, response, acc);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Account acc)
            throws ServletException, IOException {
        try {
            int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
            int modelID = Integer.parseInt(request.getParameter("modelID"));
            String licensePlate = LicensePlateUtils.normalize(request.getParameter("licensePlate"));
            if (!LicensePlateUtils.isValid(licensePlate)) {
                forwardUpdatePageWithError(request, response, vehicleID, LicensePlateUtils.FORMAT_MESSAGE);
                return;
            }

            String color = request.getParameter("color");
            Integer manufactureYear = null;
            String yearStr = request.getParameter("manufactureYear");
            if (yearStr != null && !yearStr.trim().isEmpty()) {
                manufactureYear = Integer.parseInt(yearStr);
            }

            VehicleDAO dao = new VehicleDAO();
            Vehicle oldVehicle = dao.getVehicleByID(vehicleID);
            if (dao.isLicensePlateExistsForOther(licensePlate, vehicleID)) {
                forwardUpdatePageWithError(request, response, vehicleID, "License plate already exists.");
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
                String fileName = new File(imagePart.getSubmittedFileName()).getName();
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

            if (dao.updateVehicle(updatedVehicle) <= 0) {
                forwardUpdatePageWithError(request, response, vehicleID, "Cannot update vehicle.");
                return;
            }

            request.setAttribute("SUCCESS", "Vehicle updated successfully.");
            forwardDashboard(request, response, acc);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "System error: " + e.getMessage());
            request.getRequestDispatcher("error_page.jsp").forward(request, response);
        }
    }

    private void forwardUpdatePageWithError(HttpServletRequest request, HttpServletResponse response,
            int vehicleID, String errorMessage) throws ServletException, IOException {
        VehicleDAO dao = new VehicleDAO();
        VehicleBrandDAO brandDAO = new VehicleBrandDAO();
        VehicleModelDAO modelDAO = new VehicleModelDAO();
        request.setAttribute("ERROR", errorMessage);
        request.setAttribute("VEHICLE", dao.getVehicleByID(vehicleID));
        request.setAttribute("BRAND_LIST", brandDAO.getAllBrands());
        request.setAttribute("MODEL_LIST", modelDAO.getAllModels());
        request.getRequestDispatcher("updateVehicle.jsp").forward(request, response);
    }

    private void forwardDashboard(HttpServletRequest request, HttpServletResponse response, Account acc)
            throws ServletException, IOException {
        Business business = (Business) request.getSession().getAttribute("BUS");
        if (business != null) {
            request.getRequestDispatcher("BusinessDashboardController").forward(request, response);
            return;
        }
        request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Update vehicle page and submit";
    }
}
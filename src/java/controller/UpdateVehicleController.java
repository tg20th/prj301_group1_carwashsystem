
package controller;

import dao.VehicleDAO;
import dto.Vehicle;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.Part;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateVehicleController",
        urlPatterns = {"/UpdateVehicleController"})

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)

public class UpdateVehicleController extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            int vehicleID= Integer.parseInt(request.getParameter("vehicleID"));
            int modelID = Integer.parseInt(request.getParameter("modelID"));
            String licensePlate = request.getParameter("licensePlate").trim().toUpperCase();
            String color  = request.getParameter("color");
            String yearStr = request.getParameter("manufactureYear");
            Integer manufactureYear = null;
            if (yearStr != null && !yearStr.trim().isEmpty()) {
                manufactureYear = Integer.parseInt(yearStr);
            }
            VehicleDAO dao = new VehicleDAO();

            if (dao.isLicensePlateExistsForOther(licensePlate, vehicleID)) {
                request.setAttribute("ERROR", "License plate already exists!");
                request.getRequestDispatcher( "MainController?action=UpdateVehicle_page&vehicleID="+ vehicleID).forward(request, response);
                return;
            }
            // ===== GET OLD VEHICLE =====
            Vehicle oldVehicle= dao.getVehicleByID(vehicleID);
            // ===== IMAGE =====
            String imageURL = oldVehicle.getImageURL();
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadPath= getServletContext().getRealPath("/") + "vehicleImages";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                String fileName= Paths.get(imagePart.getSubmittedFileName() ).getFileName().toString();
                imagePart.write(uploadPath+ File.separator + fileName);
                imageURL = "vehicleImages/" + fileName;
            }

            Vehicle v = new Vehicle();
            v.setVehicleID(vehicleID);
            v.setModelID(modelID);
            v.setLicensePlate(licensePlate);
            v.setColor(color);
            v.setManufactureYear(manufactureYear);
            v.setImageURL(imageURL);

            int rs = dao.updateVehicle(v);
            if (rs > 0) {
                response.sendRedirect( "CustomerDashBoardController");
            } else {
                request.setAttribute("ERROR", "Update failed!");
                request.getRequestDispatcher("MainController?action=UpdateVehicle_page&vehicleID=" + vehicleID ).forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "Error: " + e.getMessage());
            request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Update Vehicle Controller";
    }
}


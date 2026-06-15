/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.VehicleDAO;
import dto.Account;
import dto.Customer;
import dto.Vehicle;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author Minh Khanh
 */
@WebServlet(name = "AddVehicleController", urlPatterns = {"/AddVehicleController"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddVehicleController extends HttpServlet {

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
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddVehicleController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddVehicleController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        try {
            // Use ACCOUNT (set at login) instead of CUSTOMER (only set after visiting dashboard)
            // This prevents unwanted redirect to login page when submitting the add form.
            Account account = (Account) request.getSession().getAttribute("ACCOUNT");
            if (account == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }

            // Load fresh Customer to get reliable cusID (more robust)
            CustomerDAO cusDAO = new CustomerDAO();
            Customer customer = cusDAO.getCustomerByAccountID(account.getAccountID());
            if (customer == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }
            int cusID = customer.getCusID();

            // Safe parameter extraction
            String licensePlate = request.getParameter("licensePlate");
            if (licensePlate != null) {
                licensePlate = licensePlate.trim().toUpperCase();
            }

            if (licensePlate == null || licensePlate.isEmpty()) {
                request.setAttribute("ERROR", "License plate is required.");
                request.getRequestDispatcher("addVehicle.jsp").forward(request, response);
                return;
            }

            String modelIDStr = request.getParameter("modelID");
            int modelID = 0;
            if (modelIDStr != null && !modelIDStr.trim().isEmpty()) {
                modelID = Integer.parseInt(modelIDStr);
            }

            if (modelID <= 0) {
                request.setAttribute("ERROR", "Please select a valid vehicle model.");
                request.getRequestDispatcher("addVehicle.jsp").forward(request, response);
                return;
            }

            // Manufacture year - allow empty (nullable) - matches UpdateVehicleController behavior
            String yearStr = request.getParameter("manufactureYear");
            Integer manufactureYear = null;
            if (yearStr != null && !yearStr.trim().isEmpty()) {
                manufactureYear = Integer.parseInt(yearStr);
            }

            String color = request.getParameter("color");

            // === IMAGE HANDLING (consistent with UpdateVehicleController) ===
            String imageURL = null;
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("/") + "vehicleImages";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                // Make filename unique to avoid collisions
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                imagePart.write(uploadPath + File.separator + uniqueFileName);
                imageURL = "vehicleImages/" + uniqueFileName;
            }

            String status = "Pending";

            Vehicle v = new Vehicle(cusID, modelID, licensePlate, color, manufactureYear, imageURL, status);

            VehicleDAO d = new VehicleDAO();
            Vehicle found = (licensePlate != null && !licensePlate.isEmpty()) ? d.getVeByPlate(licensePlate) : null;

            int result = 0;
            if (found == null) {
                result = d.createVehicle(v);
                if (result > 0) {
                    request.setAttribute("SUCCESS", "Vehicle added successfully");
                } else {
                    request.setAttribute("ERROR", "Cannot add vehicle");
                }
            } else if (found.getCustomerID() != cusID) {
                request.setAttribute("ERROR", "Vehicle already belongs to another customer");
            } else if (!found.isActive()) {
                // Reuse the vehicle object for reactivation (it now has the new image if uploaded)
                result = d.reactivateVehicle(v);
                if (result > 0) {
                    request.setAttribute("SUCCESS", "Vehicle added successfully");
                } else {
                    request.setAttribute("ERROR", "Cannot add vehicle");
                }
            } else {
                request.setAttribute("error", "Vehicle already exists in your account.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.setAttribute("ERROR", "Error processing request: " + e.getMessage());
                request.getRequestDispatcher("error_page.jsp").forward(request, response);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return;
        }
        request.getRequestDispatcher("addVehicle.jsp").forward(request, response);
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

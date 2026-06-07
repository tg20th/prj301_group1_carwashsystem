package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import dao.VehicleDAO;
import dto.Vehicle;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
        try {
            int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
            String licensePlate = request.getParameter("licensePlate").toUpperCase();
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String color = request.getParameter("color");

            Vehicle v = new Vehicle();
            v.setVehicleID(vehicleID);
            v.setLicensePlate(licensePlate);
            v.setBrand(brand);
            v.setModel(model);
            v.setColor(color);

            VehicleDAO dao = new VehicleDAO();
            Vehicle oldVehicle = dao.getVehicleByID(vehicleID);
            if (dao.isLPExist(licensePlate, vehicleID)) {
                request.setAttribute("ERROR", "License plate already exists!");
                request.setAttribute("VEHICLE", oldVehicle);
                request.getRequestDispatcher("updateVehicle.jsp").forward(request, response);
                return;
            }
            int rs = dao.updateVehicle(v);
            if (rs > 0) {
                request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
            } else {
                request.setAttribute("ERROR", "Update failed");
                request.setAttribute("VEHICLE", oldVehicle);
                request.getRequestDispatcher("updateVehicle.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "Error: " + e.getMessage());
            request.getRequestDispatcher("updateVehicle.jsp").forward(request, response);
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

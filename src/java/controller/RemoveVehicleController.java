package controller;

import dao.VehicleDAO;
import dto.Account;
import dto.Business;
import dto.Vehicle;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "RemoveVehicleController", urlPatterns = {"/RemoveVehicleController"})
public class RemoveVehicleController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("ACCOUNT") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        try {
            int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
            VehicleDAO dao = new VehicleDAO();
            int result = dao.deleteVehicle(vehicleID);
            if (result > 0) {
                request.setAttribute("SUCCESS", "Remove vehicle successful!");
            } else {
                request.setAttribute("ERROR", "Remove vehicle failed!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "System error: " + e.getMessage());
        }

        if (session.getAttribute("BUS") != null) {
            request.getRequestDispatcher("BusinessDashboardController").forward(request, response);
        } else {
            request.getRequestDispatcher("CustomerDashBoardController").forward(request, response);
        }
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}

package controller;

import dao.VehicleBrandDAO;
import dao.VehicleModelDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.VehicleDataJsonBuilder;

@WebServlet(name = "GetVehicleDataController", urlPatterns = {"/GetVehicleDataController"})
public class GetVehicleDataController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        VehicleBrandDAO brandDAO = new VehicleBrandDAO();
        VehicleModelDAO modelDAO = new VehicleModelDAO();
        try (PrintWriter out = response.getWriter()) {
            out.print(VehicleDataJsonBuilder.buildCatalogJson(
                    brandDAO.getAllBrands(),
                    modelDAO.getAllModels()));
        }
    }
}
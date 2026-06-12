/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.TierDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RemoveTierController", urlPatterns = {"/RemoveTierController"})
public class RemoveTierController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("tierID");

            if (idParam == null || idParam.trim().isEmpty()) {
                showError(request, response, "Invalid tier ID!");
                return;
            }

            int id = Integer.parseInt(idParam);
            TierDAO td = new TierDAO();

            // Gọi hàm remove (thực chất là cập nhật status)
            int result = td.removeTierByID(id);

            if (result > 0) {
                request.setAttribute("success", "Tier has been removed (deactivated) successfully!");
                request.setAttribute("LISTOFTIER", td.getAllTier());
                request.getRequestDispatcher("ManageTiersController").forward(request, response);
            } else {
                showError(request, response, "Failed to remove tier. Please try again!");
            }

        } catch (NumberFormatException e) {
            showError(request, response, "Invalid tier ID format!");
        } catch (Exception e) {
            e.printStackTrace();
            showError(request, response, "System error occurred!");
        }
    }

    private void showError(HttpServletRequest request,
            HttpServletResponse response,
            String msg) throws ServletException, IOException {

        request.setAttribute("error", msg);
        TierDAO td = new TierDAO();
        request.setAttribute("LISTOFTIER", td.getAllTier());
        request.getRequestDispatcher("ManageTiersController").forward(request, response);
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
        return "Remove Tier Controller (Soft Delete)";
    }
}
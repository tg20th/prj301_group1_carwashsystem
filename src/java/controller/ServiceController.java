/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ServicePricesDAO;
import dao.ServicesDAO;
import dao.VehicleTypeDAO;
import dto.Account;
import dto.Service;
import dto.ServicePrices;
import dto.VehicleType;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ServiceController", urlPatterns = {"/ServiceController"})
public class ServiceController extends HttpServlet {

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
        /* TODO output your page here. You may use following sample code. */
        HttpSession session = request.getSession(false);
        Account account = session != null ? (Account) session.getAttribute("ACCOUNT") : null;

        // xu ly khi chua log
        if (account == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        //xu ly khi 0 phai ad
        if (account.getRoleID() != 1) {
            response.sendRedirect("error_page");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }
        if (action.equalsIgnoreCase("list")) {
            ServicesDAO sDAO = new ServicesDAO();
            ServicePricesDAO spDAO = new ServicePricesDAO();
            VehicleTypeDAO vTDAO = new VehicleTypeDAO();

            List<Service> serviceList = sDAO.getAllServices();
            List<VehicleType> vehicleTypeList = vTDAO.getAllActiveVehicleType();

            Map<Integer, List<ServicePrices>> priceMap = new HashMap<>();

            for (Service s : serviceList) {
                List<ServicePrices> prices = spDAO.getPricesByServiceID(s.getId());
                priceMap.put(s.getId(), prices);
            }

            request.setAttribute("SERVICES", serviceList);
            request.setAttribute("PRICE_MAP", priceMap);
            request.setAttribute("VEHICLE_TYPES", vehicleTypeList);

            request.getRequestDispatcher("service-dashboard.jsp").forward(request, response);
            return;
        }

        if (action.equalsIgnoreCase("AddNewService")) {
            VehicleTypeDAO vehicleTypeDAO = new VehicleTypeDAO();
            List<VehicleType> vehicleTypeList = vehicleTypeDAO.getAllActiveVehicleType();

            request.setAttribute("VEHICLE_TYPES", vehicleTypeList);
            request.getRequestDispatcher("edit-service.jsp").forward(request, response);
            return;
        }

        if (action.equalsIgnoreCase("createService")) {
            String serviceName = request.getParameter("serviceName");
            String description = request.getParameter("description");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            Service service = new Service();

            service.setName(serviceName);
            service.setDescription(description);
            service.setStatus(status);

            ServicesDAO servicesDAO = new ServicesDAO();
            int newServiceID = servicesDAO.createService(service);

            if (newServiceID > 0) {
                ServicePricesDAO priceDAO = new ServicePricesDAO();

                String[] vehicleTypeIDList = request.getParameterValues("vehicleTypeID");
                if (vehicleTypeIDList != null) {
                    for (String vTIdRaw : vehicleTypeIDList) {
                        int vehicleTypeID = Integer.parseInt(vTIdRaw);

                        String priceRaw = request.getParameter("price_" + vehicleTypeID);
                        String durationRaw = request.getParameter("duration_" + vehicleTypeID);

                        if (priceRaw != null && durationRaw != null
                                && !priceRaw.trim().isEmpty()
                                && !durationRaw.trim().isEmpty()) {
                            BigDecimal price = new BigDecimal(priceRaw);
                            int duration = Integer.parseInt(durationRaw);

                            if (price.compareTo(BigDecimal.ZERO) <= 0 || duration <= 0) {
                                response.sendRedirect("ServiceController?action=showCreate&error=invalidPrice");
                                return;
                            }

                            ServicePrices sp = new ServicePrices();
                            sp.setServiceID(newServiceID);
                            sp.setVehicleTypeID(vehicleTypeID);
                            sp.setPrice(price);
                            sp.setDurations(duration);

                            priceDAO.createServicePrice(sp);

                        }
                    }
                }
                response.sendRedirect("ServiceController?action=list&saved=true");
                return;
            }
            request.getRequestDispatcher("ServiceController?action=list&error=true").forward(request, response);

        } // end create service

        if (action.equalsIgnoreCase("showEdit")) {
            int serviceID = Integer.parseInt(request.getParameter("id"));

            ServicesDAO serviceDAO = new ServicesDAO();
            VehicleTypeDAO vehicleTypeDAO = new VehicleTypeDAO();
            ServicePricesDAO priceDAO = new ServicePricesDAO();

            Service service = serviceDAO.getServiceByID(serviceID);
            List<VehicleType> vehicleTypes = vehicleTypeDAO.getAllActiveVehicleType();
            List<ServicePrices> servicePrices = priceDAO.getPricesByServiceID(serviceID);

            request.setAttribute("SERVICE", service);
            request.setAttribute("VEHICLE_TYPES", vehicleTypes);
            request.setAttribute("SERVICE_PRICES", servicePrices);

            request.getRequestDispatcher("edit-service.jsp").forward(request, response);
            return;
        }

        if (action.equalsIgnoreCase("update")) {
            int serviceID = Integer.parseInt(request.getParameter("serviceId"));
            String serviceName = request.getParameter("serviceName");
            String description = request.getParameter("description");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            Service service = new Service();
            service.setId(serviceID);
            service.setName(serviceName);
            service.setDescription(description);
            service.setStatus(status);

            ServicesDAO serviceDAO = new ServicesDAO();
            ServicePricesDAO priceDAO = new ServicePricesDAO();

            serviceDAO.updateService(service);

            String[] vehicleTypeIDList = request.getParameterValues("vehicleTypeID");

            if (vehicleTypeIDList != null) {
                for (String vtIdRaw : vehicleTypeIDList) {
                    int vehicleTypeID = Integer.parseInt(vtIdRaw);

                    String priceRaw = request.getParameter("price_" + vehicleTypeID);
                    String durationRaw = request.getParameter("duration_" + vehicleTypeID);

                    if (priceRaw != null && durationRaw != null
                            && !priceRaw.trim().isEmpty()
                            && !durationRaw.trim().isEmpty()) {

                        BigDecimal price = new BigDecimal(priceRaw);
                        int duration = Integer.parseInt(durationRaw);

                        ServicePrices sp = new ServicePrices();
                        sp.setServiceID(serviceID);
                        sp.setVehicleTypeID(vehicleTypeID);
                        sp.setPrice(price);
                        sp.setDurations(duration);

                        int result = priceDAO.updateServicePrice(sp);

                        if (result == 0) {
                            priceDAO.createServicePrice(sp);
                        }
                    }
                }
            }

            response.sendRedirect("ServiceController?action=list&saved=true");
            return;
        }

        if (action.equalsIgnoreCase("deactive")) {
            int serviceID = Integer.parseInt(request.getParameter("id"));

            ServicesDAO servicesDAO = new ServicesDAO();
            servicesDAO.deactiveService(serviceID);

            response.sendRedirect("ServiceController?action=list&statusUpdated=true");
            return;
        }

        if (action.equalsIgnoreCase("active")) {
            int serviceID = Integer.parseInt(request.getParameter("id"));

            ServicesDAO servicesDAO = new ServicesDAO();
            servicesDAO.activeService(serviceID);

            response.sendRedirect("ServiceController?action=list&statusUpdated=true");
            return;
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

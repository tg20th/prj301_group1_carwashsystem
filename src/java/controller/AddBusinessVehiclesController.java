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
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
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
@WebServlet(name = "AddBusinessVehiclesController", urlPatterns = {"/AddBusinessVehiclesController"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 50,
        maxRequestSize = 1024 * 1024 * 200)
public class AddBusinessVehiclesController extends HttpServlet {

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
            Part csvPart = request.getPart("csvFile");
            Part zipPart = request.getPart("zipFile");
            // ========================= // SAVE CSV // ========================= 
            String uploadPath = getServletContext().getRealPath("/") + "businessUploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            String csvName = Paths.get(csvPart.getSubmittedFileName()).getFileName().toString();
            String csvPath = uploadPath + File.separator + csvName;
            csvPart.write(csvPath);
// ========================= // SAVE ZIP // ========================= 
            String zipName = Paths.get(zipPart.getSubmittedFileName()).getFileName().toString();
            String zipPath = uploadPath + File.separator + zipName;
            zipPart.write(zipPath);
// ========================= // EXTRACT ZIP // ========================= 
            String imageFolder = uploadPath + File.separator + "images";
            File imgDir = new File(imageFolder);
            if (!imgDir.exists()) {
                imgDir.mkdir();
            }
            unzip(zipPath, imageFolder);
// ========================= // READ CSV // ========================= 
            BufferedReader br = new BufferedReader(new FileReader(csvPath));
            String line;
            boolean skipHeader = true;
            VehicleDAO dao = new VehicleDAO();
            /*
            int successCount = 0;
            while ((line = br.readLine()) != null) {
                if (skipHeader) {
                    skipHeader = false;
                    continue;
                }
                String[] data = line.split(",");
                String licensePlate = data[0].trim();
                int modelID = Integer.parseInt(data[1].trim());
                String color = data[2].trim();
                Integer year = Integer.parseInt(data[3].trim());
                String imageName = data[4].trim(); // CHECK DUPLICATE 
                if (dao.isLicensePlateExists(licensePlate)) {
                    continue;
                }
                String imageURL = "businessUploads/images/" + imageName;
                Vehicle v = new Vehicle();
                v.setCustomerID(1);
                v.setModelID(modelID);
                
             */
            int successCount = 0;
            Account account = (Account) request.getSession().getAttribute("ACCOUNT");
            if (account == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }
            // --- THÊM MỚI: Lấy CustomerID từ Session ---
            // Load fresh Customer to get reliable cusID (more robust)
            CustomerDAO cusDAO = new CustomerDAO();
            Customer customer = cusDAO.getCustomerByAccountID(account.getAccountID());
            if (customer == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }
            int cusID = customer.getCusID();
            // -------------------------------------------

            while ((line = br.readLine()) != null) {
                if (skipHeader) {
                    skipHeader = false;
                    continue;
                }
                String[] data = line.split(",");
                String licensePlate = data[0].trim();
                int modelID = Integer.parseInt(data[1].trim());
                String color = data[2].trim();
                Integer year = Integer.parseInt(data[3].trim());
                String imageName = data[4].trim(); // CHECK DUPLICATE 

                if (dao.isLicensePlateExists(licensePlate)) {
                    continue;
                }
                String imageURL = "businessUploads/images/" + imageName;
                Vehicle v = new Vehicle();

                // --- SỬA Ở ĐÂY: Dùng biến currentCustomerID thay vì gán cứng 1 ---
                v.setCustomerID(cusID);
                v.setModelID(modelID);
                v.setLicensePlate(licensePlate);
                v.setColor(color);
                v.setManufactureYear(year);
                v.setImageURL(imageURL);
                v.setStatus("Pending");
                int result = dao.createVehicle(v);
                if (result > 0) {
                    successCount++;
                }
            }
            br.close();
            request.setAttribute("SUCCESS", "Uploaded " + successCount + " vehicles successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "Upload failed");
            request.getRequestDispatcher("addBusinessVehicle.jsp").forward(request, response);
        }
        request.getRequestDispatcher("MainController?action=BusinessDashboard").forward(request, response);
    } // ========================= // UNZIP METHOD // =========================

    private void unzip(String zipFilePath, String destDirectory) throws IOException {
        File destDir = new File(destDirectory);
        if (!destDir.exists()) {
            destDir.mkdir();
        }
        ZipInputStream zipIn = new ZipInputStream(new FileInputStream(zipFilePath));
        ZipEntry entry = zipIn.getNextEntry();
        while (entry != null) {
            String filePath = destDirectory + File.separator + entry.getName();
            if (!entry.isDirectory()) {
                extractFile(zipIn, filePath);
            }
            zipIn.closeEntry();
            entry = zipIn.getNextEntry();
        }
        zipIn.close();
    }

    private void extractFile(ZipInputStream zipIn, String filePath) throws IOException {
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(filePath));
        byte[] bytesIn = new byte[4096];
        int read;
        while ((read = zipIn.read(bytesIn)) != -1) {
            bos.write(bytesIn, 0, read);
        }
        bos.close();
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

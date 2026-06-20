/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.VehicleDAO;
import dao.VehicleModelDAO;
import dbutils.LicensePlateUtils;
import dto.Account;
import dto.Business;
import dto.Customer;
import dto.Vehicle;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            Account account = (Account) request.getSession().getAttribute("ACCOUNT");
            if (account == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }
            Business business = (Business) request.getSession().getAttribute("BUS");
            if (business == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }

            CustomerDAO cusDAO = new CustomerDAO();
            Customer customer = cusDAO.getCustomerByAccountID(account.getAccountID());
            if (customer == null) {
                response.sendRedirect("MainController?action=home");
                return;
            }
            int cusID = customer.getCusID();

            Part csvPart = request.getPart("csvFile");
            Part zipPart = request.getPart("zipFile");
            if (csvPart == null || csvPart.getSize() == 0) {
                request.setAttribute("ERROR", "Please upload a CSV file.");
                request.getRequestDispatcher("addBusinessVehicle.jsp").forward(request, response);
                return;
            }
            if (zipPart == null || zipPart.getSize() == 0) {
                request.setAttribute("ERROR", "Please upload a ZIP file containing vehicle images.");
                request.getRequestDispatcher("addBusinessVehicle.jsp").forward(request, response);
                return;
            }

            String uploadPath = getServletContext().getRealPath("/") + "businessUploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String csvName = Paths.get(csvPart.getSubmittedFileName()).getFileName().toString();
            String csvPath = uploadPath + File.separator + csvName;
            csvPart.write(csvPath);

            String zipName = Paths.get(zipPart.getSubmittedFileName()).getFileName().toString();
            String zipPath = uploadPath + File.separator + zipName;
            zipPart.write(zipPath);

            String imageFolder = uploadPath + File.separator + "images";
            File imgDir = new File(imageFolder);
            if (!imgDir.exists()) {
                imgDir.mkdir();
            }
            unzip(zipPath, imageFolder);

            VehicleDAO dao = new VehicleDAO();
            VehicleModelDAO modelDAO = new VehicleModelDAO();
            int successCount = 0;
            int skippedCount = 0;
            int duplicateCount = 0;

            try (BufferedReader br = new BufferedReader(new FileReader(csvPath))) {
                String line;
                boolean skipHeader = true;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    if (skipHeader) {
                        skipHeader = false;
                        continue;
                    }

                    String[] data = line.split(",", -1);
                    if (data.length < 6) {
                        skippedCount++;
                        continue;
                    }

                    String licensePlate = LicensePlateUtils.normalize(data[0]);
                    String brandName = data[1].trim();
                    String modelName = data[2].trim();
                    String color = data[3].trim();
                    String yearStr = data[4].trim();
                    String imageName = data[5].trim();

                    if (!LicensePlateUtils.isValid(licensePlate)) {
                        skippedCount++;
                        continue;
                    }

                    Integer modelID = modelDAO.getModelIDByBrandAndModel(brandName, modelName);
                    if (modelID == null) {
                        skippedCount++;
                        continue;
                    }

                    Integer year;
                    try {
                        year = yearStr.isEmpty() ? null : Integer.parseInt(yearStr);
                    } catch (NumberFormatException ex) {
                        skippedCount++;
                        continue;
                    }

                    if (dao.isLicensePlateExists(licensePlate)) {
                        duplicateCount++;
                        continue;
                    }

                    String imageURL = "businessUploads/images/" + imageName;
                    Vehicle v = new Vehicle();
                    v.setCustomerID(cusID);
                    v.setModelID(modelID);
                    v.setLicensePlate(licensePlate);
                    v.setColor(color);
                    v.setManufactureYear(year);
                    v.setImageURL(imageURL);
                    v.setStatus("Pending");

                    if (dao.createVehicle(v) > 0) {
                        successCount++;
                    }
                }
            }

            StringBuilder message = new StringBuilder();
            if (successCount > 0) {
                message.append("Uploaded ").append(successCount).append(" vehicle(s) successfully.");
            } else {
                message.append("No vehicles were added.");
            }
            if (skippedCount > 0) {
                message.append(" Skipped ").append(skippedCount)
                        .append(" row(s) with invalid data (check license plate format 63A-12345, brand/model names, or CSV columns).");
            }
            if (duplicateCount > 0) {
                message.append(" Skipped ").append(duplicateCount).append(" duplicate license plate(s).");
            }

            if (successCount > 0) {
                request.getSession().setAttribute("UPLOAD_MSG", message.toString());
                response.sendRedirect("BusinessDashboardController");
            } else {
                request.setAttribute("ERROR", message.toString());
                request.getRequestDispatcher("addBusinessVehicle.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "Upload failed: " + e.getMessage());
            request.getRequestDispatcher("addBusinessVehicle.jsp").forward(request, response);
        }
    }

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("MainController?action=AddBusinessVehicle_page");
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
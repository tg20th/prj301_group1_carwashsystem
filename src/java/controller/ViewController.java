package controller;

import dao.TierDAO;
import dto.Customer;
import dto.Tier;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lan
 */
@WebServlet(name = "ViewController", urlPatterns = {"/ViewController"})
public class ViewController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            Customer cus = (Customer) request.getSession().getAttribute("CUSTOMER");
            if (cus != null) {
                int cusID = cus.getCusID();
                int tierID = cus.getTierID();
                TierDAO t = new TierDAO();
                Tier currentTier = t.getTier(tierID);
                Tier nextTier = null;
                if (currentTier != null) {
                    nextTier = t.getTier(tierID + 1);
                }
                request.setAttribute("customer", cus);
                request.setAttribute("currentTier", currentTier);
                request.setAttribute("nextTier", nextTier);
                request.getRequestDispatcher("view.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("index.html").forward(request, response);
            }
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

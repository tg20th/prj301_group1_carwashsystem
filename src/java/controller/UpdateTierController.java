package controller;

import dao.TierDAO;
import dto.Tier;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateTierController", urlPatterns = {"/UpdateTierController"})
public class UpdateTierController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); // Đảm bảo nhận tiếng Việt từ form không bị lỗi font

        try {
            // GIỮ NGUYÊN KIỂU DỮ LIỆU BAN ĐẦU CỦA BẠN
            int id = Integer.parseInt(request.getParameter("tierID"));
            String name = request.getParameter("tierName");
            String description = request.getParameter("description");
            int minSpend = Integer.parseInt(request.getParameter("minSpend"));
            double pointRate = Double.parseDouble(request.getParameter("pointRate"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            TierDAO td = new TierDAO();

            // Lấy danh sách tier
            List<Tier> list = td.getAllTier();

            int previousMinSpend = getMinSpendPrevious(id, list);
            int nextMinSpend = getMinSpendNext(id, list);

            // Validate
            if (minSpend < 0) {
                showError(request, response, "Min Spend must be greater than or equal to 0.");
                return;
            }

            if (minSpend <= previousMinSpend) {
                showError(request, response,
                        "Min Spend must be greater than previous tier (" + previousMinSpend + ").");
                return;
            }

            if (minSpend >= nextMinSpend) {
                showError(request, response,
                        "Min Spend must be less than next tier (" + nextMinSpend + ").");
                return;
            }

            // Update
            int result = td.updateTier( id, name, minSpend, pointRate, description, status);

            
            if (result > 0) {
                request.setAttribute("success", "Update tier successfully!"); 
                request.setAttribute("LISTOFTIER", td.getAllTier());
                request.getRequestDispatcher("ManageTiersController").forward(request, response);
                return; 
            } else {
                showError(request, response, "Update failed. Please try again.");
                return; 
            }

        } catch (NumberFormatException e) {
            showError(request, response, "Invalid input format.");
        } catch (Exception e) {
            e.printStackTrace();
            showError(request, response, "System error.");
        }
    }

    private void showError(HttpServletRequest request,
            HttpServletResponse response,
            String msg)
            throws ServletException, IOException {
        request.setAttribute("isEditMode", true);

        request.setAttribute("error", msg);

        TierDAO td = new TierDAO();
        request.setAttribute("LISTOFTIER", td.getAllTier());

        request.getRequestDispatcher("ManageTiersController")
                .forward(request, response);
    }

    private int getMinSpendPrevious(int id, List<Tier> list) {
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getTierID() == id) {
                // Tier đầu tiên
                if (i == 0) {
                    return Integer.MIN_VALUE;
                }
                return list.get(i - 1).getMinSpend();
            }
        }
        return Integer.MIN_VALUE;
    }

    private int getMinSpendNext(int id, List<Tier> list) {
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getTierID() == id) {
                // Tier cuối cùng
                if (i == list.size() - 1) {
                    return Integer.MAX_VALUE;
                }
                return list.get(i + 1).getMinSpend();
            }
        }
        return Integer.MAX_VALUE;
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
        return "Update Tier Controller";
    }
}
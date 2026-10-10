package servlet;

import da.ReportDA;
import entity.Report;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class ReportServlet extends HttpServlet {

    @EJB
    private ReportDA reportDA;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get max products for the form dropdown
            int maxProducts = reportDA.getMaxProductCount();
            request.setAttribute("maxProducts", maxProducts);
            
            // Forward to report.jsp
            request.getRequestDispatcher("./manager/report.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(response, "Error loading report page: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String topSoldParam = request.getParameter("topSold");

            if (fromDate != null && toDate != null) {
                handleSalesReport(request, response, fromDate, toDate);
            } else if (topSoldParam != null) {
                handleTopProductsReport(request, response, topSoldParam);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report request");
            }
        } catch (Exception e) {
            handleError(response, "Error generating report: " + e.getMessage());
        }
    }

    private void handleSalesReport(HttpServletRequest request, HttpServletResponse response, 
                                  String fromDate, String toDate) 
            throws ServletException, IOException {
        Map<String, Double> salesData = reportDA.generateSalesReportByDateRange(fromDate, toDate);
        
        // Sort dates and prepare chart data
        List<String> sortedDates = new ArrayList<>(salesData.keySet());
        Collections.sort(sortedDates);
        
        List<Double> chartData = new ArrayList<>();
        double totalSales = 0.0;
        
        for (String date : sortedDates) {
            Double amount = salesData.get(date);
            chartData.add(amount);
            totalSales += amount != null ? amount : 0.0;
        }

        request.setAttribute("reportTitle", "Sales Report from " + fromDate + " to " + toDate);
        request.setAttribute("reportSubtitle", "Daily Sales Breakdown");
        request.setAttribute("chartLabels", sortedDates);
        request.setAttribute("chartData", chartData);
        request.setAttribute("totalSales", totalSales);
        request.setAttribute("reportType", "daily");
        
        request.getRequestDispatcher("./manager/reportResult.jsp").forward(request, response);
    }

    private void handleTopProductsReport(HttpServletRequest request, HttpServletResponse response,
                                        String topSoldParam) 
            throws ServletException, IOException {
        try {
            int topSold = Integer.parseInt(topSoldParam);
            List<Report> topProducts = reportDA.generateTopSoldProductsReport(topSold);
            
            request.setAttribute("reportData", topProducts);
            request.setAttribute("reportType", "products");
            request.setAttribute("reportTitle", "Top " + topSold + " Products Report");
            request.setAttribute("reportSubtitle", "Based on Total Quantity Sold");
            
            request.getRequestDispatcher("./manager/reportResult.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format for top products");
        }
    }

    private void handleError(HttpServletResponse response, String message) throws IOException {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, message);
    }
}
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../include/adminHeader.jsp" />
<%@ page import="entity.Report" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    entity.Users user = (entity.Users) session.getAttribute("user");

    if (user == null || !user.getRole().equals("MANAGER")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    DecimalFormat df = new DecimalFormat("#,##0.00");
%>

<style>


    .container {
        font-family: 'Arial', sans-serif;
    }

    .report-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        padding: 30px;
        margin-bottom: 30px;
    }

    .report-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        border-bottom: 1px solid #e5e5e5;
        padding-bottom: 15px;
    }

    .report-title {
        font-size: 24px;
        font-weight: bold;
        color: #333;
    }

    .report-subtitle {
        font-size: 18px;
        color: #666;
        margin-top: 5px;
    }

    .chart-container {
        position: relative;
        height: 400px;
        margin-bottom: 30px;
    }

    .data-summary {
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 15px;
        margin-top: 20px;
        border: 1px solid #e5e5e5;
    }

    .summary-title {
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }

    .summary-value {
        font-size: 20px;
        font-weight: bold;
        color: #28a745;
    }

    .table-container {
        margin-top: 30px;
    }

    .action-buttons {
        margin-top: 20px;
        display: flex;
        gap: 10px;
    }

    .btn-export {
        background-color: #28a745;
        color: white;
        padding: 8px 16px;
        border-radius: 5px;
        text-decoration: none;
        font-weight: bold;
        transition: background-color 0.3s;
    }

    .btn-export:hover {
        background-color: #218838;
        color: white;
    }

    .btn-back {
        background-color: #6c757d;
        color: white;
        padding: 8px 16px;
        border-radius: 5px;
        text-decoration: none;
        font-weight: bold;
        transition: background-color 0.3s;
    }

    .btn-back:hover {
        background-color: #5a6268;
        color: white;
    }

    #reportTable th, #reportTable td {
        vertical-align: middle;
    }

    @media print {
        .no-print {
            display: none;
        }
    }

    .page-break {
        page-break-before: always;
    }

    /* Ensure page content doesn't overflow in PDF */
    .pdf-page {
        page-break-inside: avoid;
    }
    
</style>

<div class="container mt-5" id="reportContent">
    <div class="report-container">
        <div class="report-header">
            <div>
                <h2 class="report-title">${reportTitle}</h2>
                <p class="report-subtitle">${reportSubtitle}</p>
            </div>
            <div class="action-buttons no-print">
                <button id="exportPDF" class="btn btn-export">Export to PDF</button>
                <a href="ReportServlet" class="btn btn-back">Back to Reports</a>
            </div>
        </div>

        <c:choose>
            <%-- Sales Report with Chart --%>
            <c:when test="${reportType == 'monthly' || reportType == 'weekly' || reportType == 'daily'}">
                <div class="chart-container pdf-page" id="reportPageChart">
                    <canvas id="salesChart"></canvas>
                </div>

                <div class="row pdf-page page-break" id="reportPageDetails">
                    <div class="col-md-4">
                        <div class="data-summary">
                            <div class="summary-title">Total Sales</div>
                            <div class="summary-value">RM <fmt:formatNumber value="${totalSales}" pattern="#,##0.00"/></div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="table-container">
                            <table class="table table-bordered table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Period</th>
                                        <th>Sales Amount</th>
                                        <th>% of Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="label" items="${chartLabels}" varStatus="status">
                                        <tr>
                                            <td>${label}</td>
                                            <td>RM <fmt:formatNumber value="${chartData[status.index]}" pattern="#,##0.00"/></td>
                                            <td>
                                                <c:if test="${totalSales > 0}">
                                                    <fmt:formatNumber value="${(chartData[status.index] / totalSales) * 100}" pattern="#,##0.00"/>%
                                                </c:if>
                                                <c:if test="${totalSales == 0}">
                                                    0.00%
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr class="table-light">
                                        <th>Total</th>
                                        <th>RM <fmt:formatNumber value="${totalSales}" pattern="#,##0.00"/></th>
                                        <th>100.00%</th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </c:when>

            <%-- Top Products Report with Table --%>
            <c:when test="${reportType == 'products'}">
                <div class="table-container">
                    <!-- Make the table responsive on small screens -->
                    <div class="table-responsive">
                        <table id="reportTable" class="table table-striped table-bordered table-hover table">
                            <thead class="table-dark">
                                <tr class="text-center">
                                    <th>Rank</th>
                                    <th>Product ID</th>
                                    <th>Product Name</th>
                                    <th>Total Sold</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="report" items="${reportData}" varStatus="status">
                                    <tr class="text-center">
                                        <td class="fw-bold">${status.index + 1}</td>
                                        <td>${report.productId}</td>
                                        <td>${report.productName}</td>
                                        <td>${report.totalSold}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </c:when>
        </c:choose>
    </div>
</div>

<script>


    // Initialize Chart.js for sales reports
    if (document.getElementById('salesChart')) {
        const ctx = document.getElementById('salesChart').getContext('2d');

        // Get data from JSP
        const chartLabels = [<c:forEach var="label" items="${chartLabels}" varStatus="status">'${label}'<c:if test="${!status.last}">, </c:if></c:forEach>];
                const chartData = [<c:forEach var="value" items="${chartData}" varStatus="status">${value}<c:if test="${!status.last}">, </c:if></c:forEach>];

        // Create gradient for area chart
        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(54, 162, 235, 0.8)');
        gradient.addColorStop(1, 'rgba(54, 162, 235, 0.1)');

        // Create the chart
        const salesChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: chartLabels,
                datasets: [{
                        label: 'Sales (RM) ',
                        data: chartData,
                        backgroundColor: gradient,
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 2,
                        pointBackgroundColor: 'rgba(54, 162, 235, 1)',
                        pointBorderColor: '#fff',
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        fill: true,
                        tension: 0.4
                    }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return 'RM' + value.toLocaleString();
                            }
                        }
                    }
                },
                plugins: {
                    title: {
                        display: true,
                        text: '${reportTitle}',
                        font: {
                            size: 18
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return 'Sales: RM' + context.raw.toLocaleString();
                            }
                        }
                    },
                    legend: {
                        display: false
                    }
                }
            }
        });
    }

    // Export to PDF functionality
    document.getElementById('exportPDF').addEventListener('click', function () {
        const actionButtons = document.querySelector('.action-buttons');
        const element = document.getElementById('reportContent');
        const reportContainer = document.querySelector('#reportContent');

        // Optional: attempt to find chart elements (may not exist)
        const chartContainer = document.querySelector('.chart-container');
        const canvas = document.querySelector('#salesChart');

        // Backup original styles
        const originalMargin = reportContainer.style.marginTop;
        const originalPadding = reportContainer.style.paddingTop;
        reportContainer.style.marginTop = '0';
        reportContainer.style.paddingTop = '0';

        let originalCanvasWidth, originalCanvasHeight;

        // Fix canvas/chart size if chart exists
        if (canvas && chartContainer) {
            originalCanvasWidth = canvas.style.width;
            originalCanvasHeight = canvas.style.height;

            canvas.style.width = '1000px';
            canvas.style.height = '400px';
            chartContainer.style.width = '1000px';
            chartContainer.style.height = '400px';
        }

        // Hide buttons
        actionButtons.style.display = 'none';

        // Wait before generating the PDF
        setTimeout(() => {
            const now = new Date();
            const opt = {
                margin: 10,
                filename: `${reportTitle}_${reportSubtitle}_${now.getTime()}.pdf`,
                image: {type: 'jpeg', quality: 0.98},
                html2canvas: {scale: 2},
                jsPDF: {unit: 'mm', format: 'a4', orientation: 'landscape'},
                pagebreak: {mode: ['css', 'legacy']}
            };

            html2pdf().set(opt).from(element).save().then(() => {
                // Restore chart size if needed
                if (canvas && chartContainer) {
                    canvas.style.width = originalCanvasWidth;
                    canvas.style.height = originalCanvasHeight;
                    chartContainer.style.width = '';
                    chartContainer.style.height = '';
                }

                reportContainer.style.marginTop = originalMargin;
                reportContainer.style.paddingTop = originalPadding;
                actionButtons.style.display = 'flex'; // Restore button visibility
            });
        }, 500);
    });



</script>

<jsp:include page="../include/adminFooter.jsp" />
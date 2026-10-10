package entity;

public class Report {

    private String reportType;
    private Double amount;      
    private Integer productId; 
    private String productName;
    private Long totalSold;   

    // Constructor for 'Sales Report' (Day, Month, Year)
    public Report(String reportType, Double amount) {
        this.reportType = reportType;
        this.amount = amount;
    }

    // Constructor for 'Top Sold Products Report'
    public Report(Integer productId, String productName, Long totalSold) {
        this.productId = productId;
        this.productName = productName;
        this.totalSold = totalSold;
    }

    // Getters and Setters

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Long getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(Long totalSold) {
        this.totalSold = totalSold;
    }

    @Override
    public String toString() {
        if (reportType != null) {
            return "Report Type: " + reportType + ", Amount: " + amount;
        }
        return "Product: " + productName + ", Total Sold: " + totalSold;
    }
}

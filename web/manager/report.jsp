<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../include/adminHeader.jsp" />

<style>
    :root {
        --primary-color: #2563eb;
        --secondary-color: #1e40af;
        --accent-color: #60a5fa;
        --text-dark: #1f2937;
        --text-light: #6b7280;
    }


    .report-card {
        font-family: 'Inter', sans-serif;
        border: none;
        border-radius: 1rem;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        height: 100%;
        display: flex;
        flex-direction: column;
        padding: 1.5rem;
        background-color: #f3f4f6;
    }

    .report-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
    }

    .card-title {
        color: var(--text-dark);
        font-weight: 600;
        font-size: 1.25rem;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .card-title i {
        font-size: 1.5rem;
        color: var(--primary-color);
    }

    .card-text {
        color: var(--text-light);
        font-size: 0.875rem;
        margin-bottom: 1.5rem;
    }

    .date-filters {
        border-radius: 0.5rem;
    }

    .filter-group {
        margin-bottom: 1rem;
    }

    .filter-group label {
        font-size: 0.875rem;
        font-weight: 500;
        color: var(--text-light);
    }

    .form-select, .form-control {
        border: 2px solid #e2e8f0;
        border-radius: 0.5rem;
        padding: 0.75rem 1rem;
        transition: border-color 0.2s ease;
    }

    .form-select:focus, .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: none;
    }

    .btn-primary {
        background-color: var(--primary-color);
        border: none;
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        font-weight: 500;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-primary:hover {
        background-color: var(--secondary-color);
        transform: translateY(-2px);
    }

    @media (max-width: 768px) {
        .date-filter-controls {
            flex-direction: column;
        }

        .filter-group {
            width: 100%;
        }
    }
</style>

<div class="container p-5">
    <h2 class="text-center mb-5 display-5 fw-600 text-dark">Reporting Dashboard</h2>
    <div class="row g-4">
        <!-- Sales Report Card -->
        <div class="col-lg-6">
            <form action="ReportServlet" method="post" id="salesReportForm">
                <div class="report-card">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="bi bi-graph-up-arrow"></i>
                            Sales Report
                        </h5>
                        <p class="card-text">
                            Analyze sales trends with interactive visual reports. Select date range to generate 
                            detailed revenue charts and growth metrics.
                        </p>
                        <div class="date-filters">
                            <div class="date-filter-controls d-flex gap-3 mb-4">
                                <div class="filter-group flex-grow-1">
                                    <label class="mb-2">From Date</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-end-0">
                                            📅
                                        </span>
                                        <input type="date" class="form-control" name="fromDate" required id="fromDateInput">
                                    </div>
                                </div>
                                <div class="filter-group flex-grow-1">
                                    <label class="mb-2">To Date</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-end-0">
                                            📅
                                        </span>
                                        <input type="date" class="form-control" name="toDate" required id="toDateInput">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-auto">
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-file-bar-graph me-2"></i>
                            Generate Sales Report
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Top Products Card -->
        <div class="col-lg-6">
            <form action="ReportServlet" method="post">
                <div class="report-card">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="bi bi-trophy-fill"></i>
                            Top Product Report
                        </h5>
                        <p class="card-text">
                            Discover top-performing products based on sales volume and revenue contribution.
                            Customize the number of products to display.
                        </p>
                        <div class="filter-group">
                            <label class="mb-2">Number of Top Products</label>
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-end-0">
                                    <i class="bi bi-123"></i>
                                </span>
                                <input type="number" class="form-control" id="topSold" name="topSold" 
                                       min="1" max="${maxProducts}" value="${maxProducts}" required>
                            </div>
                            <div class="range-container" style="display: flex; justify-content: space-between; align-items: center;">
                                <span>1</span>
                                <input type="range" class="form-control-range" id="topSoldSlider" min="1" max="${maxProducts}" value="${maxProducts}" oninput="updateNumberOfProducts(this.value)" style="flex-grow: 1;">
                                <span>${maxProducts}</span>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-auto">
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-list-ol me-2"></i>
                            Generate Rankings
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Add dynamic date placeholder
    document.addEventListener('DOMContentLoaded', function () {
        const dateInputs = document.querySelectorAll('input[type="date"]');
        dateInputs.forEach(input => {
            input.addEventListener('focus', () => {
                input.parentElement.parentElement.style.borderColor = '#2563eb';
            });
            input.addEventListener('blur', () => {
                input.parentElement.parentElement.style.borderColor = '#e2e8f0';
            });
        });
    });
</script>

<script>
    // Get today's date in YYYY-MM-DD format
    const today = new Date().toISOString().split('T')[0];

    const firstOfMonth = new Date(today);
    firstOfMonth.setDate(1);  // Set the date to the first day of the month
    const firstOfMonthStr = firstOfMonth.toISOString().split('T')[0];

    const fromDateInput = document.getElementById('fromDateInput');
    fromDateInput.setAttribute('max', today);  // Set the max date for fromDate input
    fromDateInput.value = firstOfMonthStr;    // Set the default value to the first day of the current month

    // Set the 'max' and 'value' attributes of the input field
    const toDateInput = document.getElementById('toDateInput');
    toDateInput.setAttribute('max', today);  // Set the max date to today
    toDateInput.value = today;               // Set the default date to today

    function updateNumberOfProducts(value) {
        document.getElementById('topSold').value = value;
    }
</script>

<jsp:include page="../include/adminFooter.jsp" />
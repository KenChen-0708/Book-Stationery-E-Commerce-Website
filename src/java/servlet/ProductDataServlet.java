package servlet;

import da.ProductDA;
import entity.Product;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.List;

@MultipartConfig
@WebServlet("/ProductDataServlet")
public class ProductDataServlet extends HttpServlet {

    @EJB
    private ProductDA productDA;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String selectedMainCategory = request.getParameter("mainCategory");
        String selectedSubCategory = request.getParameter("subCategory");

        // Filter product list based on selected category/subcategory
        List<Product> productList = productDA.findByCategory(selectedMainCategory, selectedSubCategory);

        List<String> mainCategories = productDA.getAllDistinctMainCategories();
        List<String> subCategories;

        // For cascading dropdowns
        if (selectedMainCategory != null && !selectedMainCategory.isEmpty()) {
            subCategories = productDA.getSubCategoriesByMain(selectedMainCategory);
        } else {
            subCategories = productDA.getAllDistinctSubCategories();
        }

        request.setAttribute("mainCategoryList", mainCategories);
        request.setAttribute("subCategoryList", subCategories);
        request.setAttribute("selectedMainCategory", selectedMainCategory);
        request.setAttribute("selectedSubCategory", selectedSubCategory);
        request.setAttribute("productList", productList);

        request.getRequestDispatcher("./manager/product_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // --- Filtering request ---
        if (action == null) {
            // This is a filter request
            String idParam = request.getParameter("id");
            String nameParam = request.getParameter("name");
            String priceParam = request.getParameter("price");
            String stockParam = request.getParameter("stock");
            String selectedMainCategory = request.getParameter("mainCategory");
            String selectedSubCategory = request.getParameter("subCategory");

            List<Product> productList = productDA.findAll(); // or filter based on your own logic

            // Optional: apply filtering manually if not done in DB (use a query method if needed)
            if (selectedMainCategory != null && !selectedMainCategory.isEmpty()) {
                productList = productDA.findByCategory(selectedMainCategory, selectedSubCategory);
            }

            List<String> mainCategories = productDA.getAllDistinctMainCategories();
            List<String> subCategories = selectedMainCategory != null && !selectedMainCategory.isEmpty()
                    ? productDA.getSubCategoriesByMain(selectedMainCategory)
                    : productDA.getAllDistinctSubCategories();

            request.setAttribute("mainCategoryList", mainCategories);
            request.setAttribute("subCategoryList", subCategories);
            request.setAttribute("selectedMainCategory", selectedMainCategory);
            request.setAttribute("selectedSubCategory", selectedSubCategory);
            request.setAttribute("productList", productList);

            // Preserve filter inputs
            request.setAttribute("id", idParam);
            request.setAttribute("name", nameParam);
            request.setAttribute("price", priceParam);
            request.setAttribute("stock", stockParam);

            request.getRequestDispatcher("./manager/product_list.jsp").forward(request, response);
            return;
        }

        // --- Deletion ---
        if ("delete".equals(action)) {
            int deleteId = Integer.parseInt(request.getParameter("id"));
            productDA.delete(deleteId);
            response.sendRedirect("ProductDataServlet");
            return;
        }

        // --- Creation/Update ---
        Product p = new Product();
        p.setName(request.getParameter("name"));
        p.setDescription(request.getParameter("description"));
        p.setPrice(new BigDecimal(request.getParameter("price")));
        p.setStock(Integer.parseInt(request.getParameter("stock")));
        p.setCategoryMain(request.getParameter("categoryMain"));
        p.setCategorySub(request.getParameter("categorySub"));

        Part imagePart = request.getPart("image");
        String fileName = imagePart != null ? Paths.get(imagePart.getSubmittedFileName()).getFileName().toString() : "";

        if (imagePart != null && imagePart.getSize() > 0 && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("/assets/img");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File outputFile = new File(uploadDir, fileName);
            try (InputStream input = imagePart.getInputStream(); OutputStream out = new FileOutputStream(outputFile)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                p.setImageUrl(fileName);
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            p.setImageUrl(request.getParameter("existingImage"));
        }

        if ("edit".equals(action)) {
            p.setProductId(Integer.parseInt(request.getParameter("id")));
            productDA.update(p);
        } else {
            productDA.create(p);
        }

        response.sendRedirect("ProductDataServlet");
    }

}

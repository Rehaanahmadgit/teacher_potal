
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.xml.crypto.dsig.spec.XPathType;
import java.awt.image.FilteredImageSource;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.LogRecord;

@WebFilter(urlPatterns = "/login")
public class filter_stu_tech implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;

        String name = req.getParameter("name");
        int roll = Integer.parseInt(req.getParameter("password")); // Assuming the parameter name is roll_number
        String userType = req.getParameter("role");

        HttpSession session = req.getSession();
        session.setAttribute("nameperson", name);
        session.setAttribute("studentId", roll);

        String sql = "SELECT * FROM login_potal WHERE roll_num = ?";
        Connection con = data_con.getConnection();
        String namedata = null;
        int rolldata = 0;

        try (
                PreparedStatement preparedStatement = con.prepareStatement(sql)) {
            preparedStatement.setInt(1, roll);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                namedata = rs.getString("name");
                rolldata = rs.getInt("roll_num"); // Assuming the column name is roll_num
            }
        } catch (Exception e) {
            System.out.println("Error fetching data from database login_potal: " + e.getMessage());
        }

        if (namedata != null && rolldata != 0) {
            if (name.equals(namedata) && roll == rolldata&& userType.equalsIgnoreCase("teacher")) {
                filterChain.doFilter(servletRequest, servletResponse);
            }else if (name.equals(namedata) && roll == rolldata&& userType.equalsIgnoreCase("student")){
                resp.sendRedirect("student_marks.jsp");
            }else {
                resp.sendRedirect("error.html");
            }
        } else {
            resp.sendRedirect("error.html");
        }
    }
}


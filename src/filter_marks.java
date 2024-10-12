import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebFilter(urlPatterns = "/marks")
public class filter_marks implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
       int rol1=Integer.valueOf(servletRequest.getParameter("rollNumber"));
       String name=servletRequest.getParameter("studentName");
        int math=Integer.valueOf(servletRequest.getParameter("mathMarks"));
        int sci=Integer.valueOf(servletRequest.getParameter("scienceMarks"));
        int computer=Integer.valueOf(servletRequest.getParameter("computerMarks"));
        int english=Integer.valueOf(servletRequest.getParameter("englishMarks"));
        int sst=Integer.valueOf(servletRequest.getParameter("sstMarks"));


        String sql = "insert into student_marks (math,science,computer,english,SST ,roll_num,name) values (?,?,?,?,?,?,?)";
        String sql_log="insert into login_potal (name,roll_num) values(?,?)";
        Connection con = data_con.getConnection();
          try (
                  PreparedStatement preparedStatement_log=con.prepareStatement(sql_log);
                PreparedStatement preparedStatement = con.prepareStatement(sql)) {
            preparedStatement.setInt(1, math);
             preparedStatement.setInt(2,sci );
            preparedStatement.setInt(3,computer );
            preparedStatement.setInt(4,english );
            preparedStatement.setInt(5, sst);
            preparedStatement.setInt(6,rol1 );
            preparedStatement.setString(7,name);
            preparedStatement_log.setString(1,name);
            preparedStatement_log.setInt(2,rol1);

            preparedStatement.executeUpdate();
            preparedStatement_log.executeUpdate();
            con.close();
        } catch (Exception e) {
            System.out.println("Error fetching data from database login_potal: " + e.getMessage());
        }
        filterChain.doFilter(servletRequest,servletResponse);

    }

    }


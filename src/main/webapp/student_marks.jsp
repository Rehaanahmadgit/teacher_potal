<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Results</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #e0f7fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
            text-align: center;
        }
        .container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            max-width: 600px;
            width: 90%;
            padding: 40px;
            animation: fadeIn 1s ease-in-out;
            border: 1px solid #00838f;
        }
        h1 {
            color: #00838f;
            margin-bottom: 20px;
            font-size: 28px;
            text-transform: uppercase;
        }
        p {
            color: #333;
            margin-bottom: 30px;
            font-size: 18px;
        }
        .results {
            text-align: left;
            margin: 20px 0;
        }
        .result-item {
            margin: 10px 0;
            font-size: 18px;
            color: #555;
        }
        .total, .percentage {
            font-weight: bold;
            font-size: 22px;
            color: #00838f;
            margin: 10px 0;
        }
        .percentage {
            color: #e91e63;
        }
        .btn {
            padding: 12px 25px;
            background-color: #00838f;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            margin-top: 20px;
            transition: background-color 0.3s ease-in-out;
            text-transform: uppercase;
        }
        .btn:hover {
            background-color: #006064;
        }

        @keyframes fadeIn {
            0% { opacity: 0; }
            100% { opacity: 1; }
        }

    </style>
</head>
<body>

<div class="container">
    <h1>Exam Results</h1>

    <%
        // Retrieve session information (Assume studentId is stored in session)
        Integer studentId = (Integer) session.getAttribute("studentId");

        if (studentId != null) {
            // Database connection setup
            String dbURL = "jdbc:mysql://localhost:3306/b_tech";
            String dbUser = "root";
            String dbPass = "9336119497";

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            int totalMarks = 0;
            double percentage = 0.0;

            try {
                // Load MySQL JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish the connection
                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                // Query to fetch student marks based on the studentId
                String sql = "SELECT name, roll_num, math, science, computer, english, SST FROM student_marks WHERE roll_num = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, studentId); // Use studentId instead of student_marks
                rs = stmt.executeQuery();

                if (rs.next()) {
                    String studentName = rs.getString("name");
                    String rollNumber = rs.getString("roll_num");
                    int mathMarks = rs.getInt("math");
                    int scienceMarks = rs.getInt("science");
                    int computerMarks = rs.getInt("computer");
                    int englishMarks = rs.getInt("english");
                    int sstMarks = rs.getInt("SST");

                    totalMarks = mathMarks + scienceMarks + computerMarks + englishMarks + sstMarks;
                    percentage = totalMarks / 5.0;
    %>

    <p>Student Name: <strong><%= studentName %></strong></p>
    <p>Roll Number: <strong><%= rollNumber %></strong></p>

    <div class="results">
        <div class="result-item">Math: <strong><%= mathMarks %></strong></div>
        <div class="result-item">Science: <strong><%= scienceMarks %></strong></div>
        <div class="result-item">Computer: <strong><%= computerMarks %></strong></div>
        <div class="result-item">English: <strong><%= englishMarks %></strong></div>
        <div class="result-item">S.S.T: <strong><%= sstMarks %></strong></div>
    </div>

    <div class="total">Total Marks: <strong><%= totalMarks %></strong></div>
    <div class="percentage">Percentage: <strong><%= String.format("%.2f", percentage) %> %</strong></div>

    <%
                } else {
                    out.println("<p style='color: red;'>No results found for this student.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>An error occurred while retrieving results.</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        } else {
            out.println("<p style='color: red;'>No student ID found in session. Please log in again.</p>");
        }
    %>

    <button class="btn" onclick="location.href='./index.html'">Logout</button>
</div>

</body>
</html>

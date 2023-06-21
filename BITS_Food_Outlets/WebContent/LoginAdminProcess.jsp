<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login Process</title>
</head>
<body>
    <%-- Retrieve the form data --%>
    <% String AUserID = request.getParameter("AUserID");
       String password = request.getParameter("password");
		Connection conn=null;
       // Perform database connection and query to validate admin credentials
       try {
           // Establish database connection
           conn=DatabaseUtil.getConnection();
           Statement stmt = conn.createStatement();

           // Execute query to validate admin credentials
           String query = "SELECT * FROM Admin WHERE AUserID = ? AND password = ?";
           PreparedStatement ps = conn.prepareStatement(query);
           ps.setString(1, AUserID);
           ps.setString(2, password);
           ResultSet rs = ps.executeQuery();

           if (rs.next()) {
               // Admin authentication successful
               // Redirect to the appropriate page
               session.setAttribute("AUserID", AUserID);
               response.sendRedirect("WelcomeAdmin.jsp");
           } else {
               // Admin authentication failed
               // Display error message
               out.println("Invalid admin ID or password");
           }

           // Close database connections
           rs.close();
           ps.close();
           stmt.close();
           conn.close();
       } catch (SQLException e) {
           // Handle database connection errors
           e.printStackTrace();
       }
    %>
</body>
</html>

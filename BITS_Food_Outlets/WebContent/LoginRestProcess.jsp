<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Processing</title>
</head>
<body>
    <%-- Establishing database connection --%>
    <%
    String RUserID = request.getParameter("RUserID");
    String password = request.getParameter("password");
    
    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;
    
    try {
        connection = DatabaseUtil.getConnection();
        String query = "SELECT * FROM Restaurants WHERE RUserID = ? AND password = ?";
        statement = connection.prepareStatement(query);
        statement.setString(1, RUserID);
        statement.setString(2, password);
        resultSet = statement.executeQuery();

        if (resultSet.next()) {
            // User authenticated, redirect to the restaurant welcome page
            int RestaurantID = resultSet.getInt("RestaurantID");
            String RestaurantName = resultSet.getString("Name");
            session.setAttribute("RestaurantID", RestaurantID);
            session.setAttribute("RUserID", RUserID);
            session.setAttribute("RestaurantName", RestaurantName);
            response.sendRedirect("WelcomeRest.jsp");
        } else {
            // Invalid credentials, redirect back to login page with an error message
            out.println("Invalid credentials. Please try again.");
 /*            String errorMessage = "Invalid credentials. Please try again.";
            response.sendRedirect("LoginRest.jsp?error=" + URLEncoder.encode(errorMessage, "UTF-8")); */
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Closing database resources
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    %>
</body>
</html>

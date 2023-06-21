<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Counter Process</title>
</head>
<body>
    <h1>New Counter Process</h1>

    <% 
        // Get the form data
        String restaurantId = request.getParameter("RestaurantID");
        String foodType = request.getParameter("foodType");
        String counterName = request.getParameter("counterName");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Connect to the database
            conn = DatabaseUtil.getConnection();

            // Insert the new counter into the database
            String insertQuery = "INSERT INTO Counters (RestaurantID, Name, Type) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(insertQuery);
            stmt.setInt(1, Integer.parseInt(restaurantId));
            stmt.setString(2, counterName);
            stmt.setString(3, foodType);
            stmt.executeUpdate();

            out.println("New counter added successfully!");
        } catch (SQLException e) {
            out.println("Error: Unable to connect to the database or execute the query!");
            e.printStackTrace();
        } finally {
            // Close the database resources
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>

    <br><br>
    <a href="ManageRestaurant.jsp?restaurant=<%= restaurantId %>">Back to Manage Restaurant</a>
    <br><br>
    <a href="ManageRestaurantsHome.jsp">Back to Home</a>
    <br><br>
    <a href="ResetPassword.jsp">Reset Password</a>
    <br><br>
    <a href="Logout.jsp">Logout</a>
</body>
</html>

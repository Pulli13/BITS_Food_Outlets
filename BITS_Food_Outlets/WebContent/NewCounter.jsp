<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Counter</title>
</head>
<body>
    <h1>New Counter</h1>

    <% 
        // Get the selected restaurant ID from the previous page
        String RestaurantID = session.getAttribute("RestaurantID").toString();
		
      

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Connect to the database
   
            conn = DatabaseUtil.getConnection();

            // Retrieve the restaurant name from the database
            String restaurantName = null;
            String restaurantQuery = "SELECT Name FROM restaurants WHERE RestaurantID = ?";
            stmt = conn.prepareStatement(restaurantQuery);
            stmt.setString(1, RestaurantID);
            rs = stmt.executeQuery();
            if (rs.next()) {
                restaurantName = rs.getString("Name");
            }

            // Display the restaurant name and counter form
            if (restaurantName != null) {
    %>
             
                <h2>Restaurant Name: <%= restaurantName %></h2>

                <form action="NewCounterProcess.jsp" method="post">
                    <input type="hidden" name="RestaurantID" value="<%= RestaurantID %>">
                    <label for="foodType">Select Food Type:</label>
                    <select name="foodType" id="foodType">
                        <option value="Veg">Veg</option>
                        <option value="Non-Veg">Non-Veg</option>
                    </select>
                    <br><br>
                    <label for="counterName">Counter Name:</label>
                    <input type="text" id="counterName" name="counterName" required>
                    <br><br>
                    <input type="submit" value="Add Counter">
                </form>
    <%
            } else {
                out.println("Restaurant not found!");
            }
        }  catch (SQLException e) {
            out.println("Error: Unable to connect to the database!");
            e.printStackTrace();
        } finally {
            // Close the database resources
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
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
    <a href="ManageRestaurant.jsp?restaurant=<%= RestaurantID %>">Back to Manage Restaurant</a>
    <br><br>
    <a href="ManageRestaurantsHome.jsp">Back to Home</a>
    <br><br>
    <a href="ResetPassword.jsp">Reset Password</a>
    <br><br>
    <a href="Logout.jsp">Logout</a>
</body>
</html>

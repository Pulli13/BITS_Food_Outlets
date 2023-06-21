<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Restaurants Home</title>
</head>
<body>
    <h1>Manage Restaurants</h1>

    <% 
        // Database connection details
        Connection connection=null;
        
        try {
            // Establish database connection
           
   			connection = DatabaseUtil.getConnection();
            
            // Fetch restaurants from the database
            Statement statement = connection.createStatement();
            String query = "SELECT * FROM restaurants";
            ResultSet resultSet = statement.executeQuery(query);
            
            // Generate the dropdown list dynamically
            %>
            <form action="ManageRestaurant.jsp" method="post">
                <label for="restaurant">Select a restaurant:</label>
                <select name="restaurant" id="restaurant">
                    <%
                    while (resultSet.next()) {
                        String RestaurantID = resultSet.getString("RestaurantID");
                        String RestaurantName = resultSet.getString("Name");
                        %>
                        <option value="<%= RestaurantID %>"><%= RestaurantName %></option>
                        <%
                    }
                    %>
                </select>
                <br><br>
                <input type="submit" value="Manage">
            </form>
            <%
            
            // Close the database connection
            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    
    <br><br>
    <a href="ResetPassword.jsp">Reset Password</a>
    <br><br>
    <a href="Logout.jsp">Logout</a>
</body>
</html>

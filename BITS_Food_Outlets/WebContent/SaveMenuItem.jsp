<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<%@ page import="java.util.*" %>
<%
    // Get the form parameters
    int CounterID = Integer.parseInt(request.getParameter("CounterID"));
	int RestaurantID = Integer.parseInt(request.getParameter("RestaurantID"));
    String ItemName = request.getParameter("ItemName");
    String ItemDesc = request.getParameter("ItemDesc");
    double ItemPrice = Double.parseDouble(request.getParameter("ItemPrice"));

    // Database Connection
    Connection connection = null;
    PreparedStatement statement = null;
    
    try {
        connection = DatabaseUtil.getConnection();

        // Insert the new menu item into the database
        statement = connection.prepareStatement("INSERT INTO MenuItems (CounterID,RestaurantID, ItemName,Description, Price) VALUES (?,?,?, ?, ?)");
        statement.setInt(1, CounterID);
        statement.setInt(2, RestaurantID);
        statement.setString(3, ItemName);
        statement.setString(4, ItemDesc);
        statement.setDouble(5, ItemPrice);
        statement.executeUpdate();

        // Close database connections
        statement.close();
        connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Save Menu Item</title>
</head>
<body>
    <h2>Counter: <%= session.getAttribute("CounterName") %></h2>
    <h3>New Menu Item:</h3>
    <p>Name: <%= ItemName %></p>
    <p>Description: <%= ItemDesc %></p>
    <p>Price: <%= ItemPrice %></p>
    <p>Menu item has been saved successfully.</p>
    <a href="CounterManagement.jsp">Go back to Counter Management Home</a>
</body>
</html>

<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>

<%
    // Database connection parameters

    // Create a connection to the database
    Connection connection = null;
    try {
        connection = DatabaseUtil.getConnection();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database connection error
    }

    // Get the order ID from the previous page
    int orderID = Integer.parseInt(request.getParameter("orderID"));

    // Retrieve the order details from the database
    String orderStatus = "";
    Timestamp orderPlacedDateTime = null;
    try {
        PreparedStatement statement = connection.prepareStatement("SELECT OrderStatus, OrderPlacedDateTime FROM Orders WHERE OrderID = ?");
        statement.setInt(1, orderID);
        ResultSet resultSet = statement.executeQuery();
        while (resultSet.next()) {
            orderStatus = resultSet.getString("OrderStatus");
            orderPlacedDateTime = resultSet.getTimestamp("OrderPlacedDateTime");
        }
        resultSet.close();
        statement.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database query error
    }

    // Close the database connection
    try {
        connection.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database connection error
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
</head>
<body>
    <h1>Order Confirmation</h1>
    <p>Your order has been placed successfully!</p>
    <p>Order ID: <%= orderID %></p>
    <p>Status: <%= orderStatus %></p>
    <p>Order Placed Date and Time: <%= orderPlacedDateTime %></p>
     <a href="CounterNumber.jsp?counter=<%=session.getAttribute("CounterID")  %>">Go Back To Counter</a>
    	<a href="WelcomeStu.jsp">Go Back To Home</a> 
</body>
</html>

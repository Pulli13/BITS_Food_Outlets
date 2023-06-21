<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<%@ page import="java.util.*" %>

<%
    // Database connection parameters
	int CounterID=Integer.parseInt(request.getParameter("CounterID"));
    // Create a connection to the database
    Connection connection = null;
    try {
        connection = DatabaseUtil.getConnection();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database connection error
    }

    // Get the selected counter from the session
    int selectedCounter = (int) session.getAttribute("CounterID");

    // Get the selected menu item and quantity from the request
    int menuItemID = Integer.parseInt(request.getParameter("menuItem"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));

    // Get the menu item details
    double price = 0.0;
    String itemName = "";
    try {
        PreparedStatement statement = connection.prepareStatement("SELECT * FROM MenuItems WHERE MenuItemID = ? and CounterID=?");
        statement.setInt(1, menuItemID);
        statement.setInt(2, CounterID);
        ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
            itemName = resultSet.getString("ItemName");
            price = resultSet.getDouble("Price");
        }
        resultSet.close();
        statement.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database query error
    }

    // Calculate the total price for the selected quantity
    double totalPrice = price * quantity;
		
   
    // Store the cart item details in the session
    List<Map<String, Object>> cartItemsList = (List<Map<String, Object>>) session.getAttribute("cartItemsList");
    if (cartItemsList == null) {
        cartItemsList = new ArrayList<>();
    }
    
    Map<String, Object> cartItem = new HashMap<>();
    cartItem.put("menuItemID", menuItemID);
    cartItem.put("itemName", itemName);
    cartItem.put("quantity", quantity);
    cartItem.put("price", price);
    cartItem.put("totalPrice", totalPrice);
    cartItem.put("CounterID", CounterID);
    cartItemsList.add(cartItem);
    session.setAttribute("cartItemsList", cartItemsList);

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
    <title>Add to Cart</title>
</head>
<body>
    <h1>Item Added to Cart</h1>
    <p>Item: <%= itemName %></p>
    <p>Quantity: <%= quantity %></p>
    <p>Total Price: <%= totalPrice %></p>
    <a href="CounterNumber.jsp?counter=<%= selectedCounter %>">Back to Counter Number</a>
    <a href="ViewCart.jsp">View Cart</a>
    	<a href="WelcomeStu.jsp">Go Back To Home</a> 
</body>
</html>

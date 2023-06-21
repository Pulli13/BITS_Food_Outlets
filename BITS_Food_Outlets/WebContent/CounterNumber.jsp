<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
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

    // Get the selected counter from the previous page
    int selectedCounter = Integer.parseInt(request.getParameter("counter"));
    session.setAttribute("CounterID", selectedCounter);
    
    // Fetch the number of orders and calculate the approximate waiting time
    int pendingPreparingOrdersCount = 0;
    int waitingTime=0;

    try {
        /* PreparedStatement statement = connection.prepareStatement("SELECT COUNT(*) AS orderCount, SUM(TIMESTAMPDIFF(MINUTE, o.OrderPlacedDateTime, NOW())) AS totalCookingTimeMillis " +
                "FROM Orders o " +
                "INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID " +
                "INNER JOIN MenuItems mi ON oi.MenuItemID = mi.MenuItemID " +
                "WHERE oi.CounterID = ? AND (o.OrderStatus = 'Pending' OR o.OrderStatus = 'Preparing')"); */
        /*   PreparedStatement statement = connection.prepareStatement("SELECT SUM(CookingTime) AS totalCookingTime FROM MenuItems " +
               "INNER JOIN OrderItems ON MenuItems.MenuItemID = OrderItems.MenuItemID " +
               "INNER JOIN Orders ON OrderItems.OrderID = Orders.OrderID " +
               "WHERE Orders.CounterID = ? AND Orders.OrderStatus IN ('Pending', 'Preparing') " +
               "AND Orders.OrderPlacedDateTime < (SELECT OrderPlacedDateTime FROM Orders WHERE CounterID = ? AND Orders.OrderStatus IN ('Pending', 'Preparing') ORDER BY OrderPlacedDateTime LIMIT 1)"); */
          /*  String orderQuery = "SELECT Sum(OrderItems.quantity) as orderCount, SUM(CookingTime * Quantity) AS WaitingTime FROM OrderItems " +
                       "INNER JOIN MenuItems ON OrderItems.MenuItemID = MenuItems.MenuItemID " +
                    		   "inner join Orders on OrderItems.OrderID= Orders.OrderID"+
                       "WHERE OrderItems.CounterID = ? AND orders.OrderStatus IN ('Pending', 'Preparing')"; */
            String orderQuery="SELECT Sum(OrderItems.quantity) as orderCount, SUM(TIME_TO_SEC(CookingTime) * Quantity) AS WaitingTimeSecs FROM OrderItems "+ 
                    "INNER JOIN MenuItems ON OrderItems.MenuItemID = MenuItems.MenuItemID "+
                   " inner join Orders on OrderItems.OrderID= Orders.OrderID"+
                   " WHERE OrderItems.CounterID = ? AND Orders.OrderStatus IN ('Pending', 'Preparing')";
   PreparedStatement statement = connection.prepareStatement(orderQuery);
               
        statement.setInt(1, selectedCounter);
        ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
            pendingPreparingOrdersCount = resultSet.getInt("orderCount");
            if(resultSet.getInt("WaitingTimeSecs")%60==0){
            	waitingTime = resultSet.getInt("WaitingTimeSecs")/60;
            }
            else{
            	waitingTime = (resultSet.getInt("WaitingTimeSecs")/60) +1;
            }
            
        }
        resultSet.close();
        statement.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database query error
    }
	
    session.setAttribute("WaitingTime", waitingTime);
    
    
    
    // Fetch the menu items cooked in the selected counter with status 'Available'
    List<Map<String, Object>> menuItemsList = new ArrayList<>();
    try {
        PreparedStatement statement = connection.prepareStatement("SELECT * FROM MenuItems WHERE CounterID = ? AND ItemStatus = ?");
        statement.setInt(1, selectedCounter);
        statement.setString(2, "Available");
        ResultSet resultSet = statement.executeQuery();
        while (resultSet.next()) {
            Map<String, Object> menuItem = new HashMap<>();
            menuItem.put("menuItemID", resultSet.getInt("MenuItemID"));
            menuItem.put("itemName", resultSet.getString("ItemName"));
            menuItem.put("price", resultSet.getDouble("Price"));
            menuItem.put("cookingTime", resultSet.getTime("CookingTime"));
            menuItemsList.add(menuItem);
        }
        resultSet.close();
        statement.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database query error
    }
	
    // Calculate the approximate waiting time in minutes
   /*  long approximateWaitingTimeMinutes = 0;
    try {
        approximateWaitingTimeMinutes = totalCookingTimeMillis / (pendingPreparingOrdersCount * 60000); // Assuming 1 minute = 60000 milliseconds
    } catch (Exception e) {
        e.printStackTrace();
    } */
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
    <title>Counter Number</title>
</head>
<body>
<h1>Counter Number: <%= selectedCounter %></h1>
<h2>Menu Items</h2>
<table>
    <thead>
    <tr>
        <th>Item Name</th>
        <th>Price</th>
        <!-- <th>Cooking Time</th> -->
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (Map<String, Object> menuItem : menuItemsList) {
            int menuItemID = (int) menuItem.get("menuItemID");
    %>
    <tr>
        <td><%= menuItem.get("itemName") %></td>
        <td><%= menuItem.get("price") %></td>
        <%--   <td><%= menuItem.get("cookingTime") %></td> --%>
        <td>
            <form action="AddToCartItems.jsp?CounterID=<%=session.getAttribute("CounterID") %>" method="post">
                <input type="hidden" name="menuItem" value="<%= menuItemID %>">
                <input type="number" name="quantity" min="1" max="10" value="1">
                <input type="submit" value="Add to Cart">
                <input type="submit" formaction="BuyItem.jsp" formmethod="post" value="Buy">
            </form>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<h2>Orders</h2>
<p>Number of Orders (Pending/Preparing): <%= pendingPreparingOrdersCount %></p>
<p>Approximate Waiting Time: <%= waitingTime %> minutes</p>
<a href="CountersDetailsHome.jsp?restaurant=<%= session.getAttribute("RestaurantID") %>&foodType=<%= session.getAttribute("FoodType") %>">Back to Counters Home</a>
	<a href="WelcomeStu.jsp">Go Back To Home</a> 
	<a href="ViewCart.jsp">Go to Cart</a>
</body>
</html>

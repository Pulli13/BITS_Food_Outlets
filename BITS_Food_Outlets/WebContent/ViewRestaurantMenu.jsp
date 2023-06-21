<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.concurrent.*" %>
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

    // Get the selected restaurant and food type from the URL parameters
    int selectedRestaurant = Integer.parseInt(request.getParameter("RestaurantID"));
    String selectedFoodType = request.getParameter("Type");
	
    // Fetch the list of counters and their corresponding menu items with prices for the selected restaurant and food type
    Map<String, List<Map<String, Object>>> counterMenuMap = new HashMap<>();
    try {
    	 
        PreparedStatement statement = connection.prepareStatement("SELECT c.name AS counter_name, m.itemname AS menu_item_name, m.price AS menu_item_price " +
                "FROM counters c " +
                "INNER JOIN MenuItems m ON c.CounterID = m.CounterID " +
                "WHERE c.RestaurantID = ? AND c.Status = ? AND c.Type = ? AND m.itemstatus=?");
        statement.setInt(1, selectedRestaurant);
        statement.setString(2, "open");
        statement.setString(3, selectedFoodType);
        statement.setString(4, "available");
        ResultSet resultSet = statement.executeQuery();
       
        while (resultSet.next()) {
        	 
            String counterName = resultSet.getString("counter_name");
            String menuItemName = resultSet.getString("menu_item_name");
            double menuItemPrice = resultSet.getDouble("menu_item_price");
            if (!counterMenuMap.containsKey(counterName)) {
                counterMenuMap.put(counterName, new ArrayList<>());
            }
            Map<String, Object> menuItemMap = new HashMap<>();
            menuItemMap.put("name", menuItemName);
            menuItemMap.put("price", menuItemPrice);
            counterMenuMap.get(counterName).add(menuItemMap);
            
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
    <title>View Restaurant Menu</title>
</head>
<body>
    <h1>Restaurant Menu</h1>
    <h2>Restaurant: <%= session.getAttribute("RestaurantName") %></h2>
    <h2>Food Type: <%= selectedFoodType %></h2>
	<p>Below are the Available FoodItems</p>
    <% for (Map.Entry<String, List<Map<String, Object>>> entry : counterMenuMap.entrySet()) { %>
        <h3>Counter: <%= entry.getKey() %></h3>
        <ul>
            <% for (Map<String, Object> menuItem : entry.getValue()) { %>
                <li>
                    <%= menuItem.get("name") %>
                    <span style="margin-left: 10px;">Price: <%= menuItem.get("price") %></span>
                </li>
            <% } %>
        </ul>
    <% } %>

        <a href="CountersDetailsHome.jsp?restaurant=<%=selectedRestaurant%>&foodType=<%=selectedFoodType%>">Back to Counters Home</a>
        	<a href="WelcomeStu.jsp">Go Back To Home</a> 
</body>
</html>

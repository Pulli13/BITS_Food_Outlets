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

    // Get the selected restaurant and food type from the previous page
    int selectedRestaurant = Integer.parseInt(request.getParameter("restaurant")) ;
    String selectedFoodType = request.getParameter("foodType");
    session.setAttribute("RestaurantID", selectedRestaurant);
	session.setAttribute("FoodType", selectedFoodType);
	
    // Fetch the list of open counters for the selected restaurant
    List<String> counterList = new ArrayList<>();
    List<Integer> counterIdList = new ArrayList<>();
    try {
        PreparedStatement statement = connection.prepareStatement("SELECT * FROM counters WHERE RestaurantID = ? and Status = ? and  Type=?");
        statement.setInt(1, selectedRestaurant);
        statement.setString(2, "open");
        statement.setString(3, selectedFoodType);
        ResultSet resultSet = statement.executeQuery();
        while (resultSet.next()) {
            counterList.add(resultSet.getString("name"));
            counterIdList.add(resultSet.getInt("CounterID"));
        }
        resultSet.close();
        statement.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database query error
    }
    String restaurantName=null;
    try {
        PreparedStatement statement = connection.prepareStatement("SELECT * FROM restaurants WHERE RestaurantID = ?");
        statement.setInt(1, selectedRestaurant);
        ResultSet resultSet = statement.executeQuery();
        while (resultSet.next()) {
        	restaurantName=resultSet.getString("name");
        	
        }
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database query error
    }
	session.setAttribute("RestaurantName", restaurantName);
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
    <title>Counter Details</title>
</head>
<body>
    <h1>Counter Details</h1>
    <h2>Restaurant: <%= restaurantName %></h2>
    <h2>Food Type: <%= selectedFoodType %></h2>
    <form action="CounterNumber.jsp" method="post">
        <label for="counter">Select a Counter:</label>
        <select name="counter" id="counter">
            <% for (int i = 0; i < counterList.size(); i++) { %>
                <option value="<%= counterIdList.get(i) %>"><%= counterList.get(i) %></option>
            <% } %>
        </select>
        <br><br>
        <input type="submit" value="Go">
    </form>
    <a href="ViewRestaurantMenu.jsp?RestaurantID=<%=selectedRestaurant%>&Type=<%=selectedFoodType%>">View Menu</a>
    <a href="RestaurantsList.jsp">Back To Restaurants</a>
    	<a href="WelcomeStu.jsp">Go Back To Home</a> 
</body>
</html>

<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.concurrent.*"%>
<%@ page import="my_files.DatabaseUtil"%>

<%
// Database connection parameters
session.removeAttribute("cartItemsList");
// Create a connection to the database
Connection connection = null;
try {

	connection = DatabaseUtil.getConnection();
} catch (Exception e) {
	e.printStackTrace();
	// Handle the database connection error
}

// Fetch the list of available restaurants from the database
List<String> restaurantList = new ArrayList<>();
List<Integer> restaurantIdList = new ArrayList<>();
try {
	Statement statement = connection.createStatement();
	ResultSet resultSet = statement.executeQuery("SELECT * FROM restaurants");
	while (resultSet.next()) {
		restaurantList.add(resultSet.getString("name"));
		restaurantIdList.add(resultSet.getInt("RestaurantID"));
	}
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
<title>Restaurants List</title>
</head>
<body>
	<h1>Available Restaurants</h1>
	<form action="CountersDetailsHome.jsp" method="post">
		<label for="restaurant">Select a Restaurant:</label> 
		<select	name="restaurant" id="restaurant">
			<%
			for (int i = 0; i < restaurantList.size(); i++) {
			%>
			<option value="<%=restaurantIdList.get(i)%>"><%=restaurantList.get(i)%></option>
			<%
			}
			%>
		</select> <br>
		<br> <label for="foodType">Select Food Type:</label> <select
			name="foodType" id="foodType">
			<option value="veg">Vegetarian</option>
			<option value="non-veg">Non-Vegetarian</option>
		</select> <br>
		<br> <input type="submit" value="Go">
	</form>
	<a href="WelcomeStu.jsp">Go Back To Home</a> 
</body>
</html>

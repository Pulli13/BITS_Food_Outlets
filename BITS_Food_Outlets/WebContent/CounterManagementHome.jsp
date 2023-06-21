<%@page import="java.sql.*"%>
<%@page import="my_files.DatabaseUtil" %>
<%@page import="java.util.*" %>
<%
    String restaurantId = session.getAttribute("RestaurantID").toString();
	
    // Database Connection
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
        connection = DatabaseUtil.getConnection();
        statement = connection.createStatement();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Retrieve the list of counters
    String countersQuery = "SELECT * FROM counters WHERE RestaurantID=?";

    // Prepare a parameterized query to handle SQL injection
    PreparedStatement countersStatement = connection.prepareStatement(countersQuery);
    countersStatement.setInt(1, Integer.parseInt(restaurantId));
    resultSet = countersStatement.executeQuery();

    List<String> counterList = new ArrayList<>();
    List<Integer> counterIdList = new ArrayList<>();
    try {
        while (resultSet.next()) {
            counterList.add(resultSet.getString("Name"));
            counterIdList.add(resultSet.getInt("CounterID"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    // Close database connections
    resultSet.close();
    countersStatement.close();
    statement.close();
    connection.close();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Counter Management Home</title>
</head>
<body>
    <h1>Counter Management Home</h1>
    <form action="CounterManagement.jsp" method="post">
        <label for="counter">Select Counter:</label>
        <select name="counter" id="counter">
            <% for (int i = 0; i < counterList.size(); i++) { %>

                <option value="<%= counterIdList.get(i) %>"><%= counterList.get(i) %></option>
                <%-- <option value="<%= counterList.get(i) %>"><%= counterList.get(i) %></option> --%>
                <%-- <input type="hidden" name="counterID_<%= counterList.get(i) %>" value="<%= counterIdList.get(i) %>"> --%>
            <% } %>
        </select>
        <br>
        <input type="submit" value="Manage Counter">
    </form>
</body>
</html>

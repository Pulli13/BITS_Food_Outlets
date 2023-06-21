<%@page import="java.sql.*"%>
<%@page import="my_files.DatabaseUtil"%>
<%@page import="java.util.*"%>
<%
// Database Connection
Connection connection = null;
PreparedStatement statement = null;
try {
    connection = DatabaseUtil.getConnection();
    statement = connection.prepareStatement("SELECT * FROM MenuItems WHERE MenuItemID=?");
    int menuItemID = Integer.parseInt(request.getParameter("MenuItemID"));
    statement.setInt(1, menuItemID);
    ResultSet menuItemResult = statement.executeQuery();
    String itemName = null;
    Double itemPrice = 0.0;
    String itemDescription = null;
    String itemStatus = null;
    
    if (menuItemResult.next()) {
        itemName = menuItemResult.getString("ItemName");
        itemPrice = menuItemResult.getDouble("Price");
        itemDescription = menuItemResult.getString("Description");
        itemStatus = menuItemResult.getString("ItemStatus");
    }
    
    menuItemResult.close();
    statement.close();
    connection.close();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Menu Item</title>
</head>
<body>
    <h1>Manage Menu Item</h1>
    <h2>Item Name: <%= itemName %></h2>
    <form action="UpdateMenuItem.jsp" method="post">
        <input type="hidden" name="itemID" value="<%= menuItemID %>" required>
        <label for="itemName">Name:</label>
        <input type="text" name="itemName" value="<%= itemName %>" required><br>
        <label for="itemPrice">Price:</label>
        <input type="number" name="itemPrice"  step="1.0"  value="<%= itemPrice %>" required >
		<br>
        <label for="itemDescription">Description:</label>
        <textarea name="itemDescription" required><%= itemDescription %></textarea><br>
        <label for="itemStatus">Status:</label>
        <select name="itemStatus">
            <option value="Available" <%= itemStatus.equals("Available") ? "selected" : "" %>>Available</option>
            <option value="Not Available" <%= itemStatus.equals("Not Available") ? "selected" : "" %>>Not Available</option>
        </select><br>
        <input type="submit" value="Update">
    </form>
    <br>
  <%--   <form action="DeleteMenuItem.jsp" method="post">
        <input type="hidden" name="itemID" value="<%= menuItemID %>">
        <input type="submit" value="Delete">
    </form> --%>
                    <p><a href="CounterManagement.jsp?CounterID=<%= session.getAttribute("CounterID") %>">>Back to Counter</a></p>
</body>
</html>
<%
} catch (SQLException e) {
    e.printStackTrace();
}
%>

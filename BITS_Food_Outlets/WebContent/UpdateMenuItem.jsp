<%@page import="java.sql.*"%>
<%@page import="my_files.DatabaseUtil"%>
<%@page import="java.util.*"%>
<%
// Database Connection
Connection connection = null;
PreparedStatement statement = null;
try {
    connection = DatabaseUtil.getConnection();
    int menuItemID = Integer.parseInt(request.getParameter("itemID"));
    String itemName = request.getParameter("itemName");
    double itemPrice = Double.parseDouble(request.getParameter("itemPrice"));
    String itemDescription = request.getParameter("itemDescription");
    String itemStatus = request.getParameter("itemStatus");

    statement = connection.prepareStatement("UPDATE MenuItems SET ItemName=?, Price=?, Description=?, ItemStatus=? WHERE MenuItemID=?");
    statement.setString(1, itemName);
    statement.setDouble(2, itemPrice);
    statement.setString(3, itemDescription);
    statement.setString(4, itemStatus);
    statement.setInt(5, menuItemID);
    
    int rowsAffected = statement.executeUpdate();
    
    statement.close();
    connection.close();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Menu Item</title>
</head>
<body>
    <h1>Update Menu Item</h1>
    <% if (rowsAffected > 0) { %>
        <p>Menu item updated successfully.</p>
        <p><a href="ManageMenuItem.jsp?MenuItemID=<%= menuItemID %>">>Back to Menu Item</a></p>
                <p><a href="CounterManagement.jsp?CounterID=<%= session.getAttribute("CounterID") %>">>Back to Counter</a></p>
    <% } else { %>
        <p>Failed to update menu item.</p>
        <p><a href="ManageMenuItem.jsp?MenuItemID=<%= menuItemID %>">Back to Manage Menu Item</a></p>
    <% } %>
</body>
</html>
<%
} catch (SQLException e) {
    e.printStackTrace();
}
%>

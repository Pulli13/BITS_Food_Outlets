<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Add Menu Item</title>
</head>
<body>
    <h1>Add Menu Item</h1>
    <h2>Counter: <%= session.getAttribute("CounterName")  %></h2>
    <form action="SaveMenuItem.jsp" method="post">
        <input type="hidden" name="CounterID" value="<%= session.getAttribute("CounterID") %>">
        <input type="hidden" name="RestaurantID" value="<%=session.getAttribute("RestaurantID") %>">
        <label for="ItemName">Item Name:</label>
        <input type="text" name="ItemName" id="ItemName" required>
        <br>
        <label for="ItemDesc">Item Description:</label>
        <input type="text" name="ItemDesc" id="ItemDesc" required>
        <br>
        <label for="ItemPrice">Item Price:</label>
        <input type="number" name="ItemPrice" id="ItemPrice" step="1.0" required>
        <br>
        <input type="submit" value="Add Item">
    </form>
    <br>
    <a href="CounterManagement.jsp">Go back to Counter Management Home</a>
</body>
</html>

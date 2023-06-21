<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="my_files.*" %>

<%
    // Database connection parameters
   

    // Create a database connection
    Connection conn = DatabaseUtil.getConnection();

    // Query to retrieve orders along with necessary details
    String query = "SELECT oi.OrderItemID, m.ItemName, o.OrderStatus,  m.MenuItemID, oi.Quantity, oi.WaitingTime, oi.WaitingTime - TIMESTAMPDIFF(MINUTE, o.OrderPlacedDateTime, NOW()) AS RemainingWaitingTime " +
                   "FROM Orders o " +
                   "JOIN OrderItems oi ON o.OrderID = oi.OrderID " +
                   "JOIN MenuItems m ON oi.MenuItemID = m.MenuItemID " +
                   "WHERE o.StudentID =? " +
                   "ORDER BY o.OrderPlacedDateTime DESC";

    // Execute the query
   PreparedStatement stmt = conn.prepareStatement(query);
    stmt.setInt(1, (int)session.getAttribute("StudentID"));
    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Orders</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>Past Orders</h2>
    <table>
        <tr>
            <th>Order ID</th>
            <th>Menu Item</th>
            <th>Quantity</th>
            <th>Total Cost</th>
            <th>Status</th>
            <th>Remaining Waiting Time</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
            <td><%= rs.getInt("OrderItemID") %></td>
            <td><%= rs.getString("ItemName") %></td>
            <td><%= rs.getInt("Quantity") %></td>
           <td><%= rs.getInt("Quantity") * Price.getPrice((int)rs.getInt("MenuItemID"), conn) %></td> 
           <td><%= rs.getString("OrderStatus") %>
            <td><%= rs.getInt("RemainingWaitingTime") %> minutes</td>
        </tr>
        <% } %>
    </table>

    <% rs.close();
       stmt.close();
       conn.close();
    %>
</body>
</html>


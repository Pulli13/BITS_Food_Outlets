<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Restaurant</title>
</head>
<body>
    <h1>Manage Restaurant </h1>
     <%   String RestaurantID = request.getParameter("restaurant");
            session.setAttribute("RestaurantID", RestaurantID);
	%>
   <br><br>
    <a href="NewCounter.jsp?restaurantId=<%= RestaurantID %>">Add Counter</a>
    <br><br>
    <a href="CounterAdmin.jsp?restaurantId=<%= RestaurantID %>">Manage Counters</a>
    <br><br>
    <a href="ReportGenerator.jsp?restaurantId=<%= RestaurantID %>">Generate Monthly Report</a>

    <br><br>
    <a href="ManageRestaurantsHome.jsp">Back to Home</a>
    <br><br>
    <a href="ResetPassword.jsp">Reset Password</a>
    <br><br>
    <a href="Logout.jsp">Logout</a>
 
</body>
</html>

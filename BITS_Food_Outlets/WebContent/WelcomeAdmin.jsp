<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // Check if the administrator is logged in
    // If not, redirect to the login page
    if (session.getAttribute("AUserID") == null) {
        response.sendRedirect("LoginAdmin.jsp");
    }
%>

<html>
<head>
    <title>Welcome Admin</title>
</head>
<body>
    <h1>Welcome Admin</h1>
    
    <ul>
        <li><a href="ManageRestaurantsHome.jsp">Manage Restaurants</a></li>
        <li><a href="ResetPassword.jsp">Reset Password</a></li>
        <li><a href="Logout.jsp">Logout</a></li>
    </ul>

  
</body>
</html>

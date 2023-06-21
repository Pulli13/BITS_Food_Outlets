<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Restaurant Portal</title>
</head>
<body>
    <h1>Restaurant Login</h1>
    <form action="LoginRestProcess.jsp" method="post">
        <label for="RUserID">User ID:</label>
        <input type="text" id="RUserID" name="RUserID" required><br><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
        
        <input type="submit" value="Login">
    </form>
    <p><a href="SignupRest.jsp">Signup</a></p>
</body>
</html>

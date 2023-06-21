<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Login</title>
</head>
<body>
    <h1>Student Login</h1>
    <form method="post" action="LoginStuProcess.jsp">
        <label for="collegeID">CollegeID:</label>
        <input type="text" id="collegeID" name="collegeID" required><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>
</body>
</html>

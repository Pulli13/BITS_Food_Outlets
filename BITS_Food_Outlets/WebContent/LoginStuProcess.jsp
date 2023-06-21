<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>
<%
  String collegeID = request.getParameter("collegeID");
  String password = request.getParameter("password");

  // Validate the collegeID and password
  // ...

  // Connect to the MySQL database
  Connection conn = null;

 try{
	/*   out.println("B");
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    out.println("B1");
	    String url = "jdbc:mysql://localhost:3306/bfo_db";
	    out.println("B2");
	    String username = "root";
	    out.println("B3");
	    String pass = "MySQL@411681";
	    out.println("B4");
	    conn = DriverManager.getConnection(url, username, pass);
	    out.println("C"); */	  
	 conn = DatabaseUtil.getConnection();
  }
  catch(Exception e){
	  e.printStackTrace();
  } 
 
  try {
    // Check if the student exists in the database
    String query = "SELECT * FROM Students WHERE CollegeID = ?";
    PreparedStatement pstmt = conn.prepareStatement(query);
    pstmt.setString(1, collegeID);
    ResultSet rs = pstmt.executeQuery();
    if (rs.next()) {
      // Student exists, check the password
      String storedPassword = rs.getString("password");
      if (password.equals(storedPassword)) {
        // Password is correct, redirect to WelcomeStu.jsp
        int studentID=rs.getInt("StudentID");
        session.setAttribute("StudentID", studentID);
        session.setAttribute("CollegeID", collegeID);
        response.sendRedirect("WelcomeStu.jsp");
      } else {
        // Incorrect password
        out.println("Invalid password");
      }
    } else {
      // Student does not exist
      out.println("Student does not exist");
      
    }
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    if (conn != null) {
      try {
        conn.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }
%>

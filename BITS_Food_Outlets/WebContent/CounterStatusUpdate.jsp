<%@page import="java.sql.*"%>
<%@page import="my_files.DatabaseUtil" %>
<%
    // Database Connection
    Connection connection = null;
    PreparedStatement statement = null;
    int CounterID= Integer.parseInt(request.getParameter("CounterID"));
	out.println(CounterID);
    String CounterName=session.getAttribute("CounterName").toString();
    out.println(CounterName);
    String status = request.getParameter("status");
    out.println(status);
    try {
        connection = DatabaseUtil.getConnection();
        // Update the counter status
        statement = connection.prepareStatement("UPDATE counters SET Status=? WHERE CounterID=?");
        statement.setString(1, status);
        statement.setInt(2, CounterID);
        statement.executeUpdate();
		
        // Close database connections
        statement.close();
        connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
   	
    // Redirect back to CounterManagement.jsp
     response.sendRedirect("CounterManagement.jsp?CounterID=" + CounterID); 
%>

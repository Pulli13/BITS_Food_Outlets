<%@page import="java.sql.*"%>
<%@page import="my_files.DatabaseUtil"%>
<%@page import="java.util.*"%>
<%
//Database Connection
Connection connection = null;
PreparedStatement statement = null;
try {
	connection = DatabaseUtil.getConnection();
	statement = connection.prepareStatement("SELECT * FROM counters WHERE CounterID=?");
	// very important
	/* String counterName = request.getParameter("counter"); */
	String counterName=null;
	int counterID =0;
	counterName = null;
	/* if (counterName == null) {
		counterName = session.getAttribute("CounterName").toString();
	}
	String counterIdParamName = "counterID_" + counterName; */

/* 	int CounterID = 0; // Initialize CounterID

	// Check if the parameter exists and is not null
	if (request.getParameter(counterIdParamName) != null) {
		CounterID = Integer.parseInt(request.getParameter(counterIdParamName));
	} else if((request.getParameter("CounterID")!=null)) {
		CounterID = Integer.parseInt(request.getParameter("CounterID"));
	}
	else{
		CounterID=(Integer)session.getAttribute("CounterID");
	} */
	if(request.getParameter("counter")!=null){
		 counterID =Integer.parseInt(request.getParameter("counter")) ;
	}
	else{
		counterID=(Integer)session.getAttribute("CounterID");
	}
	int CounterID=counterID;
	statement.setInt(1, CounterID);
	ResultSet counterResult = statement.executeQuery();
	
	String counterStatus = "";

	if (counterResult.next()) {
		counterName=counterResult.getString("Name");
		counterStatus = counterResult.getString("Status");
	
		
	}
	counterResult.close();
	session.setAttribute("CounterID", CounterID);
	// Set counter details in session
	session.setAttribute("CounterName", counterName);
	
	session.setAttribute("CounterStatus", counterStatus);
	
	// Retrieve menu items associated with the counter
	statement = connection.prepareStatement("SELECT * FROM MenuItems WHERE CounterID=?");
	statement.setInt(1, CounterID);
	ResultSet menuItemsResult = statement.executeQuery();
	List<Map<String, String>> menuItemsList = new ArrayList<>();
	while (menuItemsResult.next()) {
		Map<String, String> menuItem = new HashMap<>();
		menuItem.put("ItemName", menuItemsResult.getString("ItemName"));
		menuItem.put("MenuItemID", menuItemsResult.getString("MenuItemID"));
		menuItemsList.add(menuItem);
	}
	menuItemsResult.close();
	
	session.setAttribute("MenuItemsList", menuItemsList);
	// Close database connections
	statement.close();
	connection.close();

	
} catch (SQLException e) {
	e.printStackTrace();
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Counter Management</title>
</head>
<body>
	<h1>Counter Management</h1>
	<h2>
		Counter:
		<%=session.getAttribute("CounterName")%>
		(Status:
		<%=session.getAttribute("CounterStatus")%>)
		
	</h2>
	<h3>Menu Items:</h3>
	<ul>
		<%
		for (Map<String, String> menuItem : (List<Map<String, String>>) session.getAttribute("MenuItemsList")) {
		%>
		<li><%=menuItem.get("ItemName")%>
			<form action="ManageMenuItem.jsp" method="post"
				style="display: inline;">
				<input type="hidden" name="MenuItemID"
					value="<%=menuItem.get("MenuItemID")%>"> <input type="submit"
					value="Manage">
			</form></li>
		<%
		}
		%>
	</ul>
<%-- 	<a
		href="ManageMenuItems.jsp?CounterID=<%=session.getAttribute("CounterID")%>">Manage
		Menu Items</a> --%>
	<br>
	<br>
	<%
	if (session.getAttribute("CounterStatus").equals("Closed")) {
	%>
	<form action="CounterStatusUpdate.jsp" method="post">
		<input type="hidden" name="CounterID"
			value="<%=session.getAttribute("CounterID")%>"> <input
			type="hidden" name="counter"
			value="<%=session.getAttribute("CounterName")%>"> <input
			type="hidden" name="status" value="Open"> <input
			type="submit" value="Open Counter">
	</form>
	<%
	} else { 
	%>
	<form action="CounterStatusUpdate.jsp" method="post">
		<input type="hidden" name="CounterID"
			value="<%=session.getAttribute("CounterID")%>"> <input
			type="hidden" name="counter"
			value="<%=session.getAttribute("CounterName")%>"> <input
			type="hidden" name="status" value="Closed"> <input
			type="submit" value="Close Counter">
	</form>
	<%
	}
	%>
	<br>
	<a href="AddMenuItem.jsp?CounterID=<%=session.getAttribute("CounterID")%>">Add
		New Menu Item</a>
</body>
</html>

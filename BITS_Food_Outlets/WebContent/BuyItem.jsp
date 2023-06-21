<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>

<%
    // Database connection parameters

    // Create a connection to the database
    Connection connection = null;
    try {
        connection = DatabaseUtil.getConnection();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database connection error
    }
    int selectedCounter = (Integer)session.getAttribute("CounterID");
    int studentID=(Integer)session.getAttribute("StudentID");
	int selectedRestaurant=(Integer)session.getAttribute("RestaurantID");
    // Get the selected counter and menu item from the previous page 
    int selectedMenuItem = Integer.parseInt(request.getParameter("menuItem"));	
    // Get the quantity of the selected menu item
    int quantity = Integer.parseInt(request.getParameter("quantity"));

    // Get the current date and time
    java.util.Date currentDate = new java.util.Date();
    java.sql.Timestamp currentDateTime = new java.sql.Timestamp(currentDate.getTime());

    // Insert the order into the database
    int orderID = 0;
    
    int waitingTime=0;
   /*  int temp=0;
    try{
    	out.println("A");
    	PreparedStatement statement=connection.prepareStatement("Select count(*) as nums from orderitems ");
    	ResultSet resultSet=statement.executeQuery();
    	if(resultSet.next()){
    		temp=resultSet.getInt("nums");
    		out.println("Count= "+ temp);
    		out.println("B");
    	}
    	out.println("C");
    }
    catch(Exception e){
    	e.printStackTrace();
    } */
    
    try{
    
    	waitingTime=(Integer)session.getAttribute("WaitingTime");
    	out.println(waitingTime);
    
    	
    	PreparedStatement statement=connection.prepareStatement("Select * from MenuItems where MenuItemID=?");
    	statement.setInt(1, selectedMenuItem);
    	ResultSet resultSet= statement.executeQuery();
    
    	if(resultSet.next()){
    		
    		Time cookingTime = resultSet.getTime("CookingTime");
    		int cookingTimeInSeconds = (int) cookingTime.toLocalTime().toSecondOfDay();
    		
    		if(((cookingTimeInSeconds*quantity)%60)==0){
    			waitingTime+=((cookingTimeInSeconds*quantity)/60);
    			
    		}
    		else{
    			waitingTime+=((cookingTimeInSeconds*quantity)/60)+1;
    			
    		}
    	
    	}
    	
    	
    }
    catch(Exception e){
    	e.printStackTrace();
    }
    try {
        // Insert the order
        PreparedStatement orderStatement = connection.prepareStatement("INSERT INTO Orders (StudentID, RestaurantID,  OrderStatus, OrderPlacedDateTime) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
        orderStatement.setInt(1, studentID); // Assuming you have the student ID stored in a variable named 'studentID'
        orderStatement.setInt(2, selectedRestaurant);
        orderStatement.setString(3, "Pending");
        orderStatement.setTimestamp(4, currentDateTime);
        orderStatement.executeUpdate();

        // Get the generated order ID
        ResultSet generatedKeys = orderStatement.getGeneratedKeys();
        if (generatedKeys.next()) {
            orderID = generatedKeys.getInt(1);
        }

        // Insert the order item
        PreparedStatement orderItemStatement = connection.prepareStatement("INSERT INTO OrderItems (OrderID, MenuItemID,CounterID, Quantity,WaitingTime) VALUES (?, ?, ?, ?, ?)");
        orderItemStatement.setInt(1, orderID);
        orderItemStatement.setInt(2, selectedMenuItem);
        orderItemStatement.setInt(3, selectedCounter);
        orderItemStatement.setInt(4, quantity);
        orderItemStatement.setInt(5, waitingTime);
        orderItemStatement.executeUpdate();

        orderItemStatement.close();
        orderStatement.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database insertion error
    }

    // Close the database connection
    try {
        connection.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database connection error
    }

    // Redirect to a confirmation page or display a success message
  response.sendRedirect("ConfirmationPage.jsp?orderID=" + orderID); 
%>

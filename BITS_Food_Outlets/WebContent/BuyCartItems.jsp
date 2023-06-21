<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="my_files.DatabaseUtil" %>

<%
    // Retrieve the counter ID and total cart price from the session
     int counterID = (int) session.getAttribute("CounterID");


	 int restaurantID=(int) session.getAttribute("RestaurantID");
	 int studentID=(int) session.getAttribute("StudentID");
  /*   double totalCartPrice = (double) session.getAttribute("totalCartPrice"); */

    // Create a connection to the database
    Connection connection = null;
    try {
        connection = DatabaseUtil.getConnection();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database connection error
    }
   /*  int numsCounters=0;
   
    try{
    	PreparedStatement statement=connection.prepareStatement("Select count(*) from mycount from counters where restaurantid=?");
    	statement.setInt(1, (Integer)session.getAttribute("RestaurantID"));
    	ResultSet resultSet=statement.executeQuery();
    	if(resultSet.next()){
    		numsCounters=resultSet.getInt("mycount");
    	}
    	resultSet.close();
    	statement.close();
    }
    catch(Exception e){
    	e.printStackTrace();
    } */
    Map<Integer,Integer> C_WaitingTime=new HashMap<Integer,Integer>();
    try{
    	String orderQuery="SELECT OrderItems.CounterID as counter, Sum(OrderItems.quantity) as orderCount, SUM(TIME_TO_SEC(CookingTime) * Quantity) AS WaitingTimeSecs FROM OrderItems "+ 
                "INNER JOIN MenuItems ON OrderItems.MenuItemID = MenuItems.MenuItemID "+
               " inner join Orders on OrderItems.OrderID= Orders.OrderID"+
               " WHERE Orders.OrderStatus IN ('Pending', 'Preparing') group by OrderItems.CounterID ";
    	PreparedStatement statement=connection.prepareStatement(orderQuery);
    	ResultSet resultSet=statement.executeQuery();
    	while(resultSet.next()){
    		int counter=resultSet.getInt("counter");
    		int waitingTime=0;
    		int waitingTimeSecs=resultSet.getInt("WaitingTimeSecs");
    		if(waitingTimeSecs%60==0){
    			waitingTime=waitingTimeSecs/60;
    		}
    		else{
    			waitingTime=(waitingTimeSecs/60)+1;
    		}
    		C_WaitingTime.put(counter, waitingTime);
    	}
    	resultSet.close();
    	statement.close();
    	/* for(int values: C_WaitingTime.values() ){
    		out.println("***");
    		out.println(values);
    	}  */
    }
    catch(Exception e){
    	e.printStackTrace();
    }
    
	//Not necssary b/c OrderID is auto-incremented.
    // Get the next order ID from the Orders table	
    String orderID = null;
    try {
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery("SELECT MAX(OrderID) AS maxOrderID FROM Orders");
        if (resultSet.next()) {
            String maxOrderID = resultSet.getString("maxOrderID");
            if (maxOrderID == null) {
                // If no previous orders exist, start with OrderID = 1
                orderID = "1";
            } else {
                // Increment the maxOrderID to generate the next orderID
                int nextOrderID = Integer.parseInt(maxOrderID) + 1;
                orderID = String.valueOf(nextOrderID);
            }
        }
        resultSet.close();
        statement.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database query error
    }
	
    // Get the current timestamp
    java.util.Date currentTimestamp = new java.util.Date();
    Timestamp orderPlacedDateTime = new Timestamp(currentTimestamp.getTime());


    // Insert the order into the database
    try {
       /*  PreparedStatement insertOrderStatement = connection.prepareStatement("INSERT INTO Orders (OrderID,StudentID,RestaurantID, OrderPlacedDateTime, OrderStatus) VALUES (?,?,?, ?, ?)");
        insertOrderStatement.setInt(1,Integer.parseInt(orderID));
        insertOrderStatement.setInt(2,studentID);
        insertOrderStatement.setInt(3,restaurantID); */
       /*  insertOrderStatement.setInt(2, counterID); */
        /* insertOrderStatement.setTimestamp(4, orderPlacedDateTime);
        insertOrderStatement.setString(5, "Pending");
        insertOrderStatement.executeUpdate();
        insertOrderStatement.close();  */
    	 PreparedStatement insertOrderStatement = connection.prepareStatement("INSERT INTO Orders (StudentID,RestaurantID, OrderPlacedDateTime, OrderStatus) VALUES (?,?, ?, ?)");
        
         insertOrderStatement.setInt(1,studentID);
         insertOrderStatement.setInt(2,restaurantID);
        /*  insertOrderStatement.setInt(2, counterID); */
         insertOrderStatement.setTimestamp(3, orderPlacedDateTime);
         insertOrderStatement.setString(4, "Pending");
         insertOrderStatement.executeUpdate();
         insertOrderStatement.close();
        
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database insert error
    }
    
    // Insert the order items into the database
    List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItemsList");
   
    if (cartItems != null && !cartItems.isEmpty()) {
    
        try {
        	/*  int waitingTime=(int)session.getAttribute("WaitingTime");
        	out.println("Previous Waiting Time= " + waitingTime);	  */
        	int wT=0;
            PreparedStatement insertOrderItemStatement = connection.prepareStatement("INSERT INTO OrderItems (OrderID, MenuItemID,CounterID, Quantity,WaitingTime) VALUES (?, ?,?, ?,?)");
          
            for (Map<String, Object> cartItem : cartItems) {
            	
                int menuItemID = (int) cartItem.get("menuItemID");
                int quantity = (int) cartItem.get("quantity");
                double price = (double) cartItem.get("price");
				int CounterID=(int) cartItem.get("CounterID");
				
				 wT= (int)C_WaitingTime.get(CounterID); 
			
				PreparedStatement statement=connection.prepareStatement("Select * from MenuItems where MenuItemID=?");			
				statement.setInt(1, menuItemID);
	    		ResultSet resultSet= statement.executeQuery();
	    		if(resultSet.next()){
	    			Time cookingTime = resultSet.getTime("CookingTime");
	    			int cookingTimeInSeconds = (int) cookingTime.toLocalTime().toSecondOfDay();
	    			if(((cookingTimeInSeconds*quantity)%60)==0){
	    				wT+=((cookingTimeInSeconds*quantity)/60);
	    			}
	    			else{
	    				wT+=((cookingTimeInSeconds*quantity)/60);
	    				wT+=1;
	    			}
	    		}
	    		
				resultSet.close();
				statement.close();
				
                insertOrderItemStatement.setString(1, orderID);
                insertOrderItemStatement.setInt(2, menuItemID);
                insertOrderItemStatement.setInt(3, CounterID);
                insertOrderItemStatement.setInt(4, quantity);
                insertOrderItemStatement.setInt(5, wT);
                insertOrderItemStatement.executeUpdate();
                
               /*  C_WaitingTime.replace(CounterID, waitingTime); */
               
            }
            insertOrderItemStatement.close(); 
            
           
        } catch (Exception e) {
            e.printStackTrace();
            // Handle the database insert error
        }
    }

    // Close the database connection
    try {
        connection.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the database connection error
    }
   
    // Clear the cart items and total cart price from the session
    
  session.removeAttribute("cartItemsList");
    
  
   /*  session.removeAttribute("totalCartPrice"); */
    

%>
 
<!DOCTYPE html>
<html>
<head>
    <title>Buy Cart Items</title>
</head>
<body>
    <h1>Order Confirmation</h1>
    <p>Order ID: <%= orderID %></p>
     
   <%--  <p>Total Cart Price: <%= totalCartPrice %></p> --%>
    <p>Your order has been placed successfully!</p>
    <a href="CounterNumber.jsp?counter=<%= counterID %>">Go Back To Counter</a>
    	<a href="WelcomeStu.jsp">Go Back To Home</a> 
</body>
</html>

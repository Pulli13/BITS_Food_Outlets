<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Cart Items</title>
</head>
<body>
    <h1>Cart Items</h1>
    <table>
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Total Price</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% 
                // Retrieve cart items from the session
                List<Map<String, Object>> cartItemsList = (List<Map<String, Object>>) session.getAttribute("cartItemsList");
                if (cartItemsList != null && !cartItemsList.isEmpty()) {
                    for (Map<String, Object> cartItem : cartItemsList) {
                        String itemName = (String) cartItem.get("itemName");
                        int quantity = (int) cartItem.get("quantity");
                        double price = (double) cartItem.get("price");
                        double totalPrice = (double) cartItem.get("totalPrice");
                        int menuItemID = (int) cartItem.get("menuItemID");
                        
                
                     
            %>
                        <tr>
                            <td><%= itemName %></td>
                            <td><%= quantity %></td>
                            <td><%= price %></td>
                            <td><%= totalPrice %></td>
                            <td>
                                <form action="RemoveFromCart.jsp" method="post" style="display: inline;">
                                    <input type="hidden" name="menuItemID" value="<%= menuItemID %>">
                                    <input type="submit" value="Remove">
                                </form>
                            </td>
                        </tr>
            <%          
                    }
            %>
                    <tr>
                        <td colspan="5">
                            <form action="BuyCartItems.jsp" method="post">
                                <input type="submit" value="Buy">
                            </form>
                        </td>
                    </tr>
            <% 
                } else {
            %>
                <tr>
                    <td colspan="5">No items in the cart</td>
                </tr>
            <% } %>
            
        </tbody>
    </table>
    <br>
   
   
    <a href="CounterNumber.jsp?counter=<%= session.getAttribute("CounterID") %>">Back to Counter Number</a>
    	<a href="WelcomeStu.jsp">Go Back To Home</a> 
</body>
</html>

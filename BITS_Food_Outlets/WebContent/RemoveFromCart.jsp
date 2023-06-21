<%@ page import="java.util.*" %>

<%
    // Retrieve the menuItemID parameter from the request
    int menuItemID = Integer.parseInt(request.getParameter("menuItemID"));

    // Retrieve the cartItemsList from the session
    List<Map<String, Object>> cartItemsList = (List<Map<String, Object>>) session.getAttribute("cartItemsList");

    // Remove the menu item from the cartItemsList based on menuItemID
    if (cartItemsList != null) {
        Iterator<Map<String, Object>> iterator = cartItemsList.iterator();
        while (iterator.hasNext()) {
            Map<String, Object> cartItem = iterator.next();
            int id = (int) cartItem.get("menuItemID");
            if (id == menuItemID) {
                iterator.remove();
                break;
            }
        }
    }

    // Update the cartItemsList in the session
    session.setAttribute("cartItemsList", cartItemsList);

    // Redirect back to CartItems.jsp
    response.sendRedirect("ViewCart.jsp");
%>

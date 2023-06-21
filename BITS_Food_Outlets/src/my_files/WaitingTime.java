package my_files;
import java.sql.*;
public class WaitingTime {
	@SuppressWarnings("resource")
	public static long calculateWaitingTime(Connection connection, int orderId, int counterId) throws SQLException {
	    long waitingTime = 0;

	    // Query the Orders and MenuItems tables to calculate the waiting time
	    PreparedStatement statement = null;
	    ResultSet resultSet = null;
	    try {
	        // Retrieve the order placed date and time
	        statement = connection.prepareStatement("SELECT OrderPlacedDateTime FROM Orders WHERE OrderID = ?");
	        statement.setInt(1, orderId);
	        resultSet = statement.executeQuery();

	        if (resultSet.next()) {
	            Timestamp orderPlacedDateTime = resultSet.getTimestamp("OrderPlacedDateTime");

	            // Calculate the waiting time using the cooking time of menu items associated with orders placed before
	            statement = connection.prepareStatement("SELECT SUM(CookingTime) AS TotalCookingTime " +
	                    "FROM OrderItems oi " +
	                    "INNER JOIN MenuItems mi ON oi.MenuItemID = mi.MenuItemID " +
	                    "INNER JOIN Orders o ON oi.OrderID = o.OrderID " +
	                    "WHERE o.CounterID = ? " +
	                    "AND o.OrderPlacedDateTime < ? " +
	                    "AND (o.OrderStatus = 'Pending' OR o.OrderStatus = 'Preparing')");
	            statement.setInt(1, counterId);
	            statement.setTimestamp(2, orderPlacedDateTime);
	            resultSet = statement.executeQuery();

	            if (resultSet.next()) {
	                Time totalCookingTime = resultSet.getTime("TotalCookingTime");
	                if (totalCookingTime != null) {
	                    // Convert the cooking time to milliseconds and calculate the waiting time in minutes
	                    waitingTime = totalCookingTime.getTime() / (60 * 1000);
	                }
	            }
	        }
	    } finally {
	        // Close the database resources
	        if (resultSet != null) {
	            resultSet.close();
	        }
	        if (statement != null) {
	            statement.close();
	        }
	    }

	    return waitingTime;
	}

}

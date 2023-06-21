package my_files;
import java.sql.*;
public class Price {
public static double getPrice(int itemID, Connection conn) throws SQLException {
        String query = "SELECT Price FROM MenuItems WHERE MenuItemID = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, itemID);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            double price = rs.getDouble("Price");
            stmt.close();
            rs.close();
            return price;
        }
        return 0.0;
    }

}

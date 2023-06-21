package my_files;
import java.sql.*;

public class DatabaseUtil {
  private static final String URL = "jdbc:mysql://localhost:3306/bfo_db";
  private static final String USERNAME = "root";
  private static final String PASSWORD = "MySQL@411681";

  public static Connection getConnection() throws SQLException {
	  try {
		Class.forName("com.mysql.cj.jdbc.Driver");
	} catch (ClassNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    return DriverManager.getConnection(URL, USERNAME, PASSWORD);
  }

  public static void closeConnection(Connection conn) {
    if (conn != null) {
      try {
        conn.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }
}

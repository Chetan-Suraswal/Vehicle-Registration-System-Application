<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<style>
  .vehicles-wrapper { padding: 0 10px; }
  .page-title { font-size: 28px; font-weight: 600; margin-bottom: 16px; }
  .vehicle-card { background: #ffffff; border-radius: 12px; padding: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
  .vehicle-table { width: 100%; border-collapse: collapse; }
  .vehicle-table thead { background: linear-gradient(90deg, #2563eb, #3b82f6); color: white; }
  .vehicle-table th, .vehicle-table td { padding: 12px 14px; text-align: left; font-size: 14px; }
  .vehicle-table tbody tr { border-bottom: 1px solid #e5e7eb; }
  .vehicle-table tbody tr:hover { background: #f9fafb; }
</style>

<div class="vehicles-wrapper">
  <h1 class="page-title">My Vehicles</h1>
  <div class="vehicle-card">
    <table class="vehicle-table">
      <thead>
        <tr>
          <th>Vehicle No</th>
          <th>Owner Name</th>
          <th>Vehicle Type</th>
          <th>Registration Date</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody id="vehicleTableBody">
        <%
            // 1. Get logged-in user ID from session
            String userIdStr = "";
            if (session.getAttribute("userId") != null) {
                userIdStr = String.valueOf(session.getAttribute("userId"));
            }
            
            boolean hasVehicles = false;

            try {
                // 2. Load JDBC Driver & Connect to DB
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vr_db", "root", "crx.sql");
                
                // 3. Prepare Query to fetch only this user's vehicles
                String query = "SELECT vehicleNumber, ownerName, vehicleType, created_at FROM vehicle WHERE userId = ? ORDER BY created_at DESC";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, userIdStr);
                
                ResultSet rs = ps.executeQuery();
                
                // 4. Loop through database results and create table rows
                while (rs.next()) {
                    hasVehicles = true;
                    String vNum = rs.getString("vehicleNumber");
                    String oName = rs.getString("ownerName");
                    String vType = rs.getString("vehicleType");
                    
                    // Get date and format it to just show YYYY-MM-DD
                    Timestamp regDate = rs.getTimestamp("created_at");
                    String dateStr = (regDate != null) ? regDate.toString().substring(0, 10) : "N/A";
        %>
                    <tr>
                        <td><%= vNum %></td>
                        <td><%= oName %></td>
                        <td><%= vType %></td>
                        <td><%= dateStr %></td>
                        <td style="color: #15803d; font-weight: bold;">Registered</td>
                    </tr>
        <%
                }
                
                con.close();
            } catch (Exception e) {
        %>
                <tr>
                   <td colspan="5" style="color:red; text-align:center;">Error loading vehicles: <%= e.getMessage() %></td>
                </tr>
        <%
            }
            
            // 5. If no vehicles found, show the default empty message
            if (!hasVehicles) {
        %>
                <tr>
                   <td colspan="5" style="text-align:center;">No vehicles registered yet.</td>
                </tr>
        <%
            }
        %>
      </tbody>
    </table>
  </div>
</div>
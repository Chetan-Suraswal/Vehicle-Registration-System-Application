<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // SECURITY CHECK: (Commented out for testing. Uncomment when you want to enforce login)
    // if (session.getAttribute("adminId") == null) {
    //     response.sendRedirect("admin_login.jsp");
    //     return; 
    // }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard - All Records</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    /* VARIABLES */
    :root { 
        --primary: #1f3c88; 
        --bg: #d9f2ff; 
        --white: #ffffff; 
        --black: #0f172a; 
        --border: #e5e7eb; 
    }
    
    /* RESET & LAYOUT */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Segoe UI", Arial, sans-serif; }
    body { background: var(--bg); color: var(--black); }
    
    /* Container (Stacking Topbar and Main Content) */
    .app-container { display: flex; flex-direction: column; height: 100vh; }
    
    /* TOPBAR (Replaces Sidebar) */
    .topbar { 
        height: 70px; 
        background: var(--white); 
        border-bottom: 1px solid var(--border); 
        display: flex; 
        align-items: center; 
        padding: 0 30px; 
        justify-content: space-between; 
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .app-title { font-size: 22px; font-weight: bold; color: var(--primary); }
    .top-right { display: flex; align-items: center; gap: 15px; }
    .admin-badge { background: #dcfce7; color: #15803d; padding: 6px 14px; border-radius: 20px; font-size: 14px; font-weight: bold; border: 1px solid #bbf7d0; }
    #logoutBtn { padding: 8px 16px; border: none; border-radius: 8px; background: #ef4444; color: white; font-weight: 600; cursor: pointer; }
    #logoutBtn:hover { background: #dc2626; }
    
    /* MAIN CONTENT */
    .main-content { padding: 30px; overflow-y: auto; flex: 1; }
    .section-title { font-size: 24px; font-weight: 600; margin-top: 10px; margin-bottom: 15px; color: var(--primary); }
    
    /* TABLE STYLES */
    .table-card { background: var(--white); border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 40px; overflow-x: auto; }
    .data-table { width: 100%; border-collapse: collapse; min-width: 900px; }
    .data-table thead { background: var(--primary); color: white; }
    .data-table th, .data-table td { padding: 14px 16px; text-align: left; font-size: 14px; }
    .data-table tbody tr { border-bottom: 1px solid var(--border); transition: background 0.2s; }
    .data-table tbody tr:hover { background: #f8fafc; }
    
    .highlight { font-weight: bold; color: #0f172a; }
  </style>
</head>
<body>

  <div class="app-container">
    
    <header class="topbar">
      <div class="app-title">VehicleReg Central Admin</div>
      <div class="top-right">
          <span class="admin-badge">● Super Admin Active</span>
          <button id="logoutBtn" onclick="window.location.href='logout.jsp'">Logout</button>
      </div>
    </header>

    <main class="main-content">
        
        <%
            // Initialize Database Connection once for the whole page
            Connection con = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vr_db", "root", "crx.sql");
            } catch(Exception e) {
                out.println("<div style='color:red; font-weight:bold;'>Database Connection Failed: " + e.getMessage() + "</div>");
            }
        %>

        <h2 class="section-title">All Registered Users</h2>
        <div class="table-card">
          <table class="data-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email Address</th>
                <th>Mobile Number</th>
                <th>City</th>
                <th>State</th>
                <th>Registration Date</th>
              </tr>
            </thead>
            <tbody>
              <%
                  if (con != null) {
                      try {
                          String userQuery = "SELECT id, fullname, email, mobileNo, city, state, created_at FROM users ORDER BY created_at DESC";
                          PreparedStatement psUsers = con.prepareStatement(userQuery);
                          ResultSet rsUsers = psUsers.executeQuery();
                          boolean hasUsers = false;
                          
                          while(rsUsers.next()) {
                              hasUsers = true;
                              String dateStr = (rsUsers.getTimestamp("created_at") != null) ? rsUsers.getTimestamp("created_at").toString().substring(0, 10) : "N/A";
              %>
                              <tr>
                                  <td class="highlight"><%= rsUsers.getInt("id") %></td>
                                  <td><%= rsUsers.getString("fullname") %></td>
                                  <td><%= rsUsers.getString("email") %></td>
                                  <td><%= rsUsers.getString("mobileNo") %></td>
                                  <td><%= rsUsers.getString("city") %></td>
                                  <td><%= rsUsers.getString("state") %></td>
                                  <td><%= dateStr %></td>
                              </tr>
              <%
                          }
                          if(!hasUsers) {
                              out.println("<tr><td colspan='7' style='text-align:center;'>No users registered in the database.</td></tr>");
                          }
                      } catch(Exception e) {
                          out.println("<tr><td colspan='7' style='color:red;'>Error loading users: "+e.getMessage()+"</td></tr>");
                      }
                  }
              %>
            </tbody>
          </table>
        </div>

        <h2 class="section-title">All Registered Vehicles</h2>
        <div class="table-card">
          <table class="data-table">
            <thead>
              <tr>
                <th>Vehicle No.</th>
                <th>Owner Name</th>
                <th>Brand & Model</th>
                <th>Type</th>
                <th>Chassis Number</th>
                <th>Engine Number</th>
                <th>Registration Date</th>
              </tr>
            </thead>
            <tbody>
              <%
                  if (con != null) {
                      try {
                          String vehQuery = "SELECT vehicleNumber, ownerName, vehicleBrand, vehicleModel, vehicleType, chassisNumber, engineNumber, created_at FROM vehicle ORDER BY created_at DESC";
                          PreparedStatement psVeh = con.prepareStatement(vehQuery);
                          ResultSet rsVeh = psVeh.executeQuery();
                          boolean hasVehicles = false;
                          
                          while(rsVeh.next()) {
                              hasVehicles = true;
                              String brandModel = rsVeh.getString("vehicleBrand") + " " + rsVeh.getString("vehicleModel");
                              String dateStr = (rsVeh.getTimestamp("created_at") != null) ? rsVeh.getTimestamp("created_at").toString().substring(0, 10) : "N/A";
              %>
                              <tr>
                                  <td class="highlight"><%= rsVeh.getString("vehicleNumber") %></td>
                                  <td><%= rsVeh.getString("ownerName") %></td>
                                  <td><%= brandModel %></td>
                                  <td><%= rsVeh.getString("vehicleType") %></td>
                                  <td><%= rsVeh.getString("chassisNumber") %></td>
                                  <td><%= rsVeh.getString("engineNumber") %></td>
                                  <td><%= dateStr %></td>
                              </tr>
              <%
                          }
                          if(!hasVehicles) {
                              out.println("<tr><td colspan='7' style='text-align:center;'>No vehicles registered in the database.</td></tr>");
                          }
                      } catch(Exception e) {
                          out.println("<tr><td colspan='7' style='color:red;'>Error loading vehicles: "+e.getMessage()+"</td></tr>");
                      }
                  }
                  
                  // Close the database connection once both tables are done rendering
                  if (con != null) {
                      try { con.close(); } catch(Exception e) {}
                  }
              %>
            </tbody>
          </table>
        </div>

    </main>
  </div>
</body>
</html>
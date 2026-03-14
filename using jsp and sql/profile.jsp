<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. BACKEND LOGIC: Fetch user data based on active session
    String userId = "";
    if (session.getAttribute("userId") != null) {
        userId = String.valueOf(session.getAttribute("userId"));
    }

    // Default empty variables to hold database values
    String dbId = "";
    String dbName = "";
    String dbEmail = "";
    String dbMobile = "";
    String dbAddress = "";
    String dbCity = "";
    String dbState = "";
    String dbPincode = "";

    // 2. Fetch from Database
    if (!userId.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vr_db", "root", "crx.sql");
            
            String query = "SELECT id, fullname, email, mobileNo, address, city, state, pincode FROM users WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, userId);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                dbId = rs.getString("id");
                dbName = (rs.getString("fullname") != null) ? rs.getString("fullname") : "";
                dbEmail = (rs.getString("email") != null) ? rs.getString("email") : "";
                dbMobile = (rs.getString("mobileNo") != null) ? rs.getString("mobileNo") : "";
                dbAddress = (rs.getString("address") != null) ? rs.getString("address") : "";
                dbCity = (rs.getString("city") != null) ? rs.getString("city") : "";
                dbState = (rs.getString("state") != null) ? rs.getString("state") : "";
                dbPincode = (rs.getString("pincode") != null) ? rs.getString("pincode") : "";
            }
            con.close();
        } catch (Exception e) {
            // Error handling could be logged here
            System.out.println("Profile Fetch Error: " + e.getMessage());
        }
    }
%>

<style>
.profile-wrapper { width: 100%; max-width: 1200px; padding: 10px; box-sizing: border-box; margin: 0 auto; }
.profile-card { background: #ffffff; border-radius: 16px; padding: 24px; margin-bottom: 24px; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.04); width: 100%; }
.card-title { font-size: 20px; font-weight: 600; margin-bottom: 20px; }
.profile-card .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; }
.profile-card .grid > div { display: flex; flex-direction: column; }
.profile-card label { display: block; font-size: 13px; color: #64748b; margin-bottom: 6px; }

/* 3. Updated Input Styles: #eee background and cursor logic for readonly */
.profile-card input { 
    width: 100%; 
    height: 44px; 
    padding: 10px 14px; 
    font-size: 14px; 
    border-radius: 10px; 
    border: 1px solid #dcdcdc; 
    background-color: #eee; /* Changed to #eee */
    box-sizing: border-box;
    cursor: not-allowed; /* Indicates it's read-only */
    color: #333; /* Slightly darker text for contrast */
}

.profile-card input:focus { outline: none; } /* Removed blue border on focus since it's readonly */

.primary-btn { background: #3b82f6; color: white; border: none; padding: 12px 26px; border-radius: 12px; font-weight: 600; cursor: pointer; }
.primary-btn:hover { opacity: 0.9; }
.action-bar { display: flex; justify-content: flex-end; margin-top: 24px; }
@media (max-width: 768px) { .profile-card .grid { grid-template-columns: 1fr; } }
</style>

<div class="profile-wrapper">
  <div class="profile-card">
    <h2 class="card-title">Basic Information</h2>
    <div class="grid">
      <div>
        <label>User ID</label>
        <input type="text" id="displayId" value="<%= dbId %>" readonly>
      </div>
      <div>
        <label>Full Name</label>
        <input type="text" id="fullName" value="<%= dbName %>" readonly>
      </div>
      <div>
        <label>Email</label>
        <input type="email" id="email" value="<%= dbEmail %>" readonly>
      </div>
      <div>
        <label>Mobile</label>
        <input type="text" id="mobile" value="<%= dbMobile %>" readonly>
      </div>
    </div>
  </div>

  <div class="profile-card">
    <h2 class="card-title">Address</h2>
    <div class="grid">
      <div>
          <label>Address</label>
          <input id="address" value="<%= dbAddress %>" placeholder="Address" readonly>
      </div>
      <div>
          <label>City</label>
          <input id="city" value="<%= dbCity %>" placeholder="City" readonly>
      </div>
      <div>
          <label>State</label>
          <input id="state" value="<%= dbState %>" placeholder="State" readonly>
      </div>
      <div>
          <label>Pincode</label>
          <input id="pincode" value="<%= dbPincode %>" placeholder="Pincode" readonly>
      </div>
    </div>
  </div>

  <div class="action-bar">
    <button class="primary-btn" id="saveProfileBtn">Save Changes</button>
  </div>
</div>
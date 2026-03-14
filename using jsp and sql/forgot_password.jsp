<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // BACKEND LOGIC: Password Reset Process
    String msg = "";
    String msgType = ""; // Used to switch between red and green text

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to database
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vr_db", "root", "crx.sql");
            
            // First, check if the email actually exists in the database
            String checkQuery = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkPs = con.prepareStatement(checkQuery);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Email exists, proceed to update the password
                String updateQuery = "UPDATE users SET password = ? WHERE email = ?";
                PreparedStatement updatePs = con.prepareStatement(updateQuery);
                updatePs.setString(1, newPassword);
                updatePs.setString(2, email);
                
                int rowsAffected = updatePs.executeUpdate();
                if (rowsAffected > 0) {
                    msg = "Password updated successfully!";
                    msgType = "success";
                } else {
                    msg = "Failed to update password. Please try again.";
                    msgType = "error";
                }
            } else {
                msg = "No account found with this email address.";
                msgType = "error";
            }
            con.close();
        } catch (Exception e) {
            msg = "Database Error: " + e.getMessage();
            msgType = "error";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Forgot Password - Vehicle Registration</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, Helvetica, sans-serif; }
    body { background-color: #d9f2ff; height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; }
    .top-header { text-align: center; margin-bottom: 20px; }
    .login-box { background: #ffffff; width: 360px; padding: 30px; border-radius: 8px; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); text-align: center; }
    .login-box h1 { font-size: 24px; margin-bottom: 8px; color: #111827; }
    .subtitle { font-size: 14px; color: #6b7280; margin-bottom: 20px; }
    .login-box input[type="email"], .login-box input[type="password"], .login-box input[type="text"] { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #e5e7eb; border-radius: 6px; font-size: 14px; }
    .password-box { position: relative; }
    .eye { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); font-size: 18px; color: #9ca3af; cursor: pointer; user-select: none; z-index: 10; }
    button { width: 100%; padding: 12px; background-color: #4f7df3; border: none; border-radius: 6px; color: #ffffff; font-size: 15px; cursor: pointer; margin-top: 5px; }
    button:hover { background-color: #3f6ae0; }
    
    /* Message Styles */
    .msg-success { color: #15803d; font-size: 14px; margin-bottom: 15px; font-weight: bold; }
    .msg-error { color: red; font-size: 14px; margin-bottom: 15px; font-weight: bold; }
    .js-error { color: red; font-size: 13px; margin-top: -10px; margin-bottom: 10px; display: none; }
    
    .links { margin-top: 20px; font-size: 14px; color: #6b7280; }
    .links a { color: #3b82f6; text-decoration: none; }
  </style>
</head>
<body>

  <div class="top-header">
    <h2 style="color: #1f3c88; font-size: 28px;">Vehicle Registration System</h2>
  </div>

  <div class="login-box">
    <h1>Reset Password</h1>
    <p class="subtitle">Enter your email and a new password</p>

    <% if (!msg.isEmpty()) { %>
        <div class="<%= msgType.equals("success") ? "msg-success" : "msg-error" %>"><%= msg %></div>
    <% } %>

    <form method="POST" action="" onsubmit="return validateForm()">
        <input type="email" name="email" placeholder="Registered Email" required>
        
        <div class="password-box">
          <input type="password" name="newPassword" id="newPassword" placeholder="New Password" required>
          <span class="eye" onclick="toggleVisibility('newPassword')">👁</span>
        </div>

        <div class="password-box">
          <input type="password" id="confirmPassword" placeholder="Confirm New Password" required>
          <span class="eye" onclick="toggleVisibility('confirmPassword')">👁</span>
        </div>

        <p id="js-error" class="js-error">Passwords do not match!</p>

        <button type="submit">Update Password</button>
    </form>

    <p class="links">
      Remembered your password? <a href="login.jsp">Back to Login</a>
    </p>
  </div>

  <script>
    // Toggle Password Visibility
    function toggleVisibility(inputId) {
      const input = document.getElementById(inputId);
      const type = input.getAttribute("type") === "password" ? "text" : "password";
      input.setAttribute("type", type);
    }

    // Validate if passwords match before sending to server
    function validateForm() {
      const newPassword = document.getElementById("newPassword").value;
      const confirmPassword = document.getElementById("confirmPassword").value;
      const errorMsg = document.getElementById("js-error");

      if (newPassword !== confirmPassword) {
        errorMsg.style.display = "block";
        return false; // Stop form submission
      }
      errorMsg.style.display = "none";
      return true; // Allow form submission to Java Backend
    }
  </script>

</body>
</html>
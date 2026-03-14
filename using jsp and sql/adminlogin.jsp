<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. BACKEND LOGIC: Admin Database Authentication
    String msg = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to database
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vr_db", "root", "crx.sql");
            
            // Query the admins table
            String query = "SELECT id, fullname FROM admins WHERE email = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Success! Admin found in the database
                session.setAttribute("adminId", rs.getString("id"));
                session.setAttribute("adminName", rs.getString("fullname"));
                response.sendRedirect("admindasboard.jsp");
                return;
            } else {
                msg = "Invalid admin email or password.";
            }
            con.close();
        } catch (Exception e) {
            msg = "Database Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Login - Vehicle Registration</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, Helvetica, sans-serif; }
    body { background-color: #d9f2ff; height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; }
    .top-header { text-align: center; margin-bottom: 20px; }
    .logo { width: 300px; height: auto; }
    .login-box { background: #ffffff; width: 360px; padding: 30px; border-radius: 8px; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); text-align: center; }
    .login-box h1 { font-size: 24px; margin-bottom: 8px; color: #111827; }
    .subtitle { font-size: 14px; color: #6b7280; margin-bottom: 20px; }
    .login-box input[type="email"], .login-box input[type="password"] { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #e5e7eb; border-radius: 6px; font-size: 14px; }
    .password-box { position: relative; }
    .eye { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); font-size: 18px; color: #9ca3af; cursor: pointer; user-select: none; z-index: 10; }
    button { width: 100%; padding: 12px; background-color: #1f3c88; border: none; border-radius: 6px; color: #ffffff; font-size: 15px; cursor: pointer; font-weight: bold; }
    button:hover { background-color: #152b65; }
    .error-msg { color: red; font-size: 14px; margin-bottom: 15px; font-weight: bold; }
    .links { margin-top: 20px; font-size: 14px; color: #6b7280; }
    .links a { color: #3b82f6; text-decoration: none; }
  </style>
</head>
<body>

  <div class="top-header">
    <h2 style="color: #1f3c88; font-size: 28px;">Vehicle Registration Admin Panel</h2>
  </div>

  <div class="login-box">
    <h1>Admin Sign In</h1>
    <p class="subtitle">Secure access for administrators</p>

    <% if (!msg.isEmpty()) { %>
        <div class="error-msg"><%= msg %></div>
    <% } %>

    <form method="POST" action="">
        <input type="email" name="email" placeholder="Admin Email" required>
        <div class="password-box">
          <input type="password" name="password" id="password" placeholder="Password" required>
          <span class="eye" id="togglePassword">👁</span>
        </div>
        <button type="submit">Sign In to Dashboard</button>
    </form>

    <p class="links">
      Not an admin? <a href="login.jsp">Back to User Login</a>
    </p>
  </div>

  <script>
    const togglePassword = document.getElementById("togglePassword");
    const passwordInput = document.getElementById("password");
    togglePassword.addEventListener("click", () => {
      const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
      passwordInput.setAttribute("type", type);
    });
  </script>

</body>
</html>
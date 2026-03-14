<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. BACKEND LOGIC: Handle Database Validation when form is submitted
    String msg = "";
    String msgType = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to database using provided credentials
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vr_db", "root", "crx.sql");
            
            // Prepare SQL query to check if the user exists
            // NOTE: Your schema DOES NOT have a password column. 
            // Currently, this only checks if the email exists.
            String query = "SELECT id, fullname FROM users WHERE email = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // User found. 
                // IF YOU ADD A PASSWORD COLUMN, add it to the SELECT query and verify it here:
                // String dbPassword = rs.getString("password");
                // if(password.equals(dbPassword)) { ... login success ... }
                
                // For now, since email exists, we consider it a success based on your schema
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("fullname"));
                
                // Redirect to dashboard (assuming dashboard.jsp exists)
                response.sendRedirect("dashboard.jsp");
                return; // Stop processing the rest of the JSP
            } else {
                msg = "Incorrect email or account does not exist.";
                msgType = "error";
            }
            
            con.close();
        } catch (Exception e) {
            msg = "Error connecting to database: " + e.getMessage();
            msgType = "error";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <style>
  	* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body {
    background-color: #d9f2ff;
    height: 100vh;
}

.heading{
    display: flex;
    justify-content: center;
    align-items: center;
}

.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 50%;
}

.login-box {
    background: #ffffff;
    width: 360px;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
    text-align: center;
    margin-top: 150px;
}

.login-box h1 {
    font-size: 24px;
    margin-bottom: 8px;
    color: #111827;
}

.subtitle {
    font-size: 14px;
    color: #6b7280;
    margin-bottom: 20px;
}

.login-box input[type="email"],
.login-box input[type="password"] {
    width: 100%;
    padding: 12px;
    margin-bottom: 15px;
    border: 1px solid #e5e7eb;
    border-radius: 6px;
    font-size: 14px;
}

.password-box {
    position: relative;
}

.eye {
    position: absolute;
    right: 12px;
    top: 50%; /* Adjusted for better centering */
    transform: translateY(-50%);
    font-size: 18px; /* Increased slightly for better clickability */
    color: #9ca3af;
    cursor: pointer;
    user-select: none;
    z-index: 10;
}

.options {
    display: flex;
    justify-content: flex-end; /* Aligned right naturally */
    font-size: 13px;
    margin-bottom: 20px;
}

.options a {
    text-decoration: none;
    color: #3b82f6;
}

button {
    width: 100%;
    padding: 12px;
    background-color: #4f7df3;
    border: none;
    border-radius: 6px;
    color: #ffffff;
    font-size: 15px;
    cursor: pointer;
}

button:hover {
    background-color: #3f6ae0;
}

.signup {
    margin-top: 18px;
    font-size: 14px;
    color: #6b7280;
}

.signup a {
    color: #3b82f6;
    text-decoration: none;
}

.top-header{
    text-align:center;
    margin-top:40px;
}

.logo{
    margin-top: -120px;
    margin-bottom: 0px;
    width:400px;
    height:auto;
}

.error-msg {
    color: red;
    font-size: 14px;
    margin-top: 10px;
    margin-bottom: 10px;
}
  </style>
</head>

<body>


  <div class="container">
    <div class="login-box">
      <h1>Sign In</h1>
      <p class="subtitle">Enter your credentials to continue</p>

      <% if (!msg.isEmpty()) { %>
          <div class="error-msg"><%= msg %></div>
      <% } %>

      <form method="POST" action="">
          <input type="email" name="email" id="email" placeholder="Email" required>

          <div class="password-box">
            <input type="password" name="password" id="password" placeholder="Password" required>
            <span class="eye" id="togglePassword">👁</span>
          </div>

          <div class="options">
            <a href="forgot_password.jsp">Forgot password?</a>
          </div>

          <button type="submit" id="loginBtn">Sign In</button>
      </form>

      <p class="signup">
        Don't have an account ? <a href="registration.jsp">Create one</a>
      </p>

      <p class="signup">
        Login as Admin ? <a href="adminlogin.jsp">Admin Login</a>
      </p>

    </div>
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
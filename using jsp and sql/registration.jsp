<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. BACKEND LOGIC: Handle Database Insertion when form is submitted
    String msg = "";
    String msgType = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String mobileNo = request.getParameter("mobileNo");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincodeStr = request.getParameter("pincode");

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to database using provided credentials
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vr_db", "root", "crx.sql");
            
            // Prepare SQL query based on your schema
            String query = "INSERT INTO users(fullname, email, mobileNo, address, city, state, pincode) VALUES(?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, mobileNo);
            ps.setString(4, address);
            ps.setString(5, city);
            ps.setString(6, state);
            ps.setInt(7, Integer.parseInt(pincodeStr));
            
            // Execute the insert
            int rowCount = ps.executeUpdate();
            if (rowCount > 0) {
                msg = "Account created successfully!";
                msgType = "success";
                response.sendRedirect("login.jsp");
            } else {
                msg = "Failed to create account. Please try again.";
                msgType = "error";
            }
            
            con.close();
        } catch (SQLIntegrityConstraintViolationException e) {
            msg = "Error: Email already exists!";
            msgType = "error";
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
            msgType = "error";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up</title>
    <style>
        /* CSS from your reference with minor scroll/flex fixes for the new fields */
        body {
            margin: 0;
            min-height: 100vh; /* Changed from height to min-height for longer form */
            padding: 20px 0; 
            font-family: Arial, sans-serif;
            background: #d9f2ff;
            display: flex;
            align-items: center;
            justify-content: center;
            box-sizing: border-box;
        }

        .container {
            width: 360px;
            padding: 25px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .container h2 {
            margin-bottom: 5px;
        }

        .subtitle {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
        }

        input {
            width: 95%;
            padding: 7px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 10px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 5px;
            margin-top: 10px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background: #1e4ed8;
        }

        .error {
            color: red;
            font-size: 14px;
            margin-top: 10px;
        }
        
        .success {
            color: green;
            font-size: 14px;
            margin-top: 10px;
            font-weight: bold;
        }

        .bottom-text {
            margin-top: 15px;
            font-size: 14px;
        }

        .bottom-text a {
            color: #2563eb;
            text-decoration: none;
        }

        .password-box {
            position: relative;
        }

        .password-box input {
            width: 100%; /* Reset to align perfectly with other fields */
            padding-right: 40px;
        }

        .eye {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            user-select: none;
            font-size: 18px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Sign Up</h2>
        <p class="subtitle">Create your account</p>

        <% if (!msg.isEmpty()) { %>
            <div class="<%= msgType %>"><%= msg %></div>
        <% } %>

        <form method="POST" action="" onsubmit="return validateForm()">
            <input type="text" name="fullname" id="name" placeholder="Full Name" required>
            <input type="email" name="email" id="email" placeholder="Email" required>
            
            <input type="text" name="mobileNo" id="mobileNo" placeholder="Mobile Number" maxlength="15" required>
            <input type="text" name="address" id="address" placeholder="Address" required>
            
            <div style="display: flex; gap: 5px;">
                <input type="text" name="city" id="city" placeholder="City" style="width: 33%" required>
                <input type="text" name="state" id="state" placeholder="State" style="width: 33%" required>
                <input type="number" name="pincode" id="pincode" placeholder="Pincode" style="width: 33%" required>
            </div>

            <div class="password-box">
                <input type="password" id="password" name="password" placeholder="Password" required>
                <span class="eye" data-target="password">👁</span>
            </div>

            <div class="password-box">
                <input type="password" id="confirmPassword" placeholder="Confirm Password" required>
                <span class="eye" data-target="confirmPassword">👁</span>
            </div>

            <button type="submit" id="registerBtn">Sign Up</button>
            <p id="js-error" class="error"></p>
        </form>

        <p class="bottom-text">
            Already have an account?
            <a href="login.jsp">Login</a>
        </p>
    </div>

    <script>
        // Password visibility toggler
        document.querySelectorAll(".eye").forEach(eye => {
            eye.addEventListener("click", () => {
                const targetId = eye.getAttribute("data-target");
                const input = document.getElementById(targetId);

                if (input.type === "password") {
                    input.type = "text";
                    eye.textContent = "👁️"; // can be updated to open/closed eye variations
                } else {
                    input.type = "password";
                    eye.textContent = "👁️";
                }
            });
        });

        // Validate password matching before submitting the form to the backend
        function validateForm() {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const errorMsg = document.getElementById("js-error");

            if (password !== confirmPassword) {
                errorMsg.innerText = "Passwords do not match!";
                return false; // Prevents form submission
            }
            
            errorMsg.innerText = "";
            return true; // Allows form submission to Java Backend
        }
    </script>
</body>
</html>
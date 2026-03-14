<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. BACKEND LOGIC: Process the form submission
    String msg = "";
    String msgType = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Fetch all form inputs using their 'name' attributes
        String ownerName = request.getParameter("ownerName");
        String ownerMobile = request.getParameter("ownerMobile");
        String ownerEmail = request.getParameter("ownerEmail");
        String ownerAddress = request.getParameter("ownerAddress");
        
        String vehicleType = request.getParameter("vehicleType");
        String vehicleBrand = request.getParameter("vehicleBrand");
        String vehicleModel = request.getParameter("vehicleModel");
        String engineNumber = request.getParameter("engineNumber");
        String chassisNumber = request.getParameter("chassisNumber");
        
        String vehicleNumber = request.getParameter("vehicleNumber");
        String vehiclePriceStr = request.getParameter("vehiclePrice");
        
        String aadhaarNumber = request.getParameter("aadhaarNumber");
        String invoiceNumberStr = request.getParameter("invoiceNumber");

        // Retrieve the logged-in user's ID from the session
        String userId = "Unknown";
        if(session.getAttribute("userId") != null) {
            userId = String.valueOf(session.getAttribute("userId"));
        }

        // Safely parse integers (defaults to 0 if left blank)
        int vehiclePrice = 0;
        int invoiceNumber = 0;
        try { if(vehiclePriceStr != null && !vehiclePriceStr.isEmpty()) vehiclePrice = Integer.parseInt(vehiclePriceStr); } catch(Exception e){}
        try { if(invoiceNumberStr != null && !invoiceNumberStr.isEmpty()) invoiceNumber = Integer.parseInt(invoiceNumberStr); } catch(Exception e){}

        try {
            // Load Driver & Connect to Database
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/vr_db", "root", "crx.sql");
            
            // Prepare Insert Query matching the 'vehicle' table schema
            String query = "INSERT INTO vehicle (AadharNumber, chassisNumber, engineNumber, invoiceNumber, ownerAddress, ownerEmail, ownerMobile, ownerName, userId, vehicleBrand, vehicleModel, vehicleNumber, vehiclePrice, vehicleType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            
            ps.setString(1, aadhaarNumber);
            ps.setString(2, chassisNumber);
            ps.setString(3, engineNumber);
            ps.setInt(4, invoiceNumber);
            ps.setString(5, ownerAddress);
            ps.setString(6, ownerEmail);
            ps.setString(7, ownerMobile);
            ps.setString(8, ownerName);
            ps.setString(9, userId);
            ps.setString(10, vehicleBrand);
            ps.setString(11, vehicleModel);
            ps.setString(12, vehicleNumber);
            ps.setInt(13, vehiclePrice);
            ps.setString(14, vehicleType);
            
            // Execute the update
            int rowCount = ps.executeUpdate();
            if (rowCount > 0) {
                msg = "Vehicle Registered Successfully!";
                msgType = "success";
            } else {
                msg = "Failed to register vehicle. Please try again.";
                msgType = "error";
            }
            con.close();
            
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
            msgType = "error";
        }
    }
%>

<style>
    /* Scoped to this file automatically when included */
    .container {
        max-width: 1200px;
        background-color: #ffffff;
        margin: auto;
        padding: 30px;
        border-radius: 6px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1 { text-align: center; color: #1f3c88; margin-bottom: 5px; }
    .subtitle { text-align: center; color: #555; margin-bottom: 20px; }
    h2 { color: #333; border-bottom: 1px solid #ddd; padding-bottom: 5px; }
    .form_title { margin-top: 70px; margin-bottom: 25px; }
    .form-group { margin-top: 15px; }
    label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
    input, textarea, select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;}
    textarea { resize: vertical; height: 80px; }
    .buttons { margin-top: 30px; text-align: center; }
    button.submit-btn { padding: 10px 25px; border: none; border-radius: 4px; background-color: #1f3c88; color: white; font-size: 15px; cursor: pointer; }
    button.reset { padding: 10px 25px; border: none; border-radius: 4px; background-color: #777; color: white; font-size: 15px; cursor: pointer; margin-left: 10px; }
    .required { color: red; font-size: 16px; margin-left: 3px; }
    
    /* New styles for server messages */
    .msg-box { text-align: center; font-weight: bold; padding: 10px; margin-bottom: 20px; border-radius: 4px; }
    .msg-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .msg-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
</style>

<div class="container">
    <h1>Vehicle Registration Form</h1>
    <p class="subtitle">Fill in the details to register a new vehicle</p>

    <% if (!msg.isEmpty()) { %>
        <div class="msg-box <%= msgType.equals("success") ? "msg-success" : "msg-error" %>">
            <%= msg %>
        </div>
    <% } %>

    <form method="POST" action="">
        <h2 class="form_title">Owner Information</h2>
        <div class="form-group">
            <label>Owner Full Name</label>
            <input id="ownerName" name="ownerName" type="text" placeholder="Enter full name" required>
        </div>
        <div class="form-group">
            <label>Mobile Number</label>
            <input id="ownerMobile" name="ownerMobile" type="number" placeholder="Enter mobile number" required>
        </div>
        <div class="form-group">
            <label>Email Address</label>
            <input id="ownerEmail" name="ownerEmail" type="email" placeholder="Enter email">
        </div>
        <div class="form-group">
            <label>Full Address</label>
            <textarea id="ownerAddress" name="ownerAddress" placeholder="Enter complete address"></textarea>
        </div>

        <h2 class="form_title">Essentials Details</h2>
        <div class="form-group">
            <label>Vehicle Type</label>
            <select id="vehicleType" name="vehicleType">
                <option value="">Select vehicle type</option>
                <option value="Two Wheeler">Two Wheeler</option>
                <option value="Four Wheeler">Four Wheeler</option>
                <option value="Commercial">Commercial</option>
            </select>
        </div>
        <div class="form-group">
            <label>Vehicle Brand</label>
            <input id="vehicleBrand" name="vehicleBrand" type="text" placeholder="e.g. Honda, Tata">
        </div>
        <div class="form-group">
            <label>Vehicle Model</label>
            <input id="vehicleModel" name="vehicleModel" type="text" placeholder="Enter model name">
        </div>
        <div class="form-group">
            <label>Engine Number</label>
            <input id="engineNumber" name="engineNumber" type="text" placeholder="Enter engine number">
        </div>
        <div class="form-group">
            <label>Chassis Number</label>
            <input id="chassisNumber" name="chassisNumber" type="text" placeholder="Enter chassis number">
        </div>

        <h2 class="form_title">Vehicle Details</h2>
        <div class="form-group">
            <label>Vehicle Number <span class="required">*</span></label>
            <input id="vehicleNumber" name="vehicleNumber" type="text" placeholder="MH-24-AB-1234" required>
        </div>
        <div class="form-group">
            <label>Vehicle Price (₹)</label>
            <input id="vehiclePrice" name="vehiclePrice" type="number" placeholder="Enter vehicle price">
        </div>

        <h2 class="form_title">Document Details</h2>
        <div class="form-group">
            <label>Adhaar Card Number</label>
            <input id="aadhaarNumber" name="aadhaarNumber" type="number" placeholder="Enter adhaar number">
        </div>
        <div class="form-group">
            <label>Vehicle Invoice Number</label>
            <input id="invoiceNumber" name="invoiceNumber" type="number" placeholder="Enter invoice number">
        </div>

        <div class="buttons">
            <button type="submit" class="submit-btn">Submit Registration</button>
            <button type="reset" class="reset">Reset</button>
        </div>
    </form>
</div>
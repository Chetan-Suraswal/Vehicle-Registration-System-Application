<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Vehicle Registration Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <style>
    /* =========================
       ROOT VARIABLES
    ========================= */
    :root {
      --primary: #3b82f6;
      --primary-dark: #2563eb;
      --bg: #d9f2ff;
      --white: #ffffff;
      --black: #0f172a;
      --gray: #64748b;
      --border: #e5e7eb;
    }

    /* =========================
       GLOBAL RESET
    ========================= */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Segoe UI", system-ui, sans-serif;
    }

    body {
      background: var(--bg);
      color: var(--black);
    }

    /* =========================
       APP LAYOUT
    ========================= */
    .app-container {
      display: flex;
      height: 100vh;
    }

    /* =========================
       SIDEBAR
    ========================= */
    .sidebar {
      width: 240px;
      background: var(--white);
      border-right: 1px solid var(--border);
      padding: 20px;
      display: flex;
      flex-direction: column;
      overflow: hidden;
      transition: width 0.25s ease;
    }

    .logo {
      color: var(--primary);
      font-size: 22px;
      font-weight: 700;
      margin-bottom: 30px;
    }

    .sidebar a {
      display: flex;
      align-items: center;
      justify-content: flex-start;
      text-decoration: none;
      color: var(--black);
      padding: 12px 14px;
      border-radius: 8px;
      margin-bottom: 8px;
      font-weight: 500;
      white-space: nowrap;
      transition: background 0.2s, color 0.2s;
    }

    .sidebar a:hover {
      background: var(--primary);
      color: var(--white);
    }

    #logoutBtn {
      margin-top: auto;
      padding: 12px;
      border: none;
      border-radius: 8px;
      background: #ef4444;
      color: white;
      font-weight: 600;
      cursor: pointer;
    }

    /* =========================
       COLLAPSED SIDEBAR
    ========================= */
    .sidebar.collapsed {
      width: 0;
      padding: 0;
      border: none;
      overflow: hidden;
    }

    .sidebar.collapsed .logo,
    .sidebar.collapsed a,
    .sidebar.collapsed #logoutBtn {
      display: none !important;
    }

    /* =========================
       MAIN AREA
    ========================= */
    .main-area {
      flex: 1;
      display: flex;
      flex-direction: column;
      min-width: 0;
    }

    /* =========================
       TOP BAR
    ========================= */
    .topbar {
      height: 64px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 24px;
      margin-top: 10px;
    }

    .topbar-left {
      display: flex;
      align-items: center;
    }

    .app-title {
      font-size: 16px;
      font-weight: 600;
    }

    .menu-btn {
      background: none;
      border: none;
      font-size: 22px;
      cursor: pointer;
      margin-right: 12px;
      color: var(--black);
    }

    .menu-btn:hover {
      color: var(--primary);
    }

    /* =========================
       MAIN CONTENT
    ========================= */
    .main-content {
      padding: 24px;
      overflow-y: auto;
    }

    /* Welcome Section */
    .welcome-section {
      margin-bottom: 30px;
    }

    .welcome-title {
      font-size: 24px;
      font-weight: 600;
      color: var(--black);
      margin-bottom: 6px;
    }

    .welcome-subtitle {
      font-size: 15px;
      color: var(--gray);
    }

    /* Card Grid */
    .card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 20px;
    }

    .card {
      background: var(--white);
      padding: 24px;
      border-radius: 12px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.02);
      display: flex;
      flex-direction: column;
    }

    .card h2 {
      font-size: 18px;
      margin-bottom: 12px;
      color: var(--black);
    }

    .card p {
      color: var(--gray);
      font-size: 14px;
      line-height: 1.5;
      margin-bottom: 16px;
    }

    .card ul {
      padding-left: 18px;
      margin-bottom: 20px;
      flex-grow: 1;
    }

    .card li {
      color: var(--gray);
      font-size: 13px;
      margin-bottom: 6px;
    }

    .card-footer {
      font-size: 13px;
      color: var(--gray);
      font-weight: 500;
      margin-top: auto;
    }

    /* How It Works Section */
    .how-it-works-section {
      background: var(--white);
      padding: 24px;
      border-radius: 12px;
      margin-top: 24px;
      text-align: center;
      box-shadow: 0 2px 4px rgba(0,0,0,0.02);
    }

    .how-it-works-section h3 {
      font-size: 18px;
      margin-bottom: 20px;
      color: var(--black);
    }

    .flow-container {
      display: flex;
      align-items: center;
      justify-content: center;
      flex-wrap: wrap;
      gap: 12px;
    }

    .flow-step {
      background: var(--white);
      padding: 10px 20px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      color: var(--black);
      box-shadow: 0 2px 6px rgba(0,0,0,0.06);
    }

    .flow-arrow {
      background: var(--white);
      padding: 10px 14px;
      border-radius: 8px;
      color: var(--gray);
      font-weight: bold;
      box-shadow: 0 2px 6px rgba(0,0,0,0.06);
    }

    @media (max-width: 768px) {
      .sidebar {
        width: 200px;
      }
    }
  </style>
</head>

<body>

  <div class="app-container">

    <jsp:include page="sidebar.jsp" />

    <div class="main-area">

      <header class="topbar">
        <div class="topbar-left">
          <button class="menu-btn" id="toggleSidebar">☰</button>
          <span class="app-title">Vehicle Registration System</span>
        </div>
      </header>

      <main class="main-content" id="mainContent">
          <%
              String pageReq = request.getParameter("page");
              
              if (pageReq == null || pageReq.equals("overview")) {
          %>
              <div class="welcome-section">
                <h1 class="welcome-title">Welcome to Vehicle Registration System</h1>
                <p class="welcome-subtitle">Manage your profile and vehicles securely from one dashboard.</p>
              </div>

              <div class="card-grid">
                  <div class="card">
                      <h2>Profile</h2>
                      <p>Your profile stores your personal and contact details. Completing your profile is mandatory before registering any vehicle.</p>
                      <ul>
                        <li>User ID & Email</li>
                        <li>Full Name & Mobile Number</li>
                        <li>Address Details</li>
                      </ul>
                      <div class="card-footer">Step: Sidebar &rarr; Profile &rarr; Fill details &rarr; Save Profile</div>
                  </div>

                  <div class="card">
                      <h2>Add Vehicle</h2>
                      <p>Register a new vehicle by entering owner, vehicle, insurance, and document details.</p>
                      <ul>
                        <li>Owner Information</li>
                        <li>Vehicle Type, Brand & Model</li>
                        <li>Engine & Chassis Number</li>
                        <li>Insurance & Document Details</li>
                      </ul>
                      <div class="card-footer">Step: Sidebar &rarr; Add Vehicle &rarr; Submit Registration</div>
                  </div>

                  <div class="card">
                      <h2>My Vehicles</h2>
                      <p>View all vehicles registered under your account. Each user can only see their own vehicle records.</p>
                      <ul>
                        <li>Registered Vehicle List</li>
                        <li>Registration Date</li>
                        <li>Current Status</li>
                      </ul>
                      <div class="card-footer">Step: Sidebar &rarr; My Vehicles</div>
                  </div>
              </div>

              <div class="how-it-works-section">
                <h3>How the System Works</h3>
                <div class="flow-container">
                  <div class="flow-step">Login</div>
                  <div class="flow-arrow">&rarr;</div>
                  <div class="flow-step">Complete Profile</div>
                  <div class="flow-arrow">&rarr;</div>
                  <div class="flow-step">Add Vehicle</div>
                  <div class="flow-arrow">&rarr;</div>
                  <div class="flow-step">View My Vehicles</div>
                </div>
              </div>

          <%
              } else if (pageReq.equals("add_vehicle") || pageReq.equals("my_vehicle") || pageReq.equals("profile")) {
                  // Safely include the requested JSP page
          %>
                  <jsp:include page="<%= pageReq + \".jsp\" %>" />
          <%
              } else {
          %>
                  <h2>404 - Page Not Found</h2>
          <%
              }
          %>
      </main>

    </div>
  </div>

  <script>
      document.getElementById("toggleSidebar").addEventListener("click", function() {
          document.getElementById("sidebar").classList.toggle("collapsed");
      });
  </script>

</body>
</html>

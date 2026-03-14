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
      background: var(--white);
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 24px;
    }

    .topbar-left {
      display: flex;
      align-items: center;
    }

    .app-title {
      font-size: 18px;
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

    /* Card Base Styles */
    .card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 20px;
    }
    .card {
      background: var(--white);
      padding: 20px;
      border-radius: 12px;
      border: 1px solid var(--border);
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .card h2 {
      font-size: 18px;
      margin-bottom: 10px;
    }
    .card p {
      color: var(--gray);
      font-size: 14px;
      margin-bottom: 16px;
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
              <div class="card-grid">
                  <div class="card">
                      <h2>Welcome to VehicleReg</h2>
                      <p>Select an option from the sidebar to continue.</p>
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
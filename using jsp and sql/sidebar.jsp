<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
/* =========================
   ROOT VARIABLES (Scoped for Sidebar)
========================= */
:root {
  --primary: #3b82f6;
  --white: #ffffff;
  --black: #0f172a;
  --border: #e5e7eb;
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

/* Sidebar links */
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

/* Logout button */
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
  width: 70px; /* Adjusted to your second definition block */
  padding: 20px 10px;
  border: none;
}

/* Hide logo */
.sidebar.collapsed .logo {
  font-size: 0;
  display: none;
}

/* Hide link text cleanly */
.sidebar.collapsed a {
  justify-content: center;
  font-size: 0;
  padding: 12px 0;
  text-align: center;
}

.sidebar.collapsed a::after {
  content: attr(data-icon);
  font-size: 18px;
}

/* Logout collapsed */
.sidebar.collapsed #logoutBtn {
  font-size: 0;
  padding: 12px 0;
  display: flex;
  justify-content: center;
  display: none !important;
}

.sidebar.collapsed #logoutBtn::before {
  content: "⏻";
  font-size: 18px;
}

/* =========================
   RESPONSIVE
========================= */
@media (max-width: 768px) {
  .sidebar {
    width: 200px;
  }
}
</style>

<aside class="sidebar" id="sidebar">
  <h2 class="logo">VehicleReg</h2>

  <a href="dashboard.jsp?page=overview">Dashboard</a>
  <a href="dashboard.jsp?page=add_vehicle">Add Vehicle</a>
  <a href="dashboard.jsp?page=my_vehicle">My Vehicles</a>
  <a href="dashboard.jsp?page=profile">Profile</a>
	
   <a id="logoutBtn" href="logout.jsp">Logout</a>
</aside>
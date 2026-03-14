<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Check if a session exists, and if so, completely invalidate it.
    // This clears "userId" and any other attributes you set during login.
    if (session != null) {
        session.invalidate();
    }
    
    // 2. Redirect the user back to the login page after clearing the session.
    response.sendRedirect("login.jsp");
%>
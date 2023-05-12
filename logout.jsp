<%@ page language="java" %>
<%@ page import="javax.servlet.http.*" %>

<%
// Invalidate the user session and redirect to the login page
if (session != null) {
    session.invalidate();
}
response.sendRedirect("login.jsp");
%>

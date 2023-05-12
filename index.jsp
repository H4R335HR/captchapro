<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Index Page</title>
	<link rel="stylesheet" type="text/css" href="style.css">
    <script src="code.js" defer></script>
</head>
<body>

<%
	//If user is not logged in, redirect him to login page
	if(session == null || session.getAttribute("user_id") == null) {
		response.sendRedirect("login.jsp");
	} else {
		String user_id = (String) session.getAttribute("user_id");
		Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String myuser = "noob";
			String mypassword = "password";
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mytest", myuser, mypassword);
			String sql = "SELECT * FROM users WHERE user_id = ?";
			stmt = conn.prepareStatement(sql);
            stmt.setString(1, user_id);
			rs = stmt.executeQuery();
	
			// Get the user details from the result set
			while (rs.next()) {
				String username = rs.getString("username");
				String phone = rs.getString("phone");
				String email = rs.getString("email");
				request.setAttribute("username", username);
				request.setAttribute("email", email);
                request.setAttribute("phone", phone);
			}
		} catch (SQLException | ClassNotFoundException ex) {
			ex.printStackTrace();
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
		}
%>
		<a href="logout.jsp">Logout</a>
		<h1>Welcome <%= request.getAttribute("username") %>!</h1>
		<p>Here are your details:</p>
    		<ul>
        <li><strong>Username:</strong> <%= request.getAttribute("username") %></li>
        <li><strong>User ID:</strong> <%= user_id %></li>
        <li><strong>Email:</strong> <%= request.getAttribute("email")  %></li>
        <li><strong>Telephone:</strong> <%= request.getAttribute("phone")  %></li>
    		</ul>
		<a href="comments.jsp">Go to Comments</a>

		
<% } %>

</body>
</html>

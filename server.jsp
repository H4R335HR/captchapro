<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
	<title>User Registration</title>
	<link rel="stylesheet" type="text/css" href="style.css">
    <script src="code.js" defer></script>
</head>
<body>
	<div class="container">
	<h1>User Registration</h1>
	<%
    String message = "";
    String user_id = (String) session.getAttribute("user_id");

    // Redirect to login page if unauthorized user is directly accssing the page 
    if (user_id == null && !request.getMethod().equals("POST")) {
        response.sendRedirect("register.jsp");
        return;
    } // Redirect to index if logged in user is accessing the page
    if (user_id != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    //Check Captcha
    String userAnswer = request.getParameter("captchaAnswer");
    // if captcha expired or is blank redirect to login
    if (session.getAttribute("captchaResult") == null || userAnswer.trim().equals("")) {
        message = "Captcha Blank or expired: Please try again";
        request.setAttribute("message", message);
        response.sendRedirect("register.jsp");
        return;
    }
    // if captcha is wrong redirect back to comments section
    String captchaResult = session.getAttribute("captchaResult").toString();
    if (!userAnswer.equals(captchaResult)){
        message = "Invalid Captcha: Please try again";
        request.setAttribute("message", message);
        RequestDispatcher rd = request.getRequestDispatcher("register.jsp");
        rd.forward(request, response);
        return;
    } else {  //else reset captcha session variable so it cannot be reused
        session.removeAttribute("captchaResult");
    }


	int rowsInserted=0;    
    try {
        // Load and register the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        throw new ServletException("Unable to load JDBC driver", e);
    }
    // Get the form data
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");

    // Set up the database connection
    String url = "jdbc:mysql://localhost:3306/mytest";
    String dbusername = "noob";
    String dbPassword = "password";
    Connection conn = DriverManager.getConnection(url, dbusername, dbPassword);
    
    // Check if username, email or phone already exist
    PreparedStatement checkStmt = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE username=? OR email=? OR phone=?");
    checkStmt.setString(1, username);
    checkStmt.setString(2, email);
    checkStmt.setString(3, phone);
    ResultSet checkResult = checkStmt.executeQuery();
    System.out.println(checkStmt.toString());
    checkResult.next();
    int rowCount = checkResult.getInt(1);
    
    if (rowCount > 0) {
        // Username, email or phone already exist, registration failed
        rowsInserted = 0;
    } else {
        // Username, email and phone don't exist, insert the user into the database
        String sql = "INSERT INTO users (username, email, password, phone) VALUES (?, ?, ?, ?)";
        PreparedStatement insertStmt = conn.prepareStatement(sql);
        insertStmt.setString(1, username);
        insertStmt.setString(2, email);
        insertStmt.setString(3, password);
        insertStmt.setString(4, phone);
        System.out.println(insertStmt.toString());
        rowsInserted = insertStmt.executeUpdate();
    }
    
    // Close the database connection
    conn.close();
	%>
	<% if(rowsInserted > 0) { %>
		<p>Registration successful! </p><br/> <a href="register.jsp">Click here to login</a></p>
	<% } else { %>
		<p>Registration failed due to duplicate username, email or phone.<br/> <a href="register.jsp">Try Again</a></p>
	<% } %>
	</div>
	                        
</body>
</html>


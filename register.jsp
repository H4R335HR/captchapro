<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
String message = (String) request.getAttribute("message");
String user_id = (String) session.getAttribute("user_id");

if (message == null) {
    message = "";
}
if (user_id != null) {
	response.sendRedirect("index.jsp");
	return;
}
%>
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
	<form method="post" action="server.jsp">
		<label for="username">Username:</label>
		<input type="text" name="username" required>
		
		<label for="email">Email:</label>
		<input type="email" name="email" required>
		
		<label for="password">Password:</label>
		<input type="password" name="password" required>
		
		<label for="phone">Phone Number:</label>
		<input type="tel" name="phone" required pattern="[0-9]{10}">
		<div id="captchaContainer">
			<img src="captcha.jsp" alt="captcha image" id="imgCaptcha">
			<a href="#" id="anchor" onclick="reloadCaptcha()">
				<img src="reload_s.jpg" alt="Reload Captcha" id="reloadCaptcha">
			</a>
		</div>
		<label for="captchaAnswer">Input the text shown above in the box below:</label>
		<input type="text" id="captchaAnswer" name="captchaAnswer">
		<h4><%= message %></h4>
		<button type="submit" > Register </button>
		<a href="login.jsp">Go to login page</a>
	</form>
	</div>
	<script>
        function reloadCaptcha() {
            location.reload();
        }
    </script>                       
</body>
</html>

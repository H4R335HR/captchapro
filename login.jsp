<%@page import="java.util.Date"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%
String user_id = (String) session.getAttribute("user_id");

if (user_id != null) {
    response.sendRedirect("index.jsp");
    return;
}

String message = (String) request.getAttribute("message");
if (message == null) {
    message = "";
}

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="style.css">
    <script src="code.js" defer></script>
    <title>Login Page</title>
</head>
<body>
    <div class="container">
        <h1>Hello user from <%= request.getRemoteAddr() %></h1>
        <p>Please enter your credentials below to login.</p>
        <p>Current Time: <%= new Date() %></p>
        <form method="post" action="captcha.jsp">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username"><br>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password"><br>
            <input type="hidden" name="destination" value="success.jsp">
            <!-- Word-based captcha -->
            
            <div id="captchaContainer">
                <img src="captcha.jsp" alt="captcha image" id="imgCaptcha">
                <a href="#" id="anchor" onclick="reloadCaptcha()">
                    <img src="reload_s.jpg" alt="Reload Captcha" id="reloadCaptcha">
                </a>
            </div>
            <br>
            <label for="captchaAnswer">Input the text shown above in the box below:</label>
            <input type="text" id="captchaAnswer" name="captchaAnswer">
            <h4><%= message %></h4>
            <button type="submit">Login</button>
            <a href="register.jsp">Click here to register</a>
        </form>
        
    </div>
</body>
</html>


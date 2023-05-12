<%@page import="java.sql.*, javax.servlet.http.*, java.util.*, org.apache.commons.lang3.StringEscapeUtils"%>
<%
    // Get the session and user_id attribute
    String user_id = (String) session.getAttribute("user_id");
    String message = (String) request.getAttribute("message");

    // Redirect to login page if user is not logged in
    if (user_id == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (message == null) {
        message = "";
    }
    // Connect to the database and retrieve the comments
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    List<String[]> comments = new ArrayList<>();

    try {
        Class.forName("com.mysql.jdbc.Driver");
        String myuser = "noob";
        String mypassword = "password";
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mytest", myuser, mypassword);
        String sql = "SELECT comments.comment, users.username, comments.created_at FROM comments INNER JOIN users ON comments.user_id = users.user_id";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        // Get the comments from the result set
        while (rs.next()) {
            String username = rs.getString("username");
            String comment = StringEscapeUtils.escapeHtml4(rs.getString("comment")); // escape HTML special characters
            java.sql.Timestamp created_at = rs.getTimestamp("created_at");
            String[] commentArr = {username, comment, created_at.toString()};
            comments.add(commentArr);
        }
    } catch (SQLException | ClassNotFoundException ex) {
        ex.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Comments</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <script src="code.js" defer></script>
</head>
<body>
    <a href=".">Home</a>
    <a href="logout.jsp">Logout</a>
    <div class="comment-box">
        <h1>Comments</h1>
        <ol>
            <%-- Display comments --%>
            <% for (String[] comment : comments) { %>
                <li>
                    <span class="comment"><%= comment[1] %></span><hr>
                    <div class="user-timestamp"><span class="username"> - <%= comment[0] %></span>
                    <span class="timestamp"> [<%= comment[2] %>]</span></div>
                </li>
            <% } %>
        </ol>

    <form action="post_comment.jsp" method="post">
        <p><label for="comment">New Comment:</label></p>
        <div><textarea name="comment" id="comment" rows="5" cols="100"></textarea>
            <div id="captchaContainer">
                <img src="mcaptcha.jsp" alt="captcha image" id="imgCaptcha">
                <a href="#" id="anchor" onclick="reloadCaptcha()">
                    <img src="reload_s.jpg" alt="Reload Captcha" id="reloadCaptcha">
                </a>
            </div>
            <label for="captchaAnswer" >Input the text shown above in the box:</label>
            <input type="text" id="captchaAnswer" name="captchaAnswer">
            <h4><%= message %></h4>
        </div>
        
        <p><input type="submit" value="Post Comment"></p>
    </form></div>
   
</body>
</html>


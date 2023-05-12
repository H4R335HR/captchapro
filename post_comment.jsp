<%@page import="java.sql.*, javax.servlet.http.*, java.util.*"%>
<%
    // Get the session and user_id attribute
    String user_id = (String) session.getAttribute("user_id");
    String message = "";

    // Redirect to login page if user is not logged in
    if (user_id == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    //Check Captcha
    String userAnswer = request.getParameter("captchaAnswer");
    // if captcha expired or is blank redirect to comments section
    if (session.getAttribute("captchaResult") == null || userAnswer.trim().equals("")) {
        response.sendRedirect("comments.jsp");
        return;
    }
    // if captcha is wrong redirect back to comments section
    String captchaResult = session.getAttribute("captchaResult").toString();
    if (!userAnswer.equals(captchaResult)){
        message = "Invalid Captcha: Please try again";
        request.setAttribute("message", message);
        RequestDispatcher rd = request.getRequestDispatcher("comments.jsp");
        rd.forward(request, response);
        return;
    } else {
        session.removeAttribute("captchaResult");
    }
    
    // Get the comment from the request parameter
    String comment = request.getParameter("comment");

    // Check if the comment is blank or null
    if (comment == null || comment.trim().equals("")) {
        response.sendRedirect("comments.jsp");
        return;
    }

    // Connect to the database and insert the new comment
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        String myuser = "noob";
        String mypassword = "password";
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mytest", myuser, mypassword);
        String sql = "INSERT INTO comments (comment, user_id) VALUES (?, ?)";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, comment);
        stmt.setString(2, user_id);
        stmt.executeUpdate();
    } catch (SQLException | ClassNotFoundException ex) {
        ex.printStackTrace();
    } finally {
        try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    // Redirect back to the comments page
    response.sendRedirect("comments.jsp");
%>

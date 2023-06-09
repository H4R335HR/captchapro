<%@page import="java.sql.*"%>

    <%
    String message = "";
    String user_id = "";

    user_id = (String) session.getAttribute("user_id");

    if (user_id != null || !request.getMethod().equals("POST") ) {
        response.sendRedirect("index.jsp");
        return;
    }


    //Check Captcha
    String userAnswer = request.getParameter("captchaAnswer");
    // if captcha expired or is blank redirect to login
    if (session.getAttribute("captchaResult") == null || userAnswer.trim().equals("")) {
        message = "Invalid Captcha: Please try again";
        RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
        rd.forward(request, response);
        return;
    }
    // if captcha is wrong redirect back to login
    String captchaResult = session.getAttribute("captchaResult").toString();
    if (!userAnswer.equals(captchaResult)){
        message = "Invalid Captcha: Please try again";
        request.setAttribute("message", message);
        RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
        rd.forward(request, response);
        return;
    } else {  //else reset captcha session variable so it cannot be reused
        session.removeAttribute("captchaResult");
    }
    

    // Validate the username & password
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    request.setAttribute("username", username);
    request.setAttribute("password", password);

      
    // Connect to the database and retrieve the user's details
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        String myuser = "noob";
        String mypassword = "password";
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mytest", myuser, mypassword);
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, username);
        stmt.setString(2, password);
        rs = stmt.executeQuery();

        if (rs.next()) {
            // If the user's details are valid, set the attributes 
            user_id = rs.getString("user_id");
            HttpSession xsession = request.getSession(true);
            // Regenerate the session ID and create a new session to prevent session hijacking and fixation
            xsession.invalidate();
            xsession = request.getSession(true);
            xsession.setAttribute("user_id", user_id);

            // Forward to the welcome page
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
            return;
            
        } else {
            message = "Invalid Credentials: Please try again";
            request.setAttribute("message", message);
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
            return;
        }
    } catch (SQLException | ClassNotFoundException ex) {
        ex.printStackTrace();
        message = "Error: " + ex.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }    
    
         %>
    

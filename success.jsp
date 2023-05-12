<%@page import="java.sql.*"%>

    <%
    String luser_id = (String) session.getAttribute("user_id");

    if (luser_id != null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String message = "";
    String username = (String) request.getAttribute("username");
    String password = (String) request.getAttribute("password");
    
    if (username != null && password != null) {
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
                String user_id = rs.getString("user_id");
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
    } %>
    

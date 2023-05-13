<%@page import="java.util.Random"%>
<%@page import="java.awt.Color"%>
<%@page import="java.awt.Font"%>
<%@page import="java.awt.Graphics2D"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="javax.servlet.http.HttpSession"%>


<%
String message = "";
String captchaResult = "";

if (request.getMethod().equals("POST")) {
    // Retrieve the correct answer from the session
    if (session.getAttribute("captchaResult") != null) {
        captchaResult = session.getAttribute("captchaResult").toString();
    } else {  //generate error on attempt to reuse the captcha
        message = "Captcha expired. Please try again!";
        request.setAttribute("message", message);
        String referer = request.getHeader("referer");
        String contextPath = request.getContextPath();
        String relativePath = referer.substring(referer.indexOf(contextPath) + contextPath.length());
        RequestDispatcher rd = request.getRequestDispatcher(relativePath);
        System.out.println(relativePath.toString());
        rd.forward(request, response);
        return;
    }

    // Invalidate the session so the captcha can't be reused
    session.removeAttribute("captchaResult");

    // Verify the user's answer
    String userAnswer = request.getParameter("captchaAnswer");
    if (userAnswer.equals(captchaResult)) {
        // Forward the request to the supposed page
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String destination = request.getParameter("destination");
        request.setAttribute("username", username);
        request.setAttribute("password", password);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        RequestDispatcher rd = request.getRequestDispatcher(destination);
        rd.forward(request, response);
        return;
    } else {
        message = "Invalid Captcha: Please try again";
        request.setAttribute("message", message);
        String referer = request.getHeader("referer");
        String contextPath = request.getContextPath();
        String relativePath = referer.substring(referer.indexOf(contextPath) + contextPath.length());
        RequestDispatcher rd = request.getRequestDispatcher(relativePath);
        System.out.println(relativePath.toString());
        rd.forward(request, response);
        return;
    }

    
}
%>

<%
// Generate a string of 6 random characters
String chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
StringBuilder sb = new StringBuilder();
Random rand = new Random();
for (int i = 0; i < 6; i++) {
    int index = rand.nextInt(chars.length());
    sb.append(chars.charAt(index));
}

// Save the captcha string in a session attribute
String captchaText = sb.toString();
session.setAttribute("captchaResult", captchaText);

// Generate the captcha image
int width = 280;
int height = 80;
BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
Graphics2D g2d = image.createGraphics();

// Generate a random background color
Color bgColor = new Color(rand.nextInt(256), rand.nextInt(256), rand.nextInt(256));
g2d.setColor(bgColor);
g2d.fillRect(0, 0, width, height);

// Generate random font color
Color fontColor = new Color(rand.nextInt(256), rand.nextInt(256), rand.nextInt(256));
g2d.setColor(fontColor);
g2d.setFont(new Font("Times New Roman", Font.BOLD, 48));

// Draw the captcha string with random distortions
int x = 10;
for (int i = 0; i < captchaText.length(); i++) {
    int angle = rand.nextInt(21) - 10;
    double radian = Math.toRadians(angle);
    g2d.rotate(radian, x, 50);
    g2d.drawString(String.valueOf(captchaText.charAt(i)), x, 50);
    g2d.rotate(-radian, x, 50);
    x += 35 + rand.nextInt(10);
}

int noiseDots = 500;
for (int i = 0; i < noiseDots; i++) {
int xo = rand.nextInt(width);
int y = rand.nextInt(height);
g2d.setColor(Color.GRAY);
g2d.fillOval(xo, y, 2, 2);
}

// Add some random lines for additional distortion
g2d.setColor(fontColor);
for (int i = 0; i < 6; i++) {
    int x1 = rand.nextInt(width);
    int y1 = rand.nextInt(height);
    int x2 = rand.nextInt(width);
    int y2 = rand.nextInt(height);
    g2d.drawLine(x1, y1, x2, y2);
}

// Write the captcha image to the response output stream
response.setContentType("image/png");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);
javax.imageio.ImageIO.write(image, "png", response.getOutputStream());
%>
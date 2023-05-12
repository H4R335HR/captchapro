<%@page import="java.util.Random"%>
<%@page import="java.awt.Color"%>
<%@page import="java.awt.Font"%>
<%@page import="java.awt.Graphics2D"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="javax.servlet.http.HttpSession"%>

<%
//If user is not logged in, redirect him to login page
if(session == null || session.getAttribute("user_id") == null) {
	response.sendRedirect("login.jsp");
}

// Generate two random numbers between 0 and 9
Random rand = new Random();
int num1 = rand.nextInt(100);
int num2 = rand.nextInt(10);

// Calculate the sum of the two numbers
int result = num1 + num2;

// Store the result in a session attribute
HttpSession csession = request.getSession();
csession.setAttribute("captchaResult", result);

// Create a new image with the two numbers drawn on it
int width = 300;
int height = 100;
BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
Graphics2D g2d = image.createGraphics();
g2d.setColor(Color.WHITE);
g2d.fillRect(0, 0, width, height);
g2d.setColor(Color.BLACK);
g2d.setFont(new Font("Arial", Font.BOLD, 48));
g2d.drawString(num1 + " + " + num2 + " = ?", 10, 60);
g2d.dispose();

// Write the image to the response output stream
response.setContentType("image/png");
response.setHeader("Cache-Control", "no-cache");
response.setDateHeader("Expires", 0);
javax.imageio.ImageIO.write(image, "png", response.getOutputStream());
%>


# captchapro

A sample web application for posting comments protected using captcha.
This is a web application built using Java, HTML, Javascript and MySQL. The application allows users to create an account, log in, and post comments. The comments are associated with the user who posted them. All of these pages are protected using Captchas. The login page as well as the register page are protected using word captcha whereas the comment section is protected using math captcha. It requires JAVA, Apache Tomcat and MySQL.

## Installation

1. Clone the repository to your local machine using `git clone https://github.com/H4R335HR/captchapro ` and change into the directory
2. Execute the SQL script as root `sudo mysql -u root < INSTALL.SQL
`
3. Compile. Run `jar -cvf captchapro.war * ` or Open the project in your preferred Java IDE (Eclipse, IntelliJ IDEA, etc.) and export to create a .WAR file
4. Deploy.  `sudo cp captchapro.war /var/lib/tomcat9/webapps/` In my case the webapps directory is at /var/lib/tomcat9/webapps/
5. Restart the server. In case of tomcat, `sudo service tomcat9 restart`
6. Visit the http://localhost:8080/captchapro (Replace 8080 if you have configured a different port for tomcat)

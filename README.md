# captchapro

A sample web application for posting comments protected using captcha.
This is a web application built using Java, HTML, Javascript and MySQL. The application allows users to create an account, log in, and post comments. The comments are associated with the user who posted them. All of these pages are protected using Captchas. The login page as well as the register page are protected using word captcha whereas the comment section is protected using math captcha.

## Installation

1. Clone the repository to your local machine using `code`git clone https://github.com/H4R335HR/captchapro `code` and change into the directory
2. Execute the SQL script as root `code`sudo mysql -u root < INSTALL.SQL
`code`
3. Compile. Run `code`jar -cvf captchapro.war * `code` or Open the project in your preferred Java IDE (Eclipse, IntelliJ IDEA, etc.) and compile to create a .WAR file
4. Deploy.  `code`sudo cp captchapro.war /var/lib/tomcat9/webapps/`code` In my case the webapps directory is at /var/lib/tomcat9/webapps/
5. Restart the server. In case of tomcat, `code`sudo service tomcat9 restart`code`
6. Visit the configured port in your web browser for localhost (by default: http://localhost:8080)

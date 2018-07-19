
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
 <link rel="icon" href="./img/favicon.png">
<title></title>
</head>
<body>
<%
	if (session.getAttribute("permission") == null || !(session.getAttribute("permission").equals("grant"))) {
			response.sendRedirect("index.jsp");
		}
%>
</body>
</html>
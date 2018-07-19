<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="./img/favicon.png">

    <title>14PKE11 - Major Project</title>

    <!-- Bootstrap core CSS -->
    <link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/signin.css" rel="stylesheet">
	 <style>
    body, html {
    height: 100%;
}
.bg {
    /* The image used */
    
background-image:url("./img/source.gif");
    /* Full height */
    height: 100%;

    /* Center and scale the image nicely */
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
}
</style>
  </head>
<body class="bg text-center">
<center>
<%

//out.println(new File(".").getAbsolutePath());

	if (session.getAttribute("permission") != null && session.getAttribute("permission").equals("grant")) {
		response.sendRedirect("twittersearch.jsp");
	}
	if(session.getAttribute("permission") == null)
		session.setAttribute("permission", "");
	if (session.getAttribute("permission").equals("incorrect")) {
%>
<div class="alert alert-danger">
<strong>Incorrect Username or password</strong>
</div>
</div>
<%
	} else if ((session.getAttribute("permission").equals("logout"))) {
%>
<div  style="padding: 20px;">
<div class="alert alert-success">
<strong>Successfully Logged Out</strong>
</div>
</div>
<%
	}else if(session.getAttribute("permission").equals("empty")){
%>
<div  style="padding: 20px;">
<div class="alert alert-danger">
<strong>Username or password should not be empty</strong>
</div>
</div>
<%		
	}else if(!session.isNew()){
		%>
		<div class="alert alert-warning">
		<strong>Session expired plz login again</strong>
		</div>
		</div>
		<%
	}
%>
    <form class="form-signin" action="login_action.jsp" method="POST">
      <img class="mb-4" src="./img/logo.png" alt="" width="300" height="80">
      <h1 class="h3 mb-3 font-weight-normal"><font color="red">Please sign in</font></h1>
      <label for="inputEmail" class="sr-only">Email address</label>
      <input type="email" name="user" class="form-control" placeholder="Email address" required autofocus>
      <label for="inputPassword" class="sr-only">Password</label>
      <input type="password" name="pass" class="form-control" placeholder="Password" required>

	  <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
   
    </form>
</center>
  </body>
</html>

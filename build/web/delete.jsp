<%@ include file="banner.jsp"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="com.yaswanthreddy.textapi.TextAPIClient"%>
<%@page import="com.yaswanthreddy.textapi.Sentiment"%>
<%@page import="com.yaswanthreddy.textapi.SentimentParams"%>
<%@page import="Twitter.*"%>
<%@page import="twitter4j.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.List"%>
<%@page import="Twitter.DbConnection" %>
<%@page import="javax.script.*"%>
<%@page import="Twitter.MapCreation" %>
<%@page import="java.awt.*"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="javax.swing.JPanel"%>
<%@page import="org.jfree.chart.ChartFactory"%>
<%@page import="org.jfree.chart.ChartPanel"%>
<%@page import="org.jfree.chart.JFreeChart"%>
<%@page import="org.jfree.chart.labels.PieSectionLabelGenerator"%>
<%@page import="org.jfree.chart.labels.StandardPieSectionLabelGenerator"%>
<%@page import="org.jfree.chart.plot.PiePlot"%>
<%@page import="Twitter.TwitterAnalysis" %>
<%@page import="Twitter.AnalyzeTweet" %>
<%@page import="org.jfree.data.general.DefaultPieDataset"%>
<%@page import="org.jfree.data.general.PieDataset"%>

<%@page contentType="text/html; charset=iso-8859-1" language="java"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="twitter sentiment, analysis, twitter analysis" />
<meta name="description" content="Twitter sentiments" />

<title>14PKE11 - Major Project</title>
   <link href="./css/style.css" rel="stylesheet">
 <link href="./assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
     <!-- Custom styles for this template -->
    <link href="./css/navbar-top-fixed.css" rel="stylesheet">
 <style>
#customers {
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

#customers td, #customers th {
    border: 1px solid #4CAF50;
    padding: 8px;
}

#customers tr:nth-child(even){background-color: #f2f2f2;}

#customers tr:hover {background-color: #ccc;}

#customers th {
    padding-top: 12px;
    padding-bottom: 12px;
    text-align: middle;
    background-color: #143d55;
    color: white;
}
</style>

</head>
<body>
            <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
      
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarCollapse">
          <img class="navbar-brand" src="img/logo.png" style="width:100px;height:45px"alt="logo">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item ">
            <a class="nav-link" href="twittersearch.jsp">Twitter Search </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="manuact.jsp">Manual Input</a>
          </li>
          <li class="nav-item active">
            <a class="nav-link" href="view.jsp">History</a>
          </li>
        </ul>
        <form class="form-inline mt-2 mt-md-0">
           
          <a href="logout.jsp" class="btn btn-danger btn-md">Log out
        </a>
        </form>
      </div>
    </nav>
<div id="wrapper">
  
    <div id="header"><h1>Twitter Search History</h1> 
</div>
<div id="content">
   
<center>
    <form method="post">

<table id="customers" border="">
<tr align="middle">
   
<th rowspan="2">Place</th>
<th rowspan="2">Keyword</th>
<th colspan="3">Number of Tweets</th>
<th rowspan="2">Delete</th>
</tr>
<tr align="middle">
    <th>Positive</th>
<th>Neutral</th>
<th>Negative</th>

</tr>
<%
try
{
Class.forName("com.mysql.jdbc.Driver");
String url="jdbc:mysql://localhost/twitter";
String username="root";
String password="myr3216";
String query="select * from dbname";
Connection conn=DriverManager.getConnection(url,username,password);
Statement stmt=conn.createStatement();
String place=request.getParameter("place");
String keyword=request.getParameter("keyword");
String pos=request.getParameter("pos");
String neu=request.getParameter("neu");
String neg=request.getParameter("neg");
    String que="delete from dbname where place='"+place+"' and keyword='"+keyword+"' and pos="+pos+" and neu="+neu+" and neg="+neg+";";
int r=stmt.executeUpdate(que);
out.print(que);
if(r>0){
    response.sendRedirect("view.jsp");
}
out.print(r);
    stmt.close();
    conn.close();
    }
catch(Exception e)
{
    e.printStackTrace();
    out.print(e.toString());
    }




%>

</form>
    </center>
       
</div></div>
    </body>
</html>

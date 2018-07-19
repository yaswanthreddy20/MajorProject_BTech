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

 <link href="./assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
     <!-- Custom styles for this template -->
             <link href="./css/style.css" rel="stylesheet">
    <link href="./css/navbar-top-fixed.css" rel="stylesheet">
<title>14PKE11 - Major Project</title>
</head>
<body>
    <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
      
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarCollapse">
          <img class="navbar-brand" src="img/logo.png" style="width:100px;height:45px"alt="logo">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item">
            <a class="nav-link" href="twittersearch.jsp">Twitter Search </a>
          </li>
          <li class="nav-item active">
            <a class="nav-link" href="manuact.jsp">Manual Input</a>
          </li>
          <li class="nav-item">
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
    
  
	<div id="header"><h1>Sentiment analysis for Manual Input</h1> 
        </div><br><br>
    <div id=""><center>
        <form id="search-form" style="width:365px;height:85px;"class="form-control" method="post" action="">
		
			<input type="text"class="form-control" name="text" placeholder="Enter your sentence here...">
                        <br><input type="submit" name="submit" value="submit"> 
		
		</form>
        
           
        </center>
       
    </form>
   
    <br><br>
        <%
            try{
             
             TextAPIClient client = new TextAPIClient("dd9fde46", "730b3c3cb9400b7f53a341b705c1d9bc");
        SentimentParams sentimentParams = new SentimentParams(request.getParameter("text"),null,null);
	  Sentiment sentiment = client.sentiment(sentimentParams);%>
    <center>
        <p></p>
        <%
            out.write("<html><p> Input Sentence : <font color='darkorange'> "+request.getParameter("text")+" </font></p></html>");
           
        
             
             String pol1=sentiment.getPolarity();
             if(pol1.equals("positive")){
         out.write("<html><p> Sentiment Polarity : <font color='green'> Positive </font></p></html>");
             }
             else if(pol1.equals("negative")){
         out.write("<html><p> Sentiment Polarity : <font color='red'> Negative </font></p></html>");
             }
             else{
         out.write("<html><p> Sentiment Polarity : <font color='blue'> Neutral</font></p></html>");
             }
            out.write("<html><p> Polarity Confidence : <font color='darkorchid'> "+sentiment.getPolarityConfidence()+" </font></p></html>");
           

                // JOptionPane.showMessageDialog(null,"Check the Check box for process");
             //   response.sendRedirect("index.jsp");
                }
            catch(Exception e)
            {
            e.printStackTrace();
            }
        %>
        <br><br>
        <center><input type="submit" name="submit" value="BACK"onclick="window.location='index.jsp';"></center>
      
        </center>
</div>
</div>
    </body>
</html>

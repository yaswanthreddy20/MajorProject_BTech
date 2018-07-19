<%@ include file="banner.jsp"%>
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

<title>Twitter Sentiments Analysis</title>
  <!-- Bootstrap core CSS -->
    <link href="./assets/bootstrap/css/bootstrap.css" rel="stylesheet">
     <!-- Custom styles for this template -->
    <link href="./css/navbar-top-fixed.css" rel="stylesheet">
        <link href="./css/style.css" rel="stylesheet">
</head>
<body style="">
        <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
      
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarCollapse">
        
            <img class="navbar-brand" src="img/logo.png" style="width:100px;height:45px"alt="logo">
         <ul class="navbar-nav mr-auto">
          <li class="nav-item active">
            <a class="nav-link" href="twittersearch.jsp">Twitter Search</a>
          </li>
          <li class="nav-item">
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
    
  
	<div id="header"><h1>Sentiment analysis for Live Tweets</h1> 
</div>
   <div id=""><center>
    
       
       <br><br>
		<form id="search-form"style="width: 365px;height: 150px;" class="form-control" method="get" action="">
		
			<input type="text"  class="form-control" placeholder="Enter Your Area Name"  name="place" size="60"
                               maxlength="100" autofocus><br>
			<input type="text" placeholder="Example.., Politics or any" class="form-control" name="key" size="60"
				maxlength="100"><br>
				<input type="submit" value="Search">  
		
		</form></center><br><br><br>
                <p>*If a place is not specified or not found on our lists, the default one is set for India <br>
		</p>
		<%  
			if (request.getParameter("key") != null) { 
				String location = "india";
				String k = request.getParameter("key").toString();
				if (request.getParameter("place") != null) {
					location = request.getParameter("place").toString().toLowerCase();
					MapCreation maps = new MapCreation();
	    			if ((maps.countries.get(location) == null) && (maps.cities.get(location) == null)) 
	    					location = "india";
	    				} 
				String keyword = request.getParameter("key").toString().toLowerCase();
				String searchfor = keyword + " -RT";  // to remove retweets
				TwitterAnalysis twe = new TwitterAnalysis();
				AnalyzeTweet sent = new AnalyzeTweet();
				
				List<Status> tweets = twe.TweetsRetrival(searchfor, location);
								
				try {	
					int neu = 0, pos = 0, neg = 0;
					if (tweets.size() > 0) {
						int set = 50, total=0;
						for(Status tweet : tweets)  {
							double score = sent.AnalyzeTweets(tweet.getText());
							
							if (score >= 1) { 
								pos++;
								if (set > 0) {
									%>
									<p class="postweet">
									<%
									out.print("@" + tweet.getUser().getScreenName() + " - " + tweet.getText()+"   :   ("+score+")");
									set--;
								}								
							}							
							else if (score <= -1) {
								neg++;
								if (set > 0) {
									%>
									</p>
									<p class="negtweet">
									<%
									out.print("@" + tweet.getUser().getScreenName() + " - " + tweet.getText()+"   :   ("+score+")");
									set--;
								}								
							}	
							else if ((score < 1) && (score > -1)) { 
								neu++;
								if (set>0) {
									%>
									</p>
									<p class="neutweet">
									
									<%
									out.print("@" + tweet.getUser().getScreenName() + " - " + tweet.getText()+"   :   ("+score+")");
									set--; 
								}								
							}  
						}
						%>
						
						 <!--Load the AJAX API-->
   <script type="text/javascript" src="https://www.google.com/jsapi"></script>
   <script type="text/javascript">

     // Load the Visualization API and the piechart package.
     google.load('visualization', '1.0', {'packages':['corechart']});

     // Set a callback to run when the Google Visualization API is loaded.
     google.setOnLoadCallback(drawChart);

     // Callback that creates and populates a data table,
     // instantiates the pie chart, passes in the data and
     // draws it.
     function drawChart() {

       // Create the data table.
       var data = new google.visualization.DataTable();
       
       data.addColumn('string', 'Sentiment');
       data.addColumn('number', 'Tweets');
       data.addRows([
         ['Positive', <%=pos%>],
         ['Neutral', <%=neu%>],
         ['Negative', <%=neg%>]
       ]);

       // Set chart options
       var options = {'title':'Sentiments of tweets for ' + '<%=k%>',
                      'width':1200,
                      'height':400,
                      colors: ['#259C37', '#42E3E0', '#D90B15']};

       // Instantiate and draw our chart, passing in some options.
       var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
       chart.draw(data, options);
     }
   </script>
 		<div id="chart_center">
		<div id="chart_div"></div>
			</div>
					
				<% 
						total = pos + neg + neu; 
				//	PieCharts res = new PieCharts("The search results for "+ keyword, "Sentiment Analysis", pos ,neu ,neg );
				//	res.pack();
				//	res.setVisible(true);	    
				  %>
				  <p>
					<%
                                            out.write("<html><p>Your search based on <font color='darkorange'>"+keyword+"</font> has returned <font color='darkorchid'>" + total + "</font> results. Out of which,</p><p> <font color='green'>" + pos + 
						"</font> - <font color='green'>positive tweets</font>,</p><p> <font color='red'>" +  neg + " </font>- <font color='red'>negative tweets</font>,</p><p><font color='blue'>" + neu + "</font> - <font color='blue'>neutral tweets</font>.</p></html>");
                                  



						 						DbConnection conn = new DbConnection();
						conn.insertkey(location, keyword, pos, neu, neg);
						
						String previous[] = conn.getPrevious(location, keyword);
						int j, x;
						
						// I want to display in the chart only the results of the last 7 searches for the given specifications; to do that,
						// I need to know how many elements does the previous string contain and start the loop from the (nr of elements - 5) elem
						
						for (j=0; j<1000; j++)   
							if (previous[j] == null)
								break;
						if (j <= 40)
							x = 0;
						else 
							x = j - 40;
						
						if (previous[9] != null) {    // checking if there is at least a previous search with same specifications, so I can 
							// create the bar chart
						
						%>
						</p>
						<script type="text/javascript" src="https://www.google.com/jsapi"> </script>
					    <script type="text/javascript">
					      google.load("visualization", "1", {packages:["corechart"]});
					google.setOnLoadCallback(drawChart);
					function drawChart() {
						var dataArray = [['Based on Previous Searches ', 'Positive', 'Neutral' , 'Negative']];
						<%
						for (int i=x; i<1000; i=i+4) {
							if (previous[i]!= null) {
								if ((i%4 == 0) || (i==0)) 
									
								%>
									dataArray.push (['', parseInt(<%=previous[i+1]%>), parseInt(<%=previous[i+2]%>), parseInt(<%=previous[i+3]%>)]);
								<%
							}
						}
						%>
							
						var data = new google.visualization.arrayToDataTable(dataArray);
						
					  var options = {
					    title: 'Previous sentiments results for ' + '<%=k%>' + ' (10 most recent results are displayed)',
                                            'width':1200,                      
                                            'height':400,
                                            colors: ['#259C37', '#42E3E0', '#D90B15'],
                                            hAxis: {title: 'Based on Previous Searches', titleTextStyle: {color: 'black'}}
					  };

					  var chart = new google.visualization.ColumnChart(document.getElementById('chart_div2'));

					  chart.draw(data, options);

					}
					    </script>

					    <div id="chart_div2" style="width: 900px; height: 500px;"></div>
											
											
			     <%			
						} else
							out.print("There are no results of previous searches for " + k + ".");
					}
					else
					{	
						out.print("<br><p>" + "Your search has not retrieved any results.</p>");
					}
					} catch (FileNotFoundException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}			
		 %>		
		   </div> <!--Closing the content div -->
  
</div> <!--Closing the wrapper div -->
</body>
</html>

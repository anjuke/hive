<%--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--%>
<%@ page import="org.apache.hadoop.hive.hwi.*"%>
<%@page errorPage="error_page.jsp"%>
<%@page import="org.apache.hadoop.hive.conf.HiveConf"%>
<%@page import="org.apache.hadoop.hive.ql.session.SessionState"%>
<%@page import="org.apache.hadoop.hive.hwi.model.MQuery"%>
<%@page import="javax.jdo.JDOHelper"%>
<%@page import="java.util.List"%>
<%
HiveConf hiveConf = new HiveConf(SessionState.class);
QueryStore qs = new QueryStore(hiveConf);
           
// Object mquery = JDOHelper.getObjectId(qs.getQuery(1));

List<MQuery> mquerys = qs.getQuerys();

%>
<!DOCTYPE html>
<html>
<head>
<title>All Queries - Hive Web Interface</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="padding-top: 60px;">
    <jsp:include page="/navbar.jsp"></jsp:include>
	<div class="container">
		<div class="row">
			<div class="span2">
				<jsp:include page="/left_navigation.jsp" />
			</div><!-- span4 -->
			<div class="span10">
				<h4>All Queries</h4>
				<div>
				Total : <%= qs.getQueryCount() %>
				</div>
				<table class="table table-striped">
					<thead>
						<tr>
						    <th>#</th>
							<th>Name</th>
							<th>Query</th>
							<th>Status</th>
							<th>Result</th>
						</tr>
					</thead>
					<tbody>
						<%-- if ( hs.findAllSessionsForUser(auth)!=null){ --%>
						<% for (MQuery item: mquerys ) { %>
						<tr>
						    <td><%= item.getId() %></td>
							<td><a href="/hwi/query_info.jsp?id=<%= item.getId() %>"><%= item.getName() %></a></td>
							<td><code><%= item.getQuery() %></code></td>
							<td>
							<%
							MQuery.Status status = item.getStatus();
							String statusClass;
							
							switch (status) {
							case INITED :
							    statusClass = "label";
							    break;
							case FINISHED :
							    statusClass = "label label-success";
                                break;
							case FAILED :
							    statusClass = "label label-important";
                                break;
							case SYNTAXERROR :
							    statusClass = "label label-warning";
                                break;
							case RUNNING :
							    statusClass = "label label-info";
                                break;
                            default :
                                statusClass = "label label-inverse";
							}
							%>
							<span class="<%= statusClass %>"><%= status %></span>
							</td>
							<td>
							<% if (item.getErrorMsg() != null) { %>
							<a error="1" class="btn btn-small" data-content="<%= item.getErrorMsg() %>" data-placement="bottom" rel="popover" href="#" data-original-title="Error">Error</a>
							<% } else { %>
							<a class="btn btn-small" href="query_result.jsp?id=<%= item.getId() %>" >View result</a>
							<% } %>
							</td>
						</tr>
						<% } %>
						<%-- } --%>
					</tbody>
				</table>
			</div><!-- span8 -->
		</div><!-- row -->
	</div><!-- container -->
</body>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript">
$(function(){
        $('a[error="1"]').popover();
});
</script>
</html>


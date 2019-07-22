<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>价格</title>
</head>
<body>
<div id="main" style="width: 820px;height:400px;"></div>
<script src=/CRM/web/common/js/echarts.min.js></script>
<script type="text/javascript">

var myChart = echarts.init(document.getElementById('main'));

var sumYAxisData = new Array();
var sumSeriesData = new Array();

ajax("/mdse/selectList", {name : '',code : ''}, 'json', function(data) {
	var list = data.data
	console.log(list);
	 for (var i = 0; i < list.length; i++) {
		 sumSeriesData.push(list[i].cost);
         sumYAxisData.push(list[i].name);
    }	
     myChart.setOption({
    	 title: { text: '价格一览表' }
     	,color: ['#009966']
	 	,legend: { data: ['价格'] }
 	    ,tooltip: { }
    	,xAxis: { }
	    ,yAxis: { data: sumYAxisData }
    	,series: [
    	    {
    	       name: '价格',
    	       type: 'bar',
    	       data: sumSeriesData
    	    }
    	]
    });
})

</script>
</body>
</html>
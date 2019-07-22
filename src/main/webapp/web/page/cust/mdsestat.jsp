<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>统计</title>
</head>
<body>
<div id="main" style="width: 920px;height:400px;"></div>
<script src=/CRM/web/common/js/echarts.min.js></script>
<script type="text/javascript">

    var myChart = echarts.init(document.getElementById('main'));

	var sumXAxisData = new Array();
	var sumSeriesData = new Array();
	ajax("/mdse/selectList", {name : '',code : ''}, 'json', function(data) {
		var list = data.data
		console.log(list);
		 for (var i = 0; i < list.length; i++) {
	        sumSeriesData.push(list[i].num);
	        sumXAxisData.push(list[i].name);
	    }	
		myChart.setOption({
			color: ['#009966'],
			title : { text : '商品库存统计' },
			tooltip : {},
			legend : { data : [ '库存' ] },
			yAxis : {},
			xAxis : { data : sumXAxisData },
			series : [ {
				name : '库存',
				type : 'bar',
				data : sumSeriesData
			} ]
		});
	})
</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>Insert title here</title>
</head>
<body>
<div id="main" style="width: 800px;height:400px;"></div>
<script src=/CRM/web/common/js/echarts.min.js></script>
<script type="text/javascript">


	var myChart = echarts.init(document.getElementById('main'));

	var dataArr = new Array();
	var nameData = new Array();
	ajax("/sale/selectVolume", '', 'json', function(data) {
		$.each(data.list, function(i, dom) {
			var model = {
				value : dom.volume,
				name : dom.mdseName
			}
			dataArr.push(model)
			nameData.push(dom.mdseName);
		})

		myChart.setOption({
			title : {
				text : '销售数量统计',
				subtext : '数量占比',
				x : 'center'
			},
			tooltip : {
				trigger : 'item',//	默认：数据项图形触发
				formatter : "{a} <br/>{b} : {c} ({d}%)"//	提示框浮层内容格式器，支持字符串模板和回调函数两种形式
			},
			legend : {
				type : 'scroll',//	可滚动翻页的图例
				orient : 'vertical',//	图例列表的布局朝向
				right : 60,
				top : 20,
				bottom : 20,
				data : nameData
			},
			series : [ {
				name : '销量',
				type : 'pie',//	定义为饼图
				radius : '55%',
				center : [ '45%', '50%' ],
				data : dataArr,
				itemStyle : {
					emphasis : {
						shadowBlur : 10,
						shadowOffsetX : 0,
						shadowColor : 'rgba(0, 0, 0, 0.5)'
					}
				}
			} ]
		})
	})
</script>
</body>
</html>
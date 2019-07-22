<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>回收站</title>
</head>
<body>
<h1 id="h1"></h1>
	<div class="layui-form">
		<table class="layui-table">
			<colgroup>
				<col ><col ><col >
				<col ><col><col ><col >
			</colgroup>
			<thead>
				<tr>
					<th>编号</th><th>姓名</th><th>创建人</th>
					<th>创建时间</th><th>价格</th><th>操作</th>
				</tr>
			</thead>
			<tbody id="tbody"></tbody>
		</table>
	</div>

<script type="text/javascript">

init();
function init(){
	ajax('/mdse/selectDel','','json',function(data){
		console.log(data)
		var html = "";
		$.each(data.list,function(i,dom){
			var code = dom.code;
			var name = dom.name;
			var cby = dom.createBy;
			var ctime = dom.createTime;
			var cost = dom.cost;
			var d = {code:code,name:name,cby:cby,ctime:ctime,cost:cost}
			html += getlaytpl('#t_per',d)
		})
		$('#tbody').html(html)
		form.render()
	})
}

function back(code){
	ajax("/mdse/back" , {code:code} , "text" , function(data){
		if(data == 1){
			layer.msg("数据还原成功！")
			init();
		}else{
			layer.msg("操作失败！")
		}
	})
}

function delCompletely(code){
	openConfirm(function(index){
		ajax("/mdse/delCompletely" , {code:code} , "text" , function(data){
			if(data == 1){
				layer.msg("数据已经彻底删除！")
				init();
			}if(data == 2){
				layer.msg("您无权删除！");
			}else{
				layer.msg("操作失败！")
			}
		})
	})
}

</script>

<script id="t_per" type="text/html">
	<tr>
		<td>{{d.code}}</td>
		<td>{{d.name}}</td>
		<td>{{d.cby}}</td>
		<td>{{d.ctime}}</td>
		<td>{{d.cost}}</td>
		<td>
			<input type='button' value='还原' class='layui-btn layui-btn-sm' onclick='back("{{ d.code }}")'/>
			<input type='button' value='彻底删除' class='layui-btn layui-btn-sm' onclick='delCompletely("{{ d.code }}")'/>
		</td>
	</tr>
</script>
</body>
</html>
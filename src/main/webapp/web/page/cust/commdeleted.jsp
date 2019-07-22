<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>回收站</title>
</head>
<body>

<div class="layui-form">
	<table class="layui-table">
		<colgroup>
			<col ><col ><col >
			<col ><col><col ><col >
		</colgroup>
		<thead>
			<tr>
				<th>编号</th><th>姓名</th>
				<th>创建时间</th>
				<th>内容</th><th>操作</th>
			</tr>
		</thead>
		<tbody id="tbody"></tbody>
	</table>
</div>
<script type="text/javascript">

init();
function init(){
	ajax('/comm/selectDel','','json',function(data){
		var html = "";
		$.each(data.list,function(i,dom){
			var id = dom.id;
			var userName = dom.userName;
			var custName = dom.custName;
			var ctime = dom.createTime;
			var descr = dom.descr;
			var d = {id:id,userName:userName,custName:custName,ctime:ctime,descr:descr}
			html += getlaytpl('#t_per',d)
		})
		$('#tbody').html(html)
		form.render()
	})
}

function back(id){
	ajax("/comm/back" , {id:id} , "text" , function(data){
		if(data == 1){
			layer.msg("数据还原成功！")
			init();
		}else{
			layer.msg("操作失败！")
		}
	})
}

function delCompletely(id){
	openConfirm(function(index){
		ajax("/comm/delCompletely" , {id:id} , "text" , function(data){
			if(data == 1){
				layer.msg("数据已经彻底删除！")
				init();
			}else{
				layer.msg("操作失败！")
			}
		})
	})
}

</script>

<script id="t_per" type="text/html">
	<tr>
		<td>{{d.userName}}</td>
		<td>{{d.custName}}</td>
		<td>{{d.ctime}}</td>
		<td>{{d.descr}}</td>
		<td>
			<input type='button' value='还原' class='layui-btn layui-btn-sm' onclick='back("{{ d.id }}")'/>
			<input type='button' value='彻底删除' class='layui-btn layui-btn-sm' onclick='delCompletely("{{ d.id }}")'/>
		</td>
	</tr>
</script>
</body>
</html>
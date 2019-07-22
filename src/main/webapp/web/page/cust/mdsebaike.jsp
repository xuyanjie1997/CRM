<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>Insert title here</title>
<style type="text/css">
	#pic{
		float: right;
		margin: 0px 0px 10px 20px;
		padding: 15px;
		text-align: center;
		width: 300px;
	}
</style>
</head>
<body>
<fieldset class="layui-elem-field" style="margin:20px;padding:20px">
	<legend>词条检索</legend>
	<div class="layui-field-box">
		<form class="layui-form layui-form-pane" method="post" onsubmit="">
			<div class="layui-form-item">
				<label class="layui-form-label">词条</label>
				<div class="layui-input-inline">
					<input type="text" name="item" class="layui-input" lay-verify="required" placeholder="请输入词条" required
						autocomplete="off">
				</div>
				<input type="button" class="layui-btn" value="检索" lay-submit lay-filter="search">
				<input type="reset" class="layui-btn" value="重置">
			</div>
		</form>
	</div>	

</fieldset>
<fieldset class="layui-elem-field" style="margin:20px;padding:20px">
	<legend>词条解释</legend>
	<div class="layui-field-box">
		<div class="layui-form-item">
			<div class="layui-input-blank">
				<div id="pic"></div>
				<span id="text" style="font-size:20px"></span>
				<br>
				<p id="p" style="font-size:20px;float: right"></p>
			</div>
		</div>
	</div>
</fieldset>
<script type="text/javascript">

formSubmit('/mdse/find','submit(search)','json',function(data){
		var text = '';
		var pic = '';
		if(data == ''){
			text = '暂无该词条';
		}else{
			text = data.contentText;
			pic = data.picUrl;
			p = "------以上词条信息来自百度百科"
		}
		$("#text").html(text);	
		$("#pic").html(pic);	
		$("#p").html(p)
	})
	
</script>
</body>
</html>
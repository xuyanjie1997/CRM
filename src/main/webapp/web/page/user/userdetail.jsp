<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<title>我的资料</title>
</head>
<body>
<fieldset class="layui-elem-field" style="margin: 20px;padding:15px;">
   <legend>员工信息--我的资料</legend>
    
    <form class="layui-form" method="post">

		<div class="layui-form-item">
			<span class="layui-form-label">编号</span>
			<div class="layui-input-inline">
 				<input type="text" name="code" autocomplete="off" class="layui-input" readonly >
			</div>
		</div>
        
        <div class="layui-form-item">
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-inline">
                <input type="text" name="name"  autocomplete="off" class="layui-input" readonly >
            </div>
        </div>
        
        <div class="layui-form-item">
            <label class="layui-form-label">角色</label>
            <div class="layui-input-inline">
				<input type="text" name="roleName" autocomplete="off" class="layui-input" readonly >
            </div>
        </div>	
        
    </form>
</fieldset>
<script type="text/javascript">

var code = '<%=request.getParameter("code")%>'

ajax("/user/selectList" , {code:code,name:''} , 'json' , function(data){
	var rolecode = null;
	$.each(data.data , function(i,dom){
		rolecode = dom.roleCode;
		$("input[name='code']").val(code)
		$("input[name='name']").val(dom.name)
	})
	ajax("/role/selectList" , {code:rolecode,name:''} , 'json' ,function(data){
		$.each(data.data , function(i,dom2){
			$("input[name='roleName']").val(dom2.name)
		})
	})
})

</script>
</body>
</html>
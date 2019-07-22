<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<title>权限信息维护</title>
</head>
<body>
<fieldset class="layui-elem-field" style="margin: 20px;padding:15px;">
   <legend>菜单信息--维护信息</legend>
    
    <form class="layui-form" method="post">

			<div class="layui-form-item">
				<span class="layui-form-label">角色</span>
				<div class="layui-input-inline">
 					<select name="roleCode">
 						<option value=''></option>
 						<c:forEach items="${role}" var="item">
							<option value='${item.code}'>${item.name}</option>
						</c:forEach>
 					</select>
				</div>
			</div>
			
			<div class="layui-form-item">
				<span class="layui-form-label">菜单</span>
				<div class="layui-input-inline">
 					<select name="menuCode">
 						<option value=''></option>
 						<c:forEach items="${menu}" var="item">
							<option value='${item.code}'>${item.name}</option>
						</c:forEach>
 					</select>
				</div>
			</div>

        
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <input type="button" class="layui-btn" lay-submit lay-filter="add" value="确定" />
                <input type="button" class="layui-btn" onclick="closeThis()" value="取消" />
            </div>
        </div>
        <input type="hidden" name="ccc" value="${model.id}"  />
        <input type="hidden" name="id" value="${model.id}"  />
    </form>
</fieldset>
<script type="text/javascript">

init();
function  init() {
	var id = $("input[name='ccc']").val();
	if(id != ''){
		$("select[name='roleCode']").val("${model.roleCode}");
		$("select[name='menuCode']").val("${model.menuCode}");
	}
}

form.render()

formSubmit('/rel/save', 'submit(add)', 'text', function(data) {
	if (data == 0) {
        layer.msg('添加成功');
        closeThis(3000);
    } else if (data == 1) {
        layer.msg('当前记录已存在');
    } else if(data == 2){
        layer.msg('修改失败');
    }else if(data == 3){
    	layer.msg('修改成功');
    	closeThis(3000);
    }else if(data == 4){
    	layer.msg('添加失败');
    }else if(data == 8){
    	layer.msg('当前角色已拥有此权限');
    }else{
    	layer.msg('操作失败');
    }
});

</script>
</body>
</html>
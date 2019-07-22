<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<title>销售信息维护</title>
</head>
<body>
<fieldset class="layui-elem-field" style="margin: 20px;padding:15px;">
   <legend>客户信息--维护信息</legend>
    
    <form class="layui-form" method="post">

			<div class="layui-form-item">
				<span class="layui-form-label">用户</span>
				<div class="layui-input-inline">
 					<select name="userCode" lay-search>
                		<option value=''></option>
                 		<c:forEach items="${saleUser}" var="item">
							<option value='${item.code}'>${item.name}</option>
						</c:forEach>
                	</select>
				</div>
			</div>

			<div class="layui-form-item">
            <label class="layui-form-label">客户</label>
            <div class="layui-input-inline">
 				<select name="custCode" lay-search>
                	<option value=''></option>
                 	<c:forEach items="${saleCust}" var="item">
						<option value='${item.code}'>${item.name}</option>
					</c:forEach>
                </select>
            </div>
        </div>
       
        <div class="layui-form-item">
            <label class="layui-form-label">商品</label>
            <div class="layui-input-inline">
 				<select name="mdseCode" lay-search>
                	<option value=''></option>
                 	<c:forEach items="${saleMdse}" var="item">
						<option value='${item.code}'>${item.name}</option>
					</c:forEach>
                </select>
            </div>
        </div>		
        
        <div class="layui-form-item">
            <label class="layui-form-label">销售量</label>
            <div class="layui-input-inline">
                <input type="text" name="volume" placeholder="请输入销量" autocomplete="off"
                    class="layui-input">
            </div>
        </div>		
        
        <div class="layui-form-item">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-inline">
 				<select name="state">
                	<option value=''></option>
                 	<c:forEach items="${state}" var="item">
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
		$("select[name='userCode']").val("${model.userCode}");
		$("select[name='custCode']").val("${model.custCode}");
		$("select[name='mdseCode']").val("${model.mdseCode}");
		$("input[name='volume']").val("${model.volume}")
		$("select[name='state']").val("${model.state}");
	}
}

form.render()

formSubmit('/sale/save', 'submit(add)', 'text', function(data) {
	if(data == 0){
        layer.msg('添加成功');
        closeThis(3000);
	}else if (data == 1) {
        layer.msg('添加失败');
    }else if(data == 2){
        layer.msg('修改成功');
        closeThis(3000);
    }else if(data == 3){
    	layer.msg('该条目已存在，操作后会增加原有条目的数量');   	
    	closeThis(3000);
    }else{
    	layer.msg('操作出现异常');
    }
});

</script>
</body>
</html>
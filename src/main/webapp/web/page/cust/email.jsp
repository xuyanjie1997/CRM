<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<script src="/CRM/web/common/js/ace.js"></script>
<script src="/CRM/web/common/js/html.js"></script>
<script src="/CRM/web/common/js/mode-html.js"></script>
<script src="/CRM/web/common/js/worker-html.js"></script>
<title>联系客户</title>
</head>
<body>

	<fieldset class="layui-elem-field" style="margin: 20px;padding:15px;">
        <legend>发送邮件</legend>
    <form class="layui-form" lay-filter="formA" id="form" method="post">
        <div class="layui-form-item">
            <label class="layui-form-label">用户邮箱</label>
            <div class="layui-input-inline">
                <input type="text" name="youxiang" readonly autocomplete="off"
                    class="layui-input" >
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">发件人邮箱</label>
            <div class="layui-input-inline">
                <input type="text" name="self" lay-verify="required" placeholder="请输入您的邮箱" autocomplete="off"
                    class="layui-input" >
            </div>
        </div>
         <div class="layui-form-item">
    	<label class="layui-form-label">主题</label>
   			 <div class="layui-input-block">
     			 <input type="text" name="title" required  lay-verify="required" placeholder="请输入标题" autocomplete="off" class="layui-input">
    		</div>
 		 </div>
  		<div class="layui-form-item layui-form-text">
    		<label class="layui-form-label">内容</label>
    		<div class="layui-input-block">
    		  <textarea id="layeditDemo"></textarea>
    		</div>
  		</div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <input type="button" class="layui-btn" onclick="send()" value="发送" />
                <input type="button" class="layui-btn" onclick="closeThis()" value="取消" />
                <input type="hidden" name="ccc" value="${user.code}" />
            </div>
        </div>
        
<!--         <div class="layui-form-item layui-form-text"> -->
<!--     		<label class="layui-form-label">内容测试</label> -->
<!--     		<div class="layui-input-block"> -->
<!--     		  <div id="test"></div> -->
<!--     		</div> -->
<!--   		</div> -->
  		
    </form>
    </fieldset>
<script type="text/javascript">

var code = '<%=request.getParameter("code")%>';
var email = '<%=request.getParameter("email")%>';

var ieditor ;
layui.use(['layedit', 'layer', 'jquery'], function () {
    var $ = layui.jquery;
    var layedit = layui.layedit;
    
    layedit.set({
		calldel: {
            url: '/Attachment/DeleteFile'
        }
        //开发者模式 --默认为false
        , devmode: true
        //插入代码设置
        , codeConfig: {
            hide: true,  //是否显示编码语言选择框
            default: 'javascript' //hide为true时的默认语言格式
        }
        , tool: [
            'html', 'code', 'strong', 'italic', 'underline', 'del', 'addhr', '|',  'face', '|'
            , 'left', 'center', 'right', '|', 'link'
        ]
        , height: '90%'
    });
    ieditor = layedit.build('layeditDemo' , {});
})

init();
function init(){
	$("input[name='youxiang']").val(email);
}

function send(){
	var email = $("input[name='youxiang']").val();
	var self = $("input[name='self']").val();
	var title = $("input[name='title']").val();
	var content = layedit.getContent(ieditor);
	var usercode = $("input[name='ccc']").val();

// 	console.log(content);
// 	$("#test").html(content)
	
	ajax("/info/email" , {email:email,self:self,text:content,title:title,code:code,usercode:usercode} , "text" ,function(data){
		if(data == 1){
			layer.msg("发送并添加信息成功！")
		}
	})
	
}

</script>

</body>
</html>
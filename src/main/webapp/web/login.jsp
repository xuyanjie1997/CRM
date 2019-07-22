<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<%@ include file="/web/header.jsp"%>
<title>登录</title>
<link href="assets/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="/CRM/web/common/css/font-awesome.min.css" />
<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:400,300" />
<link rel="stylesheet" href="/CRM/web/common/css/ace.min.css" />
<link rel="stylesheet" href="/CRM/web/common/css/ace-rtl.min.css" />
</head>

<body class="login-layout" style="background: #f1f1f1 url('/CRM/web/common/img/login-blurry-bg.jpg') no-repeat fixed center;">
	<div class="space-6"></div>
	<div class="main-container ">
		<div class="main-content">
			<div class="row">
				<div class="col-sm-10 col-sm-offset-1">
					<div class="login-container">
						<div class="center">
							<h1>
								<i class="icon-leaf green"></i>
								<span class="red">Ace</span>
								<span class="white">信息管理系统</span>
								</h1>
							<h4 class="blue">&copy; Company</h4>
						</div>

						<div class="space-6"></div>

						<div class="position-relative">
							<div id="login-box" class="login-box visible widget-box no-border">
								<div class="widget-body">
									<div class="widget-main">
										<h4 class="header blue lighter bigger">
											<i class="icon-coffee green"></i>
												输入你的个人信息
										</h4>

										<div class="space-6"></div>

										<form action="/CRM/user/login" method="post">
											<fieldset>
												<label class="block clearfix">
													<span class="block input-icon input-icon-right">
														<i class="icon-user"></i>
														<input type="text" name="code" class="form-control" placeholder="用户名" />
													</span>
												</label>

												<label class="block clearfix">
													<span class="block input-icon input-icon-right">
														<i class="icon-lock"></i>
														<input type="password" name="password" class="form-control" placeholder="密码" />
													</span>
												</label>

												<div class="space"></div>

												<div class="clearfix">			
													<div class="layui-form-item">
														<div class="layui-form-item" style="text-align: center;background-color: #7B68EE">
															<input type="submit" class="layui-btn layui-btn-normal layui-btn-fluid" value="登录"/> 		
														</div>
													</div>  														
												</div>

												<div class="space-4"></div>
											</fieldset>
										</form>
										<div class="social-or-login center">
											<span class="bigger-110">其他方式登录</span>
										</div>

										<div class="social-login center">
											<a class="btn btn-primary">
												<i class="icon-facebook"></i>
											</a>
											<a class="btn btn-info">
												<i class="icon-twitter"></i>
											</a>

											<a class="btn btn-danger">
												<i class="icon-google-plus"></i>
											</a>
										</div>
											
									</div><!-- /widget-main -->

									<div class="toolbar clearfix">
										<div>
											<a href="#" onclick="show_box('forgot-box'); return false;" class="forgot-password-link">
											
											</a>
										</div>

										<div>
											<a href="#" onclick="show_box('signup-box'); return false;" class="user-signup-link">
													
											</a>
										</div>
									</div>
								</div><!-- /widget-body -->
							</div><!-- /login-box -->
						</div><!-- /position-relative -->
					</div>
				</div><!-- /.col -->
			</div><!-- /.row -->
		</div>
	</div><!-- /.main-container -->
</body>
</html>

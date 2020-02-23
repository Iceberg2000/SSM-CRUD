<%--
  Created by IntelliJ IDEA.
  User: Nauhc
  Date: 2020/2/22
  Time: 14:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%--<jsp:forward page="/emps"></jsp:forward>--%>
<% pageContext.setAttribute("appPath",request.getContextPath()); %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SSM综合案例</title>
    <link href="${appPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <script src="${appPath}/static/js/jquery-3.2.1.min.js"></script>
    <script src="${appPath}/static/js/bootstrap.min.js"></script>

    <script>

        var totalRecord;
        $(function () {
            to_page(1);
        });

        function to_page(page) {
            $.get("${appPath}/emps",{pageNum:page},function (result) {
                //构建员工列表
                build_emps_table(result);
                //构建分页信息
                build_page_info(result);
                //构建分页条
                build_page_nav(result);
            },"json");
        }

        //构建员工列表
        function build_emps_table(result) {
            var emps=result.extend.pageInfo.list;
            var emp_trs="";
            $.each(emps,function (index,item) {
                var emp_tr="<tr class='success'>";
                var empIdTd="<td>"+item.empId+"</td>";
                var empNameTd="<td>"+item.empName+"</td>";
                var genderTd="<td>"+(item.gender=='m'?'男':'女')+"</td>";
                var emailTd="<td>"+item.email+"</td>";
                var deptNameTd="<td>"+item.department.deptName+"</td>";
                var OperationTd="<td>\n" +
                    "                            <button class=\"btn btn-info\" type=\"button\">\n" +
                    "                                <span class=\"glyphicon glyphicon-pencil\" aria-hidden=\"true\"></span>编辑\n" +
                    "                            </button>\n" +
                    "                            <button class=\"btn btn-danger\" type=\"button\">\n" +
                    "                                <span class=\"glyphicon glyphicon-trash\" aria-hidden=\"true\"></span>删除\n" +
                    "                            </button>\n" +
                    "                        </td>";
                emp_trs+=emp_tr+empIdTd+empNameTd+genderTd+emailTd+deptNameTd+OperationTd+"</tr>";
            });
            $("#emps_table tbody").html(emp_trs);





        }
        //构建分页信息
        function build_page_info(result) {
            var pageInfo='当前第<font color="red">'+result.extend.pageInfo.pageNum+'</font>页，共<font color="red">'+result.extend.pageInfo.pages+'</font>页，共<font color="red">'+result.extend.pageInfo.total+'</font>条记录';
            $("#page_info_area").html(pageInfo);
            totalRecord=result.extend.pageInfo.total;

        }
        //构建分页条
        function build_page_nav(result) {
            var pageNums=result.extend.pageInfo.navigatepageNums;
            var lis="";
            var firstPageLi='<li><a href="#" onclick="to_page(1)">首页</a></li>';
            var previousPageLi;
            if(result.extend.pageInfo.hasPreviousPage) {
                previousPageLi = '<li> <a href="#" onclick="to_page(' + (result.extend.pageInfo.pageNum - 1) + ')"> &laquo;</a> </li>';
            }else{
                previousPageLi ='';
            }
            lis+=firstPageLi+previousPageLi;
            $.each(pageNums,function (index,item) {
                var pageNumLi;
                if( result.extend.pageInfo.pageNum==item){
                    pageNumLi='<li class="active"><a href="#" onclick="to_page('+item+')">'+item+'</a></li>';
                }else{
                    pageNumLi='<li><a href="#" onclick="to_page('+item+')">'+item+'</a></li>';
                }
                lis+=pageNumLi;
            });
            var nextPageLi;
            if(result.extend.pageInfo.hasNextPage){
                nextPageLi='<li> <a href="#" onclick="to_page('+(result.extend.pageInfo.pageNum+1)+')"> &raquo;</a> </li>';
            }else{
                nextPageLi='';
            }
            var lastPageLi='<li><a href="#" onclick="to_page('+result.extend.pageInfo.pages+')">末页</a></li>';
            lis+=nextPageLi+lastPageLi;
            $("#page_nav_area ul").html(lis);
        }

        $(function () {
            $("#emp_add_btn").click(function () {
                //员工添加模态框弹出之前，先查找部门信息，添加到select标签里
                $.get("${appPath}/depts",{},function (result) {
                    //console.log(result);
                    var options='';
                    $.each(result.extend.depts,function () {
                        var deptNameOpt='<option value="'+this.deptId+'">'+this.deptName+'</option>';
                        options+=deptNameOpt;
                    });
                    $("#emp_add_modal select").html(options);
                },"json");
                $("#emp_add_modal").modal({
                   backdrop:"static"
                });
                //点击后先清除样式
                clear_form();
            });
            //点击保存按钮，保存用户
            $("#emp_save_btn").click(function () {
                //先前端校验用户名是否合法,再校验用户名是否已经存在
                var tag=$("#emp_save_btn").attr("ajax_tag");
                //if(checkEmail()&&"success"==tag){
                    //用户名校验通过保存用户
                    $.post("${appPath}/emps",$("#emp_add_modal form").serialize(),function (result) {
                        if(100==result.code){
                            //隐藏模态框
                            $("#emp_add_modal").modal('hide');
                            //跳转到最后一页
                            to_page(totalRecord);
                        }else if(200==result.code){
                            if(undefined!=result.extend.errorFields.email){
                                show_verify_info("#email_add_input","error",result.extend.errorFields.email);
                            }
                            if(undefined!=result.extend.errorFields.empName){
                                show_verify_info("#empName_add_input","error",result.extend.errorFields.empName);
                            }
                        }

                    },"json");
                //}
            });

        });

        //前端校验绑定离焦事件
        $(function () {
            $("#empName_add_input").change(function () {
                $("#empName_add_input").parent().removeClass("has-success has-error");
                $("#empName_add_input").next().text("");
                checkEmpName();
            });
            $("#email_add_input").blur(function () {
                $("#email_add_input").parent().removeClass("has-success has-error");
                $("#email_add_input").next().text("");
                checkEmail();
            });
        });

        function checkEmpName() {
            var empName=$("#empName_add_input").val();
            var regex=/(^[A-Za-z0-9_-]{3,10}$)|(^[\u4e00-\u9fa5]{1,5}$)/;
            //先前端校验用户名是否合法
            if(regex.test(empName)){
                //show_verify_info("#empName_add_input","success","前端校验正确");
                //再校验用户名是否已经存在
                $.get("${appPath}/checkEmpName",{empName:empName},function (result) {
                    if(200==result.code) {
                        $("#empName_add_input").parent().removeClass("has-success has-error");
                        $("#empName_add_input").next().text("");
                        show_verify_info("#empName_add_input", "error", "此用户名太受欢迎,请更换一个");
                        $("#emp_save_btn").attr("ajax_tag","error");
                    }else if(100==result.code){
                        $("#empName_add_input").parent().removeClass("has-success has-error");
                        $("#empName_add_input").next().text("");
                        show_verify_info("#empName_add_input", "success", "用户名可用");
                        $("#emp_save_btn").attr("ajax_tag","success");
                    }
                },"json");
            }else{
                $("#emp_save_btn").removeAttr("ajax_tag");
                show_verify_info("#empName_add_input","error","用户名不能超过4个汉字或3-10个字符");
                return false;
            }
        }

        function checkEmail() {
            var Email=$("#email_add_input").val();
            var regex=/^\w+@[a-z0-9]+\.[a-z]{2,4}$/;
            if(regex.test(Email)){
                show_verify_info("#email_add_input","success","前端校验正确");
                return true;
            }else{
                show_verify_info("#email_add_input","error","邮箱格式错误！");
                return false;
            }
        }

        function show_verify_info(ele,status,msg) {
            if("success"==status){
                $(ele).parent().addClass("has-success");
                $(ele).next().text(msg);
            }else if("error"==status){
                $(ele).parent().addClass("has-error");
                $(ele).next().text(msg);
            }
        }
        //打开模态框前先清除模态框的所有样式
        function clear_form() {
            $("#emp_add_modal form")[0].reset();
            $("#emp_add_modal form").find("span").text("");
            $("#emp_add_modal form").find("*").removeClass("has-success has-error");
        }





    </script>
</head>
<body>

    <!--员工添加模态框 -->
    <div class="modal fade" id="emp_add_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">员工添加</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" name="empName" id="empName_add_input" placeholder="empName">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" name="email" id="email_add_input" placeholder="email@haue.edu.cn">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_add_input" value="m" checked> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_add_input" value="f"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <select class="form-control" name="deptId">
                                </select>
                            </div>
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                </div>
            </div>
        </div>
    </div>

    <!--页面展示 -->
    <div class="container">
        <!--标题 -->
        <div class="row">
            <h1>SSM-CRUD</h1>
        </div>
        <!--按钮 -->
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary" id="emp_add_btn">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>
        <!--表格 -->
        <div class="row">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Gender</th>
                        <th>Email</th>
                        <th>DepartName</th>
                        <th>Operation</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>

            </table>
        </div>
        <!--分页信息 -->
        <div class="row">
            <div class="col-md-6" id="page_info_area">
            </div>
            <div class="col-md-6">
                <nav aria-label="Page navigation" id="page_nav_area">
                    <ul class="pagination">

                    </ul>
                </nav>
            </div>
        </div>
    </div>





</body>
</html>

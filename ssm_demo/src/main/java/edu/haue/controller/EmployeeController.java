package edu.haue.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import edu.haue.domain.Employee;
import edu.haue.domain.Message;
import edu.haue.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {
    /**
     * 使用Rustful风格的请求方式
     * /emps     GET查找
     * /emps     POST添加
     * /emps/{id} PUT修改
     * /emps/{id}  DELETE删除
     */

    @Autowired
    private EmployeeService employeeService;

    /**
     * 查看该用户名是否已经存在
     * @return
     */
    @RequestMapping("/checkEmpName")
    @ResponseBody
    public Message checkEmpName(@RequestParam("empName") String empName){
        boolean flag=employeeService.checkEmpName(empName);
        if(flag){
            return Message.success();
        }else{
            return Message.failure();
        }
    }

    /**
     * 添加员工
     *
     * 增加JSR303在后台验证，防止有人绕过前台校验，提交非法数据
     *
     * @return
     */
    @RequestMapping(value = "/emps",method = RequestMethod.POST)
    @ResponseBody
    public Message addEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            //数据非法
            List<FieldError> fieldErrors = result.getFieldErrors();
            //封装非法数据
            Map<String,Object> map=new HashMap<>();
            for(FieldError fieldError:fieldErrors){
                //获取非法属性
                String field = fieldError.getField();
                //获取非法错误信息
                String message = fieldError.getDefaultMessage();
                map.put(field,message);
            }
            return Message.failure().add("errorFields",map);
        }else{
            //校验通过
            employeeService.addEmp(employee);
            return Message.success();
        }
    }


    @RequestMapping("/emps")
    @ResponseBody
    public Message findEmpsWithJson(@RequestParam(value="pageNum",defaultValue = "1") Integer pageNum){
        //引入分页插件PageHelper
        //第一个参数是当前页码，第二个参数是每页展示的员工数
        PageHelper.startPage(pageNum,5);
        //下面紧跟的一个查询就是分页查询
        List<Employee> emps=employeeService.findEmps();
        //用PageInfo对emps包装,第二个参数是每次连续显示的页数
        PageInfo pageInfo=new PageInfo(emps,5);
        return Message.success().add("pageInfo",pageInfo);
    }
    /**
     * 查询员工列表(分页查询)
     * @param pageNum
     * @param model
     * @return
     */
    //@RequestMapping("/emps")
    public String findEmps(@RequestParam(value="pageNum",defaultValue = "1") Integer pageNum, Model model){
        //引入分页插件PageHelper
        //第一个参数是当前页码，第二个参数是每页展示的员工数
        PageHelper.startPage(pageNum,5);
        //下面紧跟的一个查询就是分页查询
        List<Employee> emps=employeeService.findEmps();
        //用PageInfo对emps包装,第二个参数是每次连续显示的页数
        PageInfo pageInfo=new PageInfo(emps,5);
        //把分页后的数据存到request域中
        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }
}

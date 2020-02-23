package edu.haue.controller;

import edu.haue.domain.Department;
import edu.haue.domain.Message;
import edu.haue.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping("/depts")
    @ResponseBody
    public Message findDepts(){
        List<Department> depts = departmentService.findDepts();
        return Message.success().add("depts",depts);
    }
}

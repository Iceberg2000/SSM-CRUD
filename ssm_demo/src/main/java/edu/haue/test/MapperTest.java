package edu.haue.test;


import edu.haue.dao.DepartmentMapper;
import edu.haue.dao.EmployeeMapper;
import edu.haue.domain.Department;
import edu.haue.domain.Employee;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:applicationContext.xml")
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void test(){
        //测试插入部门
        //departmentMapper.insertSelective(new Department(null,"开发部"));
        //departmentMapper.insertSelective(new Department(null,"测试部"));
        //测试员工插入
        //employeeMapper.insertSelective(new Employee(null,"noodles","m","noodles@haue.edu.cn",2));
        //批量插入员工,使用可以执行批量操作的SqlSession
       /* EmployeeMapper mapper=sqlSession.getMapper(EmployeeMapper.class);
        for(int i=0;i<1000;i++){
            String uuid= UUID.randomUUID().toString().substring(0,5)+i;
            mapper.insertSelective(new Employee(null,uuid,"m",uuid+"@haue.edu.cn",2));
        }*/
        //测试员工更新操作
       /* Employee employee=employeeMapper.selectByPrimaryKey(1);
        System.out.println(employee);
        employee.setEmpName("Nauhc");
        employee.setDeptId(3);
        employeeMapper.updateByPrimaryKeySelective(employee);*/
       //测试员工删除操作
       /* employeeMapper.deleteByPrimaryKey(3);
        System.out.println("执行完成");*/
       //测试带部门查询
        /*Employee employee=employeeMapper.selectByPrimaryKeyWithDept(1);
        System.out.println(employee);*/
    }
}

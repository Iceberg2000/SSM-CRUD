package edu.haue.service;

import edu.haue.dao.EmployeeMapper;
import edu.haue.domain.Employee;
import edu.haue.domain.EmployeeExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    public List<Employee> findEmps(){
        return employeeMapper.selectByExampleWithDept(null);
    }

    public void addEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    /**
     * 根据用户名查找该用户是否已经存在
     * true 用户名可用
     * false 不可用
     * @param empName
     * @return
     */
    public boolean checkEmpName(String empName) {
        EmployeeExample example=new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(example);
        return count==0;
    }
}

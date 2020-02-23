package edu.haue.service;

import edu.haue.dao.DepartmentMapper;
import edu.haue.domain.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> findDepts(){
        return departmentMapper.selectByExample(null);
    }
}

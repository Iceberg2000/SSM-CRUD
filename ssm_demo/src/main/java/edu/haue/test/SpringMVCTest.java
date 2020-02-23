package edu.haue.test;


import com.github.pagehelper.PageInfo;
import edu.haue.domain.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.Arrays;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:springmvc.xml"})
public class SpringMVCTest {

    //传入SpringMVC容器
    @Autowired
    WebApplicationContext ioc;

    //模拟mvc请求，获取处理结果
    MockMvc mockMvc;

    //初始化mockMvc
    @Before
    public void init(){
        mockMvc= MockMvcBuilders.webAppContextSetup(ioc).build();
    }

    @Test
    public void requestEmpsTest() throws Exception {
        //模拟发送get请求
        MvcResult result = mockMvc.perform(
                MockMvcRequestBuilders.get("/emps").param("pageNum", "180")).andReturn();
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo =(PageInfo) request.getAttribute("pageInfo");
        //测试
        System.out.println("当前页码："+pageInfo.getPageNum());
        System.out.println("总页码："+pageInfo.getPages());
        System.out.println("总记录数:"+pageInfo.getTotal());
        int[] pageNums = pageInfo.getNavigatepageNums();
        System.out.print("连续显示的页数:");
        for(int i:pageNums){
            if(i==pageInfo.getPageNum()+4){
                System.out.print(i+" \n");
            }else {
                System.out.print(i + " ");
            }
        }
        List<Employee> emps = pageInfo.getList();
        for(Employee emp:emps){
            System.out.println(emp);
        }

    }
}

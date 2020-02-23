package edu.haue.domain;

import java.util.HashMap;
import java.util.Map;

//封装返回json数据的信息类
public class Message {

    private Integer code;//状态码，100成功，200失败

    private String msg;//返回信息

    private Map<String,Object> extend=new HashMap<String,Object>();

    public static Message success(){
        Message result=new Message();
        result.setCode(100);
        result.setMsg("处理成功！");
        return result;
    }

    public static Message failure(){
        Message result=new Message();
        result.setCode(200);
        result.setMsg("处理失败！");
        return result;
    }

    public Message add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}

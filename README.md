

# TLS

---

# 开启 websocket

## 编译时
make WITH_WEBSOCKETS=yes

## conf
```
listener 9883
protocol websockets
```

---

# 取消客户端匿名登录功能，客户端登录必须提供登录名称及密码 

## 生成密码
```
$ mosquitto_passwd -c mosquitto.pwd {USERNAME}
```

## conf
```
allow_anonymous false
password_file 	mosquitto.pwd
```

---

# 目录结构
/etc/mosquitto/




# Docker
- [jllopis/mosquitto:v1.4.12](https://hub.docker.com/r/jllopis/mosquitto/~/dockerfile/)


# 官网
- http://mqtt.org/


# 客户端
- https://github.com/mqtt/mqtt.github.io/wiki/libraries
- [php](https://github.com/bluerhinos/phpMQTT)

## Chrome 客户端插件
- MQTTlens



# 参考文献
- [官网](http://mosquitto.org/)
- [GitHub](https://github.com/eclipse/mosquitto)
- https://github.com/mcxiaoke/mqtt


## 编译时遇到的问题参考：
- http://blog.csdn.net/houjixin/article/details/46711547
- http://blog.csdn.net/qhdcsj/article/details/45042515

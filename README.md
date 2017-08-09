

# TLS

```
listener 8883
```



---

# 数据持久化

## conf
```
persistence true
persistence_file mosquitto.db
persistence_location /var/lib/mosquitto/
persisitent_client_expiration 1d
```

---

# 开启 websocket

## 编译时
make WITH_WEBSOCKETS=yes

## conf
```
listener 9001 
protocol websockets
```

---

# 取消客户端匿名登录功能，客户端登录必须提供登录名称及密码 

## 生成密码
```
$ mosquitto_passwd -c /etc/mosquitto/mosquitto.passwd {username}
```

## conf
```
allow_anonymous false
password_file 	mosquitto.passwd
```

---

# 目录结构
/etc/mosquitto/


---

# 集群

---


# Docker
- [jllopis/mosquitto:v1.4.12](https://hub.docker.com/r/jllopis/mosquitto/~/dockerfile/)


# 官网
- http://mqtt.org/


# 客户端
- https://hobbyquaker.github.io/mqtt-admin/
- https://github.com/mqtt/mqtt.github.io/wiki/libraries
- [php](https://github.com/bluerhinos/phpMQTT)

## Chrome 客户端插件
- MQTTlens



# 参考文献
- [官网](http://mosquitto.org/)
- [GitHub](https://github.com/eclipse/mosquitto)
- [TLS](https://mosquitto.org/man/mosquitto-tls-7.html)
- https://github.com/mcxiaoke/mqtt
- [如何在CentOS 7上安装和保护Mosquitto MQTT消息传递代理](https://www.howtoing.com/how-to-install-and-secure-the-mosquitto-mqtt-messaging-broker-on-centos-7/)


## 编译安装
- http://garagetech.tips/install-mosquitto-websockets-centos/
- http://blog.csdn.net/houjixin/article/details/46711547
- http://blog.csdn.net/qhdcsj/article/details/45042515

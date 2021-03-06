# TLS
- [mosquitto-tls](https://mosquitto.org/man/mosquitto-tls-7.html)
- https://zhuanlan.zhihu.com/p/21421094

---







# Yum

```
curl http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-7/home:oojah:mqtt.repo > /etc/yum.repos.d/mosquitto.repo

yum install -y mosquitto mosquitto-clients
```

## 第三方签名证书
```
listener 8883
#cafile 	// 第三方签名，浏览器可以识别，此处不用填
certfile 	/etc/mosquitto/ssl/mqtt.chenliujin.com.crt
keyfile 	/etc/mosquitto/ssl/mqtt.chenliujin.com.key

```


## 自签名证书

### Certificate Authority 
```
openssl req -new -x509 -days <duration> -extensions v3_ca -keyout ca.key -out ca.crt
```

### Server
## Generate a server key without encryption.
```
openssl genrsa -out server.key 2048
```

## Generate a certificate signing request to send to the CA.
```
openssl req -out server.csr -key server.key -new

Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:GD
Locality Name (eg, city) [Default City]:SZ
Organization Name (eg, company) [Default Company Ltd]:MQTT SERVER 
Organizational Unit Name (eg, section) []:MQTT SERVER
Common Name (eg, your name or your server's hostname) []:127.0.0.1 #此处用服务器的IP或域名，否则会出错
Email Address []:liujin.chen@qq.com
```

## Send the CSR to the CA, or sign it with your CA key:
```
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days <duration>
```

# Client
```
openssl genrsa -out client.key 2048
```

```
openssl req -out client.csr -key client.key -new

Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:GD
Locality Name (eg, city) [Default City]:SZ
Organization Name (eg, company) [Default Company Ltd]:MQTT CLIENT
Organizational Unit Name (eg, section) []:MQTT CLIENT
Common Name (eg, your name or your server's hostname) []:MQTT CLIENT
Email Address []:liujin.chen@qq.com
```


```
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days <duration>
```

# Client Message
```
mosquitto_pub -h mqtt.example.com(此处需要与证书的 Common Name 一致) -p 8883 --cafile ./ca.crt --cert ./client.crt --key ./client.key -t topic -m "test" -u admin -P 123456
```

## 自签名证书脚本
- https://github.com/owntracks/tools/blob/master/TLS/generate-CA.sh

## conf
```
listener 8883
cafile 		/etc/mosquitto/ssl/ca.crt
certfile 	/etc/mosquitto/ssl/server.crt
keyfile 	/etc/mosquitto/ssl/server.key
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

1. Q1：为什么需要持久化？

---

# 开启 websocket

- 未配置 ssl 的 websocket 连接时必须使用 IP 地址，不能使用域名

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
$ mosquitto_passwd -c /etc/mosquitto/mosquitto.passwd admin 

# 添加用户
$ mosquitto_passwd /etc/mosquitto/mosquitto.passwd Tom 
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

# Go
- https://eclipse.org/paho/clients/golang/
- https://www.hivemq.com/blog/mqtt-client-library-encyclopedia-golang

# Node
- https://www.npmjs.com/package/mqtt
- https://github.com/mqttjs/MQTT.js
- https://www.hivemq.com/blog/mqtt-client-library-mqtt-js

# h5
- http://jpmens.net/2014/07/03/the-mosquitto-mqtt-broker-gets-websockets-support/

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
- MQTTBox

# Test

```
```

# 监控

```
mosquitto_sub -v -t \$SYS/#

mosquitto_sub -v -t '$SYS/broker/clients/active'
```


# 性能测试

## 吞吐率
- 测试工具：[takanorig/mqtt-bench](https://github.com/takanorig/mqtt-bench)
- 测试：
```
./mqtt-bench -action=p -broker="tcp://192.168.0.102:31883" -clients=1000 -count=100 -broker-username='appuser' -broker-password='2017@sz'

Result : broker=tcp://192.168.0.102:31883, clients=1000, totalCount=100000, duration=7878ms, throughput=12693.58messages/sec
```
- client 数量最大到 5000，到 6000 时测试脚本卡住，需要换其它的压力测试工具测试。


# 参考文献
- [官网](http://mosquitto.org/)
- [官方源码](https://mosquitto.org/files/source/)
- [GitHub](https://github.com/eclipse/mosquitto)
- [TLS](https://mosquitto.org/man/mosquitto-tls-7.html)
- https://github.com/mcxiaoke/mqtt
- [如何在CentOS 7上安装和保护Mosquitto MQTT消息传递代理](https://www.howtoing.com/how-to-install-and-secure-the-mosquitto-mqtt-messaging-broker-on-centos-7/)
- http://www.steves-internet-guide.com/mosquitto-tls/
- http://www.steves-internet-guide.com/topic-restriction-mosquitto-configuration/
- http://goochgooch.co.uk/2014/08/01/building-mosquitto-1-4/
- http://jpmens.net/2014/07/03/the-mosquitto-mqtt-broker-gets-websockets-support/
- https://gist.github.com/vigevenoj/a911eef4a6cbaa306247


## 编译安装
- http://garagetech.tips/install-mosquitto-websockets-centos/
- http://blog.csdn.net/houjixin/article/details/46711547
- http://blog.csdn.net/qhdcsj/article/details/45042515

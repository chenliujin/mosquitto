# Yum

```
curl http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-7/home:oojah:mqtt.repo > /etc/yum.repos.d/mosquitto.repo

yum install -y mosquitto mosquitto-clients
```

---

# TLS

```
# Certificate Authority 
openssl req -new -x509 -days <duration> -extensions v3_ca -keyout ca.key -out ca.crt

# Server
## Generate a server key without encryption.
openssl genrsa -out server.key 2048

## Generate a certificate signing request to send to the CA.
openssl req -out server.csr -key server.key -new

## Send the CSR to the CA, or sign it with your CA key:
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days <duration>

# Client
mosquitto_pub -h mqtt.66park.net -p 1883 -t chen --cafile ./ca.crt -m "test" -u admin -P "1q2w3e"
```

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

# Node
- https://www.npmjs.com/package/mqtt

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
- http://www.steves-internet-guide.com/mosquitto-tls/


## 编译安装
- http://garagetech.tips/install-mosquitto-websockets-centos/
- http://blog.csdn.net/houjixin/article/details/46711547
- http://blog.csdn.net/qhdcsj/article/details/45042515

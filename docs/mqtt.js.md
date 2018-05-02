



- clean: 


```
    client.on('connect', function(){
      var msg = JSON.stringify(data)

      client.publish('topic', msg, {qos:2}, function(err){
        resData = {
          head: {
            status: 1,
            requestTime: requestTime,
            responseTime: moment().format("YYYY-MM-DD HH:mm:ss.SSS"),
            errors: []
          }
        }

        res.json(resData);
      })

      client.end()
    })
```

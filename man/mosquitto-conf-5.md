<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>mosquitto.conf</title>
<link rel="stylesheet" type="text/css" href="man.css">
<meta name="generator" content="DocBook XSL Stylesheets V1.79.1">
</head>
<body bgcolor="white" text="black" link="#0000FF" vlink="#840084" alink="#0000FF"><div class="refentry">
<a name="mosquitto.conf"></a><div class="titlepage"></div>
<div class="refnamediv">
<h2>Name</h2>
<p>mosquitto.conf — the configuration file for mosquitto</p>
</div>
<div class="refsynopsisdiv">
<h2>Synopsis</h2>
<div class="cmdsynopsis"><p><code class="command">mosquitto.conf</code> </p></div>
</div>
<div class="refsect1">
<a name="idm45942561622528"></a><h2>Description</h2>
<p><strong>mosquitto.conf</strong> is the configuration file for
		mosquitto. This file can reside anywhere as long as mosquitto can read
		it. By default, mosquitto does not need a configuration file and will
		use the default values listed below. See
		mosquitto(8)
		for information on how to load a configuration file.</p>
</div>
<div class="refsect1">
<a name="idm45942561620112"></a><h2>File Format</h2>
<p>All lines with a # as the very first character are treated as a
		comment.</p>
<p>Configuration lines start with a variable name. The variable
		value is separated from the name by a single space.</p>
</div>
<div class="refsect1">
<a name="idm45942561618448"></a><h2>Authentication</h2>
<p>The authentication options described below allow a wide range of
			possibilities in conjunction with the listener options. This
			section aims to clarify the possibilities.</p>
<p>The simplest option is to have no authentication at all. This is
			the default if no other options are given. Unauthenticated
			encrypted support is provided by using the certificate based
			SSL/TLS based options cafile/capath, certfile and keyfile.</p>
<p>MQTT provides username/password authentication as part of the
			protocol. Use the password_file option to define the valid
			usernames and passwords. Be sure to use network encryption if you
			are using this option otherwise the username and password will be
			vulnerable to interception.</p>
<p>When using certificate based encryption there are two options
			that affect authentication. The first is require_certificate, which
			may be set to true or false. If false, the SSL/TLS component of the
			client will verify the server but there is no requirement for the
			client to provide anything for the server: authentication is
			limited to the MQTT built in username/password. If
			require_certificate is true, the client must provide a valid
			certificate in order to connect successfully. In this case, the
			second option, use_identity_as_username, becomes relevant. If set
			to true, the Common Name (CN) from the client certificate is used
			instead of the MQTT username for access control purposes. The
			password is not replaced because it is assumed that only
			authenticated clients have valid certificates. If
			use_identity_as_username is false, the client must authenticate as
			normal (if required by password_file) through the MQTT
			options.</p>
<p>When using pre-shared-key based encryption through the psk_hint
			and psk_file options, the client must provide a valid identity and
			key in order to connect to the broker before any MQTT communication
			takes place. If use_identity_as_username is true, the PSK identity
			is used instead of the MQTT username for access control purposes.
			If use_identity_as_username is false, the client may still
			authenticate using the MQTT username/password if using the
			password_file option.</p>
<p>Both certificate and PSK based encryption are configured on a per-listener basis.</p>
<p>Authentication plugins can be created to replace the
			password_file and psk_file options (as well as the ACL options)
			with e.g. SQL based lookups.</p>
<p>It is possible to support multiple authentication schemes at
			once. A config could be created that had a listener for all of the
			different encryption options described above and hence a large
			number of ways of authenticating.</p>
</div>
<div class="refsect1">
<a name="idm45942561611920"></a><h2>General Options</h2>
<div class="variablelist"><dl class="variablelist">


<dt>
<code>acl_file</code> 
<em><code>file path</code></em>
</dt>
<dd>

Set the path to an access control list file. If defined, the contents of the file are used to control client access to topics on the broker.

If this parameter is defined then only the topics listed will have access. 

Topic access is added with lines of the format:

```
topic [read|write|readwrite] <topic>
```

The access type is controlled using "read", "write" or "readwrite". This parameter is optional (unless <topic> includes a space character) - if not given then the access is read/write.  <topic> can contain the + or # wildcards as in subscriptions.

The first set of topics are applied to anonymous clients, assuming `allow_anonymous` is true. 

User specific topic ACLs are added after a user line as follows:

```
user <username>
```

The username referred to here is the same as in `password_file`. It is not the clientid.

It is also possible to define ACLs based on pattern substitution within the topic. The form is the same as for the topic keyword, but using pattern as the keyword.

```
pattern [read|write|readwrite] <topic>
```

The patterns available for substition are:

- %c to match the client id of the client
- %u to match the username of the client

The substitution pattern must be the only text for that level of hierarchy. Pattern ACLs apply to all users even if the "user" keyword has previously been given.

Example:

```
pattern write sensor/%u/data
```

Allow access for bridge connection messages:

```
pattern write $SYS/broker/connection/%c/state
```

If the first character of a line of the ACL file is a # it is treated as a comment.

Reloaded on reload signal. The currently loaded ACLs will be freed and reloaded. Existing subscriptions will be affected after the reload.

</dd>


<dt><code>allow_anonymous</code> [ true | false ]</dt>
<dd>

Boolean value that determines whether clients that connect without providing a username are allowed to connect. 

If set to *`false`* then a password file should be created (see the password_file option) to control authenticated client access. 

默认值：*`true`*

Reloaded on reload signal.

</dd>


<dt><code>allow_duplicate_messages</code> [ true | false ]</dt>
<dd>

如果客户端订阅了多个重叠的订阅，例如 `foo/＃` 和 `foo/+/baz`，则 MQTT 期望当代理收到与两个订阅（如`foo/bar/baz`）匹配的主题的消息时，客户端只能收到一次消息。

Mosquitto 会跟踪哪些客户端已经发送了一个消息，以满足这一要求。如果您有大量客户端订阅同一组主题并希望最小化内存使用时，可以禁用此选项。

如果您事先知道您的客户端将不会拥有重叠的订阅，则可以放心地设置为 *`true`* ，否则即使 QoS = 2，您的客户端也必须能够正确处理重复的消息。

默认值：*`true`*

Reloaded on reload signal.

</dd>


<dt><code>auth_opt_*</code> <em><code>value</code></em></dt>
<dd><p>Options to be passed to the auth plugin. See the
						specific plugin instructions.  </p></dd>
<dt><code>auth_plugin</code> <em><code>file path</code></em></dt>
<dd>
<p>Specify an external module to use for authentication
						and access control. This allows custom
						username/password and access control functions to be
						created.</p>
<p>Not currently reloaded on reload signal.</p>
</dd>
<dt><code>auth_plugin_deny_special_chars</code> [ true | false ]</dt>
<dd>
<p>If <em><code>true</code></em> then before an ACL
						check is made, the username/client id of the client
						needing the check is searched for the presence of
						either a '+' or '#' character. If either of these
						characters is found in either the username or client
						id, then the ACL check is denied before it is sent to
						the plugin.</p>
<p>This check prevents the case where a malicious user
						could circumvent an ACL check by using one of these
						characters as their username or client id. This is the
						same issue as was reported with mosquitto itself as
						CVE-2017-7650.</p>
<p>If you are entirely sure that the plugin you are
						using is not vulnerable to this attack (i.e. if you
						never use usernames or client ids in topics) then you
						can disable this extra check and hence have all ACL
						checks delivered to your plugin by setting this option
						to <em><code>false</code></em>.</p>
<p>Defaults to <em><code>true</code></em>.</p>
<p>Not currently reloaded on reload signal.</p>
</dd>


<dt><code>autosave_interval</code> <em><code>seconds</code></em></dt>
<dd>

启用持久化后，mosquitto 每间隔 autosave_interval 秒会将内存中的数据保存到磁盘。

如果设置为 0，则只有当 mosquitto 退出或接收到 SIGUSR1 信号时，内存中的数据库才会被保存。

默认值：*`1800`* seconds (30 minutes)

Reloaded on reload signal.

</dd>


<dt><code>autosave_on_changes</code> [ true | false ]</dt>
<dd>

If *`true`*, mosquitto will count the number of subscription changes, retained
messages received and queued messages and if the total exceeds `autosave_interval` then the in-memory database will be saved to disk.

If *`false`*, mosquitto will save the in-memory database to disk by treating *`autosave_interval`* as a time in seconds.

Reloaded on reload signal.

</dd>


<dt><code>clientid_prefixes</code> <em><code>prefix</code></em></dt>
<dd>

If defined, only clients that have a clientid with a
prefix that matches clientid_prefixes will be allowed
to connect to the broker. For example, setting
"secure-" here would mean a client "secure-client"
could connect but another with clientid "mqtt"
couldn't. By default, all client ids are valid.

Reloaded on reload signal. Note that currently
connected clients will be unaffected by any
changes.

</dd>


<dt><code>connection_messages</code> [ true | false ]</dt>
<dd>

If set to *`true`*, the log will include entries when clients connect and disconnect. 

If set to *`false`*, these entries will not appear.

Reloaded on reload signal.

</dd>


<dt><code>include_dir</code> <em><code>dir</code></em></dt>
<dd><p>External configuration files may be included by using
						the include_dir option. This defines a directory that
						will be searched for config files. All files that end
						in '.conf' will be loaded as a configuration file. It
						is best to have this as the last option in the main
						file. This option will only be processed from the main
						configuration file. The directory specified must not
						contain the main configuration file.</p>
</dd>


<dt><code>log_dest</code> <em><code>destinations</code></em></dt>
<dd>

Send log messages to a particular destination.

Use multiple log_dest lines for multiple logging destinations.

Possible destinations are: 
- `stdout`
- `stderr`
- `syslog`
- `topic`
- `file`

`stdout` and `stderr` log to the console on the named output.

`syslog` uses the userspace syslog facility which usually ends up in /var/log/messages or similar.

topic logs to the broker topic '$SYS/broker/log/<severity>', where severity is one of D, E, W, N, I, M which are debug, error, warning, notice, information and message. Message type severity is used by the subscribe and unsubscribe log_type options and publishes log messages at $SYS/broker/log/M/subscribe and $SYS/broker/log/M/unsubscribe.

The `file` destination requires an additional parameter which is the file to be logged to, e.g. "log_dest file /var/log/mosquitto.log". The file will be closed and reopened when the broker receives a HUP signal. Only a single file destination may be configured.

Use "log_dest none" if you wish to disable logging. 

默认值：*`stderr`*

This option may be specified multiple times.

Note that if the broker is running as a Windows service it will default to "log_dest none" and neither stdout nor stderr logging is available.

Reloaded on reload signal.

</dd>


<dt><code>log_facility</code> <em><code>local facility</code></em></dt>
<dd><p>If using syslog logging (not on Windows), messages
						will be logged to the "daemon" facility by default. Use
						the <code>log_facility</code> option to choose
						which of local0 to local7 to log to instead. The option
						value should be an integer value, e.g. "log_facility 5"
to use local5.</p>
</dd>


<dt><code>log_timestamp</code> [ true | false ]</dt>
<dd>

Boolean value, if set to *`true`* a timestamp value will be added to each log entry. 

默认值：*`true`*

Reloaded on reload signal.

</dd>


<dt><code>log_type</code> <em><code>types</code></em></dt>
<dd>

Choose types of messages to log. Possible types are:
- *`debug`*
- *`error`*
- *`warning`*
- *`notice`*
- *`information`*
- *`subscribe`*
- *`unsubscribe`*
- *`websockets`*
- *`none`*
- *`all`*

Defaults to *`error`*, *`warning`*, *`notice`* and *`information`*.  This option may be specified multiple times. Note that the *`debug`* type (used for decoding incoming/outgoing network packets) is never logged in topics.

Reloaded on reload signal.

</dd>

<dt><code>max_inflight_messages</code> <em><code>count</code></em></dt>
<dd>

每个客户端可以同时传输的 QoS 1 或 2 消息的最大数量。
包含正在握手或已握手的消息和正在重试的消息。

默认值：20

Set to 0 for no maximum. If set to 1, this will guarantee in-order delivery of QoS 1 and 2 messages.

Reloaded on reload signal.

</dd>


<dt><code>max_queued_messages</code> <em><code>count</code></em></dt>
<dd>

当超过当前同时 in flight 的消息数量时，允许 QoS 1 or 2 消息保存到队列中的最大数量。

默认值：100

Set to 0 for no maximum (not recommended). See also the <code>queue_qos0_messages</code> option.

Reloaded on reload signal.

</dd>


<dt><code>message_size_limit</code> <em><code>limit</code></em></dt>
<dd>

This option sets the maximum publish payload size that the broker will allow. Received messages that exceed this size will not be accepted by the broker.

The default value is 0, which means that all valid MQTT messages are accepted. 

MQTT imposes a maximum payload size of 268435455 bytes.

</dd>


<dt><code>password_file</code> <em><code>file path</code></em></dt>
<dd>

Set the path to a password file. 

If defined, the contents of the file are used to control client access to the broker. The file can be created using the mosquitto_passwd(1) utility. 

If mosquitto is compiled without TLS support (it is recommended that TLS support is included), then the password file should be a text file with each line in the format "username:password", where the colon and password are optional but recommended. 

如果 `allow_anonymous` 设置为 *`false`*，只有在此文件中定义的用户才允许连接。

如果 `allow_anonymous` 设置为 *`true`* 并且 *`password_file`* 定义了用户，可以与 `acl_file` 一起使用达到比如 guest/anonymous read only 而定义了的用户才可以 publish 的效果.

Reloaded on reload signal. The currently loaded username and password data will be freed and reloaded. Clients that are already connected will not be affected.

See also mosquitto_passwd(1).

</dd>


<dt><code>persistence</code> [ true | false ]</dt>
<dd>

If *`true`*, connection, subscription and message data will be written to the disk in mosquitto.db at the location dictated by persistence_location. When mosquitto is restarted, it will reload the information stored in mosquitto.db. The data will be written to disk when mosquitto closes and also at periodic intervals as defined by autosave_interval. Writing of the persistence database may also be forced by sending mosquitto the SIGUSR1 signal. 

If *`false`*, the data will be stored in memory only. 

默认值：*`false`*

Reloaded on reload signal.

</dd>


<dt><code>persistence_file</code> <em><code>file name</code></em></dt>
<dd>

The filename to use for the persistent database, not including the path.

默认值：*`mosquitto.db`*

Reloaded on reload signal.

</dd>


<dt><code>persistence_location</code> <em><code>path</code></em></dt>
<dd>

Location for persistent database. Must end in a trailing / ( e.g. /var/lib/mosquitto/ ). 

Default is an empty string (current directory).

Reloaded on reload signal.

</dd>


<dt><code>persistent_client_expiration</code> <em><code>duration</code></em></dt>
<dd>
This option allows persistent clients (those with
clean session set to false) to be removed if they do
not reconnect within a certain time frame. 

参数配置错误的客户端会将 clean session 设为 false，同时使用随机生成的 client id，将导致这些持久客户端永远不会重新连接。 此选项允许删除这些客户端。 

The expiration period should be an integer followed
by one of h d w m y for hour, day, week, month and year
respectively. For example:

- persistent_client_expiration 2m
- persistent_client_expiration 14d
- persistent_client_expiration 1y

This is a non-standard option in MQTT V3.1 but allowed in MQTT v3.1.1.

默认（如果未设置）是永不过期的持久性客户端。

Reloaded on reload signal.
</dd>


<dt><code>pid_file</code> <em><code>file path</code></em></dt>
<dd>
<p>Write a pid file to the file specified. If not given
						(the default), no pid file will be written. If the pid
						file cannot be written, mosquitto will exit. This
						option only has an effect is mosquitto is run in daemon
						mode.</p>
<p>If mosquitto is being automatically started by an
						init script it will usually be required to write a pid
						file. This should then be configured as e.g.
						/var/run/mosquitto.pid</p>
<p>Not reloaded on reload signal.</p>
</dd>


<dt><code>psk_file</code> <em><code>file path</code></em></dt>
<dd>
<p>Set the path to a pre-shared-key file. This option
						requires a listener to be have PSK support enabled. If
						defined, the contents of the file are used to control
						client access to the broker. Each line should be in the
						format "identity:key", where the key is a hexadecimal
						string with no leading "0x". A client connecting to a
						listener that has PSK support enabled must provide a
						matching identity and PSK to allow the encrypted
						connection to proceed.</p>
<p>Reloaded on reload signal. The currently loaded
						identity and key data will be freed and reloaded.
						Clients that are already connected will not be
						affected.</p>
</dd>


<dt><code>queue_qos0_messages</code> [ true | false ]</dt>
<dd>

如果设置为 *`true`*，持久客户端断开连接时会将 QoS 0 消息一起进行排队。消息的数量受 max_queued_messages 限制。

默认值：*`false`*

Note that the MQTT v3.1 spec states that only QoS 1
and 2 messages should be saved in this situation so
this is a non-standard option.

This is a non-standard option for the MQTT v3.1 spec but is allowed in v3.1.1.

Reloaded on reload signal.

</dd>


<dt><code>retained_persistence</code> [ true | false ]</dt>
<dd>
<p>This is a synonym of the <code>persistence</code>
						option.</p>
<p>Reloaded on reload signal.</p>
</dd>

<dt><code>retry_interval</code> <em><code>seconds</code></em></dt>
<dd>

在发送 QoS=1 或 QoS=2 的消息后等待多长时间没有收到确认，mosquitto 将重新发送此消息。

默认值：20 秒

Reloaded on reload signal.

</dd>

<dt><code>store_clean_interval</code> <em><code>seconds</code></em></dt>
<dd>

The integer number of seconds between the internal
message store being cleaned of messages that are no
longer referenced.  Lower values will result in lower
memory usage but more processor time, higher values
will have the opposite effect. Setting a value of 0
means the unreferenced messages will be disposed of as
quickly as possible.

默认值：10 秒

Reloaded on reload signal.

</dd>

<dt><code>sys_interval</code> <em><code>seconds</code></em></dt>
<dd>

The integer number of seconds between updates of the
$SYS subscription hierarchy, which provides status
information about the broker.

如果未设置，默认为 10 秒。

Set to 0 to disable publishing the $SYS hierarchy completely.

Reloaded on reload signal.

</dd>

<dt><code>upgrade_outgoing_qos</code> [ true | false ]</dt>
<dd>
<p>The MQTT specification requires that the QoS of a
						message delivered to a subscriber is never upgraded to
						match the QoS of the subscription. Enabling this option
						changes this behaviour. If
						<code>upgrade_outgoing_qos</code> is set
						<em><code>true</code></em>, messages sent to a
						subscriber will always match the QoS of its
						subscription. This is a non-standard option not
						provided for by the spec. Defaults to
						<em><code>false</code></em>.</p>
<p>Reloaded on reload signal.</p>
</dd>

<dt><code>user</code> <em><code>username</code></em></dt>
<dd>

When run as root, change to this user and its primary
group on startup.  If mosquitto is unable to change to
this user and group, it will exit with an error. The
user specified must have read/write access to the
persistence database if it is to be written. If run as
a non-root user, this setting has no effect.

默认值：mosquitto

This setting has no effect on Windows and so you
should run mosquitto as the user you wish it to run
as.

Not reloaded on reload signal.

</dd>

</dl>

</div>
</div>
<div class="refsect1">
<a name="idm45942561482032"></a><h2>Listeners</h2>
<p>The network ports that mosquitto listens on can be controlled
			using listeners. The default listener options can be overridden and
			further listeners can be created.</p>
<div class="refsect2">
<a name="idm45942561480816"></a><h3>General Options</h3>
<div class="variablelist"><dl class="variablelist">
<dt><code>bind_address</code> <em><code>address</code></em></dt>
<dd>
<p>Listen for incoming network connections on the
							specified IP address/hostname only. This is useful
							to restrict access to certain network interfaces.
							To restrict access to mosquitto to the local host
							only, use "bind_address localhost". This only
							applies to the default listener. Use the listener
							variable to control other listeners.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><code>http_dir</code> <em><code>directory</code></em></dt>
<dd>
<p>When a listener is using the websockets protocol,
							it is possible to serve http data as well. Set
							<code>http_dir</code> to a directory which
							contains the files you wish to serve. If this
							option is not specified, then no normal http
							connections will be possible.</p>
<p>Not reloaded on reload signal.</p>
</dd>


<dt><code>listener</code> <em><code>port</code></em> <em><code>[bind address/host]</code></em></dt>
<dd>
<p>Listen for incoming network connection on the
							specified port. A second optional argument allows
							the listener to be bound to a specific ip
							address/hostname. If this variable is used and
							neither the global <code>bind_address</code>
							nor <code>port</code> options are used then the
							default listener will not be started.</p>
<p>The <code>bind address/host</code> option
							allows this listener to be bound to a specific IP
							address by passing an IP address or hostname. For
							websockets listeners, it is only possible to pass
							an IP address here.</p>
<p>This option may be specified multiple times. See
							also the <code>mount_point</code>
							option.</p>
<p>Not reloaded on reload signal.</p>

</dd>


<dt><code>max_connections</code> <em><code>count</code></em></dt>
<dd>

Limit the total number of clients connected for the current listener. Set to *`-1`* to have "unlimited" connections. Note that other limits may be imposed that are outside the control of mosquitto.  See e.g.  limits.conf(5).

Not reloaded on reload signal.

</dd>


<dt><code>mount_point</code> <em><code>topic prefix</code></em></dt>
<dd>
<p>This option is used with the listener option to
							isolate groups of clients. When a client connects
							to a listener which uses this option, the string
							argument is attached to the start of all topics for
							this client. This prefix is removed when any
							messages are sent to the client.  This means a
							client connected to a listener with mount point
							<em><code>example</code></em> can only see
							messages that are published in the topic hierarchy
							<em><code>example</code></em> and above.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><code>port</code> <em><code>port number</code></em></dt>
<dd>
<p>Set the network port for the default listener to
							listen on. Defaults to 1883.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><code>protocol</code> <em><code>value</code></em></dt>
<dd>
<p>Set the protocol to accept for this listener. Can
							be <code>mqtt</code>, the default, or
							<code>websockets</code> if available.</p>
<p>Websockets support is currently disabled by
							default at compile time. Certificate based TLS may be used
							with websockets, except that only the
							<code>cafile</code>, <code>certfile</code>,
							<code>keyfile</code> and
							<code>ciphers</code> options are
							supported.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><code>use_username_as_clientid</code> [ true | false ]</dt>
<dd>
<p>Set <code>use_username_as_clientid</code> to
							true to replace the clientid that a client
							connected with with its username. This allows
							authentication to be tied to the clientid, which
							means that it is possible to prevent one client
							disconnecting another by using the same
							clientid. Defaults to false.</p>
<p>If a client connects with no username it will be
							disconnected as not authorised when this option is
							set to true. Do not use in conjunction with
							<code>clientid_prefixes</code>.</p>
<p>See also
							<code>use_identity_as_username</code>.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><code>websockets_log_level</code> <em><code>level</code></em></dt>
<dd>
<p>Change the websockets logging level. This is a
							global option, it is not possible to set per
							listener. This is an integer that is interpreted by
							libwebsockets as a bit mask for its lws_log_levels
							enum. See the libwebsockets documentation for more
							details.</p>
<p>To use this option, <code>log_type
								websockets</code> must also be enabled.
							Defaults to 0.</p>
</dd>
</dl></div>
</div>
<div class="refsect2">
<a name="idm45942561435728"></a><h3>Certificate based SSL/TLS Support</h3>
<p>The following options are available for all listeners to
				configure certificate based SSL support. See also
				"Pre-shared-key based SSL/TLS support".</p>
<div class="variablelist"><dl class="variablelist">
<dt><code>cafile</code> <em><code>file path</code></em></dt>
<dd>
<p>At least one of <code>cafile</code> or
							<code>capath</code> must be provided to allow
							SSL support.</p>
<p><code>cafile</code> is used to define the
							path to a file containing the PEM encoded CA
							certificates that are trusted.</p>
</dd>
<dt><code>capath</code> <em><code>directory path</code></em></dt>
<dd>
<p>At least one of <code>cafile</code> or
							<code>capath</code> must be provided to allow
							SSL support.</p>
<p><code>capath</code> is used to define a
							directory that contains PEM encoded CA certificates
							that are trusted. For <code>capath</code> to
							work correctly, the certificates files must have
							".pem" as the file ending and you must run
							"c_rehash &lt;path to capath&gt;" each time you
							add/remove a certificate.</p>
</dd>


<dt><code>certfile</code> <em><code>file path</code></em></dt>
<dd>

Path to the PEM encoded server certificate.

</dd>


<dt><code>ciphers</code> <em><code>cipher:list</code></em></dt>
<dd><p>The list of allowed ciphers, each separated with
							a colon. Available ciphers can be obtained using
							the "openssl ciphers" command.</p></dd>
<dt><code>crlfile</code> <em><code>file path</code></em></dt>
<dd><p>If you have <code>require_certificate</code>
							set to <em><code>true</code></em>, you can
							create a certificate revocation list file to revoke
							access to particular client certificates. If you
							have done this, use crlfile to point to the PEM
							encoded revocation file.</p>
</dd>


<dt><code>keyfile</code> <em><code>file path</code></em></dt>
<dd>

Path to the PEM encoded keyfile.

</dd>


<dt><code>require_certificate</code> [ true | false ]</dt>
<dd>

By default an SSL/TLS enabled listener will operate in a similar fashion to a https enabled web server, in that the server has a certificate signed by a CA and the client will verify that it is a trusted certificate.

The overall aim is encryption of the network traffic.

By setting `require_certificate` to *`true`*, the client must provide a valid certificate in order for the network connection to proceed. This allows access to the broker to be controlled outside of the mechanisms provided by MQTT.

</dd>


<dt><code>tls_version</code> <em><code>version</code></em></dt>
<dd>

Configure the version of the TLS protocol to be used for this listener. Possible values are <em><code>tlsv1.2</code></em>, <em><code>tlsv1.1</code></em> and <em><code>tlsv1</code></em>. If left unset, the default of allowing all of TLS v1.2, v1.1 and v1.0 is used.

</dd>


<dt><code>use_identity_as_username</code> [ true | false ]</dt>
<dd>

If <code>require_certificate</code> is <em><code>true</code></em>, you may set <code>use_identity_as_username</code> to <em><code>true</code></em> to use the CN value from the client certificate as a username. If this is <em><code>true</code></em>, the <code>password_file</code> option will not be used for this listener.

</dd>


</dl></div>
</div>
<div class="refsect2">
<a name="idm45942561405632"></a><h3>Pre-shared-key based SSL/TLS Support</h3>
<p>The following options are available for all listeners to
				configure pre-shared-key based SSL support. See also
				"Certificate based SSL/TLS support".</p>
<div class="variablelist"><dl class="variablelist">
<dt><code>ciphers</code> <em><code>cipher:list</code></em></dt>
<dd><p>When using PSK, the encryption ciphers used will
							be chosen from the list of available PSK ciphers.
							If you want to control which ciphers are available,
							use this option.  The list of available ciphers can
							be optained using the "openssl ciphers" command and
							should be provided in the same format as the output
							of that command.</p>
</dd>


<dt><code>psk_hint</code> <em><code>hint</code></em></dt>
<dd>

The <code>psk_hint</code> option enables pre-shared-key support for this listener and also acts as an identifier for this listener. The hint is sent to clients and may be used locally to aid authentication. The hint is a free form string that doesn't have much meaning in itself, so feel free to be creative.

If this option is provided, see <code>psk_file</code> to define the pre-shared keys to be used or create a security plugin to handle them.

</dd>


<dt><code>tls_version</code> <em><code>version</code></em></dt>
<dd>

Configure the version of the TLS protocol to be used for this listener. Possible values are <em><code>tlsv1.2</code></em>, <em><code>tlsv1.1</code></em> and <em><code>tlsv1</code></em>. If left unset, the default of allowing all of TLS v1.2, v1.1 and v1.0 is used.

</dd>


<dt><code>use_identity_as_username</code> [ true | false ]</dt>
<dd>

Set <code>use_identity_as_username</code> to have the psk identity sent by the client used as its username.  The username will be checked as normal, so <code>password_file</code> or another means of authentication checking must be used. No password will be used.

</dd>


</dl></div>
</div>
</div>
<div class="refsect1">
<a name="idm45942561391264"></a><h2>Configuring Bridges</h2>
<p>Multiple bridges (connections to other brokers) can be configured
		using the following variables.</p>
<p>Bridges cannot currently be reloaded on reload signal.</p>
<div class="variablelist"><dl class="variablelist">
<dt>
<code>address</code> <em><code>address[:port]</code></em> <em><code>[address[:port]]</code></em>, <code>addresses</code> <em><code>address[:port]</code></em> <em><code>[address[:port]]</code></em>
</dt>
<dd>
<p>Specify the address and optionally the port of the
						bridge to connect to. This must be given for each
						bridge connection. If the port is not specified, the
						default of 1883 is used.</p>
<p>Multiple host addresses can be specified on the
						address config. See the <code>round_robin</code>
						option for more details on the behaviour of bridges
						with multiple addresses.</p>
</dd>
<dt><code>bridge_attempt_unsubscribe</code> [ true | false ]</dt>
<dd><p>If a bridge has topics that have "out" direction, the
						default behaviour is to send an unsubscribe request to
						the remote broker on that topic. This means that
						changing a topic direction from "in" to "out" will not
						keep receiving incoming messages. Sending these
						unsubscribe requests is not always desirable, setting
						<code>bridge_attempt_unsubscribe</code> to
						<em><code>false</code></em> will disable sending
						the unsubscribe request. Defaults to
						<em><code>true</code></em>.</p></dd>
<dt><code>bridge_protocol_version</code> <em><code>version</code></em></dt>
<dd><p>Set the version of the MQTT protocol to use with for
						this bridge. Can be one of
						<em><code>mqttv31</code></em> or
						<em><code>mqttv311</code></em>. Defaults to
						<em><code>mqttv31</code></em>.</p></dd>
<dt><code>cleansession</code> [ true | false ]</dt>
<dd>
<p>Set the clean session option for this bridge. Setting
						to <em><code>false</code></em> (the default),
						means that all subscriptions on the remote broker are
						kept in case of the network connection dropping. If set
						to <em><code>true</code></em>, all subscriptions
						and messages on the remote broker will be cleaned up if
						the connection drops. Note that setting to
						<em><code>true</code></em> may cause a large
						amount of retained messages to be sent each time the
						bridge reconnects.</p>
<p>If you are using bridges with
						<code>cleansession</code> set to
						<em><code>false</code></em> (the default), then
						you may get unexpected behaviour from incoming topics
						if you change what topics you are subscribing to. This
						is because the remote broker keeps the subscription for
						the old topic.  If you have this problem, connect your
						bridge with <code>cleansession</code> set to
						<em><code>true</code></em>, then reconnect with
						cleansession set to <em><code>false</code></em> as
						normal.</p>
</dd>
<dt><code>connection</code> <em><code>name</code></em></dt>
<dd><p>This variable marks the start of a new bridge
						connection. It is also used to give the bridge a name
						which is used as the client id on the remote
						broker.</p></dd>
<dt><code>keepalive_interval</code> <em><code>seconds</code></em></dt>
<dd><p>Set the number of seconds after which the bridge
						should send a ping if no other traffic has occurred.
						Defaults to 60. A minimum value of 5 seconds
						is allowed.</p></dd>
<dt><code>idle_timeout</code> <em><code>seconds</code></em></dt>
<dd><p>Set the amount of time a bridge using the lazy start
						type must be idle before it will be stopped. Defaults
						to 60 seconds.</p></dd>
<dt><code>local_clientid</code> <em><code>id</code></em></dt>
<dd><p>Set the clientid to use on the local broker. If not
						defined, this defaults to
						<code>local.&lt;clientid&gt;</code>. If you are
						bridging a broker to itself, it is important that
						local_clientid and clientid do not match.</p></dd>
<dt><code>local_password</code> <em><code>password</code></em></dt>
<dd><p>Configure the password to be used when connecting
						this bridge to the local broker. This may be important
						when authentication and ACLs are being used.</p></dd>
<dt><code>local_username</code> <em><code>username</code></em></dt>
<dd><p>Configure the username to be used when connecting
						this bridge to the local broker. This may be important
						when authentication and ACLs are being used.</p></dd>
<dt><code>notifications</code> [ true | false ]</dt>
<dd><p>If set to <em><code>true</code></em>, publish
						notification messages to the local and remote brokers
						giving information about the state of the bridge
						connection. Retained messages are published to the
						topic $SYS/broker/connection/&lt;clientid&gt;/state
						unless otherwise set with
						<code>notification_topic</code>s.  If the message
						is 1 then the connection is active, or 0 if the
						connection has failed. Defaults to
						<em><code>true</code></em>.</p></dd>
<dt><code>notification_topic</code> <em><code>topic</code></em></dt>
<dd><p>Choose the topic on which notifications will be
						published for this bridge. If not set the messages will
						be sent on the topic
						$SYS/broker/connection/&lt;clientid&gt;/state.</p></dd>
<dt><code>remote_clientid</code> <em><code>id</code></em></dt>
<dd>
<p>Set the client id for this bridge connection. If not
						defined, this defaults to 'name.hostname', where name
						is the connection name and hostname is the hostname of
						this computer.</p>
<p>This replaces the old "clientid" option to avoid
						confusion with local/remote sides of the bridge.
						"clientid" remains valid for the time being.</p>
</dd>
<dt><code>remote_password</code> <em><code>value</code></em></dt>
<dd>
<p>Configure a password for the bridge. This is used for
						authentication purposes when connecting to a broker
						that supports MQTT v3.1 and up and requires a username
						and/or password to connect. This option is only valid
						if a remote_username is also supplied.</p>
<p>This replaces the old "password" option to avoid
						confusion with local/remote sides of the bridge.
						"password" remains valid for the time being.</p>
</dd>
<dt><code>remote_username</code> <em><code>name</code></em></dt>
<dd>
<p>Configure a username for the bridge. This is used for
						authentication purposes when connecting to a broker
						that supports MQTT v3.1 and up and requires a username
						and/or password to connect. See also the
						<code>remote_password</code> option.</p>
<p>This replaces the old "username" option to avoid
						confusion with local/remote sides of the bridge.
						"username" remains valid for the time being.</p>
</dd>
<dt><code>restart_timeout</code> <em><code>value</code></em></dt>
<dd><p>Set the amount of time a bridge using the automatic
						start type will wait until attempting to reconnect.
						Defaults to 30 seconds.</p></dd>
<dt><code>round_robin</code> [ true | false ]</dt>
<dd>
<p>If the bridge has more than one address given in the
						address/addresses configuration, the round_robin option
						defines the behaviour of the bridge on a failure of the
						bridge connection. If round_robin is
						<em><code>false</code></em>, the default value,
						then the first address is treated as the main bridge
						connection. If the connection fails, the other
						secondary addresses will be attempted in turn. Whilst
						connected to a secondary bridge, the bridge will
						periodically attempt to reconnect to the main bridge
						until successful.</p>
<p>If round_robin is <em><code>true</code></em>,
						then all addresses are treated as equals. If a
						connection fails, the next address will be tried and if
						successful will remain connected until it fails.</p>
</dd>
<dt><code>start_type</code> [ automatic | lazy | once ]</dt>
<dd>
<p>Set the start type of the bridge. This controls how
						the bridge starts and can be one of three types:
						<em><code>automatic</code></em>, <em><code>lazy
						</code></em>and <em><code>once</code></em>. Note
						that RSMB provides a fourth start type "manual" which
						isn't currently supported by mosquitto.</p>
<p><em><code>automatic</code></em> is the default
						start type and means that the bridge connection will be
						started automatically when the broker starts and also
						restarted after a short delay (30 seconds) if the
						connection fails.</p>
<p>Bridges using the <em><code>lazy</code></em>
						start type will be started automatically when the
						number of queued messages exceeds the number set with
						the <code>threshold</code> option. It will be
						stopped automatically after the time set by the
						<code>idle_timeout</code> parameter. Use this start
						type if you wish the connection to only be active when
						it is needed.</p>
<p>A bridge using the <em><code>once</code></em>
						start type will be started automatically when the
						broker starts but will not be restarted if the
						connection fails.</p>
</dd>
<dt><code>threshold</code> <em><code>count</code></em></dt>
<dd><p>Set the number of messages that need to be queued for
						a bridge with lazy start type to be restarted.
						Defaults to 10 messages.</p></dd>
<dt><code>topic</code> <em><code>pattern</code></em> [[[ out | in | both ] qos-level] local-prefix remote-prefix]</dt>
<dd>
<p>Define a topic pattern to be shared between the two
						brokers. Any topics matching the pattern (which may
						include wildcards) are shared. The second parameter
						defines the direction that the messages will be shared
						in, so it is possible to import messages from a remote
						broker using <em><code>in</code></em>, export
						messages to a remote broker using
						<em><code>out</code></em> or share messages in
						both directions. If this parameter is not defined, the
						default of <em><code>out</code></em> is used. The
						QoS level defines the publish/subscribe QoS level used
						for this topic and defaults to 0.</p>
<p>The <em><code>local-prefix</code></em> and
						<em><code>remote-prefix</code></em> options allow
						topics to be remapped when publishing to and receiving
						from remote brokers. This allows a topic tree from the
						local broker to be inserted into the topic tree of the
						remote broker at an appropriate place.</p>
<p>For incoming topics, the bridge will prepend the
						pattern with the remote prefix and subscribe to the
						resulting topic on the remote broker. When a matching
						incoming message is received, the remote prefix will be
						removed from the topic and then the local prefix
						added.</p>
<p>For outgoing topics, the bridge will prepend the
						pattern with the local prefix and subscribe to the
						resulting topic on the local broker. When an outgoing
						message is processed, the local prefix will be removed
						from the topic then the remote prefix added.</p>
<p>When using topic mapping, an empty prefix can be
						defined using the place marker
						<em><code>""</code></em>. Using the empty marker
						for the topic itself is also valid. The table below
						defines what combination of empty or value is
						valid.</p>
<div class="informaltable"><table class="informaltable" border="1">
<colgroup>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead><tr>
<th> </th>
<th><em>Topic</em></th>
<th><em>Local Prefix</em></th>
<th><em>Remote Prefix</em></th>
<th><em>Validity</em></th>
</tr></thead>
<tbody>
<tr>
<td>1</td>
<td>value</td>
<td>value</td>
<td>value</td>
<td>valid</td>
</tr>
<tr>
<td>2</td>
<td>value</td>
<td>value</td>
<td>""</td>
<td>valid</td>
</tr>
<tr>
<td>3</td>
<td>value</td>
<td>""</td>
<td>value</td>
<td>valid</td>
</tr>
<tr>
<td>4</td>
<td>value</td>
<td>""</td>
<td>""</td>
<td>valid (no remapping)</td>
</tr>
<tr>
<td>5</td>
<td>""</td>
<td>value</td>
<td>value</td>
<td>valid (remap single local topic to remote)</td>
</tr>
<tr>
<td>6</td>
<td>""</td>
<td>value</td>
<td>""</td>
<td>invalid</td>
</tr>
<tr>
<td>7</td>
<td>""</td>
<td>""</td>
<td>value</td>
<td>invalid</td>
</tr>
<tr>
<td>8</td>
<td>""</td>
<td>""</td>
<td>""</td>
<td>invalid</td>
</tr>
</tbody>
</table></div>
<p>To remap an entire topic tree, use e.g.:</p>
<pre class="programlisting">
topic # both 2 local/topic/ remote/topic/</pre>
<p>This option can be specified multiple times per
						bridge.</p>
<p>Care must be taken to ensure that loops are not
						created with this option. If you are experiencing high
						CPU load from a broker, it is possible that you have a
						loop where each broker is forever forwarding each other
						the same messages.</p>
<p>See also the <code>cleansession</code> option if
						you have messages arriving on unexpected topics when
						using incoming topics.</p>
<div class="example">
<a name="idm45942561296432"></a><div class="example-title">Example Bridge Topic Remapping. </div>
<div class="example-contents">
<p>The configuration below connects a bridge to the
							broker at <code>test.mosquitto.org</code>. It
							subscribes to the remote topic
							<code>$SYS/broker/clients/total</code> and
							republishes the messages received to the local topic
							<code>test/mosquitto/org/clients/total</code></p>
<pre class="programlisting">
connection test-mosquitto-org
address test.mosquitto.org
cleansession true
topic clients/total in 0 test/mosquitto/org $SYS/broker/
</pre>
</div>
</div>
<br class="example-break">
</dd>
<dt><code>try_private</code> [ true | false ]</dt>
<dd>
<p>If try_private is set to
						<em><code>true</code></em>, the bridge will
						attempt to indicate to the remote broker that it is a
						bridge not an ordinary client. If successful, this
						means that loop detection will be more effective and
						that retained messages will be propagated correctly.
						Not all brokers support this feature so it may be
						necessary to set <code>try_private</code> to
						<em><code>false</code></em> if your bridge does
						not connect properly.</p>
<p>Defaults to <em><code>true</code></em>.</p>
</dd>
</dl></div>
<div class="refsect2">
<a name="idm45942561288336"></a><h3>SSL/TLS Support</h3>
<p>The following options are available for all bridges to
				configure SSL/TLS support.</p>
<div class="variablelist"><dl class="variablelist">
<dt><code>bridge_attempt_unsubscribe</code> [ true | false ]</dt>
<dd><p>If a bridge has topics that have "out" direction,
							the default behaviour is to send an unsubscribe
							request to the remote broker on that topic. This
							means that changing a topic direction from "in" to
							"out" will not keep receiving incoming messages.
							Sending these unsubscribe requests is not always
							desirable, setting
							<code>bridge_attempt_unsubscribe</code> to
							<em><code>false</code></em> will disable
							sending the unsubscribe request.</p></dd>
<dt><code>bridge_cafile</code> <em><code>file path</code></em></dt>
<dd>
<p>One of <code>bridge_cafile</code> or
							<code>bridge_capath</code> must be provided to
							allow SSL/TLS support.</p>
<p>bridge_cafile is used to define the path to a file
							containing the PEM encoded CA certificates that
							have signed the certificate for the remote broker.
						</p>
</dd>
<dt><code>bridge_capath</code> <em><code>file path</code></em></dt>
<dd>
<p>One of <code>bridge_capath</code> or
							<code>bridge_capath</code> must be provided to
							allow SSL/TLS support.</p>
<p>bridge_capath is used to define the path to a
							directory containing the PEM encoded CA
							certificates that have signed the certificate for
							the remote broker. For bridge_capath to work
							correctly, the certificate files must have ".crt"
							as the file ending and you must run "c_rehash
							&lt;path to bridge_capath&gt;" each time you
							add/remove a certificate.</p>
</dd>
<dt><code>bridge_certfile</code> <em><code>file path</code></em></dt>
<dd><p>Path to the PEM encoded client certificate for
							this bridge, if required by the remote
							broker.</p></dd>
<dt><code>bridge_identity</code> <em><code>identity</code></em></dt>
<dd><p>Pre-shared-key encryption provides an alternative
							to certificate based encryption. A bridge can be
							configured to use PSK with the
							<code>bridge_identity</code> and
							<code>bridge_psk</code> options.  This is the
							client identity used with PSK encryption. Only one
							of certificate and PSK based encryption can be used
							on one bridge at once.</p></dd>
<dt><code>bridge_insecure</code> [ true | false ]</dt>
<dd>
<p>When using certificate based TLS, the bridge will
							attempt to verify the hostname provided in the
							remote certificate matches the host/address being
							connected to. This may cause problems in testing
							scenarios, so <code>bridge_insecure</code> may
							be set to <em><code>false</code></em> to
							disable the hostname verification.</p>
<p>Setting this option to
							<em><code>true</code></em> means that a
							malicious third party could potentially inpersonate
							your server, so it should always be set to
							<em><code>false</code></em> in production
							environments.</p>
</dd>
<dt><code>bridge_keyfile</code> <em><code>file path</code></em></dt>
<dd><p>Path to the PEM encoded private key for this
							bridge, if required by the remote broker.</p></dd>
<dt><code>bridge_psk</code> <em><code>key</code></em></dt>
<dd><p>Pre-shared-key encryption provides an alternative
							to certificate based encryption. A bridge can be
							configured to use PSK with the
							<code>bridge_identity</code> and
							<code>bridge_psk</code> options.  This is the
							pre-shared-key in hexadecimal format with no "0x".
							Only one of certificate and PSK based encryption
							can be used on one bridge at once.</p></dd>
<dt><code>bridge_tls_version</code> <em><code>version</code></em></dt>
<dd><p>Configure the version of the TLS protocol to be
							used for this bridge. Possible values are
							<em><code>tlsv1.2</code></em>,
							<em><code>tlsv1.1</code></em> and
							<em><code>tlsv1</code></em>. Defaults to
							<em><code>tlsv1.2</code></em>. The remote
							broker must support the same version of TLS for the
							connection to succeed.</p></dd>
</dl></div>
</div>
</div>
<div class="refsect1">
<a name="idm45942561255936"></a><h2>Files</h2>
<p>mosquitto.conf</p>
</div>
<div class="refsect1">
<a name="idm45942561254720"></a><h2>Bugs</h2>
<p><strong>mosquitto</strong> bug information can be found at
			<a class="ulink" href="https://github.com/eclipse/mosquitto/issues" target="_top">https://github.com/eclipse/mosquitto/issues</a></p>
</div>
<div class="refsect1">
<a name="idm45942561252768"></a><h2>See Also</h2>

				<a class="link" href="mosquitto-8.html" target="_top">mosquitto</a>(8)
			, 
				<a class="link" href="mosquitto_passwd-1.html" target="_top">mosquitto_passwd</a>(1)
			, 
				<a class="link" href="mosquitto-tls-7.html" target="_top">mosquitto-tls</a>(7)
			, 
				<a class="link" href="mqtt-7.html" target="_top">mqtt</a>(7)
			, 
				<a class="link" href="http://linux.die.net/man/5/limits.conf" target="_top">limits.conf</a>(5)
			
</div>
<div class="refsect1">
<a name="idm45942561241360"></a><h2>Author</h2>
<p>Roger Light <code class="email">&lt;<a class="email" href="mailto:roger@atchoo.org">roger@atchoo.org</a>&gt;</code></p>
</div>
</div></body>
</html>

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
<p><span class="command"><strong>mosquitto.conf</strong></span> is the configuration file for
		mosquitto. This file can reside anywhere as long as mosquitto can read
		it. By default, mosquitto does not need a configuration file and will
		use the default values listed below. See
		<span class="citerefentry"><span class="refentrytitle">mosquitto</span>(8)</span>
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
<dt><span class="term"><code class="option">acl_file</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd>
<p>Set the path to an access control list file. If
						defined, the contents of the file are used to control
						client access to topics on the broker.</p>
<p>If this parameter is defined then only the topics
						listed will have access. Topic access is added with
						lines of the format:</p>
<p><code class="code">topic [read|write|readwrite] &lt;topic&gt;</code></p>
<p>The access type is controlled using "read", "write" or
						"readwrite". This parameter is optional (unless
						&lt;topic&gt; includes a space character) - if not
						given then the access is read/write.  &lt;topic&gt; can
						contain the + or # wildcards as in
						subscriptions.</p>
<p>The first set of topics are applied to anonymous
						clients, assuming <code class="option">allow_anonymous</code> is
						true. User specific topic ACLs are added after a user
						line as follows:</p>
<p><code class="code">user &lt;username&gt;</code></p>
<p>The username referred to here is the same as in
						<code class="option">password_fil</code>e. It is not the
						clientid.</p>
<p>It is also possible to define ACLs based on pattern
						substitution within the topic. The form is the same as
						for the topic keyword, but using pattern as the
						keyword.</p>
<p><code class="code">pattern [read|write|readwrite] &lt;topic&gt;</code></p>
<p>The patterns available for substition are:</p>
<div class="itemizedlist"><ul class="itemizedlist" style="list-style-type: circle; ">
<li class="listitem" style="list-style-type: circle"><p>%c to match the client id of the client</p></li>
<li class="listitem" style="list-style-type: circle"><p>%u to match the username of the client</p></li>
</ul></div>
<p>The substitution pattern must be the only text for
						that level of hierarchy. Pattern ACLs apply to all
						users even if the "user" keyword has previously been
						given.</p>
<p>Example:</p>
<p><code class="code">pattern write sensor/%u/data</code></p>
<p>Allow access for bridge connection messages:</p>
<p><code class="code">pattern write $SYS/broker/connection/%c/state</code></p>
<p>If the first character of a line of the ACL file is a
						# it is treated as a comment.</p>
<p>Reloaded on reload signal. The currently loaded ACLs
						will be freed and reloaded. Existing subscriptions will
						be affected after the reload.</p>
</dd>

<dt><span class="term"><code class="option">allow_anonymous</code> [ true | false ]</span></dt>
<dd>
Boolean value that determines whether clients that
connect without providing a username are allowed to
connect. If set to <em><code>false</code></em>
then another means of connection should be created to
control authenticated client access.

默认值：*`true`*

Reloaded on reload signal.
</dd>

<dt><span class="term"><code class="option">allow_duplicate_messages</code> [ true | false ]</span></dt>
<dd>
<p>If a client is subscribed to multiple subscriptions
						that overlap, e.g. foo/# and foo/+/baz , then MQTT
						expects that when the broker receives a message on a
						topic that matches both subscriptions, such as
						foo/bar/baz, then the client should only receive the
						message once.</p>
<p>Mosquitto keeps track of which clients a message has
						been sent to in order to meet this requirement. This
						option allows this behaviour to be disabled, which may
						be useful if you have a large number of clients
						subscribed to the same set of topics and want to
						minimise memory usage.</p>
<p>It can be safely set to
						<em class="replaceable"><code>true</code></em> if you know in advance
						that your clients will never have overlapping
						subscriptions, otherwise your clients must be able to
						correctly deal with duplicate messages even when then
						have QoS=2.</p>
<p>Defaults to <em class="replaceable"><code>true</code></em>.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">auth_opt_*</code> <em class="replaceable"><code>value</code></em></span></dt>
<dd><p>Options to be passed to the auth plugin. See the
						specific plugin instructions.  </p></dd>
<dt><span class="term"><code class="option">auth_plugin</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd>
<p>Specify an external module to use for authentication
						and access control. This allows custom
						username/password and access control functions to be
						created.</p>
<p>Not currently reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">auth_plugin_deny_special_chars</code> [ true | false ]</span></dt>
<dd>
<p>If <em class="replaceable"><code>true</code></em> then before an ACL
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
						to <em class="replaceable"><code>false</code></em>.</p>
<p>Defaults to <em class="replaceable"><code>true</code></em>.</p>
<p>Not currently reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">autosave_interval</code> <em class="replaceable"><code>seconds</code></em></span></dt>
<dd>
<p>The number of seconds that mosquitto will wait
						between each time it saves the in-memory database to
						disk. If set to 0, the in-memory database will only be
						saved when mosquitto exits or when receiving the
						SIGUSR1 signal. Note that this setting only has an
						effect if persistence is enabled.  Defaults to 1800
						seconds (30 minutes).</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">autosave_on_changes</code> [ true | false ]</span></dt>
<dd>
<p>If <em class="replaceable"><code>true</code></em>, mosquitto will
						count the number of subscription changes, retained
						messages received and queued messages and if the total
						exceeds <code class="option">autosave_interval</code> then the
						in-memory database will be saved to disk. If
						<em class="replaceable"><code>false</code></em>, mosquitto will save
						the in-memory database to disk by treating
						<code class="option">autosave_interval</code> as a time in
						seconds.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">clientid_prefixes</code> <em class="replaceable"><code>prefix</code></em></span></dt>
<dd>
<p>If defined, only clients that have a clientid with a
						prefix that matches clientid_prefixes will be allowed
						to connect to the broker. For example, setting
						"secure-" here would mean a client "secure-client"
						could connect but another with clientid "mqtt"
						couldn't. By default, all client ids are valid.</p>
<p>Reloaded on reload signal. Note that currently
						connected clients will be unaffected by any
						changes.</p>
</dd>
<dt><span class="term"><code class="option">connection_messages</code> [ true | false ]</span></dt>
<dd>
<p>If set to <em class="replaceable"><code>true</code></em>, the log
						will include entries when clients connect and
						disconnect. If set to <em class="replaceable"><code>false</code></em>,
						these entries will not appear.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">include_dir</code> <em class="replaceable"><code>dir</code></em></span></dt>
<dd><p>External configuration files may be included by using
						the include_dir option. This defines a directory that
						will be searched for config files. All files that end
						in '.conf' will be loaded as a configuration file. It
						is best to have this as the last option in the main
						file. This option will only be processed from the main
						configuration file. The directory specified must not
						contain the main configuration file.</p></dd>
<dt><span class="term"><code class="option">log_dest</code> <em class="replaceable"><code>destinations</code></em></span></dt>
<dd>
<p>Send log messages to a particular destination.
						Possible destinations are: <code class="option">stdout</code>
						<code class="option">stderr</code> <code class="option">syslog</code>
						<code class="option">topic</code>.</p>
<p><code class="option">stdout</code> and
						<code class="option">stderr</code> log to the console on the
						named output.</p>
<p><code class="option">syslog</code> uses the userspace syslog
						facility which usually ends up in /var/log/messages or
						similar and topic logs to the broker topic
						'$SYS/broker/log/&lt;severity&gt;', where severity is
						one of D, E, W, N, I, M which are debug, error,
						warning, notice, information and message. Message type
						severity is used by the subscribe and unsubscribe
						log_type options and publishes log messages at
						$SYS/broker/log/M/subscribe and
						$SYS/broker/log/M/unsubscribe.</p>
<p>The <code class="option">file</code> destination requires an
						additional parameter which is the file to be logged to,
						e.g. "log_dest file /var/log/mosquitto.log". The file
						will be closed and reopened when the broker receives a
						HUP signal. Only a single file destination may be
						configured.</p>
<p>Use "log_dest none" if you wish to disable logging.
						Defaults to stderr. This option may be specified
						multiple times.</p>
<p>Note that if the broker is running as a Windows
						service it will default to "log_dest none" and neither
						stdout nor stderr logging is available.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">log_facility</code> <em class="replaceable"><code>local facility</code></em></span></dt>
<dd><p>If using syslog logging (not on Windows), messages
						will be logged to the "daemon" facility by default. Use
						the <code class="option">log_facility</code> option to choose
						which of local0 to local7 to log to instead. The option
						value should be an integer value, e.g. "log_facility 5"
						to use local5.</p></dd>
<dt><span class="term"><code class="option">log_timestamp</code> [ true | false ]</span></dt>
<dd>
<p>Boolean value, if set to
						<em class="replaceable"><code>true</code></em> a timestamp value will
						be added to each log entry. The default is
						<em class="replaceable"><code>true</code></em>.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">log_type</code> <em class="replaceable"><code>types</code></em></span></dt>
<dd>
<p>Choose types of messages to log. Possible types are:
						<em class="replaceable"><code>debug</code></em>,
						<em class="replaceable"><code>error</code></em>,
						<em class="replaceable"><code>warning</code></em>,
						<em class="replaceable"><code>notice</code></em>,
						<em class="replaceable"><code>information</code></em>,
						<em class="replaceable"><code>subscribe</code></em>,
						<em class="replaceable"><code>unsubscribe</code></em>,
						<em class="replaceable"><code>websockets</code></em>,
						<em class="replaceable"><code>none</code></em>,
						<em class="replaceable"><code>all</code></em>.</p>
<p>Defaults to <em class="replaceable"><code>error</code></em>,
						<em class="replaceable"><code>warning</code></em>, <em class="replaceable"><code>notice
						</code></em>and
						<em class="replaceable"><code>information</code></em>.  This option
						may be specified multiple times. Note that the
						<em class="replaceable"><code>debug </code></em>type (used for
						decoding incoming/outgoing network packets) is never
						logged in topics.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">max_inflight_messages</code> <em class="replaceable"><code>count</code></em></span></dt>
<dd>
<p>The maximum number of QoS 1 or 2 messages that can be
						in the process of being transmitted simultaneously.
						This includes messages currently going through
						handshakes and messages that are being retried.
						Defaults to 20. Set to 0 for no maximum. If set to 1,
						this will guarantee in-order delivery of
						messages.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">max_queued_messages</code> <em class="replaceable"><code>count</code></em></span></dt>
<dd>
<p>The maximum number of QoS 1 or 2 messages to hold in
						the queue above those messages that are currently in
						flight. Defaults to 100. Set to 0 for no maximum (not
						recommended). See also the
						<code class="option">queue_qos0_messages</code> option.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">message_size_limit</code> <em class="replaceable"><code>limit</code></em></span></dt>
<dd><p>This option sets the maximum publish payload size
						that the broker will allow. Received messages that
						exceed this size will not be accepted by the broker.
						The default value is 0, which means that all valid MQTT
						messages are accepted. MQTT imposes a maximum payload
						size of 268435455 bytes.</p></dd>
<dt><span class="term"><code class="option">password_file</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd>
<p>Set the path to a password file. If defined, the
						contents of the file are used to control client access
						to the broker. The file can be created using the
						<span class="citerefentry"><span class="refentrytitle">mosquitto_passwd</span>(1)</span>
						utility. If mosquitto is compiled without TLS support
						(it is recommended that TLS support is included), then
						the password file should be a text file with each line
						in the format "username:password", where the colon and
						password are optional but recommended. If
						<code class="option">allow_anonymous</code> is set to
						<em class="replaceable"><code>false</code></em>, only users defined in
						this file will be able to connect. Setting
						<code class="option">allow_anonymous</code> to
						<em class="replaceable"><code>true</code></em> when
						<em class="replaceable"><code>password_file</code></em>is defined is
						valid and could be used with acl_file to have e.g. read
						only guest/anonymous accounts and defined users that
						can publish.</p>
<p>Reloaded on reload signal. The currently loaded
						username and password data will be freed and reloaded.
						Clients that are already connected will not be
						affected.</p>
<p>See also
						<span class="citerefentry"><span class="refentrytitle">mosquitto_passwd</span>(1)</span>.</p>
</dd>
<dt><span class="term"><code class="option">persistence</code> [ true | false ]</span></dt>
<dd>
<p>If <em class="replaceable"><code>true</code></em>, connection,
						subscription and message data will be written to the
						disk in mosquitto.db at the location dictated by
						persistence_location. When mosquitto is restarted, it
						will reload the information stored in mosquitto.db. The
						data will be written to disk when mosquitto closes and
						also at periodic intervals as defined by
						autosave_interval. Writing of the persistence database
						may also be forced by sending mosquitto the SIGUSR1
						signal. If <em class="replaceable"><code>false</code></em>, the data
						will be stored in memory only. Defaults to
						<em class="replaceable"><code>false</code></em>.</p>
<p>Reloaded on reload signal.</p>
</dd>

<dt><span class="term"><code class="option">persistence_file</code> <em class="replaceable"><code>file name</code></em></span></dt>
<dd>
The filename to use for the persistent database.
Defaults to mosquitto.db.

Reloaded on reload signal.
</dd>

<dt><span class="term"><code class="option">persistence_location</code> <em class="replaceable"><code>path</code></em></span></dt>
<dd>
The path where the persistence database should be
stored. Must end in a trailing slash. If not given,
then the current directory is used.

Reloaded on reload signal.
</dd>

<dt><span class="term"><code class="option">persistent_client_expiration</code> <em class="replaceable"><code>duration</code></em></span></dt>
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

<dt><span class="term"><code class="option">pid_file</code> <em class="replaceable"><code>file path</code></em></span></dt>
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
<dt><span class="term"><code class="option">psk_file</code> <em class="replaceable"><code>file path</code></em></span></dt>
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
<dt><span class="term"><code class="option">queue_qos0_messages</code> [ true | false ]</span></dt>
<dd>
<p>Set to <em class="replaceable"><code>true</code></em> to queue
						messages with QoS 0 when a persistent client is
						disconnected. These messages are included in the limit
						imposed by max_queued_messages.  Defaults to
						<em class="replaceable"><code>false</code></em>.</p>
<p>Note that the MQTT v3.1 spec states that only QoS 1
						and 2 messages should be saved in this situation so
						this is a non-standard option.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">retained_persistence</code> [ true | false ]</span></dt>
<dd>
<p>This is a synonym of the <code class="option">persistence</code>
						option.</p>
<p>Reloaded on reload signal.</p>
</dd>

<dt>`retry_interval` *`seconds`*</dt>
<dd>

在发送 QoS=1 或 QoS=2 的消息后等待多长时间没有收到确认，mosquitto 将重新发送此消息。

如果未设置，默认为20秒。

Reloaded on reload signal.

</dd>

<dt><span class="term"><code class="option">store_clean_interval</code> <em class="replaceable"><code>seconds</code></em></span></dt>
<dd>
<p>The integer number of seconds between the internal
						message store being cleaned of messages that are no
						longer referenced.  Lower values will result in lower
						memory usage but more processor time, higher values
						will have the opposite effect. Setting a value of 0
						means the unreferenced messages will be disposed of as
						quickly as possible. Defaults to 10 seconds.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">sys_interval</code> <em class="replaceable"><code>seconds</code></em></span></dt>
<dd>
<p>The integer number of seconds between updates of the
						$SYS subscription hierarchy, which provides status
						information about the broker. If unset, defaults to 10
						seconds.</p>
<p>Set to 0 to disable publishing the $SYS hierarchy
						completely.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">upgrade_outgoing_qos</code> [ true | false ]</span></dt>
<dd>
<p>The MQTT specification requires that the QoS of a
						message delivered to a subscriber is never upgraded to
						match the QoS of the subscription. Enabling this option
						changes this behaviour. If
						<code class="option">upgrade_outgoing_qos</code> is set
						<em class="replaceable"><code>true</code></em>, messages sent to a
						subscriber will always match the QoS of its
						subscription. This is a non-standard option not
						provided for by the spec. Defaults to
						<em class="replaceable"><code>false</code></em>.</p>
<p>Reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">user</code> <em class="replaceable"><code>username</code></em></span></dt>
<dd>
<p>When run as root, change to this user and its primary
						group on startup.  If mosquitto is unable to change to
						this user and group, it will exit with an error. The
						user specified must have read/write access to the
						persistence database if it is to be written. If run as
						a non-root user, this setting has no effect. Defaults
						to mosquitto.</p>
<p>This setting has no effect on Windows and so you
						should run mosquitto as the user you wish it to run
						as.</p>
<p>Not reloaded on reload signal.</p>
</dd>
</dl></div>
</div>
<div class="refsect1">
<a name="idm45942561482032"></a><h2>Listeners</h2>
<p>The network ports that mosquitto listens on can be controlled
			using listeners. The default listener options can be overridden and
			further listeners can be created.</p>
<div class="refsect2">
<a name="idm45942561480816"></a><h3>General Options</h3>
<div class="variablelist"><dl class="variablelist">
<dt><span class="term"><code class="option">bind_address</code> <em class="replaceable"><code>address</code></em></span></dt>
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
<dt><span class="term"><code class="option">http_dir</code> <em class="replaceable"><code>directory</code></em></span></dt>
<dd>
<p>When a listener is using the websockets protocol,
							it is possible to serve http data as well. Set
							<code class="option">http_dir</code> to a directory which
							contains the files you wish to serve. If this
							option is not specified, then no normal http
							connections will be possible.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">listener</code> <em class="replaceable"><code>port</code></em> <em class="replaceable"><code>[<span class="optional">bind address/host</span>]</code></em></span></dt>
<dd>
<p>Listen for incoming network connection on the
							specified port. A second optional argument allows
							the listener to be bound to a specific ip
							address/hostname. If this variable is used and
							neither the global <code class="option">bind_address</code>
							nor <code class="option">port</code> options are used then the
							default listener will not be started.</p>
<p>The <code class="option">bind address/host</code> option
							allows this listener to be bound to a specific IP
							address by passing an IP address or hostname. For
							websockets listeners, it is only possible to pass
							an IP address here.</p>
<p>This option may be specified multiple times. See
							also the <code class="option">mount_point</code>
							option.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">max_connections</code> <em class="replaceable"><code>count</code></em></span></dt>
<dd>
<p>Limit the total number of clients connected for
							the current listener. Set to <code class="literal">-1</code>
							to have "unlimited" connections. Note that other
							limits may be imposed that are outside the control
							of mosquitto.  See e.g.
							<span class="citerefentry"><span class="refentrytitle">limits.conf</span>(5)</span>.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">mount_point</code> <em class="replaceable"><code>topic prefix</code></em></span></dt>
<dd>
<p>This option is used with the listener option to
							isolate groups of clients. When a client connects
							to a listener which uses this option, the string
							argument is attached to the start of all topics for
							this client. This prefix is removed when any
							messages are sent to the client.  This means a
							client connected to a listener with mount point
							<em class="replaceable"><code>example</code></em> can only see
							messages that are published in the topic hierarchy
							<em class="replaceable"><code>example</code></em> and above.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">port</code> <em class="replaceable"><code>port number</code></em></span></dt>
<dd>
<p>Set the network port for the default listener to
							listen on. Defaults to 1883.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">protocol</code> <em class="replaceable"><code>value</code></em></span></dt>
<dd>
<p>Set the protocol to accept for this listener. Can
							be <code class="option">mqtt</code>, the default, or
							<code class="option">websockets</code> if available.</p>
<p>Websockets support is currently disabled by
							default at compile time. Certificate based TLS may be used
							with websockets, except that only the
							<code class="option">cafile</code>, <code class="option">certfile</code>,
							<code class="option">keyfile</code> and
							<code class="option">ciphers</code> options are
							supported.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">use_username_as_clientid</code> [ true | false ]</span></dt>
<dd>
<p>Set <code class="option">use_username_as_clientid</code> to
							true to replace the clientid that a client
							connected with with its username. This allows
							authentication to be tied to the clientid, which
							means that it is possible to prevent one client
							disconnecting another by using the same
							clientid. Defaults to false.</p>
<p>If a client connects with no username it will be
							disconnected as not authorised when this option is
							set to true. Do not use in conjunction with
							<code class="option">clientid_prefixes</code>.</p>
<p>See also
							<code class="option">use_identity_as_username</code>.</p>
<p>Not reloaded on reload signal.</p>
</dd>
<dt><span class="term"><code class="option">websockets_log_level</code> <em class="replaceable"><code>level</code></em></span></dt>
<dd>
<p>Change the websockets logging level. This is a
							global option, it is not possible to set per
							listener. This is an integer that is interpreted by
							libwebsockets as a bit mask for its lws_log_levels
							enum. See the libwebsockets documentation for more
							details.</p>
<p>To use this option, <code class="option">log_type
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
<dt><span class="term"><code class="option">cafile</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd>
<p>At least one of <code class="option">cafile</code> or
							<code class="option">capath</code> must be provided to allow
							SSL support.</p>
<p><code class="option">cafile</code> is used to define the
							path to a file containing the PEM encoded CA
							certificates that are trusted.</p>
</dd>
<dt><span class="term"><code class="option">capath</code> <em class="replaceable"><code>directory path</code></em></span></dt>
<dd>
<p>At least one of <code class="option">cafile</code> or
							<code class="option">capath</code> must be provided to allow
							SSL support.</p>
<p><code class="option">capath</code> is used to define a
							directory that contains PEM encoded CA certificates
							that are trusted. For <code class="option">capath</code> to
							work correctly, the certificates files must have
							".pem" as the file ending and you must run
							"c_rehash &lt;path to capath&gt;" each time you
							add/remove a certificate.</p>
</dd>
<dt><span class="term"><code class="option">certfile</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd><p>Path to the PEM encoded server certificate.</p></dd>
<dt><span class="term"><code class="option">ciphers</code> <em class="replaceable"><code>cipher:list</code></em></span></dt>
<dd><p>The list of allowed ciphers, each separated with
							a colon. Available ciphers can be obtained using
							the "openssl ciphers" command.</p></dd>
<dt><span class="term"><code class="option">crlfile</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd><p>If you have <code class="option">require_certificate</code>
							set to <em class="replaceable"><code>true</code></em>, you can
							create a certificate revocation list file to revoke
							access to particular client certificates. If you
							have done this, use crlfile to point to the PEM
							encoded revocation file.</p></dd>
<dt><span class="term"><code class="option">keyfile</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd><p>Path to the PEM encoded keyfile.</p></dd>
<dt><span class="term"><code class="option">require_certificate</code> [ true | false ]</span></dt>
<dd><p>By default an SSL/TLS enabled listener will
							operate in a similar fashion to a https enabled web
							server, in that the server has a certificate signed
							by a CA and the client will verify that it is a
							trusted certificate.  The overall aim is encryption
							of the network traffic.  By setting
							<code class="option">require_certificate</code> to
							<em class="replaceable"><code>true</code></em>, the client must
							provide a valid certificate in order for the
							network connection to proceed. This allows access
							to the broker to be controlled outside of the
							mechanisms provided by MQTT.</p></dd>
<dt><span class="term"><code class="option">tls_version</code> <em class="replaceable"><code>version</code></em></span></dt>
<dd><p>Configure the version of the TLS protocol to be
							used for this listener. Possible values are
							<em class="replaceable"><code>tlsv1.2</code></em>,
							<em class="replaceable"><code>tlsv1.1</code></em> and
							<em class="replaceable"><code>tlsv1</code></em>. If left unset,
							the default of allowing all of TLS v1.2, v1.1 and
							v1.0 is used.</p></dd>
<dt><span class="term"><code class="option">use_identity_as_username</code> [ true | false ]</span></dt>
<dd><p>If <code class="option">require_certificate</code> is
							<em class="replaceable"><code>true</code></em>, you may set
							<code class="option">use_identity_as_username</code> to
							<em class="replaceable"><code>true</code></em> to use the CN value
							from the client certificate as a username. If this
							is <em class="replaceable"><code>true</code></em>, the
							<code class="option">password_file</code> option will not be
							used for this listener.</p></dd>
</dl></div>
</div>
<div class="refsect2">
<a name="idm45942561405632"></a><h3>Pre-shared-key based SSL/TLS Support</h3>
<p>The following options are available for all listeners to
				configure pre-shared-key based SSL support. See also
				"Certificate based SSL/TLS support".</p>
<div class="variablelist"><dl class="variablelist">
<dt><span class="term"><code class="option">ciphers</code> <em class="replaceable"><code>cipher:list</code></em></span></dt>
<dd><p>When using PSK, the encryption ciphers used will
							be chosen from the list of available PSK ciphers.
							If you want to control which ciphers are available,
							use this option.  The list of available ciphers can
							be optained using the "openssl ciphers" command and
							should be provided in the same format as the output
							of that command.</p></dd>
<dt><span class="term"><code class="option">psk_hint</code> <em class="replaceable"><code>hint</code></em></span></dt>
<dd>
<p>The <code class="option">psk_hint</code> option enables
							pre-shared-key support for this listener and also
							acts as an identifier for this listener. The hint
							is sent to clients and may be used locally to aid
							authentication. The hint is a free form string that
							doesn't have much meaning in itself, so feel free
							to be creative.</p>
<p>If this option is provided, see
							<code class="option">psk_file</code> to define the pre-shared
							keys to be used or create a security plugin to
							handle them.</p>
</dd>
<dt><span class="term"><code class="option">tls_version</code> <em class="replaceable"><code>version</code></em></span></dt>
<dd><p>Configure the version of the TLS protocol to be
							used for this listener. Possible values are
							<em class="replaceable"><code>tlsv1.2</code></em>,
							<em class="replaceable"><code>tlsv1.1</code></em> and
							<em class="replaceable"><code>tlsv1</code></em>. If left unset,
							the default of allowing all of TLS v1.2, v1.1 and
							v1.0 is used.</p></dd>
<dt><span class="term"><code class="option">use_identity_as_username</code> [ true | false ]</span></dt>
<dd><p>Set <code class="option">use_identity_as_username</code> to
							have the psk identity sent by the client used as
							its username.  The username will be checked as
							normal, so <code class="option">password_file</code> or
							another means of authentication checking must be
							used. No password will be used.</p></dd>
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
<span class="term"><code class="option">address</code> <em class="replaceable"><code>address[:port]</code></em> <em class="replaceable"><code>[address[:port]]</code></em>, </span><span class="term"><code class="option">addresses</code> <em class="replaceable"><code>address[:port]</code></em> <em class="replaceable"><code>[address[:port]]</code></em></span>
</dt>
<dd>
<p>Specify the address and optionally the port of the
						bridge to connect to. This must be given for each
						bridge connection. If the port is not specified, the
						default of 1883 is used.</p>
<p>Multiple host addresses can be specified on the
						address config. See the <code class="option">round_robin</code>
						option for more details on the behaviour of bridges
						with multiple addresses.</p>
</dd>
<dt><span class="term"><code class="option">bridge_attempt_unsubscribe</code> [ true | false ]</span></dt>
<dd><p>If a bridge has topics that have "out" direction, the
						default behaviour is to send an unsubscribe request to
						the remote broker on that topic. This means that
						changing a topic direction from "in" to "out" will not
						keep receiving incoming messages. Sending these
						unsubscribe requests is not always desirable, setting
						<code class="option">bridge_attempt_unsubscribe</code> to
						<em class="replaceable"><code>false</code></em> will disable sending
						the unsubscribe request. Defaults to
						<em class="replaceable"><code>true</code></em>.</p></dd>
<dt><span class="term"><code class="option">bridge_protocol_version</code> <em class="replaceable"><code>version</code></em></span></dt>
<dd><p>Set the version of the MQTT protocol to use with for
						this bridge. Can be one of
						<em class="replaceable"><code>mqttv31</code></em> or
						<em class="replaceable"><code>mqttv311</code></em>. Defaults to
						<em class="replaceable"><code>mqttv31</code></em>.</p></dd>
<dt><span class="term"><code class="option">cleansession</code> [ true | false ]</span></dt>
<dd>
<p>Set the clean session option for this bridge. Setting
						to <em class="replaceable"><code>false</code></em> (the default),
						means that all subscriptions on the remote broker are
						kept in case of the network connection dropping. If set
						to <em class="replaceable"><code>true</code></em>, all subscriptions
						and messages on the remote broker will be cleaned up if
						the connection drops. Note that setting to
						<em class="replaceable"><code>true</code></em> may cause a large
						amount of retained messages to be sent each time the
						bridge reconnects.</p>
<p>If you are using bridges with
						<code class="option">cleansession</code> set to
						<em class="replaceable"><code>false</code></em> (the default), then
						you may get unexpected behaviour from incoming topics
						if you change what topics you are subscribing to. This
						is because the remote broker keeps the subscription for
						the old topic.  If you have this problem, connect your
						bridge with <code class="option">cleansession</code> set to
						<em class="replaceable"><code>true</code></em>, then reconnect with
						cleansession set to <em class="replaceable"><code>false</code></em> as
						normal.</p>
</dd>
<dt><span class="term"><code class="option">connection</code> <em class="replaceable"><code>name</code></em></span></dt>
<dd><p>This variable marks the start of a new bridge
						connection. It is also used to give the bridge a name
						which is used as the client id on the remote
						broker.</p></dd>
<dt><span class="term"><code class="option">keepalive_interval</code> <em class="replaceable"><code>seconds</code></em></span></dt>
<dd><p>Set the number of seconds after which the bridge
						should send a ping if no other traffic has occurred.
						Defaults to 60. A minimum value of 5 seconds
						is allowed.</p></dd>
<dt><span class="term"><code class="option">idle_timeout</code> <em class="replaceable"><code>seconds</code></em></span></dt>
<dd><p>Set the amount of time a bridge using the lazy start
						type must be idle before it will be stopped. Defaults
						to 60 seconds.</p></dd>
<dt><span class="term"><code class="option">local_clientid</code> <em class="replaceable"><code>id</code></em></span></dt>
<dd><p>Set the clientid to use on the local broker. If not
						defined, this defaults to
						<code class="option">local.&lt;clientid&gt;</code>. If you are
						bridging a broker to itself, it is important that
						local_clientid and clientid do not match.</p></dd>
<dt><span class="term"><code class="option">local_password</code> <em class="replaceable"><code>password</code></em></span></dt>
<dd><p>Configure the password to be used when connecting
						this bridge to the local broker. This may be important
						when authentication and ACLs are being used.</p></dd>
<dt><span class="term"><code class="option">local_username</code> <em class="replaceable"><code>username</code></em></span></dt>
<dd><p>Configure the username to be used when connecting
						this bridge to the local broker. This may be important
						when authentication and ACLs are being used.</p></dd>
<dt><span class="term"><code class="option">notifications</code> [ true | false ]</span></dt>
<dd><p>If set to <em class="replaceable"><code>true</code></em>, publish
						notification messages to the local and remote brokers
						giving information about the state of the bridge
						connection. Retained messages are published to the
						topic $SYS/broker/connection/&lt;clientid&gt;/state
						unless otherwise set with
						<code class="option">notification_topic</code>s.  If the message
						is 1 then the connection is active, or 0 if the
						connection has failed. Defaults to
						<em class="replaceable"><code>true</code></em>.</p></dd>
<dt><span class="term"><code class="option">notification_topic</code> <em class="replaceable"><code>topic</code></em></span></dt>
<dd><p>Choose the topic on which notifications will be
						published for this bridge. If not set the messages will
						be sent on the topic
						$SYS/broker/connection/&lt;clientid&gt;/state.</p></dd>
<dt><span class="term"><code class="option">remote_clientid</code> <em class="replaceable"><code>id</code></em></span></dt>
<dd>
<p>Set the client id for this bridge connection. If not
						defined, this defaults to 'name.hostname', where name
						is the connection name and hostname is the hostname of
						this computer.</p>
<p>This replaces the old "clientid" option to avoid
						confusion with local/remote sides of the bridge.
						"clientid" remains valid for the time being.</p>
</dd>
<dt><span class="term"><code class="option">remote_password</code> <em class="replaceable"><code>value</code></em></span></dt>
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
<dt><span class="term"><code class="option">remote_username</code> <em class="replaceable"><code>name</code></em></span></dt>
<dd>
<p>Configure a username for the bridge. This is used for
						authentication purposes when connecting to a broker
						that supports MQTT v3.1 and up and requires a username
						and/or password to connect. See also the
						<code class="option">remote_password</code> option.</p>
<p>This replaces the old "username" option to avoid
						confusion with local/remote sides of the bridge.
						"username" remains valid for the time being.</p>
</dd>
<dt><span class="term"><code class="option">restart_timeout</code> <em class="replaceable"><code>value</code></em></span></dt>
<dd><p>Set the amount of time a bridge using the automatic
						start type will wait until attempting to reconnect.
						Defaults to 30 seconds.</p></dd>
<dt><span class="term"><code class="option">round_robin</code> [ true | false ]</span></dt>
<dd>
<p>If the bridge has more than one address given in the
						address/addresses configuration, the round_robin option
						defines the behaviour of the bridge on a failure of the
						bridge connection. If round_robin is
						<em class="replaceable"><code>false</code></em>, the default value,
						then the first address is treated as the main bridge
						connection. If the connection fails, the other
						secondary addresses will be attempted in turn. Whilst
						connected to a secondary bridge, the bridge will
						periodically attempt to reconnect to the main bridge
						until successful.</p>
<p>If round_robin is <em class="replaceable"><code>true</code></em>,
						then all addresses are treated as equals. If a
						connection fails, the next address will be tried and if
						successful will remain connected until it fails.</p>
</dd>
<dt><span class="term"><code class="option">start_type</code> [ automatic | lazy | once ]</span></dt>
<dd>
<p>Set the start type of the bridge. This controls how
						the bridge starts and can be one of three types:
						<em class="replaceable"><code>automatic</code></em>, <em class="replaceable"><code>lazy
						</code></em>and <em class="replaceable"><code>once</code></em>. Note
						that RSMB provides a fourth start type "manual" which
						isn't currently supported by mosquitto.</p>
<p><em class="replaceable"><code>automatic</code></em> is the default
						start type and means that the bridge connection will be
						started automatically when the broker starts and also
						restarted after a short delay (30 seconds) if the
						connection fails.</p>
<p>Bridges using the <em class="replaceable"><code>lazy</code></em>
						start type will be started automatically when the
						number of queued messages exceeds the number set with
						the <code class="option">threshold</code> option. It will be
						stopped automatically after the time set by the
						<code class="option">idle_timeout</code> parameter. Use this start
						type if you wish the connection to only be active when
						it is needed.</p>
<p>A bridge using the <em class="replaceable"><code>once</code></em>
						start type will be started automatically when the
						broker starts but will not be restarted if the
						connection fails.</p>
</dd>
<dt><span class="term"><code class="option">threshold</code> <em class="replaceable"><code>count</code></em></span></dt>
<dd><p>Set the number of messages that need to be queued for
						a bridge with lazy start type to be restarted.
						Defaults to 10 messages.</p></dd>
<dt><span class="term"><code class="option">topic</code> <em class="replaceable"><code>pattern</code></em> [[[ out | in | both ] qos-level] local-prefix remote-prefix]</span></dt>
<dd>
<p>Define a topic pattern to be shared between the two
						brokers. Any topics matching the pattern (which may
						include wildcards) are shared. The second parameter
						defines the direction that the messages will be shared
						in, so it is possible to import messages from a remote
						broker using <em class="replaceable"><code>in</code></em>, export
						messages to a remote broker using
						<em class="replaceable"><code>out</code></em> or share messages in
						both directions. If this parameter is not defined, the
						default of <em class="replaceable"><code>out</code></em> is used. The
						QoS level defines the publish/subscribe QoS level used
						for this topic and defaults to 0.</p>
<p>The <em class="replaceable"><code>local-prefix</code></em> and
						<em class="replaceable"><code>remote-prefix</code></em> options allow
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
						<em class="replaceable"><code>""</code></em>. Using the empty marker
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
<th><span class="emphasis"><em>Topic</em></span></th>
<th><span class="emphasis"><em>Local Prefix</em></span></th>
<th><span class="emphasis"><em>Remote Prefix</em></span></th>
<th><span class="emphasis"><em>Validity</em></span></th>
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
<p>See also the <code class="option">cleansession</code> option if
						you have messages arriving on unexpected topics when
						using incoming topics.</p>
<div class="example">
<a name="idm45942561296432"></a><div class="example-title">Example Bridge Topic Remapping. </div>
<div class="example-contents">
<p>The configuration below connects a bridge to the
							broker at <code class="option">test.mosquitto.org</code>. It
							subscribes to the remote topic
							<code class="option">$SYS/broker/clients/total</code> and
							republishes the messages received to the local topic
							<code class="option">test/mosquitto/org/clients/total</code></p>
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
<dt><span class="term"><code class="option">try_private</code> [ true | false ]</span></dt>
<dd>
<p>If try_private is set to
						<em class="replaceable"><code>true</code></em>, the bridge will
						attempt to indicate to the remote broker that it is a
						bridge not an ordinary client. If successful, this
						means that loop detection will be more effective and
						that retained messages will be propagated correctly.
						Not all brokers support this feature so it may be
						necessary to set <code class="option">try_private</code> to
						<em class="replaceable"><code>false</code></em> if your bridge does
						not connect properly.</p>
<p>Defaults to <em class="replaceable"><code>true</code></em>.</p>
</dd>
</dl></div>
<div class="refsect2">
<a name="idm45942561288336"></a><h3>SSL/TLS Support</h3>
<p>The following options are available for all bridges to
				configure SSL/TLS support.</p>
<div class="variablelist"><dl class="variablelist">
<dt><span class="term"><code class="option">bridge_attempt_unsubscribe</code> [ true | false ]</span></dt>
<dd><p>If a bridge has topics that have "out" direction,
							the default behaviour is to send an unsubscribe
							request to the remote broker on that topic. This
							means that changing a topic direction from "in" to
							"out" will not keep receiving incoming messages.
							Sending these unsubscribe requests is not always
							desirable, setting
							<code class="option">bridge_attempt_unsubscribe</code> to
							<em class="replaceable"><code>false</code></em> will disable
							sending the unsubscribe request.</p></dd>
<dt><span class="term"><code class="option">bridge_cafile</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd>
<p>One of <code class="option">bridge_cafile</code> or
							<code class="option">bridge_capath</code> must be provided to
							allow SSL/TLS support.</p>
<p>bridge_cafile is used to define the path to a file
							containing the PEM encoded CA certificates that
							have signed the certificate for the remote broker.
						</p>
</dd>
<dt><span class="term"><code class="option">bridge_capath</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd>
<p>One of <code class="option">bridge_capath</code> or
							<code class="option">bridge_capath</code> must be provided to
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
<dt><span class="term"><code class="option">bridge_certfile</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd><p>Path to the PEM encoded client certificate for
							this bridge, if required by the remote
							broker.</p></dd>
<dt><span class="term"><code class="option">bridge_identity</code> <em class="replaceable"><code>identity</code></em></span></dt>
<dd><p>Pre-shared-key encryption provides an alternative
							to certificate based encryption. A bridge can be
							configured to use PSK with the
							<code class="option">bridge_identity</code> and
							<code class="option">bridge_psk</code> options.  This is the
							client identity used with PSK encryption. Only one
							of certificate and PSK based encryption can be used
							on one bridge at once.</p></dd>
<dt><span class="term"><code class="option">bridge_insecure</code> [ true | false ]</span></dt>
<dd>
<p>When using certificate based TLS, the bridge will
							attempt to verify the hostname provided in the
							remote certificate matches the host/address being
							connected to. This may cause problems in testing
							scenarios, so <code class="option">bridge_insecure</code> may
							be set to <em class="replaceable"><code>false</code></em> to
							disable the hostname verification.</p>
<p>Setting this option to
							<em class="replaceable"><code>true</code></em> means that a
							malicious third party could potentially inpersonate
							your server, so it should always be set to
							<em class="replaceable"><code>false</code></em> in production
							environments.</p>
</dd>
<dt><span class="term"><code class="option">bridge_keyfile</code> <em class="replaceable"><code>file path</code></em></span></dt>
<dd><p>Path to the PEM encoded private key for this
							bridge, if required by the remote broker.</p></dd>
<dt><span class="term"><code class="option">bridge_psk</code> <em class="replaceable"><code>key</code></em></span></dt>
<dd><p>Pre-shared-key encryption provides an alternative
							to certificate based encryption. A bridge can be
							configured to use PSK with the
							<code class="option">bridge_identity</code> and
							<code class="option">bridge_psk</code> options.  This is the
							pre-shared-key in hexadecimal format with no "0x".
							Only one of certificate and PSK based encryption
							can be used on one bridge at once.</p></dd>
<dt><span class="term"><code class="option">bridge_tls_version</code> <em class="replaceable"><code>version</code></em></span></dt>
<dd><p>Configure the version of the TLS protocol to be
							used for this bridge. Possible values are
							<em class="replaceable"><code>tlsv1.2</code></em>,
							<em class="replaceable"><code>tlsv1.1</code></em> and
							<em class="replaceable"><code>tlsv1</code></em>. Defaults to
							<em class="replaceable"><code>tlsv1.2</code></em>. The remote
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
<p><span class="command"><strong>mosquitto</strong></span> bug information can be found at
			<a class="ulink" href="https://github.com/eclipse/mosquitto/issues" target="_top">https://github.com/eclipse/mosquitto/issues</a></p>
</div>
<div class="refsect1">
<a name="idm45942561252768"></a><h2>See Also</h2>
<span class="simplelist">
				<span class="citerefentry"><span class="refentrytitle"><a class="link" href="mosquitto-8.html" target="_top">mosquitto</a></span>(8)</span>
			, 
				<span class="citerefentry"><span class="refentrytitle"><a class="link" href="mosquitto_passwd-1.html" target="_top">mosquitto_passwd</a></span>(1)</span>
			, 
				<span class="citerefentry"><span class="refentrytitle"><a class="link" href="mosquitto-tls-7.html" target="_top">mosquitto-tls</a></span>(7)</span>
			, 
				<span class="citerefentry"><span class="refentrytitle"><a class="link" href="mqtt-7.html" target="_top">mqtt</a></span>(7)</span>
			, 
				<span class="citerefentry"><span class="refentrytitle"><a class="link" href="http://linux.die.net/man/5/limits.conf" target="_top">limits.conf</a></span>(5)</span>
			</span>
</div>
<div class="refsect1">
<a name="idm45942561241360"></a><h2>Author</h2>
<p>Roger Light <code class="email">&lt;<a class="email" href="mailto:roger@atchoo.org">roger@atchoo.org</a>&gt;</code></p>
</div>
</div></body>
</html>

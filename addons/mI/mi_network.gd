extends Node
signal Radio(Tag, Value)

# The URL we will connect to
export var websocket_url = "ws://espressif.local"
onready var controls_members = get_tree().get_nodes_in_group("controls")

# Our WebSocketClient instance
var _client = WebSocketClient.new()
var ReconnectTimer := Timer.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	controls_members = get_tree().get_nodes_in_group("controls")
	disable_all_controls()
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# # Initiate reconnection timer
	ReconnectTimer.wait_time = 5.0
	ReconnectTimer.one_shot = true
	ReconnectTimer.connect("timeout", self, "_on_ReconnectTimer_timeout")
	add_child(ReconnectTimer)
	# Initiate connection to the given URL.
	_on_ReconnectTimer_timeout()

	pass # Replace with function body.


func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	disable_all_controls()
	ReconnectTimer.start()
	#$PingTimer.stop()
	#set_process(false)


func _on_ReconnectTimer_timeout():

	print_debug("Trying to connect to "+websocket_url)
	var err = _client.connect_to_url(websocket_url)
	print_debug(err)
	if err != OK:
		print_debug("Unable to connect")
		#set_process(false)
		#$ReconnectTimer.start()
	else:
		print_debug("Connected to "+_client.get_connected_host())
	pass # Replace with function body.


func disable_all_controls():
	for member in controls_members:
		member.disable(true)
func enable_all_controls():
	for member in controls_members:
		member.disable(false)


func _on_button_ON_OFF_button_changed(state, _arg):
	print_debug(state)
	_client.get_peer(1).put_packet(state.to_utf8())
	pass # Replace with function body.


func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()


func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	print_debug("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())


func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print_debug("Connected with protocol: ", proto)
	#$PingTimer.start()
	enable_all_controls()
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.get_peer(1).put_packet("Test packet".to_utf8())


func PhoneCall(from, message, advanced=""):
	print_debug("Message from: ", from, "=", message)
	match from:
		"PUMP":
			match message:
				"START":
					emit_signal("Radio", "PUMP", "RUNNING")
				"STOP":
					emit_signal("Radio", "PUMP", "STOPPED")
		_:
			emit_signal("Radio", from, message)
				

extends Control

@onready var label: Label = $Label

var audio_buffer = []
var capture: AudioEffectCapture

# Constants
const SAMPLE_RATE = 44100
const BUFFER_SIZE = 2048  # Number of samples to process

func _ready():
	# Create or get the microphone bus
	var bus_index = AudioServer.get_bus_index("Record")
	capture = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectCapture

func _process(delta):
	if capture and capture.can_get_buffer(BUFFER_SIZE):
		var new_samples = capture.get_buffer(BUFFER_SIZE)
		audio_buffer = new_samples
		#update()  # Refresh the drawing
		label.text = "Samples: " + str(audio_buffer.size())

func _draw():
	if audio_buffer.size() < 2:
		return

	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y
	var points = []
	
	for i in range(audio_buffer.size()):
		var x = width * i / float(audio_buffer.size())  # Normalize X
		var y = height / 2 + (audio_buffer[i] * height / 2)  # Scale waveform
		points.append(Vector2(x, y))

	draw_polyline(points, Color(1, 1, 1), 2)  # Draw waveform

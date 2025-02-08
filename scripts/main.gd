extends Control

@onready var waveform: Line2D = $Waveform
@onready var record_button: Button = $RecordButton

var audio_buffer = []
var capture: AudioEffectCapture
var record: AudioEffectRecord

# Constants
const SAMPLE_RATE = 44100
const BUFFER_SIZE = 1024  # Number of samples to process

func _ready():
	var bus_index = AudioServer.get_bus_index("Record")
	capture = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectCapture
	record = AudioServer.get_bus_effect(bus_index, 1) as AudioEffectRecord

func _process(delta):
	if capture and capture.can_get_buffer(BUFFER_SIZE):
		audio_buffer = capture.get_buffer(BUFFER_SIZE)
		update_waveform()
	print(audio_buffer.slice(0,10))

func update_waveform():
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y

	var points = []
	for i in range(audio_buffer.size()):
		var x = width * i / float(audio_buffer.size())  # Normalize X
		var y = height / 2 + (audio_buffer[i].x * height / 2)  # Scale waveform
		points.append(Vector2(x, y))

	waveform.points = points  # Update Line2D

func _on_record_button_pressed() -> void:
	if record.is_recording_active():
		record.set_recording_active(false)
		record_button.text = "Record"
	else:
		record.set_recording_active(true)
		record_button.text = "Stop"

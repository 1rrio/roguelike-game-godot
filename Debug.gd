extends Node

static var enabled := true

static func log(source: String, message: String):
	if !enabled:
		return

	print("[%s] %s" % [source, message])

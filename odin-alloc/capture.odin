package main

import "core:fmt"

main :: proc() {
	// Repeat
	sum: int = 0
	repeat(3, &sum, proc(data: ^int, i: int) {
		sum := (^int)(data)
		sum^ += i
	})
	fmt.printf("sum: %v\n", sum)

	// Gather
	hub: Hub
	hub_init(&hub)
	defer hub_destroy(&hub)
	defer free_all(context.temp_allocator)
	gather_handlers(&hub)
	hub_action_performed(&hub)
}

repeat :: proc(times: int, data: ^$T, act: proc(data: ^T, i: int)) {
	for i in 0 ..< times {
		act(data, i)
	}
}

Items_Capture :: struct {
	items:     ^[dynamic]int,
	i:         int,
}

gather_handlers :: proc(hub: ^Hub) {
	items := new([dynamic]int, context.temp_allocator)
	items^ = make([dynamic]int, 0, 3, context.temp_allocator)
	for i in 0 ..< cap(items) {
		capture := new(Items_Capture, context.temp_allocator)
		capture.items = items
		capture.i = i
		handler := Handler(Items_Capture) {
			data = capture,
			procedure = proc(data: ^Items_Capture) {
				append(data.items, data.i)
				fmt.printf("items: %v\n", data.items^)
			},
		}
		hub_on_action(hub, handler)
	}
}

Handler :: struct($Data: typeid) {
	data:      ^Data,
	procedure: proc(data: ^Data),
}

Hub :: struct {
	handlers: [dynamic]Handler(rawptr),
}

hub_init :: proc(hub: ^Hub) {
	hub.handlers = make([dynamic]Handler(rawptr))
}

hub_destroy :: proc(hub: ^Hub) {
	delete(hub.handlers)
}

hub_on_action :: proc(hub: ^Hub, handler: Handler($T)) {
	handler_raw := Handler(rawptr) {
		data      = auto_cast handler.data,
		procedure = auto_cast handler.procedure,
	}
	append(&hub.handlers, handler_raw)
}

hub_action_performed :: proc(hub: ^Hub) {
	for handler in hub.handlers {
		handler.procedure(handler.data)
	}
}

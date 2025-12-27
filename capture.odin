package main

import "core:fmt"

main :: proc() {
	// Repeat
	sum: int = 0
	repeat(3, &sum, proc(data: ^int, i: int) {
		s := (^int)(data)
		s^ += i
	})
	fmt.printf("sum: %v\n", sum)

	// Gather
	hub: Hub
	hub_init(&hub)
	defer hub_destroy(&hub)
	init_hub(&hub)
	hub_action_performed(&hub)
}

repeat :: proc(times: int, data: ^$T, act: proc(data: ^T, i: int)) {
	for i in 0 ..< times {
		act(data, i)
	}
}

Handler :: struct {
	data:      rawptr,
	procedure: proc(data: rawptr),
}

Hub :: struct {
	handlers: [dynamic]Handler,
}

hub_init :: proc(hub: ^Hub) {
	hub.handlers = make([dynamic]Handler)
}

hub_destroy :: proc(hub: ^Hub) {
	// In a real app, you'd also free the individual Capture_Data pointers here
	// TODO Or else use temp allocator?
	delete(hub.handlers)
}

hub_on_action :: proc(hub: ^Hub, data: ^$T, procedure: proc(_: ^T)) {
	handler := Handler {
		data      = rawptr(data),
		procedure = auto_cast procedure,
	}
	append(&hub.handlers, handler)
}

hub_action_performed :: proc(hub: ^Hub) {
	for hnd in hub.handlers {
		hnd.procedure(hnd.data)
	}
}

Items_Capture :: struct {
	items: ^[dynamic]int,
	i:     int,
}

init_hub :: proc(hub: ^Hub) {
	items := new([dynamic]int)
	items^ = make([dynamic]int)
	for i in 0 ..< 3 {
		capture := new(Items_Capture)
		capture.items = items
		capture.i = i
		hub_on_action(hub, capture, proc(data: ^Items_Capture) {
			append(data.items, data.i)
			fmt.printf("items: %v\n", data.items^)
		})
	}
}

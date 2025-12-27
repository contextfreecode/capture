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

Handler :: struct($Data: typeid) {
	data:      ^Data,
	destroy:   proc(data: ^Data),
	procedure: proc(data: ^Data),
}

Hub :: struct {
	handlers: [dynamic]Handler(rawptr),
}

hub_init :: proc(hub: ^Hub) {
	hub.handlers = make([dynamic]Handler(rawptr))
}

hub_destroy :: proc(hub: ^Hub) {
	for handler in hub.handlers {
		if handler.destroy != nil {
			handler.destroy(handler.data)
		}
	}
	delete(hub.handlers)
}

hub_on_action :: proc(hub: ^Hub, handler: Handler($T)) {
	handler_raw := Handler(rawptr) {
		data      = auto_cast handler.data,
		destroy   = auto_cast handler.destroy,
		procedure = auto_cast handler.procedure,
	}
	append(&hub.handlers, handler_raw)
}

hub_action_performed :: proc(hub: ^Hub) {
	for handler in hub.handlers {
		handler.procedure(handler.data)
	}
}

Items_Capture :: struct {
	items:     ^[dynamic]int,
	ref_count: ^int,
	i:         int,
}

init_hub :: proc(hub: ^Hub) {
	items := new([dynamic]int)
	ref_count := new(int)
	for i in 0 ..< 3 {
		capture := new(Items_Capture)
		capture.items = items
		capture.i = i
		capture.ref_count = ref_count
		ref_count^ += 1
		handler := Handler(Items_Capture) {
			data = capture,
			destroy = proc(data: ^Items_Capture) {
				data.ref_count^ -= 1
				if data.ref_count^ == 0 {
					delete(data.items^)
					free(data.items)
					free(data.ref_count)
				}
				free(data)
			},
			procedure = proc(data: ^Items_Capture) {
				append(data.items, data.i)
				fmt.printf("items: %v\n", data.items^)
			},
		}
		hub_on_action(hub, handler)
	}
}

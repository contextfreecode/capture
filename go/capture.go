package main

import "fmt"

func main() {
	// Repeat
	sum := 0
	repeat(3, func(i int) {
		sum += i
	})
	fmt.Println("sum:", sum)

	// Gather
	hub := &Hub{}
	initHub(hub)
	hub.ActionPerformed()
}

func repeat(times int, act func(int)) {
	// for i := range times {
	for i := 0; i < times; i++ {
		act(i)
	}
}

func initHub(hub *Hub) {
	items := []int{}
	// for i := range 3 {
	for i := 0; i < 3; i++ {
		// i := i
		hub.OnAction(func() {
			items = append(items, i)
			fmt.Println("items:", items)
		})
	}
}

type Hub struct {
	handlers []func()
}

func (h *Hub) OnAction(handler func()) {
	h.handlers = append(h.handlers, handler)
}

func (h *Hub) ActionPerformed() {
	for _, handler := range h.handlers {
		handler()
	}
}

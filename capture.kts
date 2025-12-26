fun main() {
    // Repeat
    var sum = 0
    repeat(3) { i ->
        sum += i
    }
    println("sum: $sum")

    // Gather
    val hub = Hub()
    initHub(hub)
    hub.actionPerformed()
}

fun repeat(times: Int, act: (Int) -> Unit) {
    for (i in 0 until times) {
        act(i)
    }
}

fun initHub(hub: Hub) {
    val items = mutableListOf<Int>()
    for (i in 0 until 3) {
        hub.onAction {
            items.add(i)
            println("items: $items")
        }
    }
}

class Hub {
    private val handlers = mutableListOf<() -> Unit>()

    fun onAction(handler: () -> Unit) {
        handlers.add(handler)
    }

    fun actionPerformed() {
        for (handler in handlers) {
            handler()
        }
    }
}

main()

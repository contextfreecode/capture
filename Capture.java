void main() {
    // Repeat
    int[] sum = {0};
    repeat(3, i -> {
        sum[0] += i;
    });
    IO.println("sum: " + sum[0]);

    // Gather
    var hub = new Hub();
    gatherHandlers(hub);
    hub.actionPerformed();
}

void repeat(int times, IntConsumer act) {
    for (int i = 0; i < times; ++i) {
        act.accept(i);
    }
}

void gatherHandlers(Hub hub) {
    var items = new ArrayList<Integer>();
    for (int i = 0; i < 3; ++i) {
        int i2 = i;
        hub.onAction(() -> {
            items.add(i2);
            IO.println("items: " + items);
        });
    }
}

class Hub {
    public void onAction(Runnable handler) {
        handlers.add(handler);
    }

    public void actionPerformed() {
        handlers.forEach(Runnable::run);
    }

    List<Runnable> handlers = new ArrayList<>();
}

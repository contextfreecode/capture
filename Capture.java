void main() {
    // Repeat
    int[] sum = {0};
    repeat(3, i -> {
        sum[0] += i;
    });
    IO.println("sum: " + sum[0]);

    // Gather
    var hub = new Hub();
    initHub(hub);
    hub.actionPerformed();
}

void repeat(int times, IntConsumer act) {
    for (int i = 0; i < times; ++i) {
        act.accept(i);
    }
}

void initHub(Hub hub) {
    for (int i = 0; i < 3; ++i) {
        int i2 = i;
        hub.onAction(() -> {
            IO.println("i: " + i2);
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

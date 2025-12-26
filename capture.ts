function main() {
  // Repeat
  let sum = 0;
  repeat(3, (i) => {
    sum += i;
  });
  console.log("sum:", sum);

  // Gather
  const hub = new Hub();
  initHub(hub);
  hub.actionPerformed();
}

function repeat(times: number, act: (i: number) => void) {
  for (let i = 0; i < times; i++) {
    act(i);
  }
}

class Hub {
  private handlers: (() => void)[] = [];

  onAction(handler: () => void) {
    this.handlers.push(handler);
  }

  actionPerformed() {
    for (const handler of this.handlers) {
      handler();
    }
  }
}

function initHub(hub: Hub) {
  const items: number[] = [];
  for (let i = 0; i < 3; i++) {
    hub.onAction(() => {
      items.push(i);
      console.log("items:", items);
    });
  }
}

main()

from collections.abc import Callable


def main():
    # Repeat
    sum_val = 0

    def act(i: int):
        nonlocal sum_val
        sum_val = sum_val + i

    repeat(3, act)
    print(f"sum: {sum_val}")

    # Gather
    hub = Hub()
    gather_handlers(hub)
    hub.action_performed()


def repeat(times: int, act: Callable[[int], None]) -> None:
    for i in range(times):
        act(i)


def gather_handlers(hub: Hub) -> None:
    items: list[int] = []
    for i in range(3):

        # def handler():
        def handler(i=i):
            items.append(i)
            print(f"items: {items}")

        hub.on_action(handler)


class Hub:
    def __init__(self):
        self.handlers: list[Callable[[], None]] = []

    def on_action(self, handler: Callable[[], None]) -> None:
        self.handlers.append(handler)

    def action_performed(self) -> None:
        for handler in self.handlers:
            handler()


main()

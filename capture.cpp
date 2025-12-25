#include <functional>
#include <iostream>
#include <vector>

void repeat(int times, std::function<void(int)> act) {
    for (int i = 0; i < times; ++i) {
        act(i);
    }
}

struct Hub {
    void on_action(std::function<void()> handler) {
        handlers.push_back(handler);
    }

    void action_performed() {
        for (auto& handler: handlers) {
            handler();
        }
    }

private:
    std::vector<std::function<void()>> handlers;
};

void init_hub(Hub& hub) {
    for (int i = 0; i < 3; ++i) {
        hub.on_action([i](){
            std::cout << "i: " << i << "\n";
        });
    }
}

int main() {
    // Sum
    int sum = 0;
    repeat(3, [&sum](int i) {
        sum += i;
    });
    std::cout << "sum: " << sum << "\n";
    // Gather
    Hub hub;
    init_hub(hub);
    hub.action_performed();
}

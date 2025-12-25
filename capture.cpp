#include <functional>
#include <iostream>
#include <memory>
#include <vector>

// template<typename F>
// void repeat(int times, F&& act) {
// void repeat(int times, void(*act)(int)) {
void repeat(int times, std::function<void(int)> act) {
    for (int i = 0; i < times; ++i) {
        act(i);
    }
}

struct Hub {
    template<typename F>
    void on_action(F&& handler) {
        handlers.emplace_back(std::forward<F>(handler));
    }

    void action_performed() {
        for (const auto& handler: handlers) {
            handler();
        }
    }

private:
    // std::vector<void(*)()> handlers;
    std::vector<std::function<void()>> handlers;
};

void init_hub(Hub& hub) {
    auto items = std::make_shared<std::vector<int>>();
    for (int i = 0; i < 3; ++i) {
        hub.on_action([items, i](){
            items->push_back(i);
            std::cout << "items:";
            for (int i : *items) {
                std::cout << " " << i;
            }
            std::cout << "\n";
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

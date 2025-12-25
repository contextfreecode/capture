#include <iostream>
#include <functional>

void repeat(int times, std::function<void(int)> act) {
    for (int i = 0; i < times; i += 1) {
        act(i);
    }
}

int main() {
    int sum = 0;
    repeat(3, [&sum](int i) {
        sum += i;
    });
    std::cout << "sum: " << sum << "\n";
}

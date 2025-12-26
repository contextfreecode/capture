use std::cell::RefCell;
use std::rc::Rc;

fn main() {
    // Repeat
    let mut sum = 0;
    repeat(3, |i| {
        sum += i;
    });
    println!("sum: {}", sum);

    // Gather
    let mut hub = Hub::new();
    init_hub(&mut hub);
    hub.action_performed();
}

fn repeat<F>(times: i32, mut act: F)
where
    F: FnMut(i32),
{
    for i in 0..times {
        act(i);
    }
}

fn init_hub(hub: &mut Hub) {
    let items = Rc::new(RefCell::new(Vec::new()));
    // let mut items = Vec::new();
    for i in 0..3 {
        let items = Rc::clone(&items);
        hub.on_action(Box::new(move || {
            items.borrow_mut().push(i);
            println!("items: {:?}", items.borrow());
            // items.push(i);
            // println!("items: {:?}", items);
        }));
    }
}

struct Hub {
    handlers: Vec<Box<dyn Fn()>>,
}

impl Hub {
    fn new() -> Self {
        Hub {
            handlers: Vec::new(),
        }
    }

    fn on_action(&mut self, handler: Box<dyn Fn()>) {
        self.handlers.push(handler);
    }

    fn action_performed(&self) {
        for handler in &self.handlers {
            handler();
        }
    }
}

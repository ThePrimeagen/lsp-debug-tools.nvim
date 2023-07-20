
const a = [];
function foo() {
    a.push({
        a: 69,
        b: 69,
    });

    setTimeout(foo);
}

foo();


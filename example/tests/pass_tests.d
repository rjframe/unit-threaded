module example.tests.pass_tests;

import unit_threaded.check;
import unit_threaded.testcase;
import unit_threaded.io;
import core.thread;


class IntEqualTest: TestCase {
    override void test() {
        writelnUt("This will not show up unless -d is used");
        checkNotEqual(1, 5);
        checkNotEqual(5, 1);
        checkEqual(3, 3);
        checkEqual(2, 2);
    }
}

class DoubleEqualTest: TestCase {
    override void test() {
        checkNotEqual(1.0, 2.0);
        checkEqual(2.0, 2.0);
        checkEqual(2.0, 2.0);
    }
}

void testEqual() {
    writelnUt("More output for writelnUt (disabled with -d)");
    checkEqual(1, 1);
    checkEqual(1.0, 1.0);
    checkEqual("foo", "foo");
}

void testNotEqual() {
    checkNotEqual(3, 4);
    checkNotEqual(5.0, 6.0);
    checkNotEqual("foo", "bar");
}


private class MyException: Exception {
    this() {
        super("MyException");
    }
}

void testThrown() {
    checkThrown!MyException(throwFunc());
}

void testNotThrown() {
    checkNotThrown(nothrowFunc());
}

private void throwFunc() {
    throw new MyException;
}

private void nothrowFunc() nothrow {
    {}
}

//the tests below should take only 1 second in total if using parallelism
//(given enough cores)
void testLongRunning1() {
    Thread.sleep( dur!"seconds"(1));
}

void testLongRunning2() {
    Thread.sleep( dur!"seconds"(1));
}

void testLongRunning3() {
    Thread.sleep( dur!"seconds"(1));
}

void testLongRunning4() {
    Thread.sleep( dur!"seconds"(1));
}

// void testNoIo() {
//     import std.stdio;
//     writeln("This should not be seen except for -d option");
//     writeln("Or this");
//     stderr.writeln("Stderr shouldn't be seen either");
// }

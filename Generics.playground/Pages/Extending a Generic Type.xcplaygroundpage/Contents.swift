/*:
 # Extensions with a Generic Where Clause
 
 We can use a generic `where` clause while extending generic types or "protocols with associated types" to specify which concrete implementations will be extended. For instance we may wish to add a `sum` function to `Collection` but only if it's `Element`s are `Int`s.
 */

// Extend Collection's of Int with sum function.
extension Collection where Element == Int {
    // Note we're using `sumInts()` rather than `sum()` to avoid conflict with more general definition below.
    func sumInts() -> Element {
        return self.reduce(0, +)
    }
}

[1, 2, 3].sumInts()
// [1.0, 2.0, 3.0].sumInts() // Won't compile becuase our extension doesn't apply to `Collection`s of `Double`.

/*:
 Now let's expand this to apply to any `Collection` whose `Element`s are `Numeric` (arithetic types)
 */

// Extend Collection's of Numeric with sum function.
extension Collection where Element: Numeric {
    func sum() -> Element {
        return self.reduce(0, +)
    }
}

// Now our extension will apply to all `Collection`s who's `Element`s are `Numeric` including `Int`, `Float`, `Double`, etc.
[4, 5, 6].sum()
[7.0, 8.0, 9.0].sum()

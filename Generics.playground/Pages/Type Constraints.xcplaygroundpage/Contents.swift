/*:
 # Type Constraints
 
 It is often useful to write generic code that can only work with types that conform to a particular protocol.
 
 */

import Foundation

/// A type in which instances can be added together to get a result of the same type.
protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}

// Swift does not support implicit protocol conformance so we must explicitly add it to the following type even though they already meet the protocol requirement.
extension Int: Addable {}
extension Double: Addable {}
extension Array: Addable {}
extension String: Addable {}


// Non-generic attempt which doesn't compile.
//func add(a: Addable, b: Addable) -> Addable {
//    fatalError("This doesn't work because `a`, `b`, and the return type need to be the same concrete type and the compiler has no way to guarantee this as written.")
//}


// Implement generic version constrained to Addable. Now the compiler can enforce that `a`, `b`, and the return type are all the same concrete type, and that type conforms to `Addable`.
func add<T: Addable>(a: T, b: T) -> T {
    return a + b
}

add(a: 1, b: 2)
add(a: 3.0, b: 4.0)
add(a: [1,2,3], b: [4,5,6])
add(a: "One", b: "Two")

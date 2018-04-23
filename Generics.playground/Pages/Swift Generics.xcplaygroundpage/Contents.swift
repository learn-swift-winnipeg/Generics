/*:
 # Swift Generics
 
 Generics is a language feature supported by Swift. I personally find the definitions provided by Apple and online tutorials easier to understand *after* I've converted a non-generic function to use generics. So let's first start with a simple function that prints an item of a specific type to the console.
 
 */

import Foundation

// Non-generic

func printToConsole(itemToPrint: Int) {
    print(itemToPrint)
}

printToConsole(itemToPrint: 1)

// Try the above with a Double, String, etc.

func printToConsole(itemToPrint: Double) {
    print(itemToPrint)
}

func printToConsole(itemToPrint: String) {
    print(itemToPrint)
}

printToConsole(itemToPrint: 2.0)
printToConsole(itemToPrint: "Three")
//printToConsole(itemToPrint: [1,2,3]) // Won't compile because we haven't defined an `[Int]` version.

//: Swift's type safety is great and prevents lot's of bugs but could lead a developer to duplicate a lot of code... unless they know about generics!

// Re-implement above function using generics. Note `T` is a placeholder for whatever type is actually used at the callsite.
func printToConsole<T>(itemToPrint: T) {
    print(itemToPrint)
}

// We can now pass in an `[Int]` because our generic function works with any type.
printToConsole(itemToPrint: [1,2,3])

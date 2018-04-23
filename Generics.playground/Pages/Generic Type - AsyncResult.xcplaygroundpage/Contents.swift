/*:
 # AyncResult Enumeration
 
 Getting results back from asynchronous code often involves completion closures because we can't rely on function return values.
 
 Many Foundation APIs use a single completion block with multiple optional parameters in order to report back a failure or success case. Callers often need to read the documentation very carefully in order to know which values will be provided under which circumstances. It's confusing, error prone, and the compiler can't help.

 */

import Foundation
import PlaygroundSupport

// Allow playground to continue executing indefinitely so asynchronous code can call completion handlers at some point in the future.
PlaygroundPage.current.needsIndefiniteExecution = true


// Example of completion handler signature commonly found in Foundation.
func fetchIntAsynchronously(completionHandler: @escaping (Error?, Int?) -> Void) {
    DispatchQueue.main.asyncAfter(seconds: 2.0) {
        // As far as the compiler is concerned the completion handler can be called with four possible parameter combinations:
        // 1. (nil, nil)
//        completionHandler(nil, nil)
        
        // 2. (error, nil)
//        completionHandler(FetchError.failed, nil)
        
        // 3. (nil, error)
        completionHandler(nil, 123)
        
        // 4. (error, int)
//        completionHandler(FetchError.failed, 123)
    }
}

// Example of using above function.
fetchIntAsynchronously(completionHandler: { (error, fetchedInt) in
    // API documentation often encourages making assumptions like "fetchedInt will be nil if error was provided" or "fetchedInt will be provided if error is nil". However as responsible Swift developers we write the code "safely" anyhow.
    
    guard error == nil else {
        // Assume the fetchedInt is nil and return early or fatalError
        fatalError("Failed with error: \(error!)")
    }
    
    guard let fetchedInt = fetchedInt else {
        // Probably create a custom error type to express this case which means more boilerplate code for a case that will should possibily never occur. Or maybe a nil fetchedInt is valid, we'll have to read the documentation carefully and hope they haven't made any errors; not optimal.
        fatalError("Failed to access fetchedInt even though no error was provided.")
    }
    
    // Do something with result.
    print(fetchedInt)
})

/*:
 Why does foundation do this? I imagine it's because most of these APIs were designed for Objective-C which doesn't have a better way to express this. Luckily for us Swift does!
 
 We really want to express there being only two possible outcomes:
 1. Failure with an error.
 2. Success with a value of a predefined type. i.e. `Int`, `Int?`, `[Int]`, `String`, etc.
 
 The "only 2 possible outcomes" requirement can be accomplished using an enumeration. Let's start by creating a non-generic version only handling a single `Int`.
 */

// Create non-generic AsyncResultInt type
enum AsyncResultInt {
    case failure(Error)
    case success(Int)
}

// Re-implement above function with AsyncResultInt.
func fetchIntAsynchronously(completionHandler: @escaping (AsyncResultInt) -> Void) {
    DispatchQueue.main.asyncAfter(seconds: 2.0) {
        let result: AsyncResultInt = .success(456)
        completionHandler(result)
    }
}

// Call AsyncResultInt based function
fetchIntAsynchronously(completionHandler: { result in
    // We now must switch on `result` in order to handle whichever case occurred. Now it's clear there are only two possible outcomes; failure with an error, or success with an integer.
    switch result {
    case .failure(let error):
        fatalError("\(#function): Failed with error: \(error)")
        
    case .success(let fetchedInt):
        // Do something with result.
        print(fetchedInt)
    }
})

/*:
 I love the clarity provided by the above enum example however it only works with a sinlge `Int`. What if we need to fetch other types i.e. `Int?`, `[Int]`, `String`, etc. A developer new to Swift may be tempted to copy/paste `AsyncResultInt`, changing `Int` to whichever new type needs to be handled. However we can solve this without any code duplication now that we now about generics.
 */

// Create generic AsyncResult<T> type
enum AsyncResult<T> {
    case failure(Error)
    case success(T)
}

// Re-implement above function using AsyncResult<Int>.
func fetchAsynchronously(completionHandler: @escaping (AsyncResult<Int>) -> Void) {
    DispatchQueue.main.asyncAfter(seconds: 2.0) {
        let result: AsyncResult<Int> = .success(789)
        completionHandler(result)
    }
}

// Call AsyncResult<Int> based function
fetchAsynchronously(completionHandler: { (result: AsyncResult<Int>) in
    switch result {
    case .failure(let error):
        fatalError("\(#function): Failed with error: \(error)")
        
    case .success(let fetchedValue):
        // Do something with result.
        print(fetchedValue)
    }
})

/*:
 Brilliant! Now let's use `AsyncResult<T>` to implement `Int?`, `[Int]`, and `String` versions.
 
 Note: All the functions are named `fetchAsynchronously` but have different parameter types (https://en.wikipedia.org/wiki/Function_overloading). The callsites below use an explicit type annotation to specify which implementation gets called. i.e. `(result: AsyncResult<Int?>)` or `(result: AsyncResult<[Int]>)`.
 */

// Re-implement above function using AsyncResult<Int?>.
func fetchAsynchronously(completionHandler: @escaping (AsyncResult<Int?>) -> Void) {
    DispatchQueue.main.asyncAfter(seconds: 2.0) {
        completionHandler( .success(789) )
    }
}

// Call AsyncResult<Double> based function
fetchAsynchronously(completionHandler: { (result: AsyncResult<Int?>) in
    switch result {
    case .failure(let error): fatalError("\(#function): Failed with error: \(error)")
    case .success(let fetchedValue): print(String(describing: fetchedValue))
    }
})

// Re-implement above function using AsyncResult<[Int]>.
func fetchAsynchronously(completionHandler: @escaping (AsyncResult<[Int]>) -> Void) {
    DispatchQueue.main.asyncAfter(seconds: 2.0) {
        completionHandler( .success([7, 8, 9]) )
    }
}

// Call AsyncResult<[Int]> based function
fetchAsynchronously(completionHandler: { (result: AsyncResult<[Int]>) in
    switch result {
    case .failure(let error): fatalError("\(#function): Failed with error: \(error)")
    case .success(let fetchedValue): print(fetchedValue)
    }
})

// Re-implement above function using AsyncResult<String>.
func fetchAsynchronously(completionHandler: @escaping (AsyncResult<String>) -> Void) {
    DispatchQueue.main.asyncAfter(seconds: 2.0) {
        completionHandler( .success("Seven hundred eighty-nine") )
    }
}

// Call AsyncResult<String> based function
fetchAsynchronously(completionHandler: { (result: AsyncResult<String>) in
    switch result {
    case .failure(let error): fatalError("\(#function): Failed with error: \(error)")
    case .success(let fetchedValue): print(fetchedValue)
    }
    
    // Tell the Playground to stop executing. This is needed because of the `PlaygroundPage.current.needsIndefiniteExecution = true` above.
    PlaygroundPage.current.finishExecution()
})





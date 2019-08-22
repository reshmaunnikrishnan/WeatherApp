//
//  Observable.swift
//  WeatherApp
//
//  Created by Reshma Unnikrishnan on 21.08.19.
//  Copyright © 2019 ruvlmoon. All rights reserved.
//

import Foundation

/// Data wrapper for observing the value changes
class Observable<T> {
    /// The value container
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
                self.valueChangedHotStart?(self.value)
            }
        }
    }
    
    /// Assign this with a closure to observe the value changes, note that this is a cold signal, which won't be fired by closure assignement
    var valueChanged: ((T) -> Void)?
    
    /// This closure will be triggered when the value updated and when closure is assigned
    var valueChangedHotStart: ((T) -> Void)? {
        didSet {
            valueChangedHotStart?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}

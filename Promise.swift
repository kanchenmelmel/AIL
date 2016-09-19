//
//  Promise.swift
//  AIL
//
//  Created by Wenyu Zhao on 19/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import Swift


class Promise<T> {
    
    private var onSuccess: ((T) -> Void)?
    private var onFail: ((String) -> Void)?
    
    private var result: T?
    private var error: String?
    private var then_inited = false
    private var fail_inited = false
    
    func resolve(value: T) {
        if self.onSuccess != nil {
            self.onSuccess!(value)
        } else {
            self.result = value
        }
    }
    
    func reject(error: String) {
        if self.onFail != nil {
            self.onFail!(error)
        } else {
            self.error = error
        }
    }
    
    func then(callback: (T) -> Void) -> Void {
        if self.result != nil {
            callback(self.result!)
        } else {
            self.onSuccess = callback
        }
    }
    
    func fail(callback: (String) -> Void) -> Void {
        if self.error != nil {
            callback(self.error!)
        } else {
            self.onFail = callback
        }
    }
    
    init() {}
    
}

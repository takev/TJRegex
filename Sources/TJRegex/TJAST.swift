//
//  TJAST.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-30.
//

import Foundation

struct TJAST<T> {
    typealias Element = T

    let token: Element
    let children: [TJAST<Element>]

    init(_ token: Element, _ children: [TJAST<Element>]) {
        self.token = token
        self.children = children
    }

    init(_ token: Element, _ children: ArraySlice<TJAST<Element>>) {
        self.init(token, Array<TJAST<Element>>(children))
    }
}

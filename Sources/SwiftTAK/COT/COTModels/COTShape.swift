//
//  COTShape.swift
//  SwiftTAK
//
//  Created by Cory Foy on 11/24/24.
//

import Foundation

public struct COTShape : COTNode, Equatable {
    
    public var childNodes:[COTNode] = []
    
    public var cotEllipse: COTEllipse? {
        return childNodes.first(where: { $0 is COTEllipse }) as? COTEllipse
    }
    
    public var cotEllipses: [COTEllipse] {
        let ellipses = childNodes.filter { $0 is COTEllipse } as? [COTEllipse] ?? []
        return ellipses
    }
    
    public init(childNodes: [COTNode] = []) {
        self.childNodes = childNodes
    }
    
    public func toXml() -> String {
        return COTXMLHelper.generateXML(
            nodeName: "shape",
            attributes: [:],
            childNodes: childNodes)
    }
    
    public static func == (lhs: COTShape, rhs: COTShape) -> Bool {
        return lhs.childNodes.count == rhs.childNodes.count
    }
}

//
//  Node.swift
//  CommonMark
//
//  Created by Nero Zuo on 16/8/2.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation
import cmark

class Testclass {
  func test() {
//    cmark_m
  }
}

extension String {
  public func markdownToHTML() -> String {
    let outString = cmark_markdown_to_html(self, self.utf8.count, 0)
    return String(UTF8String: outString)!
  }
}

public class Node: CustomStringConvertible {
  let node: COpaquePointer
  
  init(node: COpaquePointer) {
    self.node = node
  }
  
  public convenience init?(markdown: String) {
    let node = cmark_parse_document(markdown, markdown.utf8.count, 0)
    guard node != nil else { return nil }
    self.init(node: node)
  }
  
  
  var type: cmark_node_type {
    return cmark_node_get_type(node)
  }
  
  var listType: cmark_list_type {
    get { return cmark_node_get_list_type(node) }
    set { cmark_node_set_list_type(node, newValue) }
  }
  
  var children: [Node] {
    var result: [Node] = []
    var child = cmark_node_first_child(node)
    while child != nil {
      result.append(Node(node: child))
      child = cmark_node_next(child)
    }
    return result
  }
  
  var childrenS: AnySequence<Node> {
    return AnySequence { () -> AnyGenerator<Node> in
      var child = cmark_node_first_child(self.node)
      return AnyGenerator {
        let result: Node? = child == nil ? nil : Node(node: child)
        child = cmark_node_next(child)
        return result
      }
    }
  }
  
  public var description: String {
    return ""
  }
  
//  deinit {
//    guard type == CMARK_NODE_DOCUMENT else { return }
//    cmark_node_free(node)
//  }
  
}


extension Node {
  func inlineElement() -> InlineElement {
    let parseChildren = { self.children.map { $0.inlineElement() } }
    switch type {
    case CMARK_NODE_TEXT:
      return .Text(text: literal!)
    case CMARK_NODE_SOFTBREAK:
      return .SoftBreak
    case CMARK_NODE_LINEBREAK:
      return .LineBreak
    case CMARK_NODE_CODE:
      return .Code(text: literal!)
    case CMARK_NODE_INLINE_HTML:
      return .InlineHtml(text: literal!)
    case CMARK_NODE_EMPH:
      return .Emphasis(children: parseChildren())
    case CMARK_NODE_STRONG:
      return .Strong(children: parseChildren())
    case CMARK_NODE_LINK:
      return .Link(children: parseChildren(), title: title,
                   url: urlString)
    case CMARK_NODE_IMAGE:
      return .Image(children: parseChildren(), title: title,
                    url: urlString)
    default:
      fatalError("Expected inline element, got \(typeString)")
    }
  }
}


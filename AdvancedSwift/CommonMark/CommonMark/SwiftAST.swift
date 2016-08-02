//
//  SwiftAST.swift
//  CommonMark
//
//  Created by Nero Zuo on 16/8/2.
//  Copyright © 2016年 Nero. All rights reserved.
//

import Foundation

public enum InlineElement {
  case Text(text: String)
  case SoftBreak
  case LineBreak
  case Code(text: String)
  case LineHtml(text: String)
  case Emphasis(children: [InlineElement])
  case Strong(children: [InlineElement])
  case Line(children: [InlineElement], title: String?, url: String?)
  case Image(children: [InlineElement], title: String?, url: String?)
}

public enum Block {
  case List(items: [[Block]], type: ListType)
  case BlockQuote(items: [Block])
  case CodeBlock(text: String, language: String?)
  case Html(text: String)
  case paragraph(text: [InlineElement])
  case Header(text: [InlineElement], level: Int)
  case HorizonalRule
}

public enum ListType {
  case Unordered
  case Ordered
}
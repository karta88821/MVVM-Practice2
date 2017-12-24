//
//  Protocal.swift
//  MVVM-Practice2
//
//  Created by liao yuhao on 2017/12/23.
//  Copyright © 2017年 liao yuhao. All rights reserved.
//

import Foundation

// Base of the item properties
protocol TodoItemPresentable {
    var id: String? { get }
    var textValue: String? { get }
    var isDone: Bool? { get set } // set代表可變動
    var menuItems: [TodoMenuItemViewPresentable]? { get }
    
}
// New Item property
protocol TodoViewPresentable {
    var newTodoItem: String? { get }
}
// Menu properties
protocol TodoMenuItemViewPresentable {
    var title: String? { get set }
    var backColor: String? { get }
}

// Receive item data
protocol TodoViewDelegate:class {
    func onTodoAdded()
    func onTodoDelete(todoID: String)
    func onTodoDone(todoID: String)
}
// Item event
protocol TodoItemViewDelegate:class {
    func onItemSelected()
    func onRemoveSelected()
    func onDoneSelected()
}
// Menu event
protocol TodoMenuItemViewDelegate {
    func onMenuItemSelected()
}






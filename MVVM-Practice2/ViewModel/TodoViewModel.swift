//
//  TodoViewModel.swift
//  MVVM-Practice2
//
//  Created by liao yuhao on 2017/12/18.
//  Copyright © 2017年 liao yuhao. All rights reserved.
//

import Foundation

// 每個Item的物件
class TodoItemViewModel:TodoItemPresentable {
    var id: String? = "0"
    var textValue: String?
    var isDone: Bool? = false
    var menuItems: [TodoMenuItemViewPresentable]? = []
    weak var parent: TodoViewDelegate?
    
    init(id: String,textValue: String,parentViewModel: TodoViewDelegate) {
        self.id = id
        self.textValue = textValue
        self.parent = parentViewModel
        
        let removeMenuItem = RemoveMenuItemViewModel(parentViewModel: self) // send Item to MenuItem
        removeMenuItem.title = "Remove"
        removeMenuItem.backColor = "RemoveColor"
        let doneMenuItem = DoneMenuItemViewModel(parentViewModel: self)
        doneMenuItem.title = isDone! ? "Undone":"Done"
        doneMenuItem.backColor = "DoneColor"
        
        menuItems?.append(contentsOf: [removeMenuItem,doneMenuItem])
    }
}

extension TodoItemViewModel: TodoItemViewDelegate {

    /*!
     * @discuss On item selected received in view model on didSelectRowAt.
     * @params Void
     * @return Void
     */
    func onItemSelected() {
        if let id = self.id {
            print("Did select row at received for item with id = \(id)")
        }
    }
    
    func onRemoveSelected() {
        parent?.onTodoDelete(todoID: id!)

    }
    
    func onDoneSelected() {
        parent?.onTodoDone(todoID: id!)
    }

}


class TodoViewModel: TodoViewPresentable {
    
    weak var view: TodoView?  // View與ViewModel是綁定的(Binding)
    var newTodoItem: String?
    var items: [TodoItemPresentable] = []
    
    init(view: TodoView) {
        self.view = view
        let item1 = TodoItemViewModel(id: "1", textValue: "washing clothes", parentViewModel:self)
        let item2 = TodoItemViewModel(id: "2", textValue: "wash car", parentViewModel:self)
        let item3 = TodoItemViewModel(id: "3", textValue: "buy food", parentViewModel:self)
        items.append(contentsOf: [item1,item2,item3])
    }
    
}

extension TodoViewModel: TodoViewDelegate {

    func onTodoAdded() {
        
        guard let newValue = newTodoItem else {
            print("New value is empty")
            return
        }
        print("New todo item receive in view model: \(newValue)")
        
        let itemIndex = items.count + 1
        let newItem = TodoItemViewModel(id: "\(itemIndex)", textValue: newValue, parentViewModel: self)
        self.items.append(newItem)
        self.newTodoItem = ""
        self.view?.insertTodoItem()
    }
    
    func onTodoDelete(todoID: String) {
        guard let index = self.items.index(where: { $0.id! == todoID }) else {
            print("Item for the index dosen't exist")
            return
        }
        self.items.remove(at: index)
        
        self.view?.removeTodoItem(at: index)
    }
    
    func onTodoDone(todoID: String) {
        print("Todo item done with id = \(todoID)")
        guard let index = self.items.index(where: { $0.id! == todoID }) else {
            print("Item for the index dosen't exist")
            return
        }
        
        var todoItem = self.items[index]
        todoItem.isDone = !(todoItem.isDone)!
        
        if var doneMenuItem = todoItem.menuItems?.filter({ (todoMenuItem) -> Bool in
            todoMenuItem is DoneMenuItemViewModel
        }).first {
            doneMenuItem.title = todoItem.isDone! ? "Undone":"Done"
        }
        
        self.items.sort(by: {
            
            if !($0.isDone!) && !($1.isDone!) {
                return $0.id! < $1.id!
            }
            if $0.isDone! && $1.isDone! {
                return $0.id! < $1.id!
            }
            return !($0.isDone!) && $1.isDone!
        })
        
        
        self.view?.reloadItems()
    }
    
}

class TodoMenuItemViewModel: TodoMenuItemViewPresentable, TodoMenuItemViewDelegate {
    var title: String?
    var backColor: String?
    weak var parent: TodoItemViewDelegate?
    
    init(parentViewModel:TodoItemViewDelegate) {
        self.parent = parentViewModel
    }
    func onMenuItemSelected() {
        // Base class dosen't require an implementation
    }
}

class RemoveMenuItemViewModel: TodoMenuItemViewModel {
    override func onMenuItemSelected() {
        print("Remove menu item selected")
        parent?.onRemoveSelected()
    }
}

class DoneMenuItemViewModel: TodoMenuItemViewModel {
    override func onMenuItemSelected() {
        print("Done menu item selected")
        parent?.onDoneSelected()
    }
}





//
//  ViewController.swift
//  MVVM-Practice2
//
//  Created by liao yuhao on 2017/12/18.
//  Copyright © 2017年 liao yuhao. All rights reserved.
//

import UIKit

// 指派給View(ViewController)，要求加入一個Item（限制為class）
// View的更新
protocol TodoView: class {
    func insertTodoItem() -> ()
    func removeTodoItem(at index: Int) -> ()
    func updateTodoItem(at index: Int) -> ()
    func reloadItems() -> ()
}

class ViewController: UIViewController {

    @IBOutlet weak var tableViewItems: UITableView!
    @IBOutlet weak var textFieldNewItem: UITextField!
    
    let identifier = "todoCellId"
    var viewModel: TodoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        let nib = UINib(nibName: "TodoItemCell", bundle: nil)
        tableViewItems.register(nib, forCellReuseIdentifier: identifier)
        
        viewModel = TodoViewModel(view: self)
    }

    @IBAction func onAddItem(_ sender: Any) {
        guard let newTodoValue = textFieldNewItem.text,
            !newTodoValue.isEmpty,
            let itemViewModel = viewModel else {
            print("No todo value entered.")
            return
        }
        itemViewModel.newTodoItem = newTodoValue
        
        DispatchQueue.global(qos: .background).async {
            itemViewModel.onTodoAdded()
        }
        
    }
    
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TodoItemCell,
            let itemViewModel = viewModel?.items[indexPath.row] else {
            fatalError("Could not fetch the cell")
        }
        cell.configure(withViewModel: itemViewModel)
        
        return cell
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let itemViewModel = viewModel?.items[indexPath.row] as? TodoItemViewDelegate else {
            print("Couldn't fetch viewModel.")
            return
        }
        itemViewModel.onItemSelected()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let itemViewModel = viewModel?.items[indexPath.row]
        
        var menuActions: [UIContextualAction] = []
        
        _ = itemViewModel?.menuItems?.map({ menuItem in
            let menuAction = UIContextualAction(style: .normal, title:menuItem.title ) { (action, sourceView, succes:(Bool) -> (Void)) in
            
                if let delegate = menuItem as? TodoMenuItemViewDelegate {
                    DispatchQueue.global(qos: .background).async {
                        delegate.onMenuItemSelected()
                    }
                }
                succes(true)
            }
            menuAction.backgroundColor = UIColor(named: menuItem.backColor!)
            menuActions.append(menuAction)
        })
        
        return UISwipeActionsConfiguration(actions: menuActions)
    }
    

}

extension ViewController: TodoView {
    
    func insertTodoItem() {
        
        guard let items = viewModel?.items else {
            return
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.textFieldNewItem.text = self.viewModel?.newTodoItem
            
            self.tableViewItems.beginUpdates()
            self.tableViewItems.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
            self.tableViewItems.endUpdates()
        })
    }
    
    func removeTodoItem(at index: Int) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableViewItems.beginUpdates()
            self.tableViewItems.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.tableViewItems.endUpdates()
        })
    }
    
    func updateTodoItem(at index: Int) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableViewItems.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        })
    }
    
    func reloadItems() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableViewItems.reloadData()
        })
    }
    

}


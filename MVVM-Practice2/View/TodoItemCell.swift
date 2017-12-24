//
//  TodoItemCell.swift
//  MVVM-Practice2
//
//  Created by liao yuhao on 2017/12/18.
//  Copyright © 2017年 liao yuhao. All rights reserved.
//

import UIKit

class TodoItemCell: UITableViewCell {

    @IBOutlet weak var txtIndex: UILabel!
    @IBOutlet weak var txtTodoItem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*!
     * @discuss This fuction is to configure your cell using view model.
     * @params viewModel
     * @return Void
    */
    func configure(withViewModel viewModel:TodoItemPresentable) -> Void {
        txtIndex.text = viewModel.id!
        
        let attributeString: NSMutableAttributedString =
            NSMutableAttributedString(string: viewModel.textValue!)
        
        if viewModel.isDone! {
            
            let range = NSMakeRange(0, attributeString.length)
            
            attributeString.addAttribute(.strikethroughColor,
                                         value: UIColor.lightGray,
                                         range: range)
            attributeString.addAttribute(.strikethroughStyle,
                                         value: 1,
                                         range: range)
            attributeString.addAttribute(.foregroundColor,
                                         value: UIColor.lightGray,
                                         range: range)
            
        }
        
        txtTodoItem.attributedText = attributeString
    }
    
}

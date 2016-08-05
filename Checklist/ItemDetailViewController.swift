//
//  ItemDetailViewController.swift
//  Checklist
//
//  Created by Vyacheslav Nagornyak on 7/31/16.
//  Copyright © 2016 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
	func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
	func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
	
	// MARK: - Outlets
	
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var doneBarButton: UIBarButtonItem!
	
	// MARK: - Variables
	
	weak var delegate: ItemDetailViewControllerDelegate?
	var itemToEdit: ChecklistItem?
	
	// MARK: - View
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let item = itemToEdit {
			title = "Edit Item"
			textField.text = item.text
			doneBarButton.isEnabled = true
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		textField.becomeFirstResponder()
	}
	
	// MARK: - Table View
	
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}
	
	// MARK: Text Field
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let oldText: NSString = textField.text!
		let newText: NSString = oldText.replacingCharacters(in: range, with: string)
		
		doneBarButton.isEnabled = newText.length > 0
		return true
	}
	
	// MARK: - Actions
	
	@IBAction func cancel() {
		textField.resignFirstResponder()
		delegate?.itemDetailViewControllerDidCancel(self)
	}
	
	@IBAction func done() {
		textField.resignFirstResponder()
		if let item = itemToEdit {
			item.text = textField.text!
			item.checked = false
			delegate?.itemDetailViewController(self, didFinishEditingItem: item)
		} else {
			delegate?.itemDetailViewController(self, didFinishAddingItem: ChecklistItem(textField.text!, checked: false))
		}
	}
}

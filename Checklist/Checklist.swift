//
//  Checklist.swift
//  Checklist
//
//  Created by Vyacheslav Nagornyak on 8/1/16.
//  Copyright © 2016 Vyacheslav Nagornyak. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
	
	// MARK: - Variables
	
	var title = ""
	var items = [ChecklistItem]()
	
	// MARK: - Init
	
	init(_ name: String) {
		title = name
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		title = aDecoder.decodeObject(forKey: "Title") as! String
		items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
		super.init()
	}
	
	// MARK: - NSCoding
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(title, forKey: "Title")
		aCoder.encode(items, forKey: "Items")
	}
	
	func countUncheckedItems() -> Int {
		return items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1) }
		
	}
}

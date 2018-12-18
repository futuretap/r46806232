//
//  MasterViewController.swift
//  TableUpdateDemo
//
//  Created by Ortwin Gentz on 17.12.18.
//  Copyright © 2018 FutureTap GmbH. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	var objects = [Any]()
	var selectedIndexSet = IndexSet()
	var rowHeights = [IndexPath: CGFloat]()
	
	@objc
	@IBAction func insertNewObject(_ sender: Any) {
		let indexPath = IndexPath(row: objects.count, section: 0)
		objects.append(NSDate())
		tableView.insertRows(at: [indexPath], with: .automatic)
		self.view.setNeedsLayout()
	}
	
	// MARK: - Table View
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let height = rowHeights[indexPath] {
			return height
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell") as! MyTableViewCell
		populate(cell: cell, indexPath: indexPath)
		let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
		rowHeights[indexPath] = height
		return height
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
		
		populate(cell: cell, indexPath: indexPath)
		return cell
	}
	
	func populate(cell: MyTableViewCell, indexPath: IndexPath) {
		let object = objects[indexPath.row] as! NSDate
		cell.label!.text = "\(selectedIndexSet.contains(indexPath.row) ? "Selected:" : "")\(selectedIndexSet.contains(indexPath.row) && indexPath.row % 2 == 1 ? "\n\n" : "\n")\(object.description)"
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			objects.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		rowHeights.removeValue(forKey: indexPath)
		tableView.beginUpdates()
		
		if self.selectedIndexSet.contains(indexPath.row) {
			self.selectedIndexSet.remove(indexPath.row)
		} else {
			self.selectedIndexSet.insert(indexPath.row)
		}
		tableView.reloadRows(at: [indexPath], with: .fade)

		tableView.endUpdates()
	}
}

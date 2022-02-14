//
//  UITableView.swift
//  Alamofire
//
//  Created by NamNH on 02/10/2021.
//

import UIKit

public extension UITableView {
	func set(delegateAndDataSource: UITableViewDataSource & UITableViewDelegate) {
		delegate = delegateAndDataSource
		dataSource = delegateAndDataSource
	}
	
	func registerNibCellFor<T: UITableViewCell>(type: T.Type, bundle: Bundle) {
		register(UINib(nibName: type.name, bundle: bundle), forCellReuseIdentifier: type.name)
	}
	
	func registerClassCellFor<T: UITableViewCell>(type: T.Type) {
		register(type, forCellReuseIdentifier: type.name)
	}
	
	func registerNibHeaderFooterFor<T: UIView>(type: T.Type, bundle: Bundle) {
		register(UINib(nibName: type.name, bundle: bundle), forHeaderFooterViewReuseIdentifier: type.name)
	}
	
	func registerClassHeaderFooterFor<T: UIView>(type: T.Type) {
		register(type, forHeaderFooterViewReuseIdentifier: type.name)
	}
	
	func reusableCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath? = nil) -> T? {
		if let indexPath = indexPath {
			return self.dequeueReusableCell(withIdentifier: type.name, for: indexPath) as? T
		}
		return self.dequeueReusableCell(withIdentifier: type.name) as? T
	}
	
	func cell<T: UITableViewCell>(type: T.Type, section: Int, row: Int) -> T? {
		guard let indexPath = validIndexPath(section: section, row: row) else { return nil }
		return self.cellForRow(at: indexPath) as? T
	}
	
	func reusableHeaderFooterFor<T: UIView>(type: T.Type) -> T? {
		return self.dequeueReusableHeaderFooterView(withIdentifier: type.name) as? T
	}
	
	func tableHeader<T: UIView>(type: T.Type) -> T? {
		return tableHeaderView as? T
	}
	
	func tableFooter<T: UIView>(type: T.Type) -> T? {
		return tableFooterView as? T
	}
}

// MARK: - Actions extension
public extension UITableView {
	func scrollToTop(animated: Bool = true) {
		setContentOffset(.zero, animated: animated)
	}
	
	func scrollToBottom(animated: Bool = true) {
		guard numberOfSections > 0 else { return }
		let lastRowNumber = numberOfRows(inSection: numberOfSections - 1)
		guard lastRowNumber > 0 else { return }
		let indexPath = IndexPath(row: lastRowNumber - 1, section: numberOfSections - 1)
		scrollToRow(at: indexPath, at: .top, animated: animated)
	}
	
	func reloadCellAt(section: Int = 0, row: Int, animation: RowAnimation = .fade) {
		if let indexPath = validIndexPath(section: section, row: row) {
			reloadRows(at: [indexPath], with: animation)
		}
	}
	
	func reloadSectionAt(index: Int, animation: RowAnimation = .fade) {
		reloadSections(IndexSet(integer: index), with: animation)
	}
}

// MARK: - Private function helper
private extension UITableView {
	func validIndexPath(section: Int, row: Int) -> IndexPath? {
		guard section >= 0 && row >= 0 else { return nil }
		let rowCount = numberOfRows(inSection: section)
		guard rowCount > 0 && row < rowCount else { return nil }
		return IndexPath(row: row, section: section)
	}
}

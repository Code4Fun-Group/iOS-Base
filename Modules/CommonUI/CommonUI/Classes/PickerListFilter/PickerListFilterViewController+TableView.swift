//
//  PickerListFilterViewController+TableView.swift
//  CommonUI
//
//  Created by NamNH on 29/11/2021.
//

import UIKit

extension PickerListFilterViewController {
	func setupTableView(_ tableView: UITableView) {
		tableView.backgroundColor = .clear
		tableView.set(delegateAndDataSource: self)
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		
		let bundle = Bundle.commonUIBundle(for: PickerListRadioViewCell.self)
		tableView.registerNibCellFor(type: PickerListRadioViewCell.self, bundle: bundle)
	}
}

// MARK: - UITableViewDataSource
extension PickerListFilterViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filterItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.reusableCell(type: PickerListRadioViewCell.self, indexPath: indexPath) else { return UITableViewCell() }
		cell.configure(item: filterItems[indexPath.row])
		return cell
	}
}

// MARK: - UITableViewDelegate
extension PickerListFilterViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.pickerDidSelectAt(item: filterItems[indexPath.row])
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - Interactor
private extension PickerListFilterViewController {
	func didSelectContainer(with containterId: String?) {
	}
}

//
//  PickerListFilterViewController.swift
//  Pods
//
//  Created by NamNH on 29/11/2021.
//

import UIKit

private enum Constants {
	static let containerCornerRadius: CGFloat = 20.0
}

class PickerListFilterViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet private weak var screenTitleLabel: CommonLabel!
	@IBOutlet private weak var searchTextField: CommonTextField!
	@IBOutlet private weak var tableView: UITableView!
	
	// MARK: - Variables
	var interactor: IPickerListFilterInteractor!
	var items: [IPickerListItem] = []
	weak var delegate: PickerListFilterDelegate?
	
	private(set) var filterItems: [IPickerListItem] = [] {
		didSet {
			tableView.reloadData()
			tableView.layoutIfNeeded()
		}
	}
	private var cellType: PickerListCellType?
	
	// MARK: Lifecycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		filter(keyword: nil)
	}
}

// MARK: - Setup UI
private extension PickerListFilterViewController {
	func setupUI() {
		view.backgroundColor = commonUIConfig.colorSet.gray50
		view.layer.cornerRadius = Constants.containerCornerRadius
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		screenTitleLabel.textStyle = .header5
		screenTitleLabel.textColorStyle = .header
		
		searchTextField.iconTextField.image = commonUIConfig.imageSet.searchIcon
		searchTextField.containerView.backgroundColor = commonUIConfig.colorSet.white
		searchTextField.containerView.layer.borderColor = commonUIConfig.colorSet.white.cgColor
		searchTextField.placeholderLabel.text = "Search".localized
		searchTextField.buttonType = .clear
		searchTextField.delegate = self
		
		setupTableView(tableView)
	}
}

// MARK: - Actions
private extension PickerListFilterViewController {
}

// MARK: - Interactor
private extension PickerListFilterViewController {
	func filter(keyword: String?) {
		interactor.filter(request: FilterPickerListUseCase.Request(keyword: keyword))
	}
}

// MARK: - IPickerListFilterViewController
extension PickerListFilterViewController: IPickerListFilterViewController {
	func showFilter(viewModel: FilterPickerListUseCase.ViewModel) {
		screenTitleLabel.text = viewModel.title
		filterItems = viewModel.items
		cellType = viewModel.cellType
	}
}

// MARK: - ICommonTextFieldDelegate
extension PickerListFilterViewController: ICommonTextFieldDelegate {
	func didClearTextChange() {
		
	}
	
	func textFieldDidBeginEditing(_ commonTextField: CommonTextField) {
		
	}
	
	func didTextChange(commonTextField: CommonTextField, text: String) {
		filter(keyword: text)
	}
}

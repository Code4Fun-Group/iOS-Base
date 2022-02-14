import Foundation

private enum Constants {
	static let cornerRadius: CGFloat = 20
	static let tableviewHeight: CGFloat = 5
	static let scrollToItemDispatchTime: Double = 0.01
	static let tableviewCellHeight: CGFloat = 48
}

protocol IPickerListViewController: AnyObject {
	func showContent(viewModel: GetContentPickerListUseCase.ViewModel)
}

class PickerListViewController: UIViewController {
	var interactor: IPickerListInteractor!
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewBottomPaddingConstraint: NSLayoutConstraint!
	
	var items: [IPickerListItem] = []
	var cellType: PickerListCellType?
	weak var delegate: PickerListDelegate?
	
	var pageSheetStyle: PageSheetStyle?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		getContent()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateTableViewHeightAnchor()
	}
	
	func setupUI() {
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		view.layer.cornerRadius = Constants.cornerRadius
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		
		let bundle = Bundle.commonUIBundle(for: PickerListViewController.self)
		tableView.registerNibCellFor(type: PickerListRadioViewCell.self, bundle: bundle)
		tableView.registerNibCellFor(type: PickerListImageRadioViewCell.self, bundle: bundle)
	}
	
	func updateTableViewHeightAnchor() {
		if pageSheetStyle == .dialogue {
			tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height + Constants.tableviewHeight).isActive = true
			let bottomPadding = UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
			tableViewBottomPaddingConstraint.constant = -bottomPadding
		}
	}
}

// MARK: - Interactor
extension PickerListViewController {
	func getContent() {
		interactor.getContent(request: GetContentPickerListUseCase.Request())
	}
}

// MARK: - IPickerListViewController

extension PickerListViewController: IPickerListViewController {
	
	func showContent(viewModel: GetContentPickerListUseCase.ViewModel) {
		items = viewModel.items
		cellType = viewModel.cellType
		tableView.reloadData()
		tableView.layoutIfNeeded()
		setScrollToRow()
	}
	
	func setScrollToRow() {
		switch cellType {
		case .picker:
			if let highlightSelectRow = getHighlightSelectRow() {
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.scrollToItemDispatchTime) {
					self.tableView.scrollToRow(at: highlightSelectRow, at: .middle, animated: false)
				}
			}
		default:
			break
		}
	}
	
	func getHighlightSelectRow() -> IndexPath? {
		for index in 0..<items.count where items[index].isHighlighted {
			return IndexPath(row: index, section: 0)
		}
		return nil
	}
}

// MARK: - IPageSheetPresentationStyle

extension PickerListViewController: IPageSheetPresentationStyle {
	
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PickerListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = items[indexPath.row]
		guard let cellType = cellType else { return UITableViewCell() }
		
		switch cellType {
		case .picker:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.cellIdentifier, for: indexPath) as? PickerListRadioViewCell else { return UITableViewCell() }
			cell.configure(item: item)
			return cell
		case .radio:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.cellIdentifier, for: indexPath) as? PickerListRadioViewCell else { return UITableViewCell() }
			cell.configure(item: item)
			return cell
		case .imageRadio:
			guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.cellIdentifier, for: indexPath) as? PickerListImageRadioViewCell else { return UITableViewCell() }
			cell.configure(item: item)
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.tableviewCellHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.pickerDidSelectAt(index: indexPath.row, item: items[indexPath.row])
		dismiss(animated: true, completion: nil)
	}
}

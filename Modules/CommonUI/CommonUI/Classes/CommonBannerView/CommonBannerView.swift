//
//  CommonBannerView.swift
//  CommonUI
//
//  Created by Nguyễn Nam on 7/30/21.
//

import UIKit

private enum Constants {
	static let cornerRadius: CGFloat = 8.0
	static let infiniteBaseSize = 1000
	static let horizontalSpacing: CGFloat = 24.0
	static let cellCornerRadius: CGFloat = 8.0
	static let pageControlHeight: CGFloat = 15.0
	static let pageControlMarginLeftRight: CGFloat = 8.0
	static let pageControlMarginBottom: CGFloat = 24.0
}

public protocol CommonBannerViewDataSource: NSObjectProtocol {
	func numberOfItems(in bannerView: CommonBannerView) -> Int
	func bannerView(_ bannerView: CommonBannerView, cellForItemAt index: Int) -> CommonBannerCell
}

@objc public protocol CommonBannerViewDelegate: NSObjectProtocol {
	@objc optional func bannerView(_ bannerView: CommonBannerView, didSelectItemAt index: Int)
}

public class CommonBannerView: UIView {

	// MARK: Delegate
	public weak var dataSource: CommonBannerViewDataSource?
	public weak var delegate: CommonBannerViewDelegate?

	// MARK: Layout
	private lazy var containerView: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.layer.cornerRadius = Constants.cornerRadius
		containerView.backgroundColor = .clear
		containerView.clipsToBounds = true
		return containerView
	}()

	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: PagingCollectionViewLayout())
		collectionView.backgroundColor = .clear
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.delegate = self
		collectionView.dataSource = self
		return collectionView
	}()

	private lazy var pageControl: CustomCurrentDotPageControl = {
		let pageControl = CustomCurrentDotPageControl()
		pageControl.translatesAutoresizingMaskIntoConstraints = false
		pageControl.currentPageIndicatorTintColor = commonUIConfig.colorSet.white
		return pageControl
	}()

	// MARK: - Private Variables
	public var isTracking: Bool {
		return self.collectionView.isTracking
	}
	public var isInfinite: Bool = false
	public var automaticSlidingInterval: CGFloat = 0.0

	// MARK: - Private Variables
	private var autoScrollTimer: Timer = Timer()
	private var numberOfItems: Int = 0
	private var dequeingSection = 0

	override init(frame: CGRect) {
		super.init(frame: frame)
		loadView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		loadView()
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
		setupUI()
		setAccessibilityIdentifier()
	}
}

// MARK: - Public
public extension CommonBannerView {
	func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
		collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
	}

	func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
		collectionView.register(nib, forCellWithReuseIdentifier: identifier)
	}

	func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> CommonBannerCell? {
		let indexPath = IndexPath(item: index, section: self.dequeingSection)
		let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
		guard cell.isKind(of: CommonBannerCell.self) else {
			fatalError("Cell class must be subclass of CommonBannerCell")
		}
		return cell as? CommonBannerCell
	}

	func reloadData() {
		numberOfItems = dataSource?.numberOfItems(in: self) ?? 0
		setupBannerPageControl()
		collectionView.isScrollEnabled = (numberOfItems > 1)
		collectionView.reloadData()
		scrollToItemCenterHorizontally()
		startAutoScrollBanner()
	}
}

// MARK: - Private
private extension CommonBannerView {
	func loadView() {
		// MARK: ContainerView
		addSubview(containerView)
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: topAnchor),
			containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])

		// MARK: CollectionView
		containerView.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
		])

		// MARK: PageControl
		containerView.addSubview(pageControl)
		NSLayoutConstraint.activate([
			pageControl.heightAnchor.constraint(equalToConstant: Constants.pageControlHeight),
			pageControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.pageControlMarginLeftRight),
			pageControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.pageControlMarginLeftRight),
			pageControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.pageControlMarginBottom)
		])
	}

	func setAccessibilityIdentifier() {
	}

	func setupUI() {
		setupBannerCollectionView()
		setupBannerCollectionViewLayout()
	}

	func setupBannerCollectionView() {
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.decelerationRate = .fast
		collectionView.dataSource = self
		collectionView.delegate = self
	}

	func setupBannerCollectionViewLayout() {
		let layout = PagingCollectionViewLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets.zero
		layout.minimumLineSpacing = 0
		collectionView.collectionViewLayout = layout
	}

	func setupBannerPageControl() {
		pageControl.isHidden = (numberOfItems <= 1)
		pageControl.numberOfPages = numberOfItems
	}

	func scrollToItemCenterHorizontally() {
		if numberOfItems > 0 && isInfinite {
			let indexRow = ((numberOfItems * Constants.infiniteBaseSize) / 2)
			let midIndexPath = IndexPath(row: indexRow, section: 0)
			DispatchQueue.main.async {
				self.collectionView.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
				self.pageControl.currentPage = midIndexPath.row % self.numberOfItems
			}
		}
	}
}

extension CommonBannerView: UICollectionViewDataSource {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return isInfinite ? (numberOfItems * Constants.infiniteBaseSize) : numberOfItems
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let index = indexPath.row % numberOfItems
		dequeingSection = indexPath.section
		guard let cell = dataSource?.bannerView(self, cellForItemAt: index) else { return CommonBannerCell() }
		return cell
	}
}

extension CommonBannerView: UICollectionViewDelegate {
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.bannerView?(self, didSelectItemAt: indexPath.row % numberOfItems)
	}
}

extension CommonBannerView: UICollectionViewDelegateFlowLayout {
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}
}

private extension CommonBannerView {
	func startAutoScrollBanner() {
		guard automaticSlidingInterval > 0 else {
			return
		}
		autoScrollTimer = Timer.scheduledTimer(timeInterval: TimeInterval(automaticSlidingInterval), target: self, selector: #selector(flipNext(sender:)), userInfo: nil, repeats: true)
	}

	@objc
	func flipNext(sender: Timer?) {
		guard numberOfItems > 1, !isTracking else {
			return
		}
		guard let visibleCell = collectionView.visibleCells.first,
			  let indexPath = collectionView.indexPath(for: visibleCell)
		else {
			return
		}
		let infiniteSize = numberOfItems * Constants.infiniteBaseSize
		let nextIndex = indexPath.row + 1
		let nextIndexPath = IndexPath(row: nextIndex, section: indexPath.section)
		
		guard nextIndex > 0, numberOfItems > 0 else { return }
		if nextIndex < infiniteSize {
			collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
		} else if nextIndex >= infiniteSize {
			collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
		}
	}

	func stopAutoScrollBanner() {
		if autoScrollTimer.isValid {
			autoScrollTimer.invalidate()
		}
	}
}

// MARK: - UIScrollViewDelegate
extension CommonBannerView: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		setCurrentPage()
	}

	public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		startAutoScrollBanner()
	}

	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		stopAutoScrollBanner()
	}

	func setCurrentPage() {
		var visibleRect = CGRect()
		visibleRect.origin = collectionView.contentOffset
		visibleRect.size = collectionView.bounds.size
		let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
		guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }

		if numberOfItems != 0 {
			pageControl.currentPage = indexPath.row % numberOfItems
		} else {
			pageControl.currentPage = indexPath.row
		}
	}
}

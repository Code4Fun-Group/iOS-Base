//
//  UICollectionView.swift
//  Alamofire
//
//  Created by NamNH on 02/10/2021.
//

import UIKit

public extension UICollectionView {
	func set(delegateAndDataSource: UICollectionViewDataSource & UICollectionViewDelegate) {
		delegate = delegateAndDataSource
		dataSource = delegateAndDataSource
	}
	
	func registerNibCellFor<T: UICollectionViewCell>(type: T.Type, bundle: Bundle) {
		register(UINib(nibName: type.name, bundle: bundle), forCellWithReuseIdentifier: type.name)
	}
	
	func registerClassCellFor<T: UICollectionViewCell>(type: T.Type) {
		register(type, forCellWithReuseIdentifier: type.name)
	}
	
	func registerNibSupplementaryViewFor<T: UIView>(type: T.Type, ofKind kind: String, bundle: Bundle) {
		register(UINib(nibName: type.name, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: type.name)
	}
	
	func registerClassSupplementaryViewFor<T: UIView>(type: T.Type, ofKind kind: String) {
		register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.name)
	}
	
	func reusableCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
		return self.dequeueReusableCell(withReuseIdentifier: type.name, for: indexPath) as? T
	}
	
	func cell<T: UICollectionViewCell>(type: T.Type, section: Int, item: Int) -> T? {
		guard let indexPath = validIndexPath(section: section, item: item) else { return nil }
		return self.cellForItem(at: indexPath) as? T
	}
	
	func reusableSupplementaryViewFor<T: UIView>(type: T.Type, ofKind kind: String, indexPath: IndexPath) -> T? {
		return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.name, for: indexPath) as? T
	}
}

// MARK: - Actions extension
public extension UICollectionView {
	func scrollToTop(animated: Bool = true) {
		setContentOffset(.zero, animated: animated)
	}
	
	func scrollToBottom(animated: Bool = true) {
		guard numberOfSections > 0 else { return }
		let lastRowNumber = numberOfItems(inSection: numberOfSections - 1)
		guard lastRowNumber > 0 else { return }
		let indexPath = IndexPath(item: lastRowNumber - 1, section: numberOfSections - 1)
		scrollToItem(at: indexPath, at: .top, animated: animated)
	}
	
	func reloadCellAt(section: Int = 0, item: Int) {
		if let indexPath = validIndexPath(section: section, item: item) {
			reloadItems(at: [indexPath])
		}
	}
	
	func reloadSectionAt(index: Int) {
		reloadSections(IndexSet(integer: index))
	}
}

// MARK: - Private functions helper
private extension UICollectionView {
	func validIndexPath(section: Int, item: Int) -> IndexPath? {
		guard section >= 0 && item >= 0 else { return nil }
		let itemCount = numberOfItems(inSection: section)
		guard itemCount > 0 && item < itemCount else { return nil }
		return IndexPath(item: item, section: section)
	}
}

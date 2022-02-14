//
//  UIImageViewExtension.swift
//  CommonUI
//
//  Created by NamNH on 06/12/2021.
//

import UIKit
import Kingfisher

private enum ImageSize {
	case small
	case medium
	case large
	case original
	
	init(from screenScale: CGFloat) {
		switch screenScale {
		case 1.0:
			self = .small
		case 2.0:
			self = .medium
		case 3.0:
			self = .large
		default:
			self = .original
		}
	}
}

extension UIImageView {
	public func load(url: URL, placeholder: UIImage? = nil, isResizingModeEnabled: Bool = false) {
		var imageURL = url
		if isResizingModeEnabled {
			let imageSize = ImageSize(from: UIScreen.main.scale)
			imageURL = url
		}
		
		kf.setImage(with: imageURL, placeholder: placeholder, options: nil) { [weak self] loadImageResult in
			if isResizingModeEnabled {
				self?.kf.setImage(with: url, placeholder: placeholder, options: nil) { [weak self] originalImageResult in
					if case .failure = originalImageResult {
						self?.setImageToDefaultPlaceholder()
					}
				}
			} else {
				if case .failure = loadImageResult {
					self?.setImageToDefaultPlaceholder()
				}
			}
		}
	}
	
	public func loads(url: URL, placeholder: UIImage? = nil, complete: @escaping () -> Void) {
		kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil) { _ in
			complete()
		}
	}
	
	public func loadWithSaturationAdjustment(url: URL, byValue: CGFloat) {
		if byValue < 1 {
			kf.setImage(with: url, options: [.processor(BlackWhiteProcessor())])
			return
		} else {
			load(url: url)
		}
	}
	
	public func loads(url: URL, complete: @escaping (Result<RetrieveImageResult, KingfisherError> ) -> Void) {
		kf.setImage(with: url, placeholder: nil, options: nil) { [weak self] result in
			if case .failure = result {
				self?.setImageToDefaultPlaceholder()
			}
			
			complete(result)
		}
	}
	
	public func loadDefaultPlaceholder() {
		setImageToDefaultPlaceholder()
	}
	
	private func setImageToDefaultPlaceholder() {
		backgroundColor = commonUIConfig.colorSet.gray75
	}
}

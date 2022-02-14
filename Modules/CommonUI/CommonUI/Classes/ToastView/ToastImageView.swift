//
//  ToastImageView.swift
//  CommonUI
//
//  Created by NamNH on 04/10/2021.
//

import UIKit
import Common

private enum Constants {
	static let containerViewCornerRadius: CGFloat = 8
	static let containerViewSpacing: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: -24.0)
	static let titleLabelSpacing: UIEdgeInsets = UIEdgeInsets(top: 12.0, left: 4.0, bottom: -12.0, right: -12.0)
	static let imageViewSpacing: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 8.0)
	static let spacing: CGFloat = 10.0
	static let borderWidth: CGFloat = 1.0
}

public class ToastImageStyle {
	var imageType: ToastImageType = .fit
	var textColor: UIColor = commonUIConfig.colorSet.white
	var backgroundColor: UIColor = commonUIConfig.colorSet.black
	var borderColor: UIColor = commonUIConfig.colorSet.black
}

public extension ToastImageStyle {
	convenience init(imageType: ToastImageType,
					 textColor: UIColor,
					 backgroundColor: UIColor,
					 borderColor: UIColor) {
		self.init()
		self.imageType = imageType
		self.textColor = textColor
		self.backgroundColor = backgroundColor
		self.borderColor = borderColor
	}
}

public enum ToastImageType {
	case fill
	case fit
}

open class ToastImageView: UIView {
	public lazy var style: ToastImageStyle = ToastImageStyle() {
		didSet {
			containerView.layer.borderColor = style.borderColor.cgColor
			containerView.backgroundColor = style.backgroundColor
			titleLabel.textColor = style.textColor
			switch style.imageType {
			case .fit:
				NSLayoutConstraint.activate([
					containerView.topAnchor.constraint(equalTo: topAnchor),
					containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
					containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
					containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.containerViewSpacing.left)
				])
			case .fill:
				NSLayoutConstraint.activate([
					containerView.topAnchor.constraint(equalTo: topAnchor),
					containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
					containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerViewSpacing.left),
					containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.containerViewSpacing.right)
				])
			}
		}
	}
	
	public lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	public lazy var titleLabel: CommonLabel = {
		let titleLabel = CommonLabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textStyle = (SystemInfo.deviceType == .iPhoneSE) ? .textS : .textM
		titleLabel.textColor = commonUIConfig.colorSet.white
		titleLabel.numberOfLines = 0
		titleLabel.lineBreakMode = .byTruncatingTail
		return titleLabel
	}()
	
	lazy var containerView: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.layer.cornerRadius = Constants.containerViewCornerRadius
		containerView.layer.borderWidth = Constants.borderWidth
		containerView.layer.borderColor = style.borderColor.cgColor
		containerView.backgroundColor = style.backgroundColor
		return containerView
	}()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		loadView()
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		loadView()
	}
}

// MARK: - Private

private extension ToastImageView {
	func loadView() {
		addSubview(containerView)
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: topAnchor),
			containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
			containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
			containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.containerViewSpacing.left)
		])
		
		containerView.addSubview(titleLabel)
		containerView.addSubview(imageView)
		
		NSLayoutConstraint.activate([
			imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
			imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.imageViewSpacing.left),
			imageView.widthAnchor.constraint(equalToConstant: ToastStyle().imageSize.width),
			imageView.heightAnchor.constraint(equalToConstant: ToastStyle().imageSize.height)
		])
		
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.titleLabelSpacing.left),
			titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.titleLabelSpacing.right),
			titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.titleLabelSpacing.top),
			titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Constants.titleLabelSpacing.bottom)
		])
	}
}

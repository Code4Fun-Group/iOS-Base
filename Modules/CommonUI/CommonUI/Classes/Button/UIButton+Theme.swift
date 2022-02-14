import UIKit

public extension UIButton {
	func setButtonStyle(style: ButtonStyle) {
		setTitleColor(style.textColor, for: .normal)
		titleLabel?.font = style.textStyle.font
		layer.cornerRadius = style.cornerRadius
		layer.borderColor = style.borderColor.cgColor
		layer.borderWidth = 1
		backgroundColor = style.backgroundColor
	}
}

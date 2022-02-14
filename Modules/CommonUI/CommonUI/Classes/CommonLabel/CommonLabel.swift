import UIKit

private enum Constants {
	static let fadeTransitionDuration: CFTimeInterval = 0.2
}

public class CommonLabel: UILabel {
	public var fontStyle: FontStyle = .body1 { didSet { setupUI() } }
	public var colorStyle = ColorStyle.normal { didSet { setupUI() } }
	
	public var textStyle = TextStyle.textM { didSet { apply(textStyle: textStyle) } }
	public var textColorStyle = ColorStyle.primaryText { didSet { apply(textColorStyle: textColorStyle) } }
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	func setupUI() {
		apply(fontSet: commonUIConfig.fontSet)
	}
	
	func apply(fontSet: IFontSet) {
		textColor = commonUIConfig.colorSet.color(of: colorStyle)
		font = fontSet.font(style: fontStyle)
	}
	
	func apply(textColorStyle: ColorStyle) {
		textColor = commonUIConfig.colorSet.color(of: textColorStyle)
	}
	
	func apply(textStyle: ITextStyle) {
		font = textStyle.font
	}
}

// MARK: - Transition

extension CommonLabel {
	public func fadeTransition() {
		let animation = CATransition()
		animation.timingFunction = CAMediaTimingFunction(name:
			CAMediaTimingFunctionName.easeInEaseOut)
		animation.type = CATransitionType.fade
		animation.duration = Constants.fadeTransitionDuration
		layer.add(animation, forKey: CATransitionType.fade.rawValue)
	}
}

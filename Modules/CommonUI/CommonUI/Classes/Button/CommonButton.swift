import UIKit
import CommonUI

private enum Constants {
	static let shadowBorderWidth: CGFloat = 6
	static let shadowRadius: CGFloat = 4
	static let shadowOffset = CGSize(width: 0, height: 2)
	static let animationOpacity: CGFloat = 0.3
	static let animationDuration: Double = 0.1
	static let animationKeyPath = "backgroundColor"
	static let textEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
}

public class CommonButton: UIControl {
	public var textLabel = CommonLabel()
	public var contentView = UIView()
	public var shadowView = UIView()
	public var style = ButtonStyle.default { didSet { updateAppearance() } }
	public var cornerRadius: CGFloat?
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}

	// MARK: - View Lifecycle
		
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		switch style {
		case .default, .primary:
			contentView.layer.cornerRadius = style.cornerRadius
		case .border:
			contentView.layer.cornerRadius = style.cornerRadius
		default:
			contentView.layer.cornerRadius = contentView.frame.height / 2
			shadowView.layer.cornerRadius = shadowView.frame.height / 2
		}
	}
	
	// MARK: - Override
	
	public override var isHighlighted: Bool {
		get { super.isHighlighted }
		set {
			guard self.isHighlighted != newValue else { return }
			super.isHighlighted = newValue
			highlightedOrSelected(newValue: newValue)
		}
	}
	
	public override var isSelected: Bool {
		get { super.isSelected }
		set {
			super.isSelected = newValue
			highlightedOrSelected(newValue: newValue)
		}
	}
	
	func animationColorChange(fromColor: UIColor, toColor: UIColor) {
		let animation = CABasicAnimation(keyPath: Constants.animationKeyPath)
		animation.fromValue = fromColor
		animation.toValue = toColor
		animation.duration = Constants.animationDuration
		shadowView.layer.add(animation, forKey: nil)
	}
	
	public override var isEnabled: Bool {
		get { super.isEnabled }
		set {
			guard self.isEnabled != newValue else { return }
			super.isEnabled = newValue
			
			switch style {
			case .default, .primary:
				contentView.backgroundColor = isEnabled ? style.backgroundColor : style.disabledBackgroundColor
				textLabel.textColor = isEnabled ? style.textColor : style.disabledTextColor
			default:
				break
			}
		}
	}
	
	// MARK: - Appearance
	
	func updateAppearance() {
		switch style {
		case .default, .primary:
			contentView.backgroundColor = style.backgroundColor
			contentView.layer.borderColor = style.borderColor.cgColor
			textLabel.textStyle = style.textStyle
			textLabel.textColor = style.textColor
			
		default:
			contentView.backgroundColor = style.backgroundColor
			contentView.layer.borderColor = style.borderColor.cgColor
			shadowView.layer.backgroundColor = UIColor.clear.cgColor
			shadowView.layer.shadowOffset = Constants.shadowOffset
			shadowView.layer.shadowRadius = Constants.shadowRadius
			
			textLabel.fontStyle = .body1
			textLabel.textColor = style.textColor
		}
		contentView.layer.borderWidth = style.borderWidth
	}
}

// MARK: - Private

private extension CommonButton {
	
	func setupUI() {
		setupShadowView()
		setupBackgroundView()
		setupTextLabel()
		updateAppearance()
		clipsToBounds = false
		isHighlighted = false
	}
	
	func setupShadowView() {
		switch style {
		case .default, .primary:
			break
		default:
			shadowView.isUserInteractionEnabled = false
			shadowView.translatesAutoresizingMaskIntoConstraints = false
			shadowView.clipsToBounds = false
			shadowView.layer.masksToBounds = false
			addSubview(shadowView)
			
			NSLayoutConstraint.activate([
						shadowView.topAnchor.constraint(equalTo: topAnchor),
						shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
						shadowView.leftAnchor.constraint(equalTo: leftAnchor),
						shadowView.rightAnchor.constraint(equalTo: rightAnchor)
			])
		}
	}
	
	func setupBackgroundView() {
		contentView.isUserInteractionEnabled = false
		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		
		NSLayoutConstraint.activate([
			contentView.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.shadowBorderWidth),
			contentView.heightAnchor.constraint(equalTo: heightAnchor, constant: -Constants.shadowBorderWidth),
			contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
			contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
	
	func setupTextLabel() {
		textLabel.isOpaque = false
		textLabel.isUserInteractionEnabled = false
		textLabel.textAlignment = .center
		textLabel.numberOfLines = 0
		textLabel.lineBreakMode = .byWordWrapping
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(textLabel)
		
		NSLayoutConstraint.activate([
			textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.textEdgeInsets.top),
			textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.textEdgeInsets.bottom),
			textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.textEdgeInsets.left),
			textLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.textEdgeInsets.right)
		])
	}
	
	func highlightedOrSelected(newValue: Bool) {
		switch style {
		case .default, .primary:
			contentView.backgroundColor = newValue ? style.highlightedBackgroundColor : style.backgroundColor
		default:
			let highlightedColor = style.borderColor.withAlphaComponent(0.2)
			let fromColor = newValue ? UIColor.clear : highlightedColor
			let toColor = !newValue ? UIColor.clear : highlightedColor
			shadowView.layer.backgroundColor = toColor.cgColor
			animationColorChange(fromColor: fromColor, toColor: toColor)
		}
	}
}

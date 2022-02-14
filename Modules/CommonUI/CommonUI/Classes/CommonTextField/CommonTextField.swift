// swiftlint:disable file_length
import UIKit

private enum Constants {
	static let containerViewCornerRadius: CGFloat = 12.0
	static let containerViewBorderWidth: CGFloat = 1.0
	static let containerViewHeight: CGFloat = 48.0
	static let placeholderLabelLeadingSpacing: CGFloat = 12.0
	static let placeholderTopSpacing: CGFloat = 6.0
	static let iconTextFieldSize: CGFloat = 20.0
	static let iconTextFieldLeadingSpacing: CGFloat = 17.0
	static let iconButtonSize: CGFloat = 20.0
	static let iconButtonTrailingSpacing: CGFloat = -17.0
	static let spacing: CGFloat = 4.0
	static let maskedTextFieldSymbol: Character = "#"
}

public enum CommonTextFieldButtonType {
	case none
	case clear
	case secure
}

@objc public protocol ICommonTextFieldDelegate: AnyObject {
	func didClearTextChange()
	func didTextChange(commonTextField: CommonTextField, text: String)
	@objc optional func textFieldDidBeginEditing(_ commonTextField: CommonTextField)
	@objc optional func textFieldDidEndEditing(_ commonTextField: CommonTextField)
	@objc optional func didTextFieldCanEditing(_ text: String) -> Bool
	@objc optional func textFieldShouldReturn(_ textField: CommonTextField) -> Bool
}

open class CommonTextField: UIView {

	// MARK: UIView
	public lazy var iconTextField: UIImageView = {
		let iconTextField = UIImageView()
		iconTextField.translatesAutoresizingMaskIntoConstraints = false
		iconTextField.contentMode = .scaleAspectFit
		return iconTextField
	}()
	
	public lazy var textField: CustomTextField = {
		let textField = CustomTextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.borderStyle = .none
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		textField.font = TextStyle.textM.font
		textField.textColor = commonUIConfig.colorSet.neutral600
		textField.tintColor = commonUIConfig.colorSet.blue700
		return textField
	}()
	
	public lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = Constants.spacing
		return stackView
	}()

	public lazy var containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = Constants.containerViewCornerRadius
		view.layer.borderWidth = Constants.containerViewBorderWidth
		view.layer.borderColor = commonUIConfig.colorSet.gray75.cgColor
		view.backgroundColor = commonUIConfig.colorSet.gray75
		view.clipsToBounds = true
		return view
	}()

	public lazy var placeholderLabel: CommonLabel = {
		let label = CommonLabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textStyle = .textM
		label.textColorStyle = .placeholder
		return label
	}()

	public lazy var validateLabel: CommonLabel = {
		let validateLabel = CommonLabel()
		validateLabel.translatesAutoresizingMaskIntoConstraints = false
		validateLabel.textStyle = .textS
		validateLabel.textColorStyle = .error
		validateLabel.numberOfLines = 0
		return validateLabel
	}()

	public lazy var clearButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(commonUIConfig.imageSet.clearTextIcon, for: .normal)
		button.isHidden = true
		return button
	}()

	public lazy var secureTextButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(commonUIConfig.imageSet.hideSecureTextIcon, for: .normal)
		button.setImage(commonUIConfig.imageSet.showSecureTextIcon, for: .highlighted)
		button.setImage(commonUIConfig.imageSet.showSecureTextIcon, for: .selected)
		button.isHidden = true
		return button
	}()

	// MARK: - Properties
	private var validator: Validator = Validator()
	private var textFieldIsActive: Bool = false
	private var isSecureTextEntry: Bool = false {
		didSet {
			textField.isSecureTextEntry = isSecureTextEntry
		}
	}
	
	// MARK: - Delegate
	weak public var delegate: ICommonTextFieldDelegate?

	public var rules: [IRule] = []
	public var maximumCharacter: Int = 0
	public var maskedFormat: String = ""
	public var customValidation: () -> Bool = { return true }

	public var text: String? {
		get {
			getText()
		}
		set {
			textField.text = newValue
			activeField(by: newValue)
		}
	}

	public var isValid: Bool {
		self.fieldIsValid()
	}

	public var buttonType: CommonTextFieldButtonType = .clear {
		didSet {
			updateButtonType()
		}
	}

	public var defaultMessage: String? {
		didSet {
			showValidationPassStyle()
		}
	}
	
	public var viewColor: UIColor? {
		didSet {
			updateBackgroundColor()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		loadView()
		commonInit()
	}

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		loadView()
		commonInit()
	}

	public func validateField() {
		guard !rules.isEmpty else {
			showValidationPassStyle()
			return
		}
		
		let validateText: String = removeMaskedSeparateSymbol(text ?? "")
		if let errorMessage = validator.validateValue(validateText, rules: rules) {
			showValidationFailedStyle(message: errorMessage)
		} else {
			if !customValidation() {
				let errorMessage = rules.filter({ $0 is RegexRule }).first?.errorMessage() ?? defaultMessage ?? ""
				showValidationFailedStyle(message: errorMessage)
			} else {
				showValidationPassStyle()
			}
		}
	}

	public func activeField(by newValue: String?) {
		guard let value = newValue, !value.isEmpty else {
			return
		}
		setActiveView(true)
		hideClearButton(false)
	}
	
	public func maskedValue(currentText: String) -> String {
		let cleanText: String = self.removeMaskedSeparateSymbol(currentText)
		let format: String = self.maskedFormat
		var maskedText: String = ""
		var index = cleanText.startIndex
		for char in format where index < cleanText.endIndex {
			if char == Constants.maskedTextFieldSymbol {
				maskedText.append(cleanText[index])
				index = cleanText.index(after: index)
			} else {
				maskedText.append(char)
			}
		}
		return maskedText
	}

	public func showValidationFailedStyle(message: String) {
		containerView.layer.borderColor = commonUIConfig.colorSet.red600.cgColor
		containerView.backgroundColor = commonUIConfig.colorSet.red100
		placeholderLabel.textColorStyle = .error
		validateLabel.textColorStyle = .error
		validateLabel.text = message
		validateLabel.isHidden = false
	}

	public func showValidationPassStyle() {
		validateLabel.text = defaultMessage
		placeholderLabel.textColorStyle = .placeholder
		validateLabel.textColorStyle = .placeholder
		containerView.layer.borderColor = commonUIConfig.colorSet.gray75.cgColor
		containerView.backgroundColor = commonUIConfig.colorSet.gray75
		validateLabel.isHidden = true
	}
}

// MARK: - Private
private extension CommonTextField {
	func loadView() {
		backgroundColor = .clear
		// MARK: - Stack View
		addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
		
		// MARK: - Container View
		stackView.addArrangedSubview(containerView)
		NSLayoutConstraint.activate([
			containerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
			containerView.heightAnchor.constraint(equalToConstant: Constants.containerViewHeight)
		])

		// MARK: - iconTextField
		containerView.addSubview(iconTextField)
		NSLayoutConstraint.activate([
			iconTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.iconTextFieldLeadingSpacing),
			iconTextField.widthAnchor.constraint(equalToConstant: Constants.iconTextFieldSize),
			iconTextField.heightAnchor.constraint(equalToConstant: Constants.iconTextFieldSize),
			iconTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
		])
		
		// MARK: - Placeholder Label
		containerView.addSubview(placeholderLabel)
		NSLayoutConstraint.activate([
			placeholderLabel.leadingAnchor.constraint(equalTo: iconTextField.trailingAnchor, constant: Constants.placeholderLabelLeadingSpacing),
			placeholderLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.placeholderLabelLeadingSpacing),
			placeholderLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
		])

		// MARK: - TextField
		containerView.addSubview(textField)
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: placeholderLabel.leadingAnchor),
			textField.trailingAnchor.constraint(equalTo: placeholderLabel.trailingAnchor),
			textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
		])

		// MARK: - Validate Label
		stackView.addArrangedSubview(validateLabel)
		NSLayoutConstraint.activate([
			validateLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: Constants.placeholderLabelLeadingSpacing),
			validateLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -Constants.placeholderLabelLeadingSpacing)
		])

		// MARK: - Clear Button
		containerView.addSubview(clearButton)
		NSLayoutConstraint.activate([
			clearButton.widthAnchor.constraint(equalToConstant: Constants.iconButtonSize),
			clearButton.heightAnchor.constraint(equalToConstant: Constants.iconButtonSize),
			clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.iconButtonTrailingSpacing),
			clearButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
		])

		// MARK: - Secure Text Button
		containerView.addSubview(secureTextButton)
		NSLayoutConstraint.activate([
			secureTextButton.widthAnchor.constraint(equalToConstant: Constants.iconButtonSize),
			secureTextButton.heightAnchor.constraint(equalToConstant: Constants.iconButtonSize),
			secureTextButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.iconButtonTrailingSpacing),
			secureTextButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
		])
	}
	
	func commonInit() {
		textField.delegate = self
		textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTappedContainerView)))
		clearButton.addTarget(self, action: #selector(handleTappedClearText), for: .touchUpInside)
		secureTextButton.addTarget(self, action: #selector(handleTappedSecureText(button:)), for: .touchUpInside)
	}

	func updateButtonType() {
		switch buttonType {
		case .clear:
			clearButton.isHidden = true
		case .secure:
			secureTextButton.isHidden = false
			isSecureTextEntry = true
		default: break
		}
	}
	
	func updateBackgroundColor() {
		containerView.backgroundColor = viewColor
		textField.backgroundColor = viewColor
	}

	func setActiveView(_ isActive: Bool) {
		self.placeholderLabel.isHidden = isActive
	}

	func hideClearButton(_ isHidden: Bool) {
		if buttonType == .clear {
			clearButton.isHidden = isHidden
		}
	}

	func removeMaskedSeparateSymbol(_ text: String) -> String {
		var textWithOutMasked: String = text
		if let maskedSeparateSymbol = self.maskedFormat.filter({ $0 != Constants.maskedTextFieldSymbol }).first {
			textWithOutMasked = text.components(separatedBy: String(maskedSeparateSymbol)).joined()
		}
		return textWithOutMasked
	}

	func fieldIsValid() -> Bool {
		let cleanText = self.removeMaskedSeparateSymbol(text ?? "")
		let isValid: Bool = self.rules.compactMap { $0.validate(cleanText) }.filter { !$0 }.isEmpty
		return isValid && customValidation()
	}
	
	func getText() -> String? {
		let currentText: String = textField.text ?? ""
		return (currentText == "") ? nil : removeMaskedSeparateSymbol(currentText)
	}
}

// MARK: - Objc functions
private extension CommonTextField {
	@objc func handleTappedContainerView() {
		textField.becomeFirstResponder()
	}

	@objc func textFieldDidChange() {
		let text = self.textField.text ?? ""
		self.hideClearButton(text.isEmpty)
		
		delegate?.didTextChange(commonTextField: self, text: text)
	}

	@objc func handleTappedClearText() {
		if buttonType == .clear {
			self.clearButton.isHidden = true
		}
		self.textField.text = nil
		delegate?.didClearTextChange()
		guard !self.textFieldIsActive else {
			return
		}
		self.hideClearButton(true)
		self.setActiveView(false)
		self.showValidationPassStyle()
	}

	@objc func handleTappedSecureText(button: UIButton) {
		isSecureTextEntry = button.isSelected
		button.isSelected = !button.isSelected
	}
}

// MARK: - UITextFieldDelegate
extension CommonTextField: UITextFieldDelegate {
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		let text = textField.text ?? ""
		self.textFieldIsActive = true
		self.hideClearButton(text.isEmpty)
		self.showValidationPassStyle()
		self.setActiveView(true)
		if buttonType == .clear {
			self.clearButton.isHidden = text.isEmpty
		}
		delegate?.textFieldDidBeginEditing?(self)
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {
		let text = textField.text ?? ""
		self.textFieldIsActive = false
		self.hideClearButton(text.isEmpty)
		self.setActiveView(!text.isEmpty)
		if buttonType == .clear {
			self.clearButton.isHidden = text.isEmpty
		}
		delegate?.textFieldDidEndEditing?(self)
	}

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let currentText: String = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
		if !self.maskedFormat.isEmpty {
			// Masked Value
			textField.text = maskedValue(currentText: currentText)
			hideClearButton((textField.text ?? "").isEmpty)
			return false
		} else if maximumCharacter > 0 {
			// Limit Text
			if string.isEmpty {
				return true
			}
			let countText: Int = currentText.utf16.count
			return countText <= maximumCharacter
		} else {
			return delegate?.didTextFieldCanEditing?(currentText) ?? true
		}
		
		delegate?.didTextChange(commonTextField: self, text: currentText)
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return delegate?.textFieldShouldReturn?(self) ?? true
	}
}

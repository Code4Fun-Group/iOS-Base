import UIKit

private enum Constants {
	static let numberOfDigits = 6
	static let spacing: CGFloat = 2
	static let separator = "•"
	static let delayTime: TimeInterval = 0.5
}

public protocol IPinCodeView: UIKeyInput {
	func clearText()
	var code: String? { get }
	var helpText: String? { get set }
}

public class PinCodeView: UIControl {
	@IBOutlet var stackView: UIStackView!
	@IBOutlet var codeTextField: UITextField!
	@IBOutlet var helpTextLabel: CommonLabel!
	@IBOutlet var codeLabels: [CommonLabel]!
	
	public var isSecureText: Bool = false
	public var helpText: String? {
		didSet {
			helpTextLabel.text = helpText
		}
	}
	
	private var isDeleteBackward: Bool = false
	// MARK: - Lifecycle
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		reloadData()
		codeTextField?.addTarget(self, action: #selector(textFieldEditingDidChanged), for: .editingChanged)
		codeLabels?.forEach {
			$0.fontStyle = .input1
			$0.colorStyle = .placeholder
		}
		
		helpTextLabel.fontStyle = .body3
		helpTextLabel.colorStyle = .error
		helpTextLabel.accessibilityIdentifier = "lbl_helptextlabel_pincodeview"
	}
}

// MARK: - Private

private extension PinCodeView {
	@IBAction
	func reloadData() {
		let code = codeTextField?.text ?? ""
		let codes = Array(code)
		codeLabels?.enumerated().forEach { index, label in
			if index < codes.count {
				let text = codes[index]
				label.fadeTransition()
				reload(character: String(text), itemIndex: index, lenght: codes.count, label: label)
				label.colorStyle = .input
			} else {
				label.text = Constants.separator
				label.colorStyle = .placeholder
			}
		}
	}
	
	func reload(character: String, itemIndex: Int, lenght: Int, label: CommonLabel) {
		if isSecureText {
			let isCurrentCursor = lenght == itemIndex + 1
			let shouldHilightCharacter = isCurrentCursor && !isDeleteBackward
			label.text = shouldHilightCharacter ? character : Constants.separator
			
			DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delayTime) {
				label.text = Constants.separator
			}
		} else {
			label.text = character
		}
	}
}

// MARK: - IPinCodeView

extension PinCodeView: IPinCodeView {
	public var code: String? {
		return codeTextField?.text
	}
	
	public var hasText: Bool {
		return codeTextField?.text?.isEmpty ?? true
	}
	
	public func insertText(_ text: String) {
		codeTextField?.text = (codeTextField?.text ?? "") + text
		reloadData()
		textFieldEditingDidChanged()
	}
	
	public func deleteBackward() {
		_ = codeTextField?.text?.popLast()
		reloadData()
		textFieldEditingDidChanged()
	}
	
	public func clearText() {
		codeTextField?.text = nil
		reloadData()
		textFieldEditingDidChanged()
	}
	
	private var keyboardType: UIKeyboardType {
		return .phonePad
	}
	
	public override var canBecomeFirstResponder: Bool {
		return true
	}
	
	public override func becomeFirstResponder() -> Bool {
		return codeTextField?.becomeFirstResponder() ?? false
	}
	
	public override func resignFirstResponder() -> Bool {
		return codeTextField?.resignFirstResponder() ?? false
	}
}

// MARK: - UITextFieldDelegate

extension PinCodeView: UITextFieldDelegate {
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let text = textField.text else { return true }
		textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
		isDeleteBackward = string == "" ? true : false
		let newLength = text.count + string.count - range.length
		return newLength <= Constants.numberOfDigits
	}
	
	@objc
	func textFieldEditingDidChanged() {
		reloadData()
		
		if let count = codeTextField?.text?.count, count == Constants.numberOfDigits {
			sendActions(for: .editingDidEnd)
		}
	}
}

public class CustomTextField: UITextField {
	
	public var isPasteEnabled: Bool = true
	
	public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		if action == #selector(UIResponderStandardEditActions.paste(_:)) && !isPasteEnabled {
			return false
		}
		return super.canPerformAction(action, withSender: sender)
	}
}

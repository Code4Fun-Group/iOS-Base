import Foundation

open class EmailRule: RegexRule {
	static let emailRegex: String = "^([A-Za-z0-9]|([A-Za-z]+(?:[._-][A-Za-z0-9]+)))+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
	
	public convenience init(message: String) {
		self.init(regex: EmailRule.emailRegex, message: message)
	}
}

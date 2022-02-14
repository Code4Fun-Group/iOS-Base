import Foundation

open class SpecialCharacterRule: IRule {
	private var message: String
	private var legalCharacterRegex: String
	private var allowedSpecialCharacters: String
	
	public init(allowedSpecialCharacters: String, legalCharacterRegex: String, message: String) {
		self.allowedSpecialCharacters = allowedSpecialCharacters
		self.legalCharacterRegex = legalCharacterRegex
		self.message = message
	}
	
	public func validate(_ value: String) -> Bool {
		let isNotContainIllegalCharecter = value.replacingOccurrences( of: legalCharacterRegex, with: "", options: .regularExpression).isEmpty
		let specialCharset = CharacterSet(charactersIn: allowedSpecialCharacters)
		let isContainSpecialCharecter = value.rangeOfCharacter(from: specialCharset) != nil
		return isNotContainIllegalCharecter && isContainSpecialCharecter
	}
	
	public func errorMessage() -> String {
		return message
	}
}

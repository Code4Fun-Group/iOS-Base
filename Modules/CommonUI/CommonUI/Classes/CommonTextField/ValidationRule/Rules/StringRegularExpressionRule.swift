import Foundation

open class StringRegularExpressionRule: IRule {
	private var regex: String
	private var message: String
	
	public init(regex: String, message: String) {
		self.regex = regex
		self.message = message
	}
	
	public func validate(_ value: String) -> Bool {
		let regularExpression = try? NSRegularExpression(pattern: regex)
		let range = NSRange(location: .zero, length: value.utf16.count)
		return regularExpression?.firstMatch(in: value, options: [], range: range) != nil
	}
	
	public func errorMessage() -> String {
		return message
	}
}

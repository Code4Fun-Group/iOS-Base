import Foundation

public protocol IRule {
	func validate(_ value: String) -> Bool
	func errorMessage() -> String
}

import Foundation

public protocol IPageSheetAppearance {
	var backdropAlpha: CGFloat { get }
	var backdropColor: UIColor { get }
	var surfaceBackgroundColor: UIColor { get }
	var surfaceCornerRadius: CGFloat { get }
	var grabberAreaOffset: CGFloat { get }
	
	var panGestureRecognizerEnabled: Bool { get }
	var dismissTapGestureEnabled: Bool { get }
}

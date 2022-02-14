import FloatingPanel

class CommonIntrinsicFloatingPanelLayout: FloatingPanelLayout {
	var appearance: IPageSheetAppearance
	var position: FloatingPanelPosition = .bottom
	var initialState: FloatingPanelState = .full
	var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
		.full: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 0, referenceGuide: .superview)
	]
	
	init(appearance: IPageSheetAppearance) {
		self.appearance = appearance
	}
	
	func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
		appearance.backdropAlpha
	}
	
	func allowsRubberBanding(for edge: UIRectEdge) -> Bool {
		return false
	}
}

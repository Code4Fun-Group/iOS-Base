import FloatingPanel

class CommonFloatingPanelLayout: FloatingPanelLayout {
	var appearance: IPageSheetAppearance
	var position: FloatingPanelPosition = .bottom
	var initialState: FloatingPanelState = .half
	var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
		.full: FloatingPanelLayoutAnchor(absoluteInset: 0, edge: .top, referenceGuide: .safeArea),
		.half: FloatingPanelLayoutAnchor(fractionalInset: 0.6, edge: .bottom, referenceGuide: .superview)
	]
	
	init(appearance: IPageSheetAppearance) {
		self.appearance = appearance
	}
	
	func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
		appearance.backdropAlpha
	}
}

class CommonAdjustableHeightFloatingPanelLayout: CommonFloatingPanelLayout {
	init(appearance: IPageSheetAppearance, height: CGFloat) {
		super.init(appearance: appearance)
		self.anchors = [
			.full: FloatingPanelLayoutAnchor(absoluteInset: 0, edge: .top, referenceGuide: .safeArea),
			.half: FloatingPanelLayoutAnchor(absoluteInset: height, edge: .bottom, referenceGuide: .superview)
		]
	}
}

class CommonEmbeddedFloatingPanelLayout: FloatingPanelLayout {
	var appearance: IPageSheetAppearance
	var position: FloatingPanelPosition = .bottom
	var initialState: FloatingPanelState = .half
	var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
		.full: FloatingPanelLayoutAnchor(absoluteInset: 0, edge: .top, referenceGuide: .safeArea),
		.half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .superview),
		.tip: FloatingPanelLayoutAnchor(fractionalInset: 0.3, edge: .bottom, referenceGuide: .superview)
	]
	
	init(appearance: IPageSheetAppearance) {
		self.appearance = appearance
	}
	
	func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
		appearance.backdropAlpha
	}
}

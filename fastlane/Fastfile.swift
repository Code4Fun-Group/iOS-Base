// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
	var isCI: Bool {
		return environmentVariable(get: "CI") == "true" ? true : false
	}
	
	func initLane() {
		desc("Run Initial")
		
		// Run 'pod install'
		cocoapods()
	}
	func swiftLintLane() {
		desc("Run SwiftLint")
		
		swiftlint(configFile: ".swiftlint.yml",
				  strict: true,
				  ignoreExitStatus: false,
				  raiseIfSwiftlintError: true,
				  executable: "Pods/SwiftLint/swiftlint"
		)
	}
	
	func dangerLane() {
		desc("Run Danger")
		
		danger(dangerfile: "Dangerfile",
			   githubApiToken: .fastlaneDefault(environmentVariable(get: "DANGER_GITHUB_API_TOKEN")),
			   newComment: .fastlaneDefault(true),
			   removePreviousComments: .fastlaneDefault(true)
		)
	}
	
	func developLane() {
		desc("Create a develop build and export an .ipa file")

		buildDebug(configuration: InternalDebug())
	}
	
	func ppeLane() {
		desc("Create a develop build and export an .ipa file")

		buildDebug(configuration: PPE())
	}
	
	func stagingLane() {
		desc("Create a staging build and export an .ipa file")

		buildProduct(configuration: QA(), exportIpa: true)
	}

	func productionLane() {
		desc("Create a production build and export an .ipa file")

		buildProduct(configuration: AppStore(), exportIpa: true)
	}
	
	private func buildDebug(configuration: Configuration) {
		buildApp(workspace: "\(environmentVariable(get: "APP_NAME")).xcworkspace",
				 scheme: .fastlaneDefault(configuration.schemeName),
				 clean: .fastlaneDefault(true),
				 configuration: .fastlaneDefault(configuration.buildConfiguration),
				 skipPackageIpa: .fastlaneDefault(true),
				 exportMethod: .fastlaneDefault(configuration.exportMethod),
				 skipArchive: .fastlaneDefault(true),
				 skipCodesigning: .fastlaneDefault(true),
				 derivedDataPath: .fastlaneDefault("./DerivedData"),
				 analyzeBuildTime: .fastlaneDefault(true))
	}
	
	private func buildProduct(configuration: Configuration, exportIpa: Bool) {
		
		// Update provisioning profile and certificate for the specified build configuration
		match(
			type: configuration.exportMethod,
			readonly: .fastlaneDefault(isCI),
			appIdentifier: [configuration.bundleIdentifier],
			forceForNewDevices: .fastlaneDefault(configuration.exportMethod == "development")
		)
		
		// Build the product for the specified build configuration
		gym(
			scheme: .fastlaneDefault(configuration.schemeName),
			clean: .fastlaneDefault(true),
			outputName: .fastlaneDefault("\(configuration.schemeName)-\(configuration.buildConfiguration).ipa"),
			configuration: .fastlaneDefault(configuration.buildConfiguration),
			includeBitcode: .fastlaneDefault(true),
			exportMethod: .fastlaneDefault(configuration.exportMethod)
		)
	}
}

protocol Configuration {
	var exportMethod: String { get }
	var buildConfiguration: String { get }
	var schemeName: String { get }
	var bundleIdentifier: String { get }
}

struct InternalDebug: Configuration {
	// Configuration for building debug builds on physical devices in-house
	var exportMethod = "development"
	var buildConfiguration = "Development"
	var schemeName = "Development"
	var bundleIdentifier: String {
		return "\(appIdentifier).dev"
	}
}

struct PPE: Configuration {
	// Configuration for building debug builds on physical devices in-house
	var exportMethod = "development"
	var buildConfiguration = "PPE"
	var schemeName = "PPE"
	var bundleIdentifier: String {
		return "\(appIdentifier).dev"
	}
}

struct QA: Configuration {
	// Configuration for building test builds to deploy in Test Flight
	var exportMethod = "adhoc"
	var buildConfiguration = "QA"
	var schemeName = "QA"
	var bundleIdentifier: String {
		return "\(appIdentifier).qa"
	}
}

struct AppStore: Configuration {
	// Configuration for building release builds to deploy in App Store
	var exportMethod = "appstore"
	var buildConfiguration = "Production"
	var schemeName = "Production"
	var bundleIdentifier: String {
		return "\(appIdentifier)"
	}
}

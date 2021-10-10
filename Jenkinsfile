#!/usr/bin/env groovy

pipeline {
	agent {
		label 'slave-macos'
	}

	options {
		disableConcurrentBuilds()
	}

	stages {
		stage("Initialize") {
			steps {
				sh """
				bundle install
				bundle exec fastlane run cocoapods
				"""
			}
		}
    
		stage("Swiftlint") {
			steps {
				sh """
				bundle exec fastlane run swiftlint
				"""
			}
		}
	
		stage("Danger") {
			environment {
				GITHUB_PERSONAL_TOKEN = credentials('GITHUB_PERSONAL_TOKEN')
			}
			steps {
				sh """
				export DANGER_GITHUB_API_TOKEN=$GITHUB_PERSONAL_TOKEN
				bundle exec fastlane run danger
				"""
			}
		}
	}
}

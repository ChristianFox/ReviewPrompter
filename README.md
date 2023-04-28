[![Latest Version](https://img.shields.io/github/v/tag/ChristianFox/ReviewPrompter?sort=semver&label=Version&color=orange)](https://github.com/ChristianFox/ReviewPrompter/)
[![Swift](https://img.shields.io/badge/Swift-5.7-orange)](https://img.shields.io/badge/Swift-5.7-orange)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS-orange)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-orange)

[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-yes-green)](https://img.shields.io/badge/Swift_Package_Manager-yes-green)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-no-red)](https://img.shields.io/badge/Cocoapods-no-red)
[![Cathage](https://img.shields.io/badge/Cathage-no-red)](https://img.shields.io/badge/Cathage-no-red)
[![Manually](https://img.shields.io/badge/Manual_Import-yes-green)](https://img.shields.io/badge/Manually_Added-sure-green)

[![CodeCoverage](https://img.shields.io/badge/Code%20Coverage-98.5%25-green)](https://img.shields.io/badge/Code%20Coverage-98.5%25-green)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](https://github.com/ChristianFox/ReviewPrompter/blob/master/LICENSE)
[![Contribution](https://img.shields.io/badge/Contributions-Welcome-blue)](https://github.com/ChristianFox/ReviewPrompter/labels/contribute)
[![First Timers Friendly](https://img.shields.io/badge/First_Timers-Welcome-blue)](https://github.com/ChristianFox/ReviewPrompter/labels/contribute)

[![Size](https://img.shields.io/github/repo-size/ChristianFox/ReviewPrompter?color=orange)](https://img.shields.io/github/repo-size/ChristianFox/ReviewPrompter?color=orange)
[![Files](https://img.shields.io/github/directory-file-count/ChristianFox/ReviewPrompter?color=orange)](https://img.shields.io/github/directory-file-count/ChristianFox/ReviewPrompter?color=orange)


# ReviewPrompter

ReviewPrompter is an open-source library for iOS applications written in Swift that helps you intelligently prompt users for app reviews. It tracks the occurrence of specific events within your app and requests a review prompt when the specified conditions are met. ReviewPrompter ensures that users are not prompted too frequently by implementing a minimum time interval between each prompt.

## Dependencies

`ReviewPrompter` is a subclass of `EventTracker` and so depends on the [EventTracker](http://github.com/ChristianFox/EventTracker) library.

## Features

- Tracks occurrences of named events in your app
- Requests review prompts when the number of events matches the specified condition
- Ensures a minimum time interval between each prompt
- Allows for manual triggering of review prompts
- Supports event count resetting
- Provides an option to enable or disable logging

## 🧪 Tests

The library is basically fully tested with 98.5% code coverage

## 💻 Installation

### Swift Package Manager
To add ReviewPrompter to your project using Swift Package Manager, add the following dependency in your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/ChristianFox/ReviewPrompter.git", from: "1.0.0")
]
```

Don't forget to add ReviewPrompter to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["ReviewPrompter"]),
]
```

## 🛠️ Usage

### ReviewPrompter

Initialise an instance

```swift
let reviewPrompter = ReviewPrompter(minimumPromptInterval: 60 * 60 * 24 * 7) // 1 week
```

Increase the event count and request a review prompt if the condition is met. Callback is used to inform the caller if a review prompt has been requested.

```swift
do {
    try reviewPrompter.increaseEventCountWithReviewPrompt(forIdentifier: "event1") { didRequestReview in
        print("Review prompt requested: \(didRequestReview)")
    }
} catch {
    print("Error: \(error)")
}
```

Manually triggr a review prompt

```swift
let didRequest = reviewPrompter.requestReviewPrompt()
print("Review prompt requested: \(didRequest)")
```

If needed, you can delete the history of review prompt dates with the deleteHistoryOfReviewPromptDates() method:

```swift
reviewPrompter.deleteHistoryOfReviewPromptDates()
```


### Inherited from EventTracker

Begin tracking an event

```swift
reviewPrompter.trackEvent(forIdentifier: "event1", withCondition: 3)
```

Stop tracking an event

```swift
reviewPrompter.stopTrackingEvent(forIdentifier: "event1")
```

Change the condition for an event

```swift
do {
    try reviewPrompter.changeCondition(5, forIdentifier: "event1")
} catch {
    print("Error updating event condition: \(error)")
}
```

Increase the event count
 
```swift
do {
    try reviewPrompter.increaseEventCount(forIdentifier: "event1")
} catch {
    print("Error increasing event count: \(error)")
}
```


Reset the event count

```swift
do {
    try reviewPrompter.resetEventCount(forIdentifier: "event1")
} catch {
    print("Error resetting event count: \(error)")
}
```

Check if an event's condition has been met

```swift
if reviewPrompter.hasEventMetCondition(forIdentifier: "event1") {
    print("Event met condition!")
}
```

Check an event is being tracked

```swift
if reviewPrompter.isTrackingEvent(forIdentifier: "event1") {
    print("Event is being tracked!")
}
```

Check the number of times an event has occured

```swift
let eventCount = reviewPrompter.eventCount(forIdentifier: "event1")
print("Event count: \(eventCount)")
```

Check the current condition of an event

```swift
let eventCondition = reviewPrompter.condition(forIdentifier: "event1")
print("Event condition: \(eventCondition)")
```

## 🐕‍🦺 Support

Please [open an issue](https://github.com/ChristianFox/ReviewPrompter/issues/new) for support.

## 👷‍♂️ Contributing

Pull requests are welcome. I welcome developers of all skill levels to help improve the library, fix bugs, or add new features. 

For major changes, please open an issue first to discuss what you would like to change.

Before submitting a pull request, please ensure that your code adheres to the existing code style and conventions, and that all tests pass. Additionally, if you're adding new functionality, please make sure to include unit tests to verify the behavior.

If you have any questions or need assistance, feel free to [open an issue](https://github.com/ChristianFox/ReviewPrompter/issues/new), and I'll do my best to help you out. 

## 🪪 Licence

ReviewPrompter is released under the MIT Licence. See the LICENSE file for more information.

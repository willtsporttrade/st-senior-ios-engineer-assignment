# st-senior-ios-engineer-assignment

Assignment for Senior iOS Engineer position at https://boards.greenhouse.io/sporttrade/jobs/4093543004?t=7e3c715f4us

## Setup

1. Install [Xcode 13.0](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
1. Fork our repo https://github.com/sporttrade/st-senior-ios-engineer-assignment
1. Clone your fork
1. `cd` into the root directory of your clone
1. Run the _setup.sh_ script

        ./setup.sh

1. Open _Assignment.xcworkspace_

## Guidelines

1. You **must** use [MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
1. You **must** use [Combine](https://developer.apple.com/documentation/combine)
1. You **cannot** remove dependencies
1. You can add dependencies, but you must provide justification in the pull request notes

## Assignment - Required

1. Finish implementing `ListViewController`
    1. Display the following for each represented `PositionModel`
        1. `name`
        1. `price`, formatted as currency (US dollars)
    1. On tap of represented `PositionModel`, push an instance of `DetailViewController`
1. Finish implementing `DetailViewController`
    1. Display the following for the represented `PositionModel`
        1. `name`
        1. `criteriaName`
        1. `storyName`
        1. `price`, formatted as currency (US dollars)
        1. `quantity`, formatted as decimal with 4 significant digits
    1. Subscribe to the publisher returned by `CombineManager.position(identifier:)` and update the displayed values
1. Document your changes for `internal` or higher access level, ignore `override`s
1. Prepare all user visible strings for localization, see `ListViewModel` for an example
1. Ensure implemented UI responds appropriately to [Dynamic Type](https://developer.apple.com/documentation/uikit/uifont/scaling_fonts_automatically) changes
1. Ensure implemented UI responds appropriately to [Dark Mode](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode)

### Assignment - Optional

1. **Optional**: Use `UICollectionViewDiffableDataSource` or `UITableViewDiffableDataSource` within `ListViewController` implementation
1. **Optional**: Implement a custom transition using [`UINavigationControllerDelegate.navigationController(_:animationControllerFor:from:to:`](https://developer.apple.com/documentation/uikit/uinavigationcontrollerdelegate/1621846-navigationcontroller) when pushing `DetailViewController`
1. **Optional**: Add unit tests to `AssignmentTests`
1. **Optional**: Add UI tests to `AssignmentUITest`
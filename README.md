![Ergo Stack logo](logo.png)

#  Ergo Stack

## About project

Ergo Stack app is a result of take home challenge. Writing this app took me 5 days and 40 hours of coding.

### Challenge requirements

**Create client app for Stack Overflow with this required features:**

1. Questions list
2. Question details
3. Question Answers
4. User Profile

**Additional nice to have features:**

1. Question search
2. User login
3. Answering questions

**Other requirements:**

1. Own written network layer
2. Data models
3. Use at least one protocol
4. Usage of MVC architecture
5. Use of Git version control

### Challenge results

Ergo Stack app at the end of challenge have had all required features implemented with respect to **Other requirements** section and
one additional feature: Question search.

## Disclaimer - API throttle limitations

Due to API throttle limitations application has hardcoded limit of requested questions to 50 items. 
This limit can be changed in [APIConfig.swift](https://github.com/nysander/ErgoStack/blob/master/ErgoStack/Networking/APIConfig.swift) file.

During development of Ergo Stack app was authorized on Stack Exchange to use higher limit of requests. 
Be aware that this key is also hardcoded in above file. This is only done for showcase purposes and you should change this key to yours if using this app.

## Ergo Stack source code highlights

* use of RelativeDateTimeFormatter
* use of UIActivityViewController
* Dark Mode support
* Coordinator pattern
* coordinated UISplitViewController for iPad support
* network layer abstracted with use of protocols
* Demo Mode with static JSON files containing example API responses
* translation ready with all strings inside Localizable.strings file (Base app language is English, app also translated to Polish)
* model layer mirroring api response objects
* decoding of response HTML and when relevant displaying as parsed HTML or as plaintext
* one question list data provider is used for 2 different sets of data
* main views are defined using storyboard, some of subviews are generated dynamically in code
* user images are loaded remotely, EmptyTableView image is loaded from Assets
* Demo Mode state is stored in UserDefaults. Access to UserDefaults is written with use of Property Wrappers.
* use of UISearchController - search with debouncing to send search request only when user stopped typing, not after every key.
* question list refreshing on demand

### External libraries used

* R.Swift - for type safe View Controllers and Strings
* PureLayout - for Empty Table View when data is loading
* CocoaPods integration - for external dependencies management

### External tools used:

* [SwiftLint](https://github.com/realm/SwiftLint) - for code linting and better code quality assurance
* [BartyCrouch](https://github.com/Flinesoft/BartyCrouch) - for managing and keeping in sync translation files

### Devices tested

This app was checked to work without issues on:

* iPad Pro 11"
* iPhone 11 Pro Max
* iPhone 8 Plus
* iPhone 8

## Demo Mode

Demo Mode support was introduced as backup for API throttling for unauthorized app. App is now authorized but Demo Mode was leaved for showcase purposes.

When using **Demo Mode** workflow loads question list, then you should click on second question to load its details, and on username to see user profile. User profile loads also user questions. Demo Mode do not contain any other data so tapping on another question will load question details of question from first list. Please note that this behavior is an assumed simplification of Demo Mode, not a bug.

Search feature is inactive in Demo Mode.

## Credits

Ergo Stack app was designed and built by **Paweł Madej**.

Source code of Ergo Stack App is licenced under MIT License. See [LICENSE.md](LICENSE.md) file for details.

Ergo Stack app was built using third-party frameworks: [R.Swift](https://github.com/mac-cain13/R.swift), [PureLayout](https://github.com/PureLayout/PureLayout). Their licenses are stored inside their respective Pods directories.

The Stack Exchange name and logos (including Stack Overflow logo used in Ergo Stack app) are trademarks of Stack Exchange Inc. The names and logos for sites and products operating on the Stack Exchange network are also trademarks of Stack Exchange Inc.

## Contact

If you have any questions, suggestions about this project, or you want me to become part of your team feel free to contact me: [@PawelMadejCK on Twitter](https://www.twitter.com/PawelMadejCK) or by email: **hello [at] pawelmadej.com**.

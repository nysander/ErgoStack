#  ErgoStack App

## Features used in app

* RelativeDateTimeFormatter
* UIActivityViewController
* Dark Mode support
* UISplitViewController for iPad support
* Coordinator pattern
* Network layer abstracted with use of protocols
* Demo Mode with static JSON files containing example API responses
* Translation ready with all strings inside Localizable.strings file
* Model layer mirroring api response objects
* decoding of response HTML and when relevant displaying as parsed HTML or as plaintext
* one question list data provider is used for 2 different sets of data 
* main views are defined using storyboard, some of subviews are generated dynamically in code
* user images are loaded remotely, EmptyTableView image is loaded from Assets
* demo mode state is stored in userdefaults. Access to userdefauts is made via property wrappers.

### External libraries

* R.Swift - for type safe View Controllers and Strings
* PureLayout - for Empty Table View when data is loading
* CocoaPods integration

### Devices

This app was checked to work without issues on:

* iPad Pro 11"
* iPhone 11 Pro Max
* iPhone 8 Plus
* iPhone 8

## Demo Mode

Demo Mode support was introduced as backup for API throttling for unauthorized app. App is now authorized but Demo Mode was leaved for showcase purposes.

Demo Mode workflow loads question list, then you should click on second question to load its details, and on username to see user profile. User profile loads also user questions. Demo Mode do not contain any other data so clicking on another question load question details of question from first list. This is assumed simplification of Demo Mode, not a bug.
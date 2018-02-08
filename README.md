# SwiftLocalDbAutoUpgrade
## sqlite本地数据库自动升级，支持添加表、添加字段、删除表、删除字段(注意:删除字段时候操作是根据现有的字段重新创建表再重名名的，在db中不要设置主键之类的字段)

[![CI Status](http://img.shields.io/travis/hu5675/SwiftLocalDbAutoUpgrade.svg?style=flat)](https://travis-ci.org/hu5675/SwiftLocalDbAutoUpgrade)
[![Version](https://img.shields.io/cocoapods/v/SwiftLocalDbAutoUpgrade.svg?style=flat)](http://cocoapods.org/pods/SwiftLocalDbAutoUpgrade)
[![License](https://img.shields.io/cocoapods/l/SwiftLocalDbAutoUpgrade.svg?style=flat)](http://cocoapods.org/pods/SwiftLocalDbAutoUpgrade)
[![Platform](https://img.shields.io/cocoapods/p/SwiftLocalDbAutoUpgrade.svg?style=flat)](http://cocoapods.org/pods/SwiftLocalDbAutoUpgrade)


![](./demo.png '描述')

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftLocalDbAutoUpgrade is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftLocalDbAutoUpgrade', '~> 1.0.1'
```

## Author

hu5675, hytmars1989@126.com

## License

SwiftLocalDbAutoUpgrade is available under the MIT license. See the LICENSE file for more info.

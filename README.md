# ExLog

[![CI Status](https://img.shields.io/travis/Jirokichi/ExLog.svg?style=flat)](https://travis-ci.org/Jirokichi/ExLog)
[![Version](https://img.shields.io/cocoapods/v/ExLog.svg?style=flat)](https://cocoapods.org/pods/ExLog)
[![License](https://img.shields.io/cocoapods/l/ExLog.svg?style=flat)](https://cocoapods.org/pods/ExLog)
[![Platform](https://img.shields.io/cocoapods/p/ExLog.svg?style=flat)](https://cocoapods.org/pods/ExLog)

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [ExLog](#exlog)
  - [Example](#example)
  - [Requirements](#requirements)
    - [動作テスト済み環境](#動作テスト済み環境)
  - [Installation](#installation)
    - [ログ機能のサポート](#ログ機能のサポート)
  - [History](#history)
  - [Author](#author)
  - [License](#license)

<!-- /code_chunk_output -->

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

### 動作テスト済み環境

As of 2021/01/31...

| ツール名 | バージョン           |
| -------- | -------------------- |
| Xcode    | Version 12.3 (12C33) |
| CocoaPod | 1.10.1               |







## Installation

ExLog is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
// cocoapods.orgに公開していないので"pod 'ExLog'"ではインストールできず、
// レポジトリを指定する必要がある
pod 'ExLog', :git => 'https://github.com/chorokichi/ExLog.git'
```

### ログ機能のサポート

次のメソッドを呼び出すと<strong>デバッグ時のみ</strong>ログがコンソールとファイルに出力される。普通の print とは違い次の情報をプラスで表示するようにしてある。

- 行数
- メインかサブスレッドどちらなのか？
- 実行時間
- 出力内容を document フォルダー内にファイルとして出力

| Method             | 呼び出し例                                                                                 | 詳細                                                                                                                                         |
| :----------------- | :----------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------- |
| `ExLog.log`        | ExLog.log("test") // [Main][📍][2018/10/27 16:04:57]:test[method(_:para:)/Class.swift(33)] | デバッグ情報を出力するためのメソッド。type, format, printType を指定できるが基本はそれらを指定せずに利用することを想定している。             |
| `ExLog.error`      | ExLog.log で出力されるアイコンが ⚠️ になる                                                 | 開発者がエラー情報だと思うが、そのままアプリは動作させていても問題ない場合に呼び出すメソッド。                                               |
| `ExLog.fatalError` | アプリが強制停止する。                                                                     | 開発者がエラーだと思い、かつそのまま放置すると重大なエラーが発生する箇所で呼ばれることを想定しているメソッド。                               |
| `ExLog.important`  | ExLog.log で出力されるアイコンが 📍 になる                                                 | 開発者が重要でコンソール上で確認することが多いと思う情報を出力するためのメソッド。アプリ起動時に DB のパスなどを表示する際に利用するといい。 |

## History

| :--- | :---- |
| `0.4.0` | Thread セーフに呼び出せるように変更|

## Author

Chorokichi, kdy.developer@gmail.com

## License

ExLog is available under the MIT license. See the LICENSE file for more info.

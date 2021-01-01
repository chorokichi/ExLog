#
# Be sure to run `pod lib lint ExLog.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ExLog'
  s.version          = '0.3.2'
  s.summary          = 'iOS用簡易ログライブラリー'
  s.description      = <<-DESC
ログ出力をサポートするライブラリー。フォーマットされたログをコンソール及びファイルとして出力することが可能。
ファイルはExLog/Debugが有効なときのみdocumentDirectory下にdebug-log.logとして作成される。
                       DESC

  s.homepage         = 'https://github.com/chorokichi/ExLog.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chorokichi' => 'kdy.developer@gmail.com' }
  s.source           = { :git => 'https://github.com/chorokichi/ExLog.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'
  s.source_files = 'ExLog/Classes/**/*'
end

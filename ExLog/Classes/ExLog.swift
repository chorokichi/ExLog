//
//  LogUtil.swift
//  PeopleTable
//
//  Created by yuya on 2016/03/10.
//  Copyright © 2016年 yuya. All rights reserved.
//

import Foundation

open class ExLog{
    
    // ファイルにログを出力するかどうか
    fileprivate static var ShouldFileOutput = true
    #if DEBUG
    fileprivate static let Debug = true
    #else
    fileprivate static let Debug = false
    #endif
    
    /// 初期設定。AppDelegateのapplicationDidFinishLaunchingで呼び出すことを想定している
    /// - parameter appName: ログファイルを格納するドキュメントフォルダー内のフォルダー名(Init: "DKMacLibraryTest")
    /// - parameter fileName: ログファイル名(Init: "debug-log.log")
    open static func configure(appName:String? = nil, fileName:String? = nil, shouldFileOutput:Bool? = nil){
        
        if let appName = appName{
            AppName = appName
        }
        if let fileName = fileName{
            FileName = fileName
        }
        if let shouldFileOutput = shouldFileOutput{
            ShouldFileOutput = shouldFileOutput
        }
    }
    
    /// ログを出力するクラスメソッド
    open static func log(_ object: Any? = "No Log",
                         classFile: String = #file,
                         functionName: String = #function,
                         lineNumber: Int = #line,
                         type: ExLogType = .Info,
                         format: ExLogFormat = .Normal,
                         printType: PrintType = .normal)
    {
        
        if Debug{
            let now = Date()
            
            let mainMessage = convert(object, by: printType)
            let classDetail = URL(string: String(classFile))?.lastPathComponent  ?? classFile
            logFormatMsg(mainMessage,
                date: now,
                classDetail: classDetail,
                functionName: functionName,
                lineNumber: lineNumber,
                type: type,
                format: format,
                printType: printType)
        }
    }
    
    private static func convert(_ object:Any?, by type:PrintType) -> String{
        var printMessage:String = ""
        switch type{
        case .normal:
            if let msg = object{
                printMessage = "\(msg)"
            }else{
                printMessage = "nil"
            }
        case .dump:
            dump(object, to:&printMessage)
        }
        return printMessage
    }
    
    /// ログを出力するクラスメソッド
    private static func logFormatMsg(_ msg: String,
                         date: Date,
                         classDetail: String,
                         functionName: String,
                         lineNumber: Int,
                         type: ExLogType,
                         format: ExLogFormat,
                         printType: PrintType)
    {
        let formatMsg = format.string(emoji: type.getEmoji(),
                                      date: date,
                                      msg: msg,
                                      functionName: functionName,
                                      classDetail: classDetail,
                                      lineNumber: lineNumber)
        output(formatMsg, printType:printType)
    }
    
    /// デバッグ時しか実行したくないコードによってのみ取得できるログを出力するメソッド。コールバックメソッドの返り値がログ出力される。
    open static func log(classFile: String = #file,
                         functionName: String = #function,
                         lineNumber: Int = #line,
                         type: ExLogType = .Info, _ runOnDebug:() -> Any?){
        if Debug{
            let msg = runOnDebug()
            ExLog.log(msg,
                      classFile:classFile,
                      functionName:functionName,
                      lineNumber:lineNumber,
                      type:type)
        }
    }
}


// - MARK: - ExLogType固定のクラスメソッド
extension ExLog{
    open static func error(_ object: Any? = "No Log",
                           classFile: String = #file,
                           functionName: String = #function,
                           lineNumber: Int = #line,
                           format: ExLogFormat = .Normal){
        log(object, classFile: classFile, functionName:functionName, lineNumber:lineNumber, type: .Error, format:format)
    }
    
    open static func fatalError(_ object: Any? = "No Log",
                           classFile: StaticString = #file,
                           functionName: String = #function,
                           lineNumber: UInt = #line,
                           format: ExLogFormat = .Normal){
        error(object, classFile: "\(classFile)", functionName:functionName, lineNumber:Int(lineNumber), format:format)
        assertionFailure(String(describing: object), file: classFile, line: lineNumber)
    }
    
    open static func important(_ object: Any? = "No Log",
                               classFile: String = #file,
                               functionName: String = #function,
                               lineNumber: Int = #line,
                               format: ExLogFormat = .Normal){
        log(object, classFile: classFile, functionName:functionName, lineNumber:lineNumber, type: .Important, format:format)
    }
    
    /// メソッド名をログに出力
    open static func method(classFile: String = #file,
                            functionName: String = #function,
                            lineNumber: Int = #line,
                            type: ExLogType = .Info){
        if Debug{
            let msg = functionName
            ExLog.log(msg,
                      classFile:classFile,
                      functionName:functionName,
                      lineNumber:lineNumber,
                      type:type)
        }
    }
    
    /// 改行を指定個出力するクラスメソッド
    open static func emptyLine(_ lineNums:Int = 1){
        if Debug{
            var msg = ""
            for _ in 1..<lineNums{
                msg = msg + "\n"
            }
            output(msg)
        }
    }
    
    /// 特定文字の指定した個数つなげたものを出力するクラスメソッド
    open static func separatorLine(_ character:String = "-", repeatNum:Int = 10){
        if Debug{
            var msg = ""
            for _ in 0..<repeatNum{
                msg = msg + character
            }
            output(msg)
            history = msg
        }
    }
}

// - MARK: - Util系（ログ出力はしない）
extension ExLog{
    // CoreDataのファイルなどを保存するフォルダーのパスを取得するメソッド
    open static func getFolderPathHavingCoreDataFile() -> String
    {
        let supportDirectory = FileManager.SearchPathDirectory.applicationSupportDirectory
        let searchPathDomainMask = FileManager.SearchPathDomainMask.allDomainsMask
        let directories = NSSearchPathForDirectoriesInDomains(supportDirectory, searchPathDomainMask, true)
        return directories.first ?? "Not Found path"
    }
    
    open static func getFileName(classFile: String = #file) -> String
    {
        if let fileNameWithExtension = URL(string: String(classFile))?.lastPathComponent {
            if case let fileName = fileNameWithExtension.components(separatedBy: "."), fileName.count > 0{
                return fileName[0]
            }
            return fileNameWithExtension
        } else {
            return classFile
        }
    }
    
    /// テスト実行中の判定(DEBUG以外では必ずfalse)。didFinishLaunchingWithOptionsに次のように埋め込むと良い。
    /// ```
    /// // iOS
    /// guard !isTesting() else {
    ///     window?.rootViewController = UIViewController()
    ///     return true
    /// }
    /// ```
    /// - Returns: テスト判定結果
    open static func isTesting() -> Bool {
        if Debug{
            return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        }else{
            return false
        }
    }
}

// - MARK: - 出力先制御
extension ExLog{
    fileprivate static var AppName = "ExLog"
    fileprivate static var FileName = "debug-log.log"
    
    public enum PrintType{
        case normal
        case dump
    }
    
    // 直前の表示内容を記録している文字列
    open static var history:String = ""
    fileprivate static func output(_ msg:String, printType:PrintType = .normal){
        print(msg)
        if ShouldFileOutput{
            outputToFile(msg)
        }
        history = msg
    }
    
    open static func createOrGetFolderForLog() -> URL?{
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("documentDirectory is nil")
            return nil
        }
        
        let folderUrl = dir.appendingPathComponent(AppName)
        
        let path = folderUrl.path
        if !fm.fileExists(atPath: path){
            print("Not found directory and try to create this dir(\(path))")
            do {
                try fm.createDirectory( atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Created!")
            } catch {
                //エラー処理
                print("Fail to create folder: \(path)")
            }
        }
        
        return folderUrl
    }
    
    open static func getLogFileForLog() -> URL?{
        return createOrGetFolderForLog()?.appendingPathComponent(FileName)
    }
    
    private static func outputToFile(_ msg:String){
        // To Download this file
        // iOS: you have to add "Application supports iTunes file sharing=true" flag to info.plist/
        // MacOS: check Document folder
        guard let fileUrl = getLogFileForLog() else{
            print("folderUrl is nil")
            return
        }
        
        guard let output = OutputStream(url: fileUrl, append: true) else{
            print("output is nil")
            return
        }
        
        output.open()
        
        defer{
            output.close()
        }
        
        guard let data = (msg + "\n").data(using: .utf8, allowLossyConversion: false) else{
            return
        }
        let result = data.withUnsafeBytes {
            output.write($0, maxLength: data.count)
        }
        
        if result <= 0{
            print("[\(result)]fail to write msg into \(fileUrl)")
        }
    }
}

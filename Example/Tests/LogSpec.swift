//
//  LogTests.swift
//  DKMacLibrary_Example
//
//  Created by yuya on 2018/06/16.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import ExLog

class LogSpec: QuickSpec {
    override func spec() {
        describe("ExLog"){
            it("Print dump log"){
                let dic = ["1":"test", "2":"test2"]
                ExLog.log(dic, printType: .dump)
                
                let expected = """
▿ Optional(["2": "test2", "1": "test"])
  ▿ some: 2 key/value pairs
    ▿ (2 elements)
      - key: "2"
      - value: "test2"
    ▿ (2 elements)
      - key: "1"
      - value: "test"
"""
                expect(ExLog.history).to(contain(expected))
            }
            it("Call log method and confirm there are no issues"){
                let msg = "Test"
                ExLog.log(msg)
                expect(ExLog.history).to(contain(#function))
                ExLog.log(msg, format:.Short)
                expect(ExLog.history).notTo(contain(#function))
                ExLog.log(msg, type:.Important)
                ExLog.log(msg, type:.Debug)
                ExLog.log(msg, type:.Error)
                ExLog.error(msg)
                ExLog.emptyLine()
                ExLog.separatorLine("-", repeatNum: 7)
                ExLog.emptyLine(3)
            }
            
            it("getFolderPathHavingCoreDataFile should be correct path without any error"){
                let path = ExLog.getFolderPathHavingCoreDataFile()
                ExLog.log(path)
                expect(path).to(contain("Application Support"))
            }
            
            it("getFileName should be correct class name without any error"){
                let fileName = ExLog.getFileName()
                ExLog.log(fileName)
                expect(fileName).to(equal("LogSpec"))
            }
            
            it("Check Log"){
                ExLog.log("")
                expect(ExLog.history).notTo(contain("Chorokichi"))
                
                ExLog.log("Chorokichi")
                expect(ExLog.history).to(contain("Chorokichi"))
                expect(ExLog.history).notTo(equal("Chorokichi")) // 関数名などがあるため完全に一致はしない
                
                ExLog.log("Chorokichi", format:.Raw)
                expect(ExLog.history).to(contain("Chorokichi"))
                expect(ExLog.history).to(equal("Chorokichi"))
            }
            
            it("async pattern"){
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 10) {
                    // 0.5秒後に実行する処理
                    ExLog.log("Async Log")
                }
                expect(ExLog.history).toEventually(contain("Async"), timeout: 15)
                expect(ExLog.history).toEventually(contain("Sub "), timeout: 15)
            }
        }
    }
}

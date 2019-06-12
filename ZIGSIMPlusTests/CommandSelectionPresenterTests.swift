//
//  CommandSelectionPresenterTests.swift
//  ZIGSIMPlusTests
//
//  Created by Nozomu Kuwae on 2019/06/12.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import XCTest
@testable import ZIGSIMPlus

class CommandSelectionPresenterTests: XCTestCase {
    let view = CommandSelectionViewController()
    let mediator = CommandAndServiceMediator()
    var presenter: CommandSelectionPresenter!

    override func setUp() {
        presenter = CommandSelectionPresenter(view: view, mediator: mediator)
    }

    func testNumberOfCommandToSelect_EqualsCommandCount() {
        XCTAssertEqual(presenter.numberOfCommandToSelect, Command.allCases.count)
    }
    
    func testDidSelectRow_AtCommandAccel() {
        presenter.didSelectRow(atLabel: Command.acceleration.rawValue)
        XCTAssertTrue(AppSettingModel.shared.isActiveByCommand[Command.acceleration]!)
        presenter.didSelectRow(atLabel: Command.acceleration.rawValue)
        XCTAssertFalse(AppSettingModel.shared.isActiveByCommand[Command.acceleration]!)
    }
    
    func testDidSelectRow_AtCommandApplePencil() {
        presenter.didSelectRow(atLabel: Command.applePencil.rawValue)
        XCTAssertTrue(AppSettingModel.shared.isActiveByCommand[Command.applePencil]!)
        presenter.didSelectRow(atLabel: Command.applePencil.rawValue)
        XCTAssertFalse(AppSettingModel.shared.isActiveByCommand[Command.applePencil]!)
    }
    
    func testDidSelectRow_AtAnyCommand() {
        for command in Command.allCases {
            presenter.didSelectRow(atLabel: command.rawValue)
            XCTAssertTrue(AppSettingModel.shared.isActiveByCommand[command]!)
            presenter.didSelectRow(atLabel: command.rawValue)
            XCTAssertFalse(AppSettingModel.shared.isActiveByCommand[command]!)
        }
    }
}

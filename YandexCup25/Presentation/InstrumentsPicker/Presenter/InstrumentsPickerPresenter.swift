//
//  InstrumentsPickerPresenter.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

protocol InstrumentsPickerPresenterProtocol: AnyObject {
    func viewLoaded()
}

final class InstrumentsPickerPresenter {
    
    weak var view: InstrumentsPickerViewControllerProtocol?
    
    private let deps: Deps
    
    init(deps: Deps) {
        self.deps = deps
    }
}

// MARK: - InstrumentsPickerPresenterProtocol

extension InstrumentsPickerPresenter: InstrumentsPickerPresenterProtocol {
    
    func viewLoaded() {
        view?.updateView(
            with: .init(
                instruments: Instrument.allCases,
                instrumentAction: { [weak self] instrument in
                    self?.deps.selectInstrument(instrument)
                }
            )
        )
    }
}

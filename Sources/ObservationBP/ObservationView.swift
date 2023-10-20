import SwiftUI

public protocol ObservationView: View where Body == _$ObservingView<ObservationBody> {
    associatedtype ObservationBody: View

    @ViewBuilder
    var observationBody: ObservationBody { get }
}

public extension ObservationView {
    var body: Body {
        _$ObservingView {
            observationBody
        }
    }
}

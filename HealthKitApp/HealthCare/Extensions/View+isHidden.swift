//
//  View+isHidden.swift
//  HealthKitApp
//
//  Created by Nour Gweda on 26/07/2023.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ shouldHide: Bool, removeFromView: Bool = false) -> some View {
        if shouldHide {
            if !removeFromView {
                self.hidden()
            }
        } else {
            self
        }
    }
}

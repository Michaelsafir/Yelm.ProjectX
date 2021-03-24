//
//  TooltipViewExtension.swift
//  rythmic
//
//  Created by Antoni Silvestrovic on 24/10/2020.
//  Copyright © 2020 Quassum Manus. All rights reserved.
//

import SwiftUI

extension View {
    func tooltip<TooltipContent: View>(@ViewBuilder content: @escaping () -> TooltipContent) -> some View {
        let config: TooltipConfig = DefaultTooltipConfig.shared

        return modifier(TooltipModifier(config: config, content: content))
    }

    func tooltip<TooltipContent: View>(config: TooltipConfig, @ViewBuilder content: @escaping () -> TooltipContent) -> some View {
        modifier(TooltipModifier(config: config, content: content))
    }

    func tooltip<TooltipContent: View>(_ side: TooltipSide, @ViewBuilder content: @escaping () -> TooltipContent) -> some View {
        var config = DefaultTooltipConfig.shared
        config.side = side

        return modifier(TooltipModifier(config: config, content: content))
    }
    
    func tooltip<TooltipContent: View>(_ side: TooltipSide, config: TooltipConfig, @ViewBuilder content: @escaping () -> TooltipContent) -> some View {
        var config = config
        config.side = side

        return modifier(TooltipModifier(config: config, content: content))
    }
}

package com.example.checkout_flow_plugin

import android.content.Context
import com.checkout.components.interfaces.api.PaymentMethodComponent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class CardFormViewFactory(
    private val messenger: BinaryMessenger,
    private val cardComponent: PaymentMethodComponent
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return CardFormPlatformView(context, cardComponent)
    }
}
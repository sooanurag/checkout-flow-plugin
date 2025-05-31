package com.example.checkout_flow_plugin

import android.content.Context
import android.widget.FrameLayout
import com.checkout.components.interfaces.api.PaymentMethodComponent
import io.flutter.plugin.platform.PlatformView

class CardFormPlatformView(
    context: Context,
    private val cardComponent: PaymentMethodComponent
) : PlatformView {

    private val rootView: FrameLayout = FrameLayout(context)

    init {
        val cardView = cardComponent.provideView(rootView)
        rootView.addView(cardView)
    }

    override fun getView() = rootView

    override fun dispose() {
        // Clean up if needed
    }
}
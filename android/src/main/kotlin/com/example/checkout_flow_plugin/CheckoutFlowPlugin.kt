package com.example.checkout_flow_plugin

import android.content.Context
import android.util.Log
import com.checkout.components.card.model.CardComponentConfig
import com.checkout.components.core.CheckoutComponentsFactory
import com.checkout.components.interfaces.Environment
import com.checkout.components.interfaces.api.CheckoutComponents
import com.checkout.components.interfaces.api.PaymentMethodComponent
import com.checkout.components.interfaces.component.CheckoutComponentConfiguration
import com.checkout.components.interfaces.component.ComponentOption
import com.checkout.components.interfaces.error.CheckoutError
import com.checkout.components.interfaces.model.ComponentName
import com.checkout.components.interfaces.model.PaymentMethodName
import com.checkout.components.interfaces.model.PaymentSessionResponse
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformViewRegistry
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.coroutines.cancel

private const val TAG = "CheckoutFlowPlugin"
private const val CHANNEL_NAME = "checkout_flow_plugin"
private const val CANNEL_VIEW = "card_form_view"

sealed class CheckoutResult {
    data class Success(val message: String) : CheckoutResult()
    data class Error(val code: String, val message: String, val details: Any? = null) : CheckoutResult()
}

/** CheckoutFlowPlugin */
class CheckoutFlowPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var checkoutComponents: CheckoutComponents? = null
    private var flowComponents: PaymentMethodComponent? = null
    private var cardComponents: PaymentMethodComponent? = null
    private var coroutineScope: CoroutineScope? = null
    private lateinit var fPluginBinding: FlutterPlugin.FlutterPluginBinding

    private val exceptionHandler = CoroutineExceptionHandler { _, throwable ->
        Log.e(TAG, "Coroutine error: ${throwable.message}", throwable)
        channel.invokeMethod("onError", CheckoutResult.Error(
            "COROUTINE_ERROR",
            throwable.message ?: "Unknown coroutine error"
        ))
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Attaching to engine")
        fPluginBinding = flutterPluginBinding;
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        coroutineScope = CoroutineScope(Dispatchers.Main + SupervisorJob() + exceptionHandler)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "Attaching to activity")
        context = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "Detached from activity for config changes")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.d(TAG, "Reattaching to activity")
        context = binding.activity
    }

    override fun onDetachedFromActivity() {
        Log.d(TAG, "Detached from activity")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "Method call received: ${call.method}")
        when (call.method) {
            "checkoutComponentConfig" -> handleCheckoutConfig(call, result)
            else -> {
                Log.w(TAG, "Method not implemented: ${call.method}")
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Detaching from engine")
        channel.setMethodCallHandler(null)
        coroutineScope?.cancel()
        coroutineScope = null
    }

    private fun handleCheckoutConfig(call: MethodCall, result: MethodChannel.Result) {
        val config = validateAndCreateConfig(call)
        if (config is CheckoutResult.Error) {
            result.error(config.code, config.message, config.details)
            return
        }

        coroutineScope?.launch(Dispatchers.IO) {
            try {
                checkoutComponents = CheckoutComponentsFactory(config =  config as CheckoutComponentConfiguration).create()
                updateComponents()

                // TODO: remove after implement further flow
                withContext(Dispatchers.Main) {
                    result.success("Checkout initialized successfully")
                }
            } catch (checkoutError: CheckoutError) {
                Log.e(TAG, "Checkout error: ${checkoutError.message}", checkoutError)
                withContext(Dispatchers.Main) {
                    result.error("CHECKOUT_ERROR", checkoutError.message ?: "Unknown checkout error", null)
                }
            } catch (e: Exception) {
                Log.e(TAG, "Unexpected error: ${e.message}", e)
                withContext(Dispatchers.Main) {
                    result.error("UNEXPECTED_ERROR", "Failed to initialize checkout: ${e.message}", null)
                }
            }
        } ?: run {
            Log.e(TAG, "Coroutine scope is null")
            result.error("INITIALIZATION_ERROR", "Plugin is not properly initialized", null)
        }
    }

    private fun validateAndCreateConfig(call: MethodCall): Any {
        val publicKey: String? = call.argument("public_key")
        val environment: String? = call.argument("environment")
        val paymentSessionId: String? = call.argument("payment_session_id")
        val paymentSessionSecret: String? = call.argument("payment_session_secret")

        if (publicKey.isNullOrBlank()) {
            return CheckoutResult.Error("INVALID_ARGUMENT", "public_key is required")
        }
        if (environment.isNullOrBlank()) {
            return CheckoutResult.Error("INVALID_ARGUMENT", "environment is required")
        }
        if (paymentSessionId.isNullOrBlank()) {
            return CheckoutResult.Error("INVALID_ARGUMENT", "payment_session_id is required")
        }
        if (paymentSessionSecret.isNullOrBlank()) {
            return CheckoutResult.Error("INVALID_ARGUMENT", "payment_session_secret is required")
        }

        return CheckoutComponentConfiguration(
            context = context,
            publicKey = publicKey,
            paymentSession = PaymentSessionResponse(
                id = paymentSessionId,
                secret = paymentSessionSecret
            ),
            environment = if (environment == "PRODUCTION") Environment.PRODUCTION else Environment.SANDBOX
        )
    }

    private fun updateComponents() {
        flowComponents = checkoutComponents?.create(ComponentName.Flow)

        cardComponents = checkoutComponents?.create(PaymentMethodName.Card)
        cardComponents?.let {
            val factory = CardFormViewFactory(
                fPluginBinding.binaryMessenger,
                it
            )
            fPluginBinding.platformViewRegistry.registerViewFactory(CANNEL_VIEW, factory)
        }
    }
}
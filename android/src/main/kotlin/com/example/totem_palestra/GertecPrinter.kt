package com.example.totem_palestra

import android.os.IBinder
import android.util.Log
import com.topwise.cloudpos.aidl.AidlDeviceService
import com.topwise.cloudpos.aidl.printer.AidlPrinter
import com.topwise.cloudpos.aidl.printer.AidlPrinterListener
import com.topwise.cloudpos.aidl.printer.PrintItemObj

/** Thin wrapper around the Topwise SDK printer used by Gertec devices. */
internal object GertecPrinter {
  private const val DEVICE_SERVICE = "topwise_cloudpos_device_service"

  private var printer: AidlPrinter? = null

  private val listener = object : AidlPrinterListener.Stub() {
    override fun onError(code: Int) {
      Log.e("GertecPrinter", "onError: $code")
    }

    override fun onPrintFinish() {}
  }

  fun printLine(text: String) {
    val printer = printer ?: connect().also { printer = it }
    printer.addRuiText(listOf(PrintItemObj(text)))
    printer.printRuiQueue(listener)
  }

  private fun connect(): AidlPrinter {
    val binder = try {
      Class.forName("android.os.ServiceManager")
        .getMethod("getService", String::class.java)
        .invoke(null, DEVICE_SERVICE) as IBinder?
    } catch (e: Exception) {
      null
    } ?: throw FlutterError("printer-unavailable", "Topwise print service not found on this device", null)

    return AidlPrinter.Stub.asInterface(AidlDeviceService.Stub.asInterface(binder).printer)
  }
}

package online.whoisthis.plugin.microcontroller

import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Binder
import android.os.IBinder
import online.whoisthis.capture.Contract
import online.whoisthis.capture.DeviceInfo
import online.whoisthis.capture.ICaptureDevice
import online.whoisthis.capture.ICaptureSink
import online.whoisthis.capture.PluginInfo
import online.whoisthis.capture.Presentation
import online.whoisthis.capture.StreamRequest

/** Exposes the CaptureDevice contract to the WhoIsThis app; every call re-checks the caller. */
class CaptureDeviceService : Service() {
    override fun onCreate() {
        super.onCreate()
        Engine.init(this)
    }

    override fun onBind(intent: Intent): IBinder? =
        if (intent.action == Contract.ACTION) binder else null

    private val binder = object : ICaptureDevice.Stub() {
        override fun contractVersion(): Int = guard { Contract.VERSION }

        override fun describe(): PluginInfo = guard {
            PluginInfo(
                id = PLUGIN_ID,
                name = getString(R.string.app_name),
                version = BuildConfig.VERSION_NAME,
                versionCode = BuildConfig.VERSION_CODE,
                sdk = "whoisthis-firmware http/${Protocol.VERSION}",
                // The board is on the local network; the plugin talks to no internet host.
                domains = emptyList(),
                permissions = requestedPermissions(),
            )
        }

        override fun listDevices(): List<DeviceInfo> = guard { Engine.listDevices() }

        override fun start(deviceId: String, request: StreamRequest, sink: ICaptureSink) = guard {
            Engine.start(deviceId, request, sink); Unit
        }

        override fun stop() = guard { Engine.stop(); Unit }
        override fun release(slot: Int) = guard { Engine.release(slot) }
        override fun present(presentation: Presentation) = guard { Engine.present(presentation); Unit }
    }

    private inline fun <T> guard(block: () -> T): T {
        val ok = Callers.trusted(packageManager, Binder.getCallingUid(), BuildConfig.TRUSTED_CALLER_SHA256, BuildConfig.ALLOW_ANY_CALLER)
        if (!ok) throw SecurityException("caller is not the WhoIsThis app")
        return block()
    }

    private fun requestedPermissions(): List<String> =
        packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
            .requestedPermissions.orEmpty().map { it.removePrefix("android.permission.") }

    companion object {
        const val PLUGIN_ID = "microcontroller"
    }
}

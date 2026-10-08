package online.whoisthis.plugin.microcontroller

import android.content.ComponentName
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.pm.PackageManager
import online.whoisthis.capture.Contract
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [35])
class ManifestTest {
    private val ctx = RuntimeEnvironment.getApplication()

    @Test
    fun serviceAnswersTheContractActionWithIdAndVersion() {
        val pm = ctx.packageManager
        val services = pm.queryIntentServices(Intent(Contract.ACTION), PackageManager.GET_META_DATA)
        val s = services.single { it.serviceInfo.packageName == ctx.packageName }.serviceInfo
        assertTrue(s.exported)
        assertEquals(Contract.VERSION, s.metaData.getInt(Contract.META_VERSION))
        assertEquals(CaptureDeviceService.PLUGIN_ID, s.metaData.getString(Contract.META_PLUGIN_ID))
    }

    @Test
    fun foldRotationAndFontChangesDoNotRecreateThePluginActivity() {
        val info = ctx.packageManager.getActivityInfo(ComponentName(ctx, PluginActivity::class.java), 0)
        val needed = ActivityInfo.CONFIG_ORIENTATION or ActivityInfo.CONFIG_SCREEN_SIZE or
            ActivityInfo.CONFIG_SMALLEST_SCREEN_SIZE or ActivityInfo.CONFIG_SCREEN_LAYOUT or
            ActivityInfo.CONFIG_DENSITY or ActivityInfo.CONFIG_FONT_SCALE or ActivityInfo.CONFIG_UI_MODE
        assertEquals(needed, info.configChanges and needed)
    }
}

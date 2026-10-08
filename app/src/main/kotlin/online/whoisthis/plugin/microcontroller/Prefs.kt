package online.whoisthis.plugin.microcontroller

import android.content.Context

object Prefs {
    private const val FILE = "plugin"
    private const val HOST = "manual_host"

    /** A board address typed on the plugin screen; discovery finds the rest. */
    fun manualHost(ctx: Context): String? =
        ctx.getSharedPreferences(FILE, Context.MODE_PRIVATE).getString(HOST, null)?.takeIf { it.isNotBlank() }

    fun setManualHost(ctx: Context, host: String) =
        ctx.getSharedPreferences(FILE, Context.MODE_PRIVATE).edit().putString(HOST, host.trim()).apply()
}

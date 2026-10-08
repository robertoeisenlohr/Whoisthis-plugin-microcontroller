package online.whoisthis.plugin.microcontroller

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** Lists boards, lets you add one by address, and mirrors the running capture. */
class PluginActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_plugin)
        Engine.init(this)

        val host = findViewById<EditText>(R.id.host).apply { setText(Prefs.manualHost(this@PluginActivity) ?: "") }
        findViewById<Button>(R.id.discover).setOnClickListener {
            Engine.setManualHost(host.text.toString())
            Engine.refresh()
        }
        findViewById<Button>(R.id.connect).setOnClickListener {
            Engine.setManualHost(host.text.toString())
            val typed = host.text.toString().trim()
            val target = typed.ifBlank { Engine.boards.value.firstOrNull()?.host.orEmpty() }
            if (target.isNotBlank()) Engine.connectLocally(target)
        }
        findViewById<Button>(R.id.disconnect).setOnClickListener { Engine.disconnectLocally() }

        val status = findViewById<TextView>(R.id.status)
        val devices = findViewById<TextView>(R.id.devices)
        val display = findViewById<TextView>(R.id.display)
        lifecycleScope.launch { Engine.status.collect { status.text = it } }
        lifecycleScope.launch { Engine.boards.collect { devices.text = Panel.boards(it) } }
        lifecycleScope.launch { Engine.display.collect { display.text = it } }

        val facts = findViewById<TextView>(R.id.facts)
        val thumbnail = findViewById<ImageView>(R.id.thumbnail)
        lifecycleScope.launch {
            var shown: ByteArray? = null
            Engine.facts.collect { f ->
                facts.text = Panel.facts(f)
                if (f.thumbnail !== shown) {
                    shown = f.thumbnail
                    thumbnail.setImageBitmap(f.thumbnail?.let { withContext(Dispatchers.Default) { decodeThumbnail(it) } })
                }
            }
        }
    }

    override fun onStart() {
        super.onStart()
        Engine.refresh()
    }

    private fun decodeThumbnail(jpeg: ByteArray): Bitmap? {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeByteArray(jpeg, 0, jpeg.size, bounds)
        var sample = 1
        while (maxOf(bounds.outWidth, bounds.outHeight) / (sample * 2) >= THUMBNAIL_PX) sample *= 2
        return BitmapFactory.decodeByteArray(jpeg, 0, jpeg.size, BitmapFactory.Options().apply { inSampleSize = sample })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    private companion object {
        const val THUMBNAIL_PX = 480
    }
}

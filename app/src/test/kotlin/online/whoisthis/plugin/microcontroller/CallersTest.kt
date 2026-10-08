package online.whoisthis.plugin.microcontroller

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class CallersTest {
    private val pin = "a8bbafbccb1e2cbd26ed94967bd3bca52617dc77fdf8a9eae3467c6c42d6ff06"

    @Test
    fun appPackageWithPinnedSignerIsTrusted() {
        assertTrue(Callers.trusted("online.whoisthis.whoisthis", listOf(pin.uppercase()), pin, allowAnySigner = false))
    }

    @Test
    fun otherSignerIsRejectedUnlessDebug() {
        val other = "0".repeat(64)
        assertFalse(Callers.trusted("online.whoisthis.whoisthis", listOf(other), pin, allowAnySigner = false))
        assertTrue(Callers.trusted("online.whoisthis.whoisthis", listOf(other), pin, allowAnySigner = true))
    }

    @Test
    fun otherPackageIsRejectedEvenInDebug() {
        assertFalse(Callers.trusted("com.example.other", listOf(pin), pin, allowAnySigner = true))
        assertFalse(Callers.trusted("online.whoisthis.whoisthis", emptyList(), pin, allowAnySigner = false))
    }

    @Test
    fun sha256IsLowercaseHex() {
        assertEquals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", Callers.sha256(ByteArray(0)))
    }
}

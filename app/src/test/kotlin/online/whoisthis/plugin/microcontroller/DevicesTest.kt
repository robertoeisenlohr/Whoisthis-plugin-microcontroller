package online.whoisthis.plugin.microcontroller

import online.whoisthis.capture.Capability
import online.whoisthis.capture.DeviceState
import org.junit.Assert.assertEquals
import org.junit.Test

class DevicesTest {
    private val found = Board("192.168.1.10", "whoisthis-cam-ab12", "XIAO ESP32-S3 Sense", listOf(Capability.CAMERA_STILL, Capability.CAMERA_STREAM), 81, Board.Source.MDNS)

    @Test
    fun txtCapabilitiesAreFilteredToContractIds() {
        assertEquals(listOf(Capability.CAMERA_STILL, Capability.BATTERY), Devices.capabilities("camera.still, battery,laser"))
        assertEquals(emptyList<String>(), Devices.capabilities(null))
    }

    @Test
    fun typedHostJoinsDiscoveredBoardsWithoutDuplicates() {
        assertEquals(listOf(found), Devices.merge(listOf(found), "192.168.1.10"))
        val merged = Devices.merge(listOf(found), "cam.local")
        assertEquals(listOf("192.168.1.10", "cam.local"), merged.map { it.host })
        assertEquals(Board.Source.MANUAL, merged[1].source)
        assertEquals(emptyList<Board>(), Devices.merge(emptyList(), "  "))
    }

    @Test
    fun descriptorUsesHostAsIdAndAssumesCameraUntilTheBoardAnswers() {
        val d = Devices.info(Board("cam.local", "cam.local"), DeviceState.READY, "")
        assertEquals("cam.local", d.id)
        assertEquals(Devices.assumedCapabilities, d.capabilities)
        assertEquals(Devices.MODEL, d.model)
        assertEquals(DeviceState.READY, d.state)
    }

    @Test
    fun statusRefinesATypedBoardButKeepsAnMdnsName() {
        val s = BoardStatus("id", "XIAO ESP32-S3 Sense", "1.0.0", 1, listOf(Capability.CAMERA_STILL), 50, 82)
        val typed = Board("cam.local", "cam.local").withStatus(s)
        assertEquals("XIAO ESP32-S3 Sense", typed.name)
        assertEquals(82, typed.streamPort)
        assertEquals("whoisthis-cam-ab12", found.withStatus(s).name)
    }

    @Test
    fun setupPlaceholderSendsTheUserToThePluginScreen() {
        val d = Devices.setup()
        assertEquals(Devices.SETUP, d.id)
        assertEquals(DeviceState.SETUP_REQUIRED, d.state)
        assertEquals("open_plugin", d.detail)
    }
}

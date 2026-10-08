package online.whoisthis.plugin.microcontroller

import android.content.pm.PackageManager
import android.content.pm.SigningInfo
import java.security.MessageDigest

/** Decides which binder callers the service answers: the WhoIsThis app, signed with the pinned key. */
object Callers {
    fun trusted(pm: PackageManager, uid: Int, trustedSha256: String, allowAnySigner: Boolean): Boolean {
        val pkgs = pm.getPackagesForUid(uid) ?: return false
        return pkgs.any { trusted(it, signers(pm, it), trustedSha256, allowAnySigner) }
    }

    fun trusted(pkg: String, signers: List<String>, trustedSha256: String, allowAnySigner: Boolean): Boolean =
        pkg == online.whoisthis.capture.Contract.APP_PACKAGE &&
            (allowAnySigner || signers.any { it.equals(trustedSha256, ignoreCase = true) })

    fun signers(pm: PackageManager, pkg: String): List<String> {
        val info = runCatching {
            pm.getPackageInfo(pkg, PackageManager.GET_SIGNING_CERTIFICATES).signingInfo
        }.getOrNull() ?: return emptyList()
        return certificates(info).map(::sha256)
    }

    private fun certificates(info: SigningInfo) =
        (if (info.hasMultipleSigners()) info.apkContentsSigners else info.signingCertificateHistory)
            .orEmpty().map { it.toByteArray() }

    fun sha256(bytes: ByteArray): String =
        MessageDigest.getInstance("SHA-256").digest(bytes).joinToString("") { "%02x".format(it) }
}

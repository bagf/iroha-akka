package co.consultsafe.iroha

import co.consultsafe.iroha.Utils.{hash, toHex}
import iroha.protocol
import jp.co.soramitsu.crypto.ed25519.Ed25519Sha3

import java.security.KeyPair

object Signature {
  def sign(t: protocol.Transaction.Payload, kp: KeyPair): protocol.Signature = {
    val rawSignature = new Ed25519Sha3().rawSign(hash(t), kp)
    protocol.Signature(toHex(kp.getPublic.getEncoded), toHex(rawSignature))
  }

  def sign(t: protocol.Query, kp: KeyPair): protocol.Signature = {
    val rawSignature = new Ed25519Sha3().rawSign(hash(t), kp)
    protocol.Signature(toHex(kp.getPublic.getEncoded), toHex(rawSignature))
  }
}

package iroha

import akka.actor.ActorSystem
import akka.grpc.GrpcClientSettings
import akka.pattern.pipe
import akka.stream.scaladsl.{Sink, Source}
import akka.testkit.{TestKit, TestProbe}
import iroha.protocol._
import jp.co.soramitsu.crypto.ed25519.Ed25519Sha3
import net.cimadai.iroha.{Account, Implicits, Payload, Status, Utils, Batch => IrohaBatch, QueryResponse => IrohaResponse}
import org.scalatest.BeforeAndAfterAll
import org.scalatest.wordspec.AnyWordSpecLike

import java.util.UUID
import scala.collection.immutable
import scala.concurrent.ExecutionContext
import scala.concurrent.duration._
import scala.util.Random

class IrohaSpec extends TestKit(ActorSystem(classOf[IrohaSpec].getSimpleName)) with AnyWordSpecLike with BeforeAndAfterAll {
  import Implicits._

  override def afterAll(): Unit = {
    TestKit.shutdownActorSystem(system)
  }

  implicit val executionContext: ExecutionContext = system.dispatcher

  // Take details how to connect to the service from the config.
  private lazy val clientSettings = GrpcClientSettings.fromConfig("iroha")
  // Create a client-side stub for the service
  private lazy val commandClient: CommandService_v1 = CommandService_v1Client(clientSettings)
  private lazy val queryClient: QueryService_v1Client = QueryService_v1Client(clientSettings)
  private val crypto = new Ed25519Sha3()
  private def randomString(length: Int = 64) = Random.alphanumeric.take(length).mkString("")

//  override implicit val patienceConfig: PatienceConfig = PatienceConfig(Futures.scaled(Span(60, Seconds)), Futures.scaled(Span(15, Millis)))

  private def successfulResponses(hashHex: String) = immutable.Seq(
    ToriiResponse(TxStatus.ENOUGH_SIGNATURES_COLLECTED, hashHex),
    ToriiResponse(TxStatus.STATEFUL_VALIDATION_SUCCESS, hashHex),
    ToriiResponse(TxStatus.COMMITTED, hashHex)
  )

  val irohaDomain = s"uuid${UUID.randomUUID().toString}.test"
  val irohaRole = "user"
  val irohaAdminKeypair = Utils.parseHexKeypair(
    "313a07e6384776ed95447710d15e59148473ccfc052a681317a72a69f2a49910",
    "f101537e319568c765b2cc89698325604991dca57b9716b58016b253506cab70"
  )
  val irohaAdminAccount = Account("admin@test")
  val irohaIrohaAsset1 = randomString(6).toLowerCase
  val irohaAccount1 = s"r${randomString(5).toLowerCase}m"
  val irohaAccount1Keypair = crypto.generateKeypair()
  val irohaAccount2 = s"r${randomString(5).toLowerCase}m"
  val irohaAccount2Keypair = crypto.generateKeypair()
  val irohaAccount3 = s"r${randomString(5).toLowerCase}m"
  val irohaAccount3Keypair = crypto.generateKeypair()

  "IrohaSpec" when {
    "Setup new domain, assets and add amounts" should {
      "create new domain" in {
        val probe = TestProbe()
        val command = new Command().update(_.createDomain.set(
          protocol.CreateDomain(irohaDomain, irohaRole)
        ))
        val tx = Payload.createFromCommand(command, irohaAdminAccount).transaction

        Source.future(commandClient.torii(tx.sign(irohaAdminKeypair)))
          .flatMapConcat(_ => commandClient.statusStream(TxStatusRequest(tx.hashHex)))
          .takeWhile(Status.isNotFinalStatus, inclusive = true)
          .completionTimeout(30.seconds)
          .runWith(Sink.seq)
          .pipeTo(probe.ref)

        probe.expectMsg(successfulResponses(tx.hashHex))
      }
      "create new asset" in {
        val probe = TestProbe()
        val command = new Command().update(_.createAsset.set(
          CreateAsset(irohaIrohaAsset1, irohaDomain, 2)
        ))
        val tx = Payload.createFromCommand(command, irohaAdminAccount).transaction

        Source.future(commandClient.torii(tx.sign(irohaAdminKeypair)))
          .flatMapConcat(_ => commandClient.statusStream(TxStatusRequest(tx.hashHex)))
          .takeWhile(Status.isNotFinalStatus, inclusive = true)
          .completionTimeout(30.seconds)
          .runWith(Sink.seq)
          .pipeTo(probe.ref)

        probe.expectMsg(successfulResponses(tx.hashHex))
      }
      "create new first account" in {
        val probe = TestProbe()
        val command = new Command().update(_.createAccount.set(
          CreateAccount(irohaAccount1, irohaDomain, irohaAccount1Keypair.getPublic.hashHex)
        ))

        val tx = Payload.createFromCommand(command, irohaAdminAccount).transaction

        Source.future(commandClient.torii(tx.sign(irohaAdminKeypair)))
          .flatMapConcat(_ => commandClient.statusStream(TxStatusRequest(tx.hashHex)))
          .takeWhile(Status.isNotFinalStatus, inclusive = true)
          .completionTimeout(30.seconds)
          .runWith(Sink.seq)
          .pipeTo(probe.ref)

        probe.expectMsg(successfulResponses(tx.hashHex))
      }
      "create new second account" in {
        val probe = TestProbe()
        val command = new Command().update(_.createAccount.set(
          CreateAccount(irohaAccount2, irohaDomain, irohaAccount2Keypair.getPublic.hashHex)
        ))

        val tx = Payload.createFromCommand(command, irohaAdminAccount).transaction

        Source.future(commandClient.torii(tx.sign(irohaAdminKeypair)))
          .flatMapConcat(_ => commandClient.statusStream(TxStatusRequest(tx.hashHex)))
            .takeWhile(Status.isNotFinalStatus, inclusive = true)
            .completionTimeout(30.seconds)
            .runWith(Sink.seq)
            .pipeTo(probe.ref)

          probe.expectMsg(successfulResponses(tx.hashHex))
        }
      }
      "add asset amount of 100.24 to account" in {
        val probe = TestProbe()
        val command = new Command().update(_.addAssetQuantity.set(
          AddAssetQuantity(s"$irohaIrohaAsset1#$irohaDomain", "100.24")
        ))

        val tx = Payload.createFromCommand(command, irohaAdminAccount).transaction

        Source.future(commandClient.torii(tx.sign(irohaAdminKeypair)))
          .flatMapConcat(_ => commandClient.statusStream(TxStatusRequest(tx.hashHex)))
          .takeWhile(Status.isNotFinalStatus, inclusive = true)
          .completionTimeout(30.seconds)
          .runWith(Sink.seq)
          .pipeTo(probe.ref)

        probe.expectMsg(successfulResponses(tx.hashHex))
      }
      "transfer amount of 100.24 from admin account" in {
        val probe = TestProbe()
        val command = new Command().update(_.transferAsset.set(
          TransferAsset(irohaAdminAccount.toIrohaString, Account(irohaAccount1, irohaDomain).toIrohaString, s"$irohaIrohaAsset1#$irohaDomain", "Transfer test", "100.24")
        ))

        val tx = Payload.createFromCommand(command, irohaAdminAccount).transaction

        Source.future(commandClient.torii(tx.sign(irohaAdminKeypair)))
          .flatMapConcat(_ => commandClient.statusStream(TxStatusRequest(tx.hashHex)))
          .takeWhile(Status.isNotFinalStatus, inclusive = true)
          .completionTimeout(30.seconds)
          .runWith(Sink.seq)
          .pipeTo(probe.ref)

        probe.expectMsg(successfulResponses(tx.hashHex))
      }
      "append money_creator role for second account" in {
        val probe = TestProbe()
        val command = new Command().update(_.appendRole.set(
          AppendRole(Account(irohaAccount2, irohaDomain).toIrohaString, "money_creator")
        ))

        val tx = Payload.createFromCommand(command, irohaAdminAccount).transaction

        Source.future(commandClient.torii(tx.sign(irohaAdminKeypair)))
          .flatMapConcat(_ => commandClient.statusStream(TxStatusRequest(tx.hashHex)))
          .takeWhile(Status.isNotFinalStatus, inclusive = true)
          .completionTimeout(30.seconds)
          .runWith(Sink.seq)
          .pipeTo(probe.ref)

        probe.expectMsg(successfulResponses(tx.hashHex))
      }
      "add amount of 100123.01 to admin account and transfer to new account and transfer back to first account" in {
        val addAssetQtyCommand = new Command().update(_.addAssetQuantity.set(
          AddAssetQuantity(s"$irohaIrohaAsset1#$irohaDomain", "100123.01")
        ))

        val createAccountCommand = new Command().update(_.createAccount.set(
          CreateAccount(irohaAccount3, irohaDomain, irohaAccount3Keypair.getPublic.hashHex)
        ))

        val transferCommand = new Command().update(_.transferAsset.set(
          TransferAsset(Account(irohaAccount2, irohaDomain).toIrohaString, Account(irohaAccount3, irohaDomain).toIrohaString, s"$irohaIrohaAsset1#$irohaDomain", "Transfer test 2", "100123.01")
        ))

        val transferBackCommand = new Command().update(_.transferAsset.set(
          TransferAsset(Account(irohaAccount3, irohaDomain).toIrohaString, Account(irohaAccount1, irohaDomain).toIrohaString, s"$irohaIrohaAsset1#$irohaDomain", "Transfer test 3", "100123.01")
        ))

        val batch = IrohaBatch.createTxOrderedBatch(Seq(
          Payload.createFromCommand(addAssetQtyCommand, Account(irohaAccount2, irohaDomain)).transaction,
          Payload.createFromCommand(createAccountCommand, irohaAdminAccount).transaction,
          Payload.createFromCommand(transferCommand, Account(irohaAccount2, irohaDomain)).transaction,
          Payload.createFromCommand(transferBackCommand, Account(irohaAccount3, irohaDomain)).transaction
        ))

        val signedBatch = Seq(
          batch(0).sign(irohaAccount2Keypair),
          batch(1).sign(irohaAdminKeypair),
          batch(2).sign(irohaAccount2Keypair),
          batch(3).sign(irohaAccount3Keypair)
        )

        for {
          _ <- commandClient.listTorii(TxList(signedBatch))
          statuses1 <- commandClient
            .statusStream(TxStatusRequest(signedBatch(0).hashHex))
            .takeWhile(Status.isNotFinalStatus, inclusive = true)
            .completionTimeout(30.seconds)
            .runWith(Sink.seq)

          statuses2 <- commandClient
            .statusStream(TxStatusRequest(signedBatch(1).hashHex))
            .takeWhile(Status.isNotFinalStatus, inclusive = true)
            .completionTimeout(30.seconds)
            .runWith(Sink.seq)

          statuses3 <- commandClient
            .statusStream(TxStatusRequest(signedBatch(2).hashHex))
            .takeWhile(Status.isNotFinalStatus, inclusive = true)
            .completionTimeout(30.seconds)
            .runWith(Sink.seq)

          statuses4 <- commandClient
            .statusStream(TxStatusRequest(signedBatch(3).hashHex))
            .takeWhile(Status.isNotFinalStatus, inclusive = true)
            .completionTimeout(30.seconds)
            .runWith(Sink.seq)
        } yield {
          assert(statuses1.contains(ToriiResponse(TxStatus.COMMITTED, signedBatch(0).hashHex)))
          assert(statuses2.contains(ToriiResponse(TxStatus.COMMITTED, signedBatch(1).hashHex)))
          assert(statuses3.contains(ToriiResponse(TxStatus.COMMITTED, signedBatch(2).hashHex)))
          assert(statuses4.contains(ToriiResponse(TxStatus.COMMITTED, signedBatch(3).hashHex)))
        }
      }

      "query admin account" in {
        val probe = TestProbe()
        val payload = Payload.createEmptyQuery(irohaAdminAccount).update(_.getAccountAssets.set(GetAccountAssets(irohaAdminAccount.toIrohaString)))

        queryClient.find(payload.toQuery.sign(irohaAdminKeypair))
          .collect {
            case IrohaResponse(IrohaResponse.AccountAssetsResponse(response)) => true
          }
          .pipeTo(probe.ref)

        probe.expectMsg(true)
      }

      "query admin account transactions" in {
        val probe = TestProbe()
        val meta = Option(TxPaginationMeta(pageSize = 1))
        val payload = Payload.createEmptyQuery(irohaAdminAccount)
          .update(_.getAccountTransactions.set(GetAccountTransactions(irohaAdminAccount.toIrohaString, meta)))

        queryClient.find(payload.toQuery.sign(irohaAdminKeypair))
          .collect {
            case IrohaResponse(IrohaResponse.TransactionsPageResponse(response)) => true
          }
          .pipeTo(probe.ref)

        probe.expectMsg(true)
    }
  }
}


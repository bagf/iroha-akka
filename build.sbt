name := "iroha-akka"
scalaVersion := "2.13.5"
organization := "com.consultsafesoftware"
version := s"1.0.${sys.env.getOrElse("JB_SPACE_EXECUTION_NUMBER", "0")}"
ThisBuild / versionScheme := Some("early-semver")

val AkkaVersion = "2.6.14"
val ScalaTestVersion = "3.2.7"
val silencerVersion = "1.7.0"

credentials += Credentials(Path.userHome / ".sbt" / "space-maven.credentials")

resolvers += "space-maven" at "https://maven.pkg.jetbrains.space/consultsafe/p/consolidated-payments/maven"
resolvers += "jitpack" at "https://jitpack.io"
libraryDependencies ++= Seq(
  "com.typesafe.akka" %% "akka-stream" % AkkaVersion,
  "com.typesafe.akka" %% "akka-discovery" % AkkaVersion,
  "com.thesamet.scalapb" %% "scalapb-runtime" % scalapb.compiler.Version.scalapbVersion % "protobuf",
  "com.typesafe.akka" %% "akka-testkit" % AkkaVersion % Test,
  "com.typesafe.akka" %% "akka-stream-testkit" % AkkaVersion % Test,
  "org.scalatest" %% "scalatest" % ScalaTestVersion % Test,
  "com.github.warchant" % "ed25519-sha3-java" % "2.0.1",
  "org.scalatest" %% "scalatest" % "3.0.8" % Test
)

publishMavenStyle := true
publishArtifact in Test := false
skip in publish := false
sources in (Compile,doc) := Seq.empty
publishArtifact in (Compile, packageDoc) := false
fork in Test := true
publishTo := Some("space-maven" at s"${sys.env.getOrElse("REPOSITORY_URL", "")}")

lazy val `iroha-akka` = (project in file("."))
  .enablePlugins(AkkaGrpcPlugin)

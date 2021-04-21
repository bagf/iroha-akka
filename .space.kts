import runtime.ui.displayedName

/**
* JetBrains Space Automation
* This Kotlin-script file lets you automate build activities
* For more info, see https://www.jetbrains.com/help/space/automation.html
*/

job("Unit tests") {
    container(displayName = "Run test",  image = "consultsafe.registry.jetbrains.space/p/consolidated-payments/containers/iroha-akka-sbt:latest") {
        resources {
            cpu = 1.cpu
            memory = 2000.mb
        }

        shellScript {
            content = """
                sbt "clean;compile;test"
            """
        }

        service("consultsafe.registry.jetbrains.space/p/consolidated-payments/containers/postgres-iroha-test:latest") {
            resources {
                cpu = 0.5.cpu
                memory = 100.mb
            }
            alias("postgres")
            env["POSTGRES_USER"] = "iroha"
            env["POSTGRES_PASSWORD"] = "helloworld"
        }

        service("hyperledger/iroha:1.2.1") {
            resources {
                cpu = 1.cpu
                memory = 500.mb
            }
            entrypoint("sh /mnt/space/work/iroha-akka/docker/iroha_data/run-iroha.sh")
            alias("iroha")
            env["IROHA_POSTGRES_HOST"] = "postgres"
            env["IROHA_POSTGRES_PORT"] = "5432"
            env["IROHA_POSTGRES_USER"] = "iroha"
            env["IROHA_POSTGRES_PASSWORD"] = "helloworld"
            env["KEY"] = "node0"
        }
    }
}

job("Build, publish dist") {
    startOn {
        gitPush { enabled = false }
    }

    container(displayName = "Run build and publish",  image = "consultsafe.registry.jetbrains.space/p/consolidated-payments/containers/iroha-akka-sbt:latest") {

        env["REPOSITORY_URL"] = "https://maven.pkg.jetbrains.space/consultsafe/p/consolidated-payments/maven"

        shellScript {
            content = """
                echo "realm=" > ~/.sbt/space-maven.credentials
                echo "host=maven.pkg.jetbrains.space" >> ~/.sbt/space-maven.credentials
                echo "user=${'$'}JB_SPACE_CLIENT_ID" >> ~/.sbt/space-maven.credentials
                echo "password=${'$'}JB_SPACE_CLIENT_SECRET" >> ~/.sbt/space-maven.credentials
                sbt "clean;compile;publish"
            """
        }
    }

    container(displayName = "Share the news in General", image = "openjdk:11") {
        kotlinScript { api ->
            api.space().chats.channels.messages.sendTextMessage(
                channelId = "3IvqFY3AISYG", //#general
                text = "Published build #"+ api.executionNumber() +" of " + api.gitRepositoryName()
            )
        }
    }
}

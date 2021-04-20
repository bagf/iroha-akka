/**
* JetBrains Space Automation
* This Kotlin-script file lets you automate build activities
* For more info, see https://www.jetbrains.com/help/space/automation.html
*/

//job("tests") {
//    container(displayName = "sbt clean;compile;test", image = "iroha-akka-sbt") {
//
//    }
//}

job("Build, publish dist") {
    container(displayName = "Run sbt using OpenJDK 11", image = "consultsafe.registry.jetbrains.space/p/consolidated-payments/containers/iroha-akka-sbt:latest") {
        env["REPOSITORY_URL"] = "https://maven.pkg.jetbrains.space/consultsafe/p/consolidated-payments/maven"

        shellScript {
            content = """
                echo Build...
                sbt "clean;compile"
                echo Publish artifacts...
                echo "realm=" > ~/.sbt/space-maven.credentials
                echo "host=maven.pkg.jetbrains.space" >> ~/.sbt/space-maven.credentials
                echo "user=${'$'}JB_SPACE_CLIENT_ID" >> ~/.sbt/space-maven.credentials
                echo "password=${'$'}JB_SPACE_CLIENT_SECRET" >> ~/.sbt/space-maven.credentials
                cat ~/.sbt/space-maven.credentials
                sbt "publish"
            """
        }
        kotlinScript { api ->
            api.space().chats.channels.messages.sendTextMessage(
                channelId = "3IvqFY3AISYG", //#general
                text = "Published build #"+ api.executionNumber() +" of " + api.gitRepositoryName()
            )
        }
    }
}

//job("Hello World!") {
//    //container(displayName = "Say Hello", image = "hello-world")
//    container(image = "openjdk:11") {
//        kotlinScript { api ->
//            api.space().chats.channels.messages.sendTextMessage(
//                channelId = "3IvqFY3AISYG", //#general
//                text = "Hello world from iroha-akka ("+ api.projectId() +") repo!"
//            )
//        }
//    }
//}

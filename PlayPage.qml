import QtQuick 2.0

Item {
    id: playpage
    anchors.fill: parent
    Rectangle{
        id: mrect
        anchors.fill: parent
        color: "black"
        Rectangle{
            id: art
            width: mrect.width/2
            height: width
            anchors.horizontalCenter: mrect.horizontalCenter
            anchors.top: mrect.top
            anchors.margins: 100
            color: "black"
            border.color: "#acee48"
            radius: 5
            border.width: 4
            Image{
                id: dfltart
                anchors.centerIn: parent
                width: parent.width*0.7
                height: width
                source: "dfltart.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text{
            id: title
            anchors.horizontalCenter: mrect.horizontalCenter
            anchors.top: art.bottom
            anchors.margins: playpage.height*0.05
            color: "#acee48"
            font.bold: true
            text: "Title"
            font.pixelSize: playpage.height*0.05
        }
        Text{
            id: artist
            anchors.horizontalCenter: mrect.horizontalCenter
            anchors.top: title.bottom
            anchors.margins: playpage.height*0.05
            color: "#acee48"
            font.bold: true
            text: "Artist"
            font.pixelSize: playpage.height*0.05
        }
        Text{
            id: album
            anchors.horizontalCenter: mrect.horizontalCenter
            anchors.top: artist.bottom
            anchors.margins: playpage.height*0.05
            color: "#acee48"
            font.bold: true
            text: "Album"
            font.pixelSize: playpage.height*0.05
        }

        Rectangle{
            id: progress
            height: 5
            width: mrect.width*0.8
            anchors.horizontalCenter: mrect.horizontalCenter
            anchors.bottom: play.top
            anchors.margins: playpage.height*0.05
            color: "black"//"#acee48"
            border.color: "#acee48"
            radius: 2
            Rectangle{
                id: activeprogress
                height: 5
                width: mrect.width*0.4
                anchors.bottom: progress.bottom
                anchors.left: progress.left
                color: "#acee48"
                radius: 2
            }
        }

        Image {
            id: play
            width: playpage.width/5
            height: width
            anchors.bottom: mrect.bottom
            anchors.horizontalCenter: mrect.horizontalCenter
            source: "play.png"
            fillMode: Image.PreserveAspectFit
            anchors.margins: 50
            Behavior on scale {
                PropertyAnimation {
                    duration: 100
                }
            }
            MouseArea{
                anchors.fill: parent
                onPressed: play.scale = 1.3
                onReleased: {
                    play.scale = 1.0
                    play.visible = false
                    pause.visible = true
                }
            }
        }
        Image {
            id: pause
            width: playpage.width/5
            height: width
            anchors.bottom: mrect.bottom
            anchors.horizontalCenter: mrect.horizontalCenter
            source: "pause.png"
            visible: false
            fillMode: Image.PreserveAspectFit
            anchors.margins: 50
            Behavior on scale {
                PropertyAnimation {
                    duration: 100
                }
            }
            MouseArea{
                anchors.fill: parent
                onPressed: pause.scale = 1.3
                onReleased: {
                    pause.scale = 1.0
                    pause.visible = false
                    play.visible = true
                }
            }
        }
        Image {
            id: stop
            width: playpage.width/5
            height: width
            anchors.bottom: mrect.bottom
            anchors.horizontalCenter: mrect.horizontalCenter
            source: "stop.png"
            visible: false
            fillMode: Image.PreserveAspectFit
            anchors.margins: 50
            Behavior on scale {
                PropertyAnimation {
                    duration: 100
                }
            }
            MouseArea{
                anchors.fill: parent
                onPressed: stop.scale = 1.3
                onReleased: stop.scale = 1.0
            }
        }
        Image {
            id: bward
            width: playpage.width/5
            height: width
            anchors.bottom: mrect.bottom
            anchors.right: play.left
            source: "bward.png"
            fillMode: Image.PreserveAspectFit
            anchors.margins: 50
            Behavior on scale {
                PropertyAnimation {
                    duration: 65
                }
            }
            MouseArea{
                anchors.fill: parent
                onPressed: bward.scale = 1.3
                onReleased: bward.scale = 1.0
            }
        }
        Image {
            id: fward
            width: playpage.width/5
            height: width
            anchors.bottom: mrect.bottom
            anchors.left: play.right
            source: "fward.png"
            fillMode: Image.PreserveAspectFit
            anchors.margins: 50
            Behavior on scale {
                PropertyAnimation {
                    duration: 65
                }
            }
            MouseArea{
                anchors.fill: parent
                onPressed: fward.scale = 1.3
                onReleased: fward.scale = 1.0
            }
        }
    }
}

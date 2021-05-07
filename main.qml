import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.12

ApplicationWindow {
    title: qsTr("Nano Cross Chat Bot")
    width: 480
    height: 800
    visible: true

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        ListModel {
            id: chatModel
            ListElement {
                chat: "Loading..."
                side: 2
            }
        }

        ListView {
            id: chatScreen
            width: parent.width
            height: parent.height*0.9 - 10
            model: chatModel
            delegate: Rectangle {
                width: parent.width*0.9
                height: chatInput.height*0.6

                Rectangle {
                    width: parent.width*0.9
                    height: parent.height*0.9
                    radius: 5
                    color: side == 0 ? "lightgreen" : side == 1 ? "lightblue" : "white"
                    border.width: 1
                    border.color: side == 0 ? "green" : side == 1 ? "blue" : "white"
                    x: side == 0 ? parent.width*0.2 : side == 1 ? 0 : 0

                    Text {
                        anchors.centerIn: parent
                        text: qsTr(chat)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Connections {
                target: bot

                function onSetResponse(res) {
                    chatModel.append({chat: res, side:1})
                }
            }
        }

        TextField {
            id: chatInput
            placeholderText: qsTr("Enter your query in any language")
            width: parent.width
            height: parent.height*0.1
            onAccepted: {
                chatModel.append({chat: text, side:0})
                var raw = text
                text = ""
                bot.getResponse(raw)

            }
        }
    }

    Component.onCompleted: bot.initBot()
}

import QtQuick 2.11
import CustomElements 1.0

import "qrc:/core/ui/controls"
import "qrc:/core/ui/items"


StretchColumn {
    leftMargin: 15*dp
    rightMargin: 15*dp
    defaultSize: 30*dp
    height: implicitHeight

    BlockRow {
        StretchText {
            text: "Server:"
        }
        AttributeCheckbox {
            width: 30*dp
            attr: controller.websocketConnection().serverEnabled()
        }
    }

    BlockRow {
        visible: controller.websocketConnection().serverEnabled().val
        leftMargin: 10*dp
        StretchText {
            text: "Port:"
        }
        AttributeNumericInput {
            width: 60*dp
            implicitWidth: 0
            attr: controller.websocketConnection().port()
        }
    }

    BlockRow {
        visible: controller.websocketConnection().serverEnabled().val
        leftMargin: 10*dp
        StretchText {
            width: parent.width * 0.5
            implicitWidth: 0
            text: "dynv6 Host:"
        }
        TextInput {
            width: parent.width * 0.5
            text: controller.websocketConnection().dynv6Hostname().val
            onTextChanged: {
                if (text !== controller.websocketConnection().dynv6Hostname().val) {
                    controller.websocketConnection().dynv6Hostname().val = text
                }
            }
            font.pixelSize: 16*dp
            clip: true
        }
    }

    BlockRow {
        visible: controller.websocketConnection().serverEnabled().val
        leftMargin: 10*dp
        StretchText {
            width: parent.width * 0.5
            implicitWidth: 0
            text: "dynv6 Token:"
        }
        TextInput {
            width: parent.width * 0.5
            text: controller.websocketConnection().dynv6Token().val
            onTextChanged: {
                if (text !== controller.websocketConnection().dynv6Token().val) {
                    controller.websocketConnection().dynv6Token().val = text
                }
            }
            font.pixelSize: 16*dp
            clip: true
        }
    }

    BlockRow {
        StretchText {
            text: "Client:"
        }
        StretchText {
            text: "Secure ✓ "
            hAlign: Text.AlignRight
            color: "lightgreen"
            visible: controller.websocketConnection().isConnectedToServer().val &&
                     controller.websocketConnection().serverUrl().val.startsWith("wss://")
        }

        Item {
            width: 15*dp
            Rectangle {
                width: 5*dp
                height: width
                radius: width / 2
                anchors.centerIn: parent
                color: controller.websocketConnection().isConnectedToServer().val ? "lightgreen" : "#888"
            }
        }
        AttributeCheckbox {
            width: 30*dp
            attr: controller.websocketConnection().clientEnabled()
        }
    }

    BlockRow {
        visible: controller.websocketConnection().clientEnabled().val
        leftMargin: 10*dp
        Text {
            text: "Url:"
            width: parent.width * 0.2
            verticalAlignment: Text.AlignVCenter
        }
        TextInput {
            width: parent.width * 0.8
            text: controller.websocketConnection().serverUrl().val
            onAccepted: {
                if (text !== controller.websocketConnection().serverUrl().val) {
                    controller.websocketConnection().serverUrl().val = text
                }
            }
            font.pixelSize: 16*dp
            clip: true
        }
    }
}  // end Settings Column

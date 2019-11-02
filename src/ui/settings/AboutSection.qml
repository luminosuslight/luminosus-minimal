import QtQuick 2.5
import CustomElements 1.0

import "qrc:/core/ui/controls"
import "qrc:/core/ui/items"


StretchColumn {
    leftMargin: 15*dp
    rightMargin: 15*dp
    defaultSize: 30*dp
    height: implicitHeight

    BlockRow {
        Text {
            text: "Version:"
            width: parent.width / 2
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            text: controller.getVersionString()
            width: parent.width / 2
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            color: controller.updateManager().updateIsAvailable ? "red" : "#fff"
        }
    }
    BlockRow {
        Text {
            text: "Build:"
            width: parent.width / 2
            verticalAlignment: Text.AlignVCenter
            color: "#888"
        }
        Text {
            text: "?"
            width: parent.width / 2
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            color: "#888"
        }
    }
    StretchText {
        text: "No Update Available"
        visible: !controller.updateManager().updateIsAvailable
        hAlign: Text.AlignRight
    }

    BlockRow {
        visible: controller.updateManager().updateIsAvailable
        Text {
            text: "Available:"
            width: parent.width / 2
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            text: controller.updateManager().newestStableVersionNumber
            width: parent.width / 2
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            color: "lightgreen"
        }
    }
    ButtonBottomLine {
        text: "Get Update"
        onPress: Qt.openUrlExternally("http://www.luminosus.org/download")
        visible: controller.updateManager().updateIsAvailable
    }

    BlockRow {
        Text {
            text: "Author:"
            width: parent.width / 2
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            text: "Tim Henning"
            width: parent.width / 2
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }
    }

    BlockRow {
        Text {
            text: "mail@luminosus.org"
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            CustomTouchArea {
                anchors.fill: parent
                onClick: Qt.openUrlExternally("mailto:mail@luminosus.org")
            }
        }
    }

    BlockRow {
        Text {
            text: "www.luminosus.org"
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            CustomTouchArea {
                anchors.fill: parent
                onClick: Qt.openUrlExternally("https://www.luminosus.org")
            }
        }
	}
}  // end About column

import QtQuick 2.5
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window 2.2
import CustomElements 1.0

import "qrc:/core/ui/controls"
import "qrc:/core/ui/items"

Item {

    Rectangle {  // left border
        width: 1
        height: parent.height
        color: "#aaa"
    }

    Item {
        id: tabs
        width: parent.width
        height: 40*dp
        // leave a margin at the top for iPhone X:
        y: Qt.platform.os === "ios" ? parent.height - Screen.desktopAvailableHeight : 0

		StretchRow {
			anchors.fill: parent
			DrawerTabButton {
				iconName: "add_icon"
				onPress: { tabView.currentIndex = 0 }
				marked: tabView.currentIndex === 0
			}
			DrawerTabButton {
				iconName: "settings_slider_icon"
				onPress: { tabView.currentIndex = 1 }
				marked: tabView.currentIndex === 1
			}
			DrawerTabButton {
				iconName: "save_icon"
				onPress: { tabView.currentIndex = 2 }
				marked: tabView.currentIndex === 2
			}
			DrawerTabButton {
				iconName: "gear_icon"
				onPress: { tabView.currentIndex = 3 }
				marked: tabView.currentIndex === 3
			}
		}
        Rectangle {  // line under tabs
            height: 1*dp
            y: parent.height
            width: parent.width
            color: "#aaa"
        }
    }

	StackLayout {
		id: tabView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: tabs.bottom
		//tabsVisible: false
        currentIndex: 0

		BlockListDrawerContent {}
		BlockSettingsDrawerContent {}
		ProjectsDrawerContent {}
		SettingsDrawerContent {}
    }

    Connections {
        target: guiManager
        onOpenBlockSettings: {
            if (tabView.currentIndex !== 1) {
                tabView.currentIndex = 1
            }
        }
    }

}


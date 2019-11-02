import QtQuick 2.4
import QtQuick.Window 2.2
import CustomElements 1.0
import "qrc:/core/ui/controls"
import "qrc:/core/ui/items"
import "qrc:/ui/settings"


VerticalScrollView {
	contentItem: root
    anchors.topMargin: 10*dp

	StretchColumn {
		id: root
		width: parent.width
		height: implicitHeight
		defaultSize: 30*dp
		// height will be minimum height for all fixed sized items

		HorizontalDivider {  // ------------------------------------------------------
			visible: false
        }

        SettingsCategory {
            name: "Websocket"

            WebsocketSettings {
                visible: !parent.collapsed
            }
        }

		HorizontalDivider {  // ------------------------------------------------------
        }

        SettingsCategory {
            name: "GUI"

            GuiSettings {
                visible: !parent.collapsed
            }
        }

		HorizontalDivider {  // ------------------------------------------------------
        }

        SettingsCategory {
            name: "About"
            collapsed: true

            AboutSection {
                visible: !parent.collapsed
            }
        }

        Item {
            height: 20*dp
        }

        BlockRow {
            leftMargin: 20*dp
            rightMargin: 20*dp
            Rectangle {
                implicitWidth: -1  // stretch
                color: Qt.rgba(1, 0, 0, 0.2)
                ButtonBottomLine {
                    anchors.fill: parent
                    text: "QUIT"
                    onPress: Qt.quit()
                }
            }
        }

	}  // end main Column
}  // end Flickable


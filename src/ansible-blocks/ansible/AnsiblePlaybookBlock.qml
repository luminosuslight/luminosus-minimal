import QtQuick 2.12
import QtQuick.Dialogs 1.2
import CustomElements 1.0
import "qrc:/core/ui/items"
import "qrc:/core/ui/controls"

BlockBase {
    id: root
    width: 600*dp
    height: 400*dp
    onWidthChanged: block.positionChanged()

    StretchColumn {
        id: mainColumn
        anchors.fill: parent

        BlockRow {
            height: 30*dp
            implicitHeight: 0
            leftMargin: 5*dp

            Item {
                implicitWidth: -1
                TextInput {
                    anchors.fill: parent
                    hintText: "Hosts Limit"
                    text: block.attr("hostsLimit").val
                    onDisplayTextChanged: {
                        if (displayText !== block.attr("hostsLimit").val) {
                            block.attr("hostsLimit").val = displayText
                        }
                    }
                }
            }

            Item {
                implicitWidth: -1
                TextInput {
                    anchors.fill: parent
                    hintText: "Vault Secret"
                    text: block.attr("vaultSecret").val
                    onTextChanged: {
                        if (text !== block.attr("vaultSecret").val) {
                            block.attr("vaultSecret").val = text
                        }
                    }
                    //echoMode: TextInput.Password
                }
            }

            ButtonBottomLine {
                width: 60*dp
                implicitWidth: 0
                text: "Run >"
                onPress: block.run()
            }

            ButtonBottomLine {
                width: 60*dp
                implicitWidth: 0
                text: "Stop"
                onPress: block.stop()
            }

            HeightResizeArea {
                width: 30*dp
                target: root
                maxSize: 1000*dp
            }
        }

        BlockRow {
            height: 30*dp
            implicitHeight: 0
            leftMargin: 10*dp
            rightMargin: 10*dp
            Item {
                implicitWidth: -1
                TextInput {
                    anchors.fill: parent
                    anchors.rightMargin: 5*dp
                    hintText: "Title Whitelist"
                    text: block.attr("titleWhitelist").val
                    onDisplayTextChanged: {
                        if (displayText !== block.attr("titleWhitelist").val) {
                            block.attr("titleWhitelist").val = displayText
                        }
                    }
                }
            }


            Item {
                implicitWidth: -1
                TextInput {
                    anchors.fill: parent
                    anchors.leftMargin: 5*dp
                    hintText: "Title Blacklist"
                    text: block.attr("titleBlacklist").val
                    onDisplayTextChanged: {
                        if (displayText !== block.attr("titleBlacklist").val) {
                            block.attr("titleBlacklist").val = displayText
                        }
                    }
                }
            }
        }

        Item {
            // this item either displays the listview or a label "No Messages"
            implicitHeight: -1  // stretch height

            ListView {
                id: listView
                anchors.fill: parent
                anchors.leftMargin: 10*dp
                visible: count > 0
                model: block.messagesModel()
                verticalLayoutDirection: ListView.BottomToTop
                clip: true
                delegate: StretchColumn {
                    id: messageDelegate
                    width: listView.width
                    height: collapsed ? 30*dp : implicitHeight + 10*dp
                    defaultSize: 30*dp
                    property bool collapsed: true

                    StretchText {
                        text: title
                        font.family: "BPmono"
                        color: model.color || "#ccc"
                        CustomTouchArea {
                            anchors.fill: parent
                            onClick: messageDelegate.collapsed = !messageDelegate.collapsed
                        }
                    }

                    Text {
                        visible: !collapsed
                        wrapMode: Text.Wrap
                        text: model.content
                        font.pixelSize: 14*dp
                        font.family: "BPmono"
                        color: "#eee"
                        enabled: false
                        lineHeight: 1.5
                        onTextChanged: guiManager.setPropertyWithoutChangingBindings(this, "height", contentHeight)
                        onWidthChanged: guiManager.setPropertyWithoutChangingBindings(this, "height", contentHeight)
                        Component.onCompleted: guiManager.setPropertyWithoutChangingBindings(this, "height", contentHeight)
                    }
                }  // end delegate
                Component.onCompleted: positionViewAtEnd()
            }

            ButtonSideLine {
                width: 30*dp
                height: 30*dp
                anchors.right: parent.right
                anchors.bottom: parent.top
                text: "^"
                onPress: listView.positionViewAtBeginning()
            }

            ButtonSideLine {
                width: 30*dp
                height: 30*dp
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: "v"
                onPress: listView.positionViewAtEnd()
            }

            Text {
                text: "No Messages"
                visible: !listView.visible
                anchors.centerIn: parent
            }
        }

        BlockRow {
            height: 30*dp
            implicitHeight: 0
            Repeater {
                model: [["total", "#ccc"], ["skipped", "grey"], ["ok", "lightgreen"], ["changed", "yellow"], ["warning", "orange"], ["fatal", "red"]]
                StretchText {
                    text: block.attr(modelData[0] + "MessageCount").val + " " + modelData[0]
                    color: modelData[1]
                    hAlign: Text.AlignHCenter
                }
            }
        }

        DragArea {
            text: "Playbook"

            WidthResizeArea {
                target: root
                minSize: 300*dp
                maxSize: 1600*dp
            }
        }
    }  // end main Column
}


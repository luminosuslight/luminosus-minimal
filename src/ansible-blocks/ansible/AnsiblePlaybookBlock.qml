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
                visible: count > 0
                model: block.messagesModel()
                verticalLayoutDirection: ListView.BottomToTop
                clip: true

                delegate: StretchColumn {
                    id: messageDelegate
                    width: listView.width
                    height: collapsed ? 30*dp : implicitHeight + 10*dp
                    property bool collapsed: true
                    defaultSize: 30*dp

//                    Behavior on height {
//                        NumberAnimation {
//                            duration: 300
//                            easing.type: Easing.OutCurve
//                        }
//                    }

                    CustomTouchArea {
                        height: 30*dp
                        onClick: messageDelegate.collapsed = !messageDelegate.collapsed

                        StretchRow {
                            anchors.fill: parent
                            Text {
                                width: 40*dp
                                text: model.id
                                font.family: "BPmono"
                                color: "#555"
                                horizontalAlignment: Text.AlignRight
                            }
                            Item {
                                width: 10*dp
                            }
                            Item {
                                width: 30*dp
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 5*dp
                                    height: width
                                    radius: width / 2
                                    antialiasing: false
                                    color: model.color || "#ccc"
                                }
                            }
                            Text {
                                width: 70*dp
                                text: model.type || ""
                                font.family: "BPmono"
                                color: model.color || "#ccc"
                            }
                            StretchText {
                                text: model.title || ""
                                font.family: "BPmono"
                                color: model.color || "#ccc"
                            }
                        }
                    }

                    Item {
                        height: messageContent.contentHeight
                        visible: !collapsed
                        Rectangle {
                            color: "#999"
                            width: 2*dp
                            height: parent.height - 6*dp
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.left
                            anchors.horizontalCenterOffset: 65*dp
                        }
                        Text {
                            id: messageContent
                            anchors.fill: parent
                            anchors.leftMargin: 80*dp
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
                    }
                }  // end delegate

                Component.onCompleted: positionViewAtBeginning()
            }

            ButtonSideLine {
                width: 30*dp
                height: 30*dp
                anchors.right: parent.right
                anchors.bottom: parent.top
                text: "^"
                onPress: listView.positionViewAtEnd()
            }

            ButtonSideLine {
                width: 30*dp
                height: 30*dp
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: "v"
                onPress: listView.positionViewAtBeginning()
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


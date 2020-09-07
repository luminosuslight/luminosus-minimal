import QtQuick 2.12
import QtQuick.Dialogs 1.2
import CustomElements 1.0
import "qrc:/core/ui/items"
import "qrc:/core/ui/controls"

BlockBase {
    id: root
    width: 900*dp
    height: 400*dp
    onWidthChanged: block.positionChanged()

    StretchColumn {
        id: mainColumn
        anchors.fill: parent

        BlockRow {
            height: 30*dp
            implicitHeight: 0
            leftMargin: 10*dp

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
                    anchors.leftMargin: 10*dp
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
                width: 70*dp
                implicitWidth: 0
                text: "Run >"
                onPress: block.run()
                color: "lightgreen"
            }

            ButtonBottomLine {
                width: 60*dp
                implicitWidth: 0
                text: "Stop"
                onPress: block.stop()
                color: "darkred"
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
                    hintText: "Search"
                    text: block.attr("searchPhrase").val
                    onDisplayTextChanged: {
                        if (displayText !== block.attr("searchPhrase").val) {
                            block.attr("searchPhrase").val = displayText
                        }
                    }
                }
            }


            Item {
                implicitWidth: -1
                TextInput {
                    anchors.fill: parent
                    anchors.leftMargin: 10*dp
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
                flickableDirection: Flickable.VerticalFlick

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
                                color: "#777"
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
                                text: model.title || "Unknown Message"
                                font.family: "BPmono"
                                color: model.color || "#ccc"
                            }
                        }
                    }

                    Item {
                        height: messageContent.contentHeight
                        visible: !collapsed
                        Rectangle {
                            color: "#777"
                            width: 2*dp
                            height: parent.height - 6*dp
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.left
                            anchors.horizontalCenterOffset: 65*dp
                        }
                        TextEdit {
                            id: messageContent
                            anchors.fill: parent
                            anchors.leftMargin: 80*dp
                            wrapMode: Text.Wrap
                            text: model.content
                            font.pixelSize: 14*dp
                            font.family: "BPmono"
                            color: "#eee"
                            selectByMouse: true
                            readOnly: true
                            //lineHeight: 1.5
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
                anchors.top: parent.top
                text: "▲"
                color: "#888"
                onPress: listView.positionViewAtEnd()
            }

            ButtonSideLine {
                width: 30*dp
                height: 30*dp
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: "▼"
                color: "#888"
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

            StretchText {
                text: block.attr("totalMessageCount").val + " messages"
                color: "#ccc"
                hAlign: Text.AlignHCenter
            }
            Repeater {
                model: [["skipped", "grey"], ["ok", "lightgreen"], ["changed", "yellow"], ["warning", "orange"], ["failed", "red"]]
                Item {
                    implicitWidth: -1
                    AttributeCheckbox {
                        width: 30*dp
                        height: 30*dp
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        attr: block.attr(modelData[0] + "MessagesEnabled")
                    }
                    StretchText {
                        anchors.fill: parent
                        text: block.attr(modelData[0] + "MessageCount").val + " " + modelData[0]
                        color: modelData[1]
                        hAlign: Text.AlignHCenter
                    }
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


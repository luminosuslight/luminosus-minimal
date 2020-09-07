import QtQuick 2.12
import QtQuick.Dialogs 1.2
import CustomElements 1.0
import "qrc:/core/ui/items"
import "qrc:/core/ui/controls"

BlockBase {
    id: root
    width: 180*dp
    height: mainColumn.implicitHeight
    settingsComponent: settings

    StretchColumn {
        id: mainColumn
        defaultSize: 30*dp
        anchors.fill: parent

        ListView {
            id: listView
            height: 260*dp
            model: block.attr("playbooks").val
            clip: true
            delegate: BlockRow {
                width: listView.width
                height: 30*dp
                leftMargin: 5*dp
                StretchText {
                    text: "%1".arg(modelData.name)
                }
                ButtonSideLine {
                    width: 30*dp
                    implicitWidth: 0
                    text: ">"
                    onPress: block.createPlaybookBlock(modelData.path, modelData.name)
                }
            }
        }

        DragArea {
            text: "Project"
        }
    }  // end main Column

    // -------------------------- Settings ----------------------------

    Component {
        id: settings
        StretchColumn {
            leftMargin: 15*dp
            rightMargin: 15*dp
            defaultSize: 30*dp

            BlockRow {
                StretchText {
                    text: "Path:"
                }
                ButtonBottomLine {
                    width: 60*dp
                    text: "Select"
                    onClick: fileDialogLoader.active = true
                }

                Loader {
                    id: fileDialogLoader
                    active: false

                    sourceComponent: FileDialog {
                        id: fileDialog
                        title: "Select Project Path"
                        selectMultiple: false
                        selectFolder: true
                        onAccepted: {
                            if (fileUrl) {
                                block.attr("projectPath").val = fileUrl
                            }
                            fileDialogLoader.active = false
                        }
                        onRejected: {
                            fileDialogLoader.active = false
                        }
                        Component.onCompleted: {
                            // don't set visible to true before component is complete
                            // because otherwise the dialog will not be configured correctly
                            visible = true
                        }
                    }
                }
            }
        }
    }  // end Settings Component
}


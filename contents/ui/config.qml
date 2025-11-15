import QtQuick
import QtQuick.Controls as QtControls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    id: configRoot

    property alias cfg_BackgroundColor: bgColorRect.color
    property alias cfg_BaseColor: baseColorRect.color
    property alias cfg_MinuteColor: minuteColorRect.color
    property alias cfg_HourColor: hourColorRect.color
    property alias cfg_BothColor: bothColorRect.color
    property alias cfg_GapSize: gapSizeSlider.value
    property alias cfg_BoxHeightRate: boxHeightSlider.value

    Kirigami.FormLayout {
        anchors.fill: parent

        // Background Color
        RowLayout {
            Kirigami.FormData.label: "Background Color:"
            
            Rectangle {
                id: bgColorRect
                width: 50
                height: 30
                color: "#000000"
                border.color: "gray"
                border.width: 1
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: bgColorDialog.open()
                }
            }
            
            QtControls.Button {
                text: "Choose"
                onClicked: bgColorDialog.open()
            }
        }

        // Base/Off Color
        RowLayout {
            Kirigami.FormData.label: "Base Color (Off):"
            
            Rectangle {
                id: baseColorRect
                width: 50
                height: 30
                color: "#808080"
                border.color: "gray"
                border.width: 1
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: baseColorDialog.open()
                }
            }
            
            QtControls.Button {
                text: "Choose"
                onClicked: baseColorDialog.open()
            }
        }

        // Minute Color
        RowLayout {
            Kirigami.FormData.label: "Minute Color:"
            
            Rectangle {
                id: minuteColorRect
                width: 50
                height: 30
                color: "#ff0000"
                border.color: "gray"
                border.width: 1
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: minuteColorDialog.open()
                }
            }
            
            QtControls.Button {
                text: "Choose"
                onClicked: minuteColorDialog.open()
            }
        }

        // Hour Color
        RowLayout {
            Kirigami.FormData.label: "Hour Color:"
            
            Rectangle {
                id: hourColorRect
                width: 50
                height: 30
                color: "#0000ff"
                border.color: "gray"
                border.width: 1
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: hourColorDialog.open()
                }
            }
            
            QtControls.Button {
                text: "Choose"
                onClicked: hourColorDialog.open()
            }
        }

        // Both (Hour + Minute) Color
        RowLayout {
            Kirigami.FormData.label: "Both (Hour+Min):"
            
            Rectangle {
                id: bothColorRect
                width: 50
                height: 30
                color: "#00ff00"
                border.color: "gray"
                border.width: 1
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: bothColorDialog.open()
                }
            }
            
            QtControls.Button {
                text: "Choose"
                onClicked: bothColorDialog.open()
            }
        }

        // Gap Size
        RowLayout {
            Kirigami.FormData.label: "Gap Size:"
            
            QtControls.Slider {
                id: gapSizeSlider
                from: 0
                to: 20
                stepSize: 1
                value: 3
                Layout.preferredWidth: 200
            }
            
            QtControls.Label {
                text: gapSizeSlider.value + "px"
                Layout.preferredWidth: 50
            }
        }

        // Box Height Rate
        RowLayout {
            Kirigami.FormData.label: "Clock Size:"
            
            QtControls.Slider {
                id: boxHeightSlider
                from: 0.1
                to: 1.0
                stepSize: 0.05
                value: 0.9
                Layout.preferredWidth: 200
            }
            
            QtControls.Label {
                text: Math.round(boxHeightSlider.value * 100) + "%"
                Layout.preferredWidth: 50
            }
        }
        
        // Information
        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "How to read:"
        }
        
        QtControls.Label {
            text: "Each Fibonacci block (1,1,2,3,5) can show:\n• Base color = not used\n• Red = minutes (×5)\n• Blue = hours\n• Green = both hours and minutes\n\nTime updates every 5 minutes."
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }

    // Color picker dialogs
    component ColorPickerDialog: QtControls.Dialog {
        property alias targetRect: colorGrid.targetRect
        
        title: "Choose Color"
        modal: true
        
        QtControls.DialogButtonBox {
            id: buttonBox
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            standardButtons: QtControls.DialogButtonBox.Ok
            onAccepted: parent.close()
        }
        
        contentItem: Item {
            implicitWidth: 240
            implicitHeight: 220
            
            GridLayout {
                id: colorGrid
                property var targetRect
                
                anchors.fill: parent
                anchors.margins: 10
                columns: 4
                columnSpacing: 10
                rowSpacing: 10
                
                Repeater {
                    model: [
                        "#000000", "#ffffff", "#808080", "#c0c0c0",
                        "#ff0000", "#00ff00", "#0000ff", "#ffff00",
                        "#ff00ff", "#00ffff", "#800000", "#008000",
                        "#000080", "#808000", "#800080", "#008080"
                    ]
                    
                    Rectangle {
                        width: 50
                        height: 50
                        color: modelData
                        border.color: colorGrid.targetRect && colorGrid.targetRect.color === modelData ? "white" : "gray"
                        border.width: colorGrid.targetRect && colorGrid.targetRect.color === modelData ? 3 : 1
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (colorGrid.targetRect) {
                                    colorGrid.targetRect.color = modelData;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    ColorPickerDialog { id: bgColorDialog; targetRect: bgColorRect }
    ColorPickerDialog { id: baseColorDialog; targetRect: baseColorRect }
    ColorPickerDialog { id: minuteColorDialog; targetRect: minuteColorRect }
    ColorPickerDialog { id: hourColorDialog; targetRect: hourColorRect }
    ColorPickerDialog { id: bothColorDialog; targetRect: bothColorRect }
}

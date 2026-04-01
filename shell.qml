import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.ds as DS


Variants {

    model: Quickshell.screens

//Main Bar
    PanelWindow {
        required property var modelData
        screen: modelData
        anchors {
            top: true
            right: true
            left: true
        }
    
    //Bar height
    implicitHeight: 26
    color: "transparent" //transparent bar so i could use rounded corner

    //this rectangle will act as the main bar(visually)
    Rectangle {
        anchors.fill: parent
        radius: DS.Theme.radius //i have reference the common themes properties like bg, fg, radius, etc it is on ../ds/Theme.qml
        color: DS.Theme.bg
        border.width: 0
    }

    //workspace viewer/counter
    RowLayout {
        id: workspaceBar

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        spacing: 8 //space between workspace buttons

        Layout.alignment: Qt.AlignVCenter

        RowLayout {

        //creates a button for each item in Hyprland.workspace model
            Repeater {
                model: Hyprland.workspaces

                delegate: Rectangle {
                    required property var modelData
                    width: 32
                    height: 16
                    radius: 6

                    color: {
                        if (modelData.focused) return DS.Theme.accent

                        if (modelData.urgent) return "#481b53"

                        return "#56495a"
                    }

                    Text {
                        anchors.centerIn: parent

                        //anchors {
                            //bottom: true
                            //centerIn: parent
                            //}
                            //
                        text: {
                            let wsName = modelData.name
                            if (wsName.startsWith("special:")){

                                return wsName.substring(8)
                            }

                            return wsName
                        }

                        //text: modelData.name
                        color: "white"
                        font.pixelSize: 8
                        font.bold: modelData.focused
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.activate()
                    }
                }
            }

            //anchors.fill: parent
            //Text { text: "hello, world" }
        }

    }

        Text {
            id: clock
            color: "white"
            anchors.centerIn: parent

        Process {
            id: dateProc

            command: ["date"]
            running: true

            stdout: StdioCollector {
                onStreamFinished: clock.text = this.text
            }
        }
        
        //timer to update the clock every second
        Timer {
            interval: 999
            running: true
            repeat: true

            onTriggered: dateProc.running = true
            }
        }
    }
}

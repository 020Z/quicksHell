import QtQuick
import Quickshell
import Quickshell.Io

//Main Bar
PanelWindow {
    anchors {
        top: true
        right: true
        left: true
    }
    
    //Bar height
    implicitHeight: 26

    Text {
        id: clock
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
            interval: 1000
            running: true
            repeat: true

            onTriggered: dateProc.running = true
        }
    }
}


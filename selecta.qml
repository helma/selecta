import QtQuick 1.1
import com.nokia.meego 1.0
import Qt.labs.gestures 1.0

PageStackWindow {

  id: app
  initialPage: main
  property variant states: ["?","+","-"]
  property int cur: 0

  function draw () {
    txt.text = states[cur]
    switch (cur) {
      case 0:
        txt.color = "white"
        break
      case 1:
        txt.color = "green"
        break
      case 2:
        txt.color = "red"
        break
    }
  }

  Page {
    id: main

      Rectangle {
        id: rect
        color: "black"
        width: main.width
        height: main.height

        Text {
          id: txt
          text: app.states[app.cur]
          color: "white"
          font.pointSize: 320
          font.bold: true
          anchors.centerIn:  parent
        }

        Timer {
          id: checkTimer
          interval: 1000 
          repeat: true
          running: true
          onTriggered: {
            mainApp.setState("check_track_change")
            app.draw()
          }
        }

        MouseArea {
          id: gesture
          anchors.fill: parent

          Timer {
            id: mouseTimer
            interval: 400 //ms
            repeat: false
            onTriggered: {
              app.cur = 0
              app.draw()
              mainApp.setState("next")
            }
          }
          onPressed: { mouseTimer.start() }
          onReleased: {
            if (mouseTimer.running) { // short press
              mouseTimer.stop()
              app.cur = (app.cur + 1) % 3
              app.draw()
              mainApp.setState(app.cur) 
            }
          }
         }
      }
  }

}

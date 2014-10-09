import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1

PageStackWindow {

  id: app
  initialPage: main
  signal log(string st)
  property string status
  property int diff

  function toggle() {
     if (status == "running") {
       status = "stopped"
       button.color = "green"
       button.text = "start"
     } else {
       status = "running"
       button.color = "red"
       button.text = "stop"
     }
     time.text = status
     app.log(status)
  }

  Page {

    id: main

    MouseArea { id: region; anchors.fill: parent; onClicked: app.toggle() }

    Text {
      id: time
      text: 'test'
      font.pointSize: 48
    }

    Timer {
      id: textTimer
      interval: 1000
      repeat: true
      running: true
      triggeredOnStart: true
      onTriggered: {
        //appWindow.seconds++;
        // time.text = Date();
        //time.text = appWindow.seconds;
      }
    }

    Text {
      id: button
      text: app.status
      anchors.centerIn:  parent
      font.pointSize: 120
    }
  }
}

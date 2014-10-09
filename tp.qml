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
    if (status == "running") { status = "stopped" } else { status = "running" }
  }

  onStatusChanged: {
    if (status == "stopped") { timer.stop() }
    else { timer.start() }
    app.log(status)
    button.update()
  }

  onDiffChanged: { time.update() }

  Page {

    id: main

    MouseArea { id: region; anchors.fill: parent; onClicked: app.toggle() }

    Text {
      id: time
      text: app.diff
      font.family: "Courier"
      font.pointSize: 48
      anchors.horizontalCenter: parent.horizontalCenter
      function pad(i) { return ('0'+i).slice(-2) } 
      function update() {
          var h = ~~(app.diff/3600)
          var m = ~~((app.diff-h*3600)/60)
          var s = Math.round(app.diff - h*3600 - m*60)
          text = pad(h)+":"+pad(m)+":"+pad(s)
          if (app.diff > 0) { color = "red" } else { color = "green" }
      }
    }

    Timer {
      id: timer
      interval: 1000
      repeat: true
      running: false
      triggeredOnStart: true
      
      onTriggered: { app.diff++ }
    }

    Text {
      id: button
      font.pointSize: 120
      anchors.centerIn:  parent
      
      function update() {
        if (app.status == "running") {
          color = "red"
          text = "stop"
        } else {
          color = "green"
          text = "start"
        }
      }
    }
  }
}

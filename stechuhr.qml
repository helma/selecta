import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1

PageStackWindow {

  id: app
  initialPage: main
  property int diff

  onDiffChanged: { time.update() }

  Page {

    id: main

    MouseArea { id: region; anchors.fill: parent; onClicked: app.toggle() }

    Text {
      id: time
      text: app.diff
      font.family: "Courier"
      font.pointSize: 64
      anchors.centerIn:  parent
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
      running: true
      triggeredOnStart: true
      
      onTriggered: { app.diff++ }
    }

  }
}

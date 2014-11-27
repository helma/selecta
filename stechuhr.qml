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
          var total = Math.abs(app.diff)
          var h = parseInt(total/3600)%24
          var m = parseInt(total/60)%60
          var s = total%60
          text = pad(h)+":"+pad(m)+":"+pad(s)
          if (app.diff > 0) { color = "red" } else { color = "green"; text = "-"+text }
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

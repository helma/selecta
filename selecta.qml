import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import io.thp.pyotherside 1.4

ApplicationWindow {

  id: app
  allowedOrientations: Orientation.All

  property var states: ["?","+","-"]
  property var colors: ["white","green","red"]
  property var files: []
  property int cur: 0

  function toggle() { app.cur = (app.cur+1)%3 }

  initialPage: Component {
    Page {

      allowedOrientations: Orientation.All

      Text {
        id: main
        anchors.centerIn: parent
        font.pointSize: 400
        font.bold: true
        text: app.states[app.cur]
        color: app.colors[app.cur]
      }

      MouseArea {
        anchors.fill: parent
        onClicked: app.toggle()
        onPressAndHold: player.next()
      }

      Audio {
        id: player
        autoPlay: true
        onPlaybackStateChanged: if (player.position != 0) player.next()

        function next() {
          py.save()
          app.cur = 0
          app.files.shift()
          player.source = app.files[0]
        }
      }

      Python {
        id: py

        function save() {
          if (app.cur == 1) py.keep()
          else if (app.cur == 2) py.rm()
        }

        function rm() {
          importModule('shutil', function () {
            py.call('shutil.move',[app.files[0],'/home/nemo/Music/DELETE'])
          });
        }

        function keep() {
          importModule('shutil', function () {
            py.call('shutil.move',[app.files[0],'/home/nemo/Music/KEEP'])
          });
        }

        Component.onCompleted: {
          addImportPath(Qt.resolvedUrl('.'));
          importModule('selecta', function () {
              py.call('selecta.playlist', [], function(result) {
                app.files = result
                player.source = app.files[0]
              });
          });
        }
        onError: console.log('Error: ' + traceback)
      }
    }
  }

  cover: Cover {

    Text {
      anchors.centerIn: parent
      font.pointSize: 100
      font.bold: true
      text: app.states[app.cur]
      color: app.colors[app.cur]
    }
  }

}

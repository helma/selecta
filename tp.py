import sys
import datetime
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtDeclarative import QDeclarativeView
 
def log(status):
  now = datetime.datetime.now()
  with open("log", "a") as f:
    if status == "running":
      f.write(str(now)+",")
    else:
      f.write(str(now)+"\n")

# Create Qt application and the QDeclarative view
app = QApplication(sys.argv)
view = QDeclarativeView()
view.setViewport(QWidget())
view.setSource(QUrl("/home/user/MyDocs/tp/tp.qml"))
view.showFullScreen()
root = view.rootObject()
root.setProperty("status","running")
root.log.connect(log)

# Enter Qt main loop
sys.exit(app.exec_())

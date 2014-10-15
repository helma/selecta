import sys
import csv
import datetime
from dateutil import parser
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtDeclarative import QDeclarativeView
 
def log(status):
  now = datetime.datetime.now()
  with open("/home/user/stechuhr/log", "a") as f:
    if status == "running":
      f.write(str(now))
      f.flush()
    else:
      f.write(", "+str(now)+"\n")
      f.flush()


dur = datetime.timedelta(seconds=0)
logstart = None
now = datetime.datetime.now()
for row in csv.reader(open("/home/user/stechuhr/log", 'rb')):

  if logstart is None:
    logstart = parser.parse(row[0])

  if len(row) == 1:
    status = "running"
    dur += now - parser.parse(row[0])
  else:
    status = "stopped"
    dur += parser.parse(row[1])-parser.parse(row[0])

# 246 business days/year
# 5 weeks vacation
# 10 hours/week
hours_per_day = 10/7.0 * (249-5*5)/365.0
planned_seconds = ((now-logstart).days+1) * hours_per_day * 60 * 60
diff = (dur.days*1440*60+dur.seconds) - planned_seconds
  
# Create Qt application and the QDeclarative view
app = QApplication(sys.argv)
view = QDeclarativeView()
view.setViewport(QWidget())
view.setSource(QUrl("/home/user/stechuhr/stechuhr.qml"))
view.showFullScreen()
root = view.rootObject()
root.setProperty("status",status)
root.setProperty("diff",diff)
root.log.connect(log)

# Enter Qt main loop
sys.exit(app.exec_())

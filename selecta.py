import os
import sys
import string
import random
import atexit
import time
import subprocess
from PySide import QtCore, QtGui, QtDeclarative

class Signal( QtCore.QObject ):
    def __init__( self ):
        QtCore.QObject.__init__(self)

    @QtCore.Slot('QString')
    def setState(self,nr):
        if nr == "next":
            with open(mplayer_in,"w") as p:
                p.write("pt_step 1\n")
        elif nr == "check_track_change":
            if track_changed():
                root.setProperty("cur",0)
        else:
            move(nr)

def quit():
    with open(mplayer_in,"w") as p:
        p.write("quit\n")

def track_changed():
    with open(mplayer_in,"w") as p:
        p.write("get_time_pos\n")
    time.sleep(0.5)
    output = float(mp.stdout.readline().split('ANS_TIME_POSITION=', 1)[1])
    sys.stdout.flush()
    if output < 2.5:
        return True
    else:
        return False

def current():
    with open(mplayer_in,"w") as p:
        p.write("get_property path\n")
    time.sleep(0.5)
    output = mp.stdout.readline().split('ANS_path=', 1)[1].rstrip()
    sys.stdout.flush()
    return output

def move(nr):

    nr = int(nr)
    dest = ["INBOX", "KEEP", "DELETE"]

    infile = current()
    infile = string.replace(infile,"INBOX",dest[nr-1])
    target = string.replace(infile,dest[nr-1],dest[nr])
    print infile+" -> "+target

    try: os.makedirs(os.path.dirname(target))
    except: pass
    try: os.rename(infile,target)
    except Exception, e:
        print e
        pass


rootDir = '/home/user/MyDocs/Music/INBOX'
mplayer_in = "/home/user/selecta/mplayer.in"
mplayer_out = "/home/user/selecta/mplayer.out"
m3u = "/home/user/selecta/mplayer.m3u"

playlist = []
for dirName, subdirList, fileList in os.walk(rootDir):
    for fname in fileList:
        base, ext = os.path.splitext(fname)
        if ext in ['.mp3', '.ogg', '.wav', '.WAV', '.aif', '.aiff', '.AIFF']:
            playlist.append(dirName+'/'+fname)
        
random.shuffle(playlist)
os.remove(m3u)

with open(m3u,"w") as f:
    for m in playlist:
        f.write(m+"\n")

cmd = ["mplayer", "-slave","-nolirc", "-quiet", "-msglevel", "all=-1", "-msglevel", "global=5", "-input", "file="+mplayer_in, "-playlist",m3u ]
mp = subprocess.Popen(cmd, stdout=subprocess.PIPE)

audio = playlist[0]
 
# Create Qt application and the QDeclarative view
app = QtGui.QApplication(sys.argv)
view = QtDeclarative.QDeclarativeView()
view.setViewport(QtGui.QWidget())
view.setSource(QtCore.QUrl("/home/user/selecta/selecta.qml"))
view.showFullScreen()
root = view.rootObject()
context = view.rootContext()
context.setContextProperty("mainApp",Signal())
atexit.register(quit)

# Enter Qt main loop
sys.exit(app.exec_())

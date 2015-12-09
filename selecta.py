import os
import sys
import string
import random
import pyotherside


inbox = '/home/nemo/Music/INBOX'
#media/sdcard/9016-4EF8/Music/

def playlist():

    playlist = []
    for dirName, subdirList, fileList in os.walk(inbox):
        for fname in fileList:
            base, ext = os.path.splitext(fname)
            if ext in ['.mp3', '.ogg', '.wav', '.WAV', '.aif', '.aiff', '.AIFF']:
                playlist.append(dirName+'/'+fname)
            
    random.shuffle(playlist)
    return playlist


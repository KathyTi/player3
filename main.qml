import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtMultimedia 5.9
import QtGraphicalEffects 1.0

import cppbrowser 1.0
import cppsettings 1.0
import cppmodel 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 480
    height: 860
    title: qsTr("Hello World")

    property real sum
    property string name
    property string tmpstr
    property string tmpstr2
    property string tmpstr3
    property real tmpint
    property real tmpint2
    property string curfolder
    property string ttl
    property string artst
    property string albm
    property string filecut: "file://"
    property var tracktime
    property bool add_pl_icon_state: add_to_pl_count > 0 ? true : false
    property real add_to_pl_count: 0
    property string newplname
    property bool play_pl_icon_state: plists.currentIndex > 0 ? true : false
    property bool edit_pl_icon_state: plists.currentIndex > 0 ? true : false
    property bool rn_pl_icon_state: plists.currentIndex > 0 ? true : false
    property bool open_pl_icon_state: plists.currentIndex > 0 ? true : false
    property string currentPL
    property real curTrackPos
    property real currentTrackCount: 0
    property real generalTrackCount: 0
    property bool shuffle_state: false
    property real repeat_state: 0
    property bool pause_state: false
    property bool stop_state: false
    property bool load: false
    property real currentprogress
    property real addnexttrack: 0
    property real curPLPos
    property bool state_next_track: false
    property real oldCurTrackPos
    property bool endofnexttrack: false
    property bool cutA: false
    property bool cutB: false
    property real cutApos: 0
    property real cutBpos: 0
    property bool cutRepeat: false
    property bool mute_state: false
    property real volume_state
    property string volumetmp
    property string ch
    property string ch2
    property real search_count: 0

    FileBrowser{id: fb}
    MediaPlayer{id: aplayer}
    Setter{id: setter}
    Cppmodel{id: cppmdl}

    Rectangle{
        id: bckground
        anchors.fill: parent
        Image{
            id: bckpic
            source: "bg2.jpg"
            fillMode: Image.PreserveAspectFit
        }
    }
    Timer{
        id: timer
        interval: 500
        repeat: true
        running: false
        onTriggered: {
            msToTime(aplayer.duration)
            msToTimeCurrent(aplayer.position)
            msToProgress(aplayer.position, aplayer.duration)
            if(cutRepeat === true && (Math.floor(aplayer.position/100) >= Math.floor(cutApos/100) && Math.floor(aplayer.position/100) <= Math.floor(cutBpos/100))){
                //console.log("P position = "+Math.floor(aplayer.position/100))
                //console.log("go2")
                if(Math.floor(aplayer.position/100) === Math.floor(cutBpos/100)){
                    console.log("startTTT")
                    aplayer.seek(cutApos)
                }
            }
            else{
                if(cutRepeat === true){
                    if(aplayer.position > cutBpos || aplayer.position < cutApos){
                        cutA = false
                        cutB = false
                        cutApos = 0
                        cutBpos = 0
                        cutRepeat = false
                    }
                }
                if(timer.interval === 100 || timer.interval === 2000 || timer.interval === 1)
                    timer.interval = 500
                if(swipe.interactive === false)
                    swipe.interactive = true

                if(aplayer.position === aplayer.duration){
                    console.log("JJJJJJJJJJJJJJJJJJJJJJ")
                    timer.stop()
                    curtime.text = "00:00"
                    activeprogress.width = 0
                    play.visible = true
                    pause.visible = false
                    if(timer.running === true)
                        timer.stop()
                    if(repeat_state === 0)
                    {
                        if(endofnexttrack === true){
                            endofnexttrack = false
                            //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                            //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                            cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                            cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                            curTrackPos = oldCurTrackPos
                        }
                        if(state_next_track === false)
                        {
                            if(curTrackPos === generalTrackCount)
                            {
                                aplayer.source = setter.nextTrack(currentPL, curTrackPos, shuffle_state)
                                aplayer.stop()
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                curTrackPos = 1
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "curstop.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "curstop.png")
                                currentlist.currentIndex = curTrackPos-1
                                setWidthOfPLName()
                                stop_state = true
                                setter.setStopState(stop_state, currentPL)
                            }
                            else
                            {
                                aplayer.source = setter.nextTrack(currentPL, curTrackPos, shuffle_state)
                                aplayer.play()
                                play.visible = false
                                pause.visible = true
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                timer.start()
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                curTrackPos++
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                setWidthOfPLName()
                                currentlist.currentIndex = curTrackPos-1
                            }
                        }
                        else
                        {
                            aplayer.source = setter.playNextTrack(currentPL)
                            aplayer.play()
                            setter.delNextTrack(currentPL, 1)
                            tmpint = 1
                            for(var j = 0; j < generalTrackCount; j++){
                                //if(curlistmod.get(j).mrknmb === 0)
                                if(cppmdl.data(j, 263) === 0)
                                    continue
                                else{
                                    //if(curlistmod.get(j).mrknmb === 1){
                                    if(cppmdl.data(j, 263) === 1){
                                        currentlist.currentIndex = j
                                        //curlistmod.setProperty(j, "mrknmb", 0)
                                        //curlistmod.setProperty(j, "mxtvis", false)
                                        cppmdl.setElementProperty(j, 263, "0")
                                        cppmdl.setElementProperty(j, 264, "false")
                                        play.visible = false
                                        pause.visible = true
                                        tmpstr = setter.loadnamefromPL(aplayer.source)
                                        timer.start()
                                        //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                        //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                        cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                        cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                        curTrackPos = j+1
                                        //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                        //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                        cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                        cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                        setWidthOfPLName()
                                    }
                                    //if(curlistmod.get(j).mrknmb > 1){
                                    if(cppmdl.data(j, 263) > 1){
                                        //curlistmod.setProperty(j, "mrknmb", curlistmod.get(j).mrknmb - 1)
                                        cppmdl.setElementProperty(j, 263, cppmdl.data(j, 263)-1)
                                    }
                                }
                                currentlist.currentIndex = curTrackPos-1
                            }
                            addnexttrack--
                            if(addnexttrack === 0){
                                state_next_track = false
                                endofnexttrack = true
                            }
                        }
                        titleani.stop()
                        setTitleAnimatiom()
                    }
                    if(repeat_state === 1)
                    {
                        //curlistmod.setProperty(curTrackPos-1, "ico", "curpause.png")
                        cppmdl.setElementProperty(curTrackPos-1, 258, "curpause.png")
                        aplayer.stop()
                        aplayer.play()
                        play.visible = false
                        pause.visible = true
                        timer.start()
                        //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                        cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                    }
                    if(repeat_state === 2)
                    {
                        if(endofnexttrack === true){
                            endofnexttrack = false
                            //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                            //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                            cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                            cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                            curTrackPos = oldCurTrackPos
                        }
                        if(state_next_track === false)
                        {
                            if(curTrackPos === generalTrackCount)
                            {
                                aplayer.source = setter.nextTrack(currentPL, curTrackPos, shuffle_state)
                                play.visible = false
                                pause.visible = true
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                curTrackPos = 1
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                aplayer.play()
                                timer.start()
                                currentlist.currentIndex = curTrackPos-1
                                setWidthOfPLName()
                            }
                            else{
                                aplayer.source = setter.nextTrack(currentPL, curTrackPos, shuffle_state)
                                aplayer.play()
                                play.visible = false
                                pause.visible = true
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                timer.start()
                                console.log("///1")
                                console.log(curTrackPos-1)
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                console.log("///2")
                                if(nameofplaylisttxt.text === "")
                                    curTrackPos
                                else curTrackPos++
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                setWidthOfPLName()
                                currentlist.currentIndex = curTrackPos-1
                            }
                        }
                        else
                        {
                            aplayer.source = setter.playNextTrack(currentPL)
                            aplayer.play()
                            ////////////////////////////////////////////////////
                            setter.delNextTrack(currentPL, 1)
                            tmpint = 1
                            for(var i = 0; i < generalTrackCount; i++){
                                //if(curlistmod.get(i).mrknmb === 0)
                                if(cppmdl.data(i, 263) === 0)
                                    continue
                                else{
                                    //if(curlistmod.get(i).mrknmb === 1){
                                    if(cppmdl.data(i, 263) === 1){
                                        currentlist.currentIndex = i
                                        //curlistmod.setProperty(i, "mrknmb", 0)
                                        //curlistmod.setProperty(i, "mxtvis", false)
                                        cppmdl.setElementProperty(i, 263, "0")
                                        cppmdl.setElementProperty(i, 264, "false")
                                        play.visible = false
                                        pause.visible = true
                                        tmpstr = setter.loadnamefromPL(aplayer.source)
                                        timer.start()
                                        //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                        //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                        cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                        cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                        curTrackPos = i+1
                                        //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                        //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                        cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                        cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                        setWidthOfPLName()
                                    }
                                    //if(curlistmod.get(i).mrknmb > 1){
                                    if(cppmdl.data(i, 263) > 1){
                                        //curlistmod.setProperty(i, "mrknmb", curlistmod.get(i).mrknmb - 1)
                                        cppmdl.setElementProperty(i, 263, cppmdl.data(i, 263)-1)
                                    }
                                }
                                currentlist.currentIndex = curTrackPos-1
                            }
                            addnexttrack--
                            /////////////////////////////////////////////////////
                            if(addnexttrack === 0){
                                state_next_track = false
                                endofnexttrack = true
                            }
                        }
                        setTitleAnimatiom()
                    }
                    titleani.stop()
                    setter.setCurrentTrack(currentPL, curTrackPos)
                }
                currentprogress = aplayer.position
                setter.setCurrentProgress(currentprogress, currentPL)
                //console.log(aplayer.position)
                if(pause_state === true){
                    timer.stop()
                    console.log("done")
                }
                //console.log(pause_state)
            }
        }
    }
    Timer{//отвечает за центровку метаДата при переключении
        id: timer2
        interval: 100
        repeat: false
        running: false
        onTriggered: {
            if(!aplayer.metaData.title){
                    console.log(tmpstr)
                    title.text = tmpstr.slice(0, -4)
                    if(title.width > mrect.width){
                        console.log("TITLE_WIDTH > RECT_WIDTH")
                        title.x = 0
                        titleani.restart()
                    }
                    else{
                        console.log("TITLE_WIDTH < RECT_WIDTH")
                        titleani.stop()
                        title.x = (mrect.width-title.width)/2
                    }
                }
            else{
                    console.log("metaData")
                    title.text = aplayer.metaData.title
                    ch2 = title.text
                    var counter = 1
                    for(var i = title.text.length-1; ; i--){
                        ch = title.text.charAt(i)                   //символ - последняя буква тайтла
                        console.log(">>>"+ch+"<<<")
                        //if(/*i === title.text.length-1*/counter === 1 && ch === " "){ //если 1 итр и символ = " "
                        //    ch2 = title.text.slice(0, -counter)              //то строка = тайтл без " "
                        //    console.log(ch2+"<")
                        //}
                        //else{                                       //иначе
                        //    if(counter === 1/*i === title.text.length-1*/){          //если 1 итр <<<
                        //        ch2 = title.text                    //строка = тайтл
                        //        console.log(ch2+"<<<")              //и
                        //        break                               //выход
                        //    }
                        //    else{                                   //иначе <<<
                        //        if(ch === " "){                      //если итр != 1 и символ = " "
                        //            ch2 = title.text.slice(0, -counter)
                        //            console.log(ch2+"<<<<<")      //строка = тайтл минус 1символ
                        //        }
                        //        else{
                        //            //ch2 = ch2.slice(-counter)
                        //            console.log(ch2+"<<<<<<<<<<<<<")
                        //            break
                        //        }
                        //    }
                        //}
                        if(ch === " "){                      //если итр != 1 и символ = " "
                            ch2 = title.text.slice(0, -counter)
                            console.log(ch2+"<<<<<")      //строка = тайтл минус 1символ
                        }
                        else{
                            console.log(ch2+"<<<<<<<<<<<<<")
                            break
                        }
                        counter++
                    }
                    if(title.width > mrect.width){
                        console.log("TITLE_WIDTH > RECT_WIDTH")
                        title.x = 0
                        titleani.restart()
                    }
                    else{
                        console.log("TITLE_WIDTH < RECT_WIDTH")
                        title.text = ch2
                        titleani.stop()
                        title.x = (mrect.width-title.width)/2
                    }
                }

            if(!aplayer.metaData.albumArtist){
                artist.text = ""
                if(artist.width > mrect.width){
                    artist.x = 0
                    artistani.restart()
                }
                else{
                    albumani.stop()
                    album.x = (mrect.width-album.width)/2
                }
            }
            else{
                artist.text = aplayer.metaData.albumArtist
                ch2 = artist.text
                var counter2 = 1
                for(var j = artist.text.length-1; ; j--){
                    ch = artist.text.charAt(j)
                    if(ch === " ") ch2 = artist.text.slice(0, -counter2)
                    else break
                    counter2++
                }
                if(artist.width > mrect.width){
                    artist.x = 0
                    artistani.restart()
                }
                else{
                    artist.text = ch2
                    artistani.stop()
                    artist.x = (mrect.width-artist.width)/2
                }
            }


            if(!aplayer.metaData.albumTitle){
                album.text = ""
                if(album.width > mrect.width){
                    album.x = 0
                    albumani.restart()
                }
                else{
                    albumani.stop()
                    album.x = (mrect.width-album.width)/2
                }
            }
            else{
                album.text = aplayer.metaData.albumTitle
                ch2 = album.text
                var counter3 = 1
                for(var k = album.text.length-1; ; k--){
                    ch = album.text.charAt(k)
                    if(ch === " ") ch2 = album.text.slice(0, -counter3)
                    else break
                    counter3++
                }
                if(album.width > mrect.width){
                    album.x = 0
                    albumani.restart()
                }
                else{
                    album.text = ch2
                    albumani.stop()
                    album.x = (mrect.width-album.width)/2
                }
            }
        }
    }
    Timer{
        id: timer3
        interval: 100
        repeat: true
        running: false
        onTriggered: {
            if(artvol.color == "#00000000"){
                artvol.visible = false
                artvol.color = "#70acee48"
                timer3.stop()
            }
        }
    }

    SwipeView{
        id: swipe
        width: root.width
        height: root.height
        anchors.centerIn: parent
        //snapMode: ListView.SnapOneItem
        //orientation: ListView.Horizontal
        interactive: true
        Item {
            id: playpage
            clip: true
            Rectangle{
                id: mrect
                anchors.fill: parent
                color: "transparent"//"black"
                Rectangle{
                    id: nameofplaylist
                    y: art.y/3-7
                    height: nameofplaylisttxt.font.pixelSize+14
                    width: setWidthOfPLName()
                    anchors.left: mrect.left
                    anchors.leftMargin: mrect.width/50
                    color: "transparent"
                    clip: true
                    Text{
                        id: nameofplaylisttxt
                        anchors.left: parent.left
                        color: "#acee48"
                        font.pixelSize: playpage.height*0.03
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle{
                    id: trackcountrect
                    y: art.y/3-7
                    height: trackcount.font.pixelSize+14
                    width: setWidthOfPLName()
                    anchors.right: mrect.right
                    anchors.rightMargin: mrect.width/50
                    color: "transparent"
                    Text{
                        id: trackcount
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#acee48"
                        font.pixelSize: playpage.height*0.03
                        text: curTrackPos+"/"+generalTrackCount
                    }
                }

                Rectangle{
                    id: art
                    width: mrect.width/2
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.margins: 100
                    color: "transparent"//"black"
                    border.color: "#acee48"
                    radius: 5
                    border.width: 4
                    Image{
                        id: dfltart
                        anchors.centerIn: parent
                        width: parent.width*0.7
                        height: width
                        source: aplayer.metaData.coverArtUrlLarge ? aplayer.metaData.coverArtUrlLarge : "dfltart.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    MouseArea{
                        id: artvolmouse
                        anchors.fill: parent
                        clip:  true
                        onMouseYChanged: {
                            swipe.interactive = false
                            artvol.visible = true
                            if(mouseY >= y && mouseY <= (y+height)){
                                artvolani.stop()
                                artvol.color = "#70acee48"
                                artvol.height = parent.height - mouseY
                                volumetmp = artvol.height/parent.height
                                aplayer.volume = volumetmp.slice(0,4)
                                setter.setVolume(aplayer.volume)
                                if(aplayer.volume === 0)
                                    mute_state = true
                                else mute_state = false
                                setter.setMuteState(mute_state)
                            }
                        }
                        onReleased: {
                            artvolani.stop()
                            artvolani.start()
                            timer3.start()
                        }
                    }
                    Rectangle{
                        id: artvol
                        color: "#70acee48"
                        width: parent.width
                        height: parent.height
                        visible: false
                        anchors.bottom: artvolmouse.bottom
                        radius: 5
                        SequentialAnimation{
                            id: artvolani
                            PauseAnimation {duration: 1000}
                            ColorAnimation{target: artvol; property: "color"; from: "#70acee48"; to: "#00000000"; duration: 2500}
                        }
                    }
                }

                Text{
                    id: title
                    x: root.width
                    //x: title.width > mrect.width ? 0 : (mrect.width-title.width)/2
                    //anchors.horizontalCenter: mrect.horizontalCenter
                    anchors.top: art.bottom
                    anchors.margins: playpage.height*0.03
                    color: "#acee48"
                    text: aplayer.metaData.title ? aplayer.metaData.title : tmpstr.slice(0, -4)
                    font.pixelSize: playpage.height*0.03
                    SequentialAnimation{
                        id: titleani
                        loops: Animation.Infinite
                        PauseAnimation {duration: 2000}
                        NumberAnimation{target: title; property: "x"; from: 0; to: root.width-title.width; duration: title.width%11000}
                        PauseAnimation {duration: 2000}
                        NumberAnimation{target: title; property: "x"; from: root.width-title.width; to: 0; duration: title.width%11000}
                    }


                }
                Text{
                    id: artist
                    x: root.width
                    //anchors.horizontalCenter: mrect.horizontalCenter
                    anchors.top: title.bottom
                    anchors.margins: playpage.height*0.03
                    color: "#acee48"
                    text: aplayer.metaData.albumArtist ? aplayer.metaData.albumArtist : ""
                    font.pixelSize: playpage.height*0.03
                    SequentialAnimation{
                        id: artistani
                        loops: Animation.Infinite
                        PauseAnimation {duration: 2000}
                        NumberAnimation{target: artist; property: "x"; from: 0; to: root.width-artist.width; duration: artist.width%11000}
                        PauseAnimation {duration: 2000}
                        NumberAnimation{target: artist; property: "x"; from: root.width-artist.width; to: 0; duration: artist.width%11000}
                    }
                }
                Text{
                    id: album
                    x: root.width
                    //anchors.horizontalCenter: mrect.horizontalCenter
                    anchors.top: artist.bottom
                    anchors.margins: playpage.height*0.03
                    color: "#acee48"
                    text: aplayer.metaData.albumTitle ? aplayer.metaData.albumTitle : ""
                    font.pixelSize: playpage.height*0.03
                    SequentialAnimation{
                        id: albumani
                        loops: Animation.Infinite
                        PauseAnimation {duration: 2000}
                        NumberAnimation{target: album; property: "x"; from: 0; to: root.width-album.width; duration: album.width%11000}
                        PauseAnimation {duration: 2000}
                        NumberAnimation{target: album; property: "x"; from: root.width-album.width; to: 0; duration: album.width%11000}
                    }
                }

                Rectangle{
                    id: progress
                    height: curtime.font.pixelSize
                    width: mrect.width*0.8
                    anchors.horizontalCenter: mrect.horizontalCenter
                    anchors.bottom: play.top
                    anchors.margins: play.height
                    color: "transparent"//"black"
                    border.color: "#acee48"
                    radius: curtime.font.pixelSize/2
                    clip: true
                    layer.enabled: true
                    MouseArea{
                        height: progress.height*2
                        width: progress.width
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        pressAndHoldInterval: 100
                        onClicked: {
                            if(cutRepeat === false){
                                if(Math.floor(aplayer.position/10) < Math.floor(cutApos/10))
                                {
                                    cutA = false
                                    cutB = false
                                    cutApos = 0
                                    cutBpos = 0
                                    cutRepeat = false
                                    console.log("CUTREP = FALSE1")
                                }
                            }
                            else{
                                if(Math.floor(aplayer.position/10) < Math.floor(cutApos/10) || Math.floor(aplayer.position/10) > Math.floor(cutBpos/10)){
                                    cutA = false
                                    cutB = false
                                    cutApos = 0
                                    cutBpos = 0
                                    cutRepeat = false
                                    console.log("CUTREP = FALSE2")
                                }
                            }
                        }
                        onMouseXChanged: {
                            swipe.interactive = false
                            timer.interval = 2000
                            activeprogress.width = mouseX
                            tracktime = mouseX / progress.width
                            tracktime = aplayer.duration * tracktime
                            aplayer.seek(tracktime)
                            msToTimeCurrent(aplayer.position)
                            msToProgress(aplayer.position, aplayer.duration)
                            timer.interval = 100

                        }
                    }
                    Rectangle{
                        id: activeprogress
                        height: curtime.font.pixelSize
                        anchors.bottom: progress.bottom
                        anchors.left: progress.left
                        color: "#acee48"
                        radius: curtime.font.pixelSize/2
                    }
                    OpacityMask{
                        id: progressmask
                        maskSource: progress
                        visible: activeprogress.status == Rectangle.Ready//(avatarImage.status==Image.Ready)
                    }
                }

                Text{
                    id: curtime
                    x: progress.x - curtime.width/2
                    anchors.top: progress.bottom
                    anchors.margins: play.height/4
                    color: "#acee48"
                    text: "00:00"//curtime.text !== eltime.text && curtime.text !== "00:00:00" ? msToTimeCurrent(aplayer.position) : "00:00:00"
                }
                Text{
                    id: eltime
                    x: (progress.x+progress.width-1) - eltime.width/2
                    anchors.top: progress.bottom
                    anchors.margins: play.height/4
                    color: "#acee48"
                    text: "00:00"
                }

                Image {
                    id: play
                    //width: playpage.width/5
                    //height: width
                    width: playpage.width/5*0.7
                    height: width
                    anchors.margins: play.height/3
                    anchors.bottom: stop.top
                    anchors.horizontalCenter: mrect.horizontalCenter
                    source: "play.png"
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 100
                        }
                    }
                    MouseArea{
                        id: playmouse
                        anchors.fill: parent
                        onPressed: play.scale = 1.3
                        onReleased: {
                            play.scale = 1.0
                            play.visible = false
                            pause.visible = true
                            aplayer.play()
                            timer.start()
                            pause_state = false
                            stop_state = false
                            setter.setPauseState(pause_state, currentPL)
                            setter.setStopState(stop_state, currentPL)
                            //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                            cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                            //console.log("play")
                        }
                    }
                }
                Image {
                    id: pause
                    width: playpage.width/5*0.7
                    height: width
                    anchors.margins: play.height/3
                    anchors.bottom: stop.top
                    anchors.horizontalCenter: mrect.horizontalCenter
                    source: "pause.png"
                    visible: false
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 100
                        }
                    }
                    MouseArea{
                        id: pausemouse
                        anchors.fill: parent
                        onPressed: pause.scale = 1.3
                        onReleased: {
                            pause.scale = 1.0
                            pause.visible = false
                            play.visible = true
                            aplayer.pause()
                            timer.stop()
                            stop_state = false
                            pause_state = true
                            setter.setStopState(stop_state, currentPL)
                            setter.setPauseState(pause_state, currentPL)
                            //curlistmod.setProperty(curTrackPos-1, "ico", "curpause.png")
                            cppmdl.setElementProperty(curTrackPos-1, 258, "curpause.png")
                            //console.log("pause")
                        }
                    }
                }
                Image {
                    id: stop
                    width: playpage.width/5*0.7
                    height: width
                    anchors.bottom: mrect.bottom
                    anchors.bottomMargin: stop.height/3
                    anchors.horizontalCenter: mrect.horizontalCenter
                    source: "stop.png"
                    //visible: false
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 100
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: stop.scale = 1.3
                        onReleased: {
                            stop.scale = 1.0
                            timer.stop()
                            aplayer.stop()
                            curtime.text = "00:00"
                            activeprogress.width = 0
                            play.visible = true
                            pause.visible = false
                            stop_state = true
                            pause_state = true
                            currentprogress = aplayer.position
                            setter.setStopState(stop_state, currentPL)
                            setter.setPauseState(pause_state, currentPL)
                            setter.setCurrentProgress(currentprogress, currentPL)
                        }

                    }
                }
                Image {
                    id: bward
                    y: play.y+(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.right: stop.left
                    anchors.margins: bward.width/3//play.height*0.1
                    source: "bward.png"
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: bward.scale = 1.3
                        onReleased: {
                            bward.scale = 1.0
                            aplayer.seek(aplayer.position-5000)
                            msToTimeCurrent(aplayer.position)
                            msToProgress(aplayer.position, aplayer.duration)
                            timer.interval = 100
                            timer.start()
                            //if(cutRepeat === true)
                            //{
                            //    if(aplayer.position < cutApos)
                            //    {
                            //        cutApos = false
                            //        cutBpos = false
                            //        cutRepeat = false
                            //    }
                            //}
                        }
                    }
                }
                Image {
                    id: fward
                    y: play.y+(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.left: stop.right
                    anchors.margins: fward.width/3//50//play.height*0.1
                    source: "fward.png"
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: fward.scale = 1.3
                        onReleased: {
                            fward.scale = 1.0
                            aplayer.seek(aplayer.position+5000)
                            msToTimeCurrent(aplayer.position)
                            msToProgress(aplayer.position, aplayer.duration)
                            timer.interval = 100
                            timer.start()
                        }
                    }
                }
                Image {//
                    id: bwardtrack
                    y: play.y+(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.right: bward.left
                    anchors.margins: bward.width/3
                    source: "bwardtrack.png"
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            cutA = false
                            cutB = false
                            cutApos = 0
                            cutBpos = 0
                            cutRepeat = false
                            bwardtrack.scale = 1.3
                        }
                        onReleased: {
                            bwardtrack.scale = 1.0
                            if(endofnexttrack === true){
                                endofnexttrack = false
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                curTrackPos = oldCurTrackPos
                            }
                            if(state_next_track === false){
                                console.log(curTrackPos)
                                currentPL = setter.getCurrentPL()
                                timer.stop()
                                aplayer.stop()
                                aplayer.source = setter.prewTrack(currentPL, curTrackPos, shuffle_state)
                                aplayer.play()
                                stop_state = false
                                setter.setStopState(stop_state, currentPL)
                                play.visible = false
                                pause.visible = true
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                timer.start()
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                if(curTrackPos === 1)
                                    curTrackPos = generalTrackCount
                                else curTrackPos--
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                console.log(curTrackPos)
                                setter.setCurrentTrack(currentPL, curTrackPos)
                                setWidthOfPLName()
                                currentlist.currentIndex = curTrackPos-1
                            }
                            else{

                            }
                            titleani.stop()
                            setTitleAnimatiom()
                        }
                    }
                }
                Image {//
                    id: fwardtrack
                    y: play.y+(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.left: fward.right
                    anchors.margins: fward.width/3
                    source: "fwardtrack.png"
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            cutA = false
                            cutB = false
                            cutApos = 0
                            cutBpos = 0
                            cutRepeat = false
                            fwardtrack.scale = 1.3
                        }
                        onReleased: {
                            fwardtrack.scale = 1.0
                            if(endofnexttrack === true){
                                endofnexttrack = false
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                curTrackPos = oldCurTrackPos
                            }
                            if(state_next_track === false){
                                currentPL = setter.getCurrentPL()
                                timer.stop()
                                aplayer.stop()
                                aplayer.source = setter.nextTrack(currentPL, curTrackPos, shuffle_state)
                                aplayer.play()
                                stop_state = false
                                setter.setStopState(stop_state, currentPL)
                                play.visible = false
                                pause.visible = true
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                timer.start()
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                if(curTrackPos === generalTrackCount)
                                    curTrackPos = 1
                                else curTrackPos++
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                setter.setCurrentTrack(currentPL, curTrackPos)
                                setWidthOfPLName()
                                currentlist.currentIndex = curTrackPos-1
                            }
                            else{
                                aplayer.source = setter.playNextTrack(currentPL)
                                aplayer.play()
                                setter.delNextTrack(currentPL, 1)
                                tmpint = 1
                                for(var i = 0; i < generalTrackCount; i++){
                                    //if(curlistmod.get(i).mrknmb === 0)
                                    if(cppmdl.data(i, 263) === 0)
                                        continue
                                    else{
                                        //if(curlistmod.get(i).mrknmb === 1){
                                        if(cppmdl.data(i, 263) === 1){
                                            currentlist.currentIndex = i
                                            //curlistmod.setProperty(i, "mrknmb", 0)
                                            //curlistmod.setProperty(i, "mxtvis", false)
                                            cppmdl.setElementProperty(i, 263, "0")
                                            cppmdl.setElementProperty(i, 264, "false")
                                            play.visible = false
                                            pause.visible = true
                                            tmpstr = setter.loadnamefromPL(aplayer.source)
                                            timer.start()
                                            //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                            //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                            cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                            cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")
                                            curTrackPos = i+1
                                            //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                            //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                            cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                            cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                            setWidthOfPLName()
                                        }
                                        //if(curlistmod.get(i).mrknmb > 1){
                                        if(cppmdl.data(i, 263) > 1){
                                            //curlistmod.setProperty(i, "mrknmb", curlistmod.get(i).mrknmb - 1)
                                            cppmdl.setElementProperty(i, 263, cppmdl.data(i, 263)-1)
                                        }
                                    }
                                }
                                addnexttrack--
                                if(addnexttrack === 0){
                                    state_next_track = false
                                    endofnexttrack = true
                                }
                            }
                            titleani.stop()
                            setTitleAnimatiom()
                        }
                    }
                }
                Image {
                    id: shuffleoff
                    y: play.y-(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.right: play.left
                    anchors.margins: fward.width/3//50//play.height*0.1
                    source: "shuffle_off.png"
                    fillMode: Image.PreserveAspectFit
                    visible: shuffle_state === false ? true : false
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: shuffleoff.scale = 1.3
                        onReleased: {
                            shuffleoff.scale = 1.0
                            shuffleoff.visible = false
                            shuffleon.visible = true
                            shuffle_state = true
                            setter.setShuffleQueue(currentPL, generalTrackCount)
                            curTrackPos = setter.setCurrentPositionShuffleOn(currentPL, aplayer.source, generalTrackCount, fb.getOSVersion())
                            setter.setShuffleState(shuffle_state)
                            //curlistmod.clear()
                            cppmdl.clearModel()
                            //for(var i = 1; i <= setter.getPLTracksCount(currentPL); i++)
                            //{
                            //    curlistmod.append({"nam": setter.viewPL(currentPL, i, shuffle_state),
                            //                          "ico": setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? (stop_state === true ? "curstop.png" : pause_state === false ? "curplay.png" : "curpause.png") : "audio.png",
                            //                          "nmb": i+".",
                            //                          "clr": setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? "#22acee48" : "#00000000",
                            //                          "pth": setter.getPathOfTrack(currentPL, i, shuffle_state),
                            //                          "mxt": "mark_next.png"})
                            //}
                            //currentlist.currentIndex = curTrackPos-1
                        }
                    }
                }
                Image {
                    id: shuffleon
                    y: play.y-(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.right: play.left
                    anchors.margins: fward.width/3//50//play.height*0.1
                    source: "shuffle_on.png"
                    fillMode: Image.PreserveAspectFit
                    visible: shuffle_state === true ? true : false
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: shuffleon.scale = 1.3
                        onReleased: {
                            shuffleon.scale = 1.0
                            shuffleon.visible = false
                            shuffleoff.visible = true
                            shuffle_state = false
                            curTrackPos = setter.setCurrentPositionShuffleOff(currentPL, aplayer.source, generalTrackCount, fb.getOSVersion())
                            setter.setShuffleState(shuffle_state)
                            //curlistmod.clear()
                            cppmdl.clearModel()
                            //for(var i = 1; i <= setter.getPLTracksCount(currentPL); i++)
                            //{
                            //    curlistmod.append({"nam": setter.viewPL(currentPL, i, shuffle_state),
                            //                          "ico": setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? (stop_state === true ? "curstop.png" : pause_state === false ? "curplay.png" : "curpause.png") : "audio.png",
                            //                          "nmb": i+".",
                            //                          "clr": setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? "#22acee48" : "#00000000",
                            //                          "pth": setter.getPathOfTrack(currentPL, i, shuffle_state),
                            //                          "mxt": "mark_next.png"})
                            //    console.log(i)
                            //}
                            //currentlist.currentIndex = curTrackPos-1
                        }
                    }
                }
                Image {
                    id: repeatoff
                    y: play.y-(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.left: play.right
                    anchors.margins: fward.width/3//50//play.height*0.1
                    source: "repeat_off.png"
                    fillMode: Image.PreserveAspectFit
                    visible: repeat_state === 0 ? true : false
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: repeatoff.scale = 1.3
                        onReleased: {
                            repeatoff.scale = 1.0
                            repeat_state = 1
                            setter.setRepeatState(repeat_state)
                        }
                    }
                }
                Image {
                    id: repeatone
                    y: play.y-(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.left: play.right
                    anchors.margins: fward.width/3//50//play.height*0.1
                    source: "repeat_one.png"
                    fillMode: Image.PreserveAspectFit
                    visible: repeat_state === 1 ? true : false
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: repeatone.scale = 1.3
                        onReleased: {
                            repeatone.scale = 1.0
                            repeat_state = 2
                            setter.setRepeatState(repeat_state)
                        }
                    }
                }
                Image {
                    id: repeatall
                    y: play.y-(stop.y - play.y)/2
                    width: playpage.width/5*0.7
                    height: width
                    anchors.left: play.right
                    anchors.margins: fward.width/3//50//play.height*0.1
                    source: "repeat_all.png"
                    fillMode: Image.PreserveAspectFit
                    visible: repeat_state === 2 ? true : false
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: repeatall.scale = 1.3
                        onReleased: {
                            repeatall.scale = 1.0
                            repeat_state = 0
                            setter.setRepeatState(repeat_state)
                        }
                    }
                }
                Image{
                    id: cut_a
                    x: art.x+art.width+(art.x/2)-(width/2)
                    y: art.y+(art.height/4)-(cut_a.height/2)
                    width: playpage.width/5*0.7
                    height: width
                    source: cutA === false ? "a_inact.png" : "a_act.png"
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: cut_a.scale = 1.3
                        onReleased: {
                            cut_a.scale = 1.0
                            if(cutA === false){
                                cutA = true
                                cutApos = aplayer.position
                            }
                            else {
                                cutA = false
                                cutB = false
                                cutApos = 0
                                cutBpos = 0
                                cutRepeat = false
                            }
                        }
                    }
                }
                Image{
                    id: cut_b
                    x: art.x+art.width+(art.x/2)-(width/2)
                    y: art.y+(art.height*0.75)-(cut_a.height/2)
                    width: playpage.width/5*0.7
                    height: width
                    source: cutB === false ? "b_inact.png" : "b_act.png"
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: cut_b.scale = 1.3
                        onReleased: {
                            cut_b.scale = 1.0
                            if(cutA === false){
                                return
                            }
                            else if(cutB === false){
                                cutB = true
                                cutRepeat = true
                                cutBpos = aplayer.position
                                aplayer.stop()
                                timer.stop()
                                aplayer.seek(cutApos)
                                aplayer.play()
                                timer.interval = 100
                                timer.start()
                                console.log("B position = "+Math.floor(cutBpos/100))
                            }
                            else if(cutB === true){
                                cutB = false
                                cutBpos = 0
                                cutRepeat = false

                                timer.interval = 500
                            }
                        }
                    }
                }
                Image{
                    id: muteoff
                    x: (art.x/2)-(width/2)
                    y: art.y+(art.height/4)-(muteoff.height/2)
                    width: playpage.width/5*0.7
                    height: width
                    source: "mute_off.png"
                    visible: mute_state === false ? false : true
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: muteoff.scale = 1.3
                        onReleased: {
                            muteoff.scale = 1.0
                            mute_state = false
                            aplayer.volume = setter.getVolume()
                            artvol.color = "#70acee48"
                            artvol.visible = true
                            artvolani.stop()
                            artvolani.start()
                            timer3.start()

                            setter.setMuteState(mute_state)
                        }
                    }
                }
                Image{
                    id: muteon
                    x: (art.x/2)-(width/2)
                    y: art.y+(art.height/4)-(muteon.height/2)
                    width: playpage.width/5*0.7
                    height: width
                    source: "mute_on.png"
                    visible: mute_state === false ? true : false
                    fillMode: Image.PreserveAspectFit
                    Behavior on scale {
                        PropertyAnimation {
                            duration: 65
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: muteon.scale = 1.3
                        onReleased: {
                            muteon.scale = 1.0
                            mute_state = true
                            volume_state = aplayer.volume
                            artvol.visible = false
                            artvolani.stop()
                            setter.setVolume(aplayer.volume)
                            aplayer.volume = 0
                            setter.setMuteState(mute_state)
                        }
                    }
                }
            }
        }
        Item {
            id: setpage
            Rectangle{
                id: tools
                width: root.width
                height: root.height/12
                color: "#acee48"
                anchors.top: setpage.top
                clip: true
                Image{
                    id: toolsbckg
                    height: tools.height
                    width: tools.width
                    //anchors.fill: parent
                    source: "toolframe.png"
                    //fillMode: Image.PreserveAspectFit
                }
                Rectangle{
                    id: playlist
                    height: tools.height
                    width: parent.width/5
                    anchors.right: tools.right
                    color: "transparent"
                    visible: list.visible === true || fmlist.visible === true || plists.visible === true || setplname_dlg.visible === true ? false : true
                    Image{
                        id: addpl
                        source: "pl.png"
                        //anchors.fill: parent
                        anchors.bottom: playlisttxt.top
                        anchors.bottomMargin: playlisttxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: playlisttxt
                        text: qsTr("Плейлист")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: addpl.scale = 1.3
                        onReleased: {
                            addpl.scale = 1.0
                            plists.visible = true
                            //list.visible = false
                            plistsmod.clear()
                            for(var i = 0; i <= setter.setCountPL(); i++)
                            {
                                if(i === 0)
                                    plistsmod.append({"nam": "Создать плейлист", "ico": "newpl.png", "clr": "#00000000"})
                                else{
                                    plists.currentIndex = i
                                    plistsmod.append({"nam": setter.getPLName(i), "ico": "pl.png", "clr": "#00000000"})
                                }
                            }
                            plists.currentIndex = -1
                        }
                    }
                }
                Rectangle{
                    id: fmanager
                    height: tools.height
                    width: parent.width/5
                    anchors.right: playlist.left
                    color: "transparent"
                    visible: list.visible === true || fmlist.visible === true || plists.visible === true || setplname_dlg.visible === true ? false : true
                    Image{
                        id: fman
                        source: "gfolder.png"
                        //anchors.fill: parent
                        anchors.bottom: fmanagertxt.top
                        anchors.bottomMargin: fmanagertxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: fmanagertxt
                        text: qsTr("Файлы")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: fman.scale = 1.3
                        onReleased: {
                            fman.scale = 1.0
                            fmlistmod.clear()
                            currentlist.visible = false
                            fmlist.visible = true
                            if(fb.getOSVersion() === "android") setRootFolderFM("/storage")
                            else{
                                curfolder = dPath
                                setCurDirectory(curfolder)
                            }
                        }
                    }
                }
                Rectangle{
                    id: playlistadd
                    height: tools.height
                    width: parent.width/5
                    anchors.right: tools.right
                    color: "transparent"
                    visible: list.visible === true ? true : false
                    Image{
                        id: addnewpl
                        source: {
                            if(add_pl_icon_state === false)
                                "addnewpl_inact.png"
                            else "addnewpl.png"
                        }
                        //anchors.fill: parent
                        anchors.bottom: addnewplaylisttxt.top
                        anchors.bottomMargin: addnewplaylisttxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: addnewplaylisttxt
                        text: qsTr("Добавить")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: {
                            if(add_pl_icon_state === false)
                                "grey"
                            else "black"
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            //currentTrackCount = 0
                            //generalTrackCount = 0
                            if(add_pl_icon_state === false)
                                return
                            else addnewpl.scale = 1.3
                        }
                        onReleased: {
                            if(add_pl_icon_state === false)
                                return
                            else {
                                addnewpl.scale = 1.0
                                for(var i = 1; i < list.count; i++) {
                                    list.currentIndex = i
                                    if(listmod.get(list.currentIndex).chck === "mark_green.png")
                                        fb.createPlayList(curfolder, listmod.get(list.currentIndex).nam, fb.getOSVersion())
                                }
                            }
                            setter.createPL(newplname, fb.getList(), fb.getOSVersion())
                            fb.clearList()
                            list.visible = false
                            add_to_pl_count = 0
                        }
                    }
                }
                Rectangle{
                    id: playlistdel
                    height: tools.height
                    width: parent.width/5
                    anchors.right: playlistplay.left
                    color: "transparent"
                    visible: plists.visible === true ? true : false
                    Image{
                        id: delpl
                        source: {
                            if(plists.currentIndex > 0)
                                "delpl.png"
                            else "delpl_inact.png"
                        }
                        anchors.bottom: delplaylisttxt.top
                        anchors.bottomMargin: delplaylisttxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: delplaylisttxt
                        text: qsTr("Удалить")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: {
                            if(plists.currentIndex > 0)
                                "black"
                            else "grey"
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            setter.delCountPL(plistsmod.get(plists.currentIndex).nam, plists.currentIndex)
                            plistsmod.remove(plists.currentIndex)
                            plists.currentIndex = -1
                        }
                    }
                }
                Rectangle{//  PLAY PLAYLIST
                    id: playlistplay
                    height: tools.height
                    width: parent.width/5
                    anchors.right: tools.right
                    color: "transparent"
                    visible: plists.visible === true ? true : false
                    Image{
                        id: playpl
                        source: {
                            if(plists.currentIndex > 0)
                                "playpl.png"
                            else "playpl_inact.png"
                        }
                        anchors.bottom: playplaylisttxt.top
                        anchors.bottomMargin: playplaylisttxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: playplaylisttxt
                        text: qsTr("Играть")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: {
                            if(plists.currentIndex > 0)
                                "black"
                            else "grey"
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            if(play_pl_icon_state === true)
                                playpl.scale = 1.3
                            else return
                        }
                        onReleased: {
                            if(play_pl_icon_state === true){
                                playpl.scale = 1.0
                                if(aplayer.playbackState === aplayer.PlayingState){
                                    timer.stop()
                                    aplayer.stop()
                                }
                                currentPL = plistsmod.get(plists.currentIndex).nam
                                nameofplaylisttxt.text = currentPL
                                setter.setCurrentPL(currentPL)
                                generalTrackCount = setter.getPLTracksCount(currentPL)
                                if(setter.getCurrentTrack() === 0){
                                    aplayer.source = setter.loadPL(currentPL, shuffle_state, generalTrackCount)
                                    aplayer.play()
                                }
                                else{
                                    aplayer.source = setter.setLastTrack(shuffle_state)
                                    aplayer.seek(setter.getCurrentProgress())
                                    aplayer.play()
                                }
                                if(!shuffle_state)
                                    curTrackPos = 1
                                else {
                                    setter.setShuffleQueue(currentPL, generalTrackCount)
                                    curTrackPos = setter.setCurrentPositionShuffleOn(currentPL, aplayer.source, generalTrackCount, fb.getOSVersion())
                                }
                                setter.setCurrentTrack(currentPL, curTrackPos)
                                play.visible = false
                                pause.visible = true
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                timer.start()
                                titleani.stop()
                                setTitleAnimatiom()
                            }
                            else return
                        }
                    }
                }
                Rectangle{
                    id: playlistedit
                    height: tools.height
                    width: parent.width/5
                    anchors.right: playlistdel.left
                    color: "transparent"
                    visible: false//plists.visible === true ? true : false
                    Image{
                        id: editpl
                        source: {
                            if(plists.currentIndex > 0)
                                "editpl.png"
                            else "editpl_inact.png"
                        }
                        anchors.bottom: editplaylisttxt.top
                        anchors.bottomMargin: editplaylisttxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: editplaylisttxt
                        text: qsTr("Изменить")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: {
                            if(plists.currentIndex > 0)
                                "black"
                            else "grey"
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            if(edit_pl_icon_state === true)
                                editpl.scale = 1.3
                            else return
                        }
                        onReleased: {
                            if(edit_pl_icon_state === true)
                                editpl.scale = 1.0
                            else return
                        }
                    }
                }
                Rectangle{
                    id: playlistrn
                    height: tools.height
                    width: parent.width/5
                    anchors.right: playlistopen.left
                    color: "transparent"
                    visible: plists.visible === true ? true : false
                    Image{
                        id: rnpl
                        source: {
                            if(plists.currentIndex > 0)
                                "rnpl.png"
                            else "rnpl_inact.png"
                        }
                        anchors.bottom: rnplaylisttxt.top
                        anchors.bottomMargin: rnplaylisttxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: rnplaylisttxt
                        text: qsTr("Переименовать")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: {
                            if(plists.currentIndex > 0)
                                "black"
                            else "grey"
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            if(rn_pl_icon_state === true)
                                rnpl.scale = 1.3
                            else return
                        }
                        onReleased: {
                            if(rn_pl_icon_state === true)
                                rnpl.scale = 1.0
                            else return
                        }
                    }
                }
                Rectangle{
                    id: playlistopen
                    height: tools.height
                    width: parent.width/5
                    anchors.right: playlistdel.left
                    color: "transparent"
                    visible: plists.visible === true ? true : false
                    Image{
                        id: openpl
                        source: {
                            if(plists.currentIndex > 0)
                                "openpl1.png"
                            else "openpl_inact1.png"
                        }
                        anchors.bottom: openplaylisttxt.top
                        anchors.bottomMargin: openplaylisttxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: openplaylisttxt
                        text: qsTr("Открыть")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: {
                            if(plists.currentIndex > 0)
                                "black"
                            else "grey"
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            if(open_pl_icon_state === true)
                                openpl.scale = 1.3
                            else return
                        }
                        onReleased: {
                            if(open_pl_icon_state === true)
                            {
                                openpl.scale = 1.0
                                currentlist.visible = true
                                plists.visible = false
                                //curlistmod.clear()
                                cppmdl.clearModel()
                                //for(var i = 1; i <= setter.getPLTracksCount(currentPL); i++)
                                //{
                                //    console.log(i)
                                //    console.log(tempstr)
                                //    curlistmod.append({"nam": setter.viewPL(currentPL, i, shuffle_state),
                                //                          "ico": setter.viewPL(currentPL, i, shuffle_state) === aplayer.source ? "curplay.png" : "audio.png",
                                //                          "nmb": i+".",
                                //                          "clr": setter.viewPL(currentPL, i, shuffle_state) === aplayer.source ? "#22acee48" : "#00000000"})
                                //
                                //    console.log(curlistmod.get(i).nam)
                                //}
                            }
                            else return
                        }
                    }
                }
                Rectangle{
                    id: opr
                    height: tools.height
                    width: parent.width/5
                    anchors.right: playlist.left
                    color: "transparent"
                    visible: false
                    Image{
                        id: opi
                        source: "openpl1.png"
                        anchors.bottom: opt.top
                        anchors.bottomMargin: opt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: opt
                        text: qsTr("Удалить")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: opi.scale = 1.3
                        onReleased: {
                            opi.scale = 1.0
                            setter.rmNextTrack(currentPL)
                        }
                    }
                }
                Rectangle{
                    id: search
                    height: tools.height
                    width: parent.width/5
                    anchors.left: tools.left
                    color: "transparent"
                    visible: true
                    Image{
                        id: searchimg
                        source: "search.png"
                        anchors.bottom: searchtxt.top
                        anchors.bottomMargin: searchtxt.font.pixelSize/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: parent.height/3*1.5
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale {
                            PropertyAnimation {
                                duration: 65
                            }
                        }
                    }
                    Text{
                        id: searchtxt
                        text: qsTr("Поиск")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        font.pixelSize: tools.height/5
                        color: "black"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onPressed: searchimg.scale = 1.3
                        onReleased: {
                            searchimg.scale = 1.0
                            setter.rmNextTrack(currentPL)
                            searchbuttonani.start()
                            searchinp.forceActiveFocus()
                        }
                    }
                    ParallelAnimation{
                        id: searchbuttonani
                        NumberAnimation{target: search; property: "y"; from: 0; to: tools.height; duration: tools.height*2}
                        NumberAnimation{target: searchhider; property: "y"; from: searchhider.y; to: 0; duration: tools.height*2;}
                        onStopped: {
                            search.y = tools.height
                            searchhider.y = 0
                        }
                    }
                }
                Rectangle{
                    id: searchhider
                    height: tools.height
                    width: tools.width*0.6
                    y: 0-height
                    anchors.left: tools.left
                    color: "transparent"
                    Image{
                        id: searchhiderimg
                        height: parent.height*0.6
                        width: height
                        anchors.leftMargin: 7
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: searchhiderinp.right
                        source: "close.png"
                        fillMode: Image.PreserveAspectFit
                        Behavior on scale{
                            PropertyAnimation{
                                duration: 65
                            }
                        }
                        MouseArea{
                            anchors.fill: parent
                            onPressed: searchhiderimg.scale = 1.3
                            onReleased: {
                                searchhiderimg.scale = 1.0
                                searchinp.text = ""
                                searchbuttonhideani.start()
                                Qt.inputMethod.hide()
                            }
                        }
                        ParallelAnimation{
                            id: searchbuttonhideani
                            NumberAnimation{target: search; property: "y"; from: tools.height; to: 0; duration: tools.height*2}
                            NumberAnimation{target: searchhider; property: "y"; from: searchhider.y; to: 0-searchhider.height; duration: tools.height*2;}
                            onStopped: {
                                search.y = 0
                                searchhider.y = 0-searchhider
                            }
                        }
                    }
                    Rectangle{
                        id: searchhiderinp
                        height: parent.height*0.4
                        width: searchhider.width-searchhiderimg.width-14
                        border.color: "transparent"
                        border.width: 3
                        anchors.verticalCenter: searchhider.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 7
                        radius: height/2
                        TextInput{
                            id: searchinp
                            width: searchhiderinp.width-20//-(setplname_inprect.border.width)*2//*0.95
                            height: searchhiderinp.height*0.66
                            clip: true
                            anchors.left: parent.left
                            anchors.leftMargin: setplname_inprect.width*0.03
                            anchors.verticalCenter: parent.verticalCenter
                            color: "black"
                            cursorVisible: true
                            horizontalAlignment: Text.AlignLeft
                            autoScroll: true
                            topPadding: 1
                            text: ""
                            renderType: TextInput.NativeRendering
                            bottomPadding: 1
                            verticalAlignment: TextInput.AlignTop
                            wrapMode: TextInput.WrapAtWordBoundaryOrAnywhere
                            inputMethodHints: Qt.ImhNoPredictiveText
                            onLengthChanged: {
                                if(searchinp.text.length === 0){
                                    currentlist.visible = true
                                    searchlist.visible = false
                                    searchlistmod.clear()
                                }
                                else{
                                    currentlist.visible = false
                                    searchlist.visible = true
                                    searchlistmod.clear()

                                    for(var i = 0; i < currentlist.count; i++){
                                        tmpstr2 = cppmdl.data(i, 257)//curlistmod.get(i).nam
                                        tmpstr2 = tmpstr2.toUpperCase()
                                        tmpstr3 = searchinp.text
                                        tmpstr3 = tmpstr3.toUpperCase()
                                        if(setter.searchTrack(tmpstr3, tmpstr2) === true){
                                            searchlistmod.append({"nam": cppmdl.data(i, 257),//curlistmod.get(i).nam,
                                                               "ico": cppmdl.data(i, 258),//curlistmod.get(i).ico,
                                                               "nmb": cppmdl.data(i, 259),//curlistmod.get(i).nmb,
                                                               "clr": cppmdl.data(i, 260),//curlistmod.get(i).clr,
                                                               "pth": cppmdl.data(i, 261),//curlistmod.get(i).pth,
                                                               "mxt": cppmdl.data(i, 262)})//curlistmod.get(i).mxt})
                                        }
                                        else continue
                                    }
                                }
                            }
                            Text{
                                id: searchphtxt
                                text: "Поиск"
                                color: "#aaaaaa"
                                anchors.left: parent.left
                                anchors.leftMargin: setplname_inprect.width*0.03
                                anchors.verticalCenter: parent.verticalCenter
                                visible: searchinp.text.length === 0 ? true : false
                            }
                        }
                    }
                }
            }
            Rectangle{
                id: setwnd
                width: root.width
                height: root.height-tools.height
                anchors.top: tools.bottom
                color: "transparent"//"black"
                Rectangle{
                    id: fldr
                    width: parent.width
                    height: tools.height/3
                    color: "transparent"
                    visible: list.visible === true || fmlist.visible === true ? true : false
                    clip: true
                    Text{
                        id: fldrtxt
                        x: {
                            if(list.visible === true)
                                fldrtxt.width < root.width ? (root.width-fldrtxt.width)/2 : root.width-fldrtxt.width
                            else if(fmlist.visible === true)
                                fldrtxt.width < root.width ? (root.width-fldrtxt.width)/2 : root.width-fldrtxt.width
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: tools.height/4
                        color: "#acee48"
                        text: curfolder
                    }
                }
                ListView{
                    id: list
                    width: root.width
                    height: root.height - tools.height - fldr.height
                    anchors.bottom: setwnd.bottom
                    clip: true
                    spacing: 25
                    maximumFlickVelocity: 16000
                    visible: false
                    ScrollBar.vertical: ScrollBar{active: true}
                    model: ListModel{
                        id: listmod
                        ListElement{
                            nam: "NAME1"
                            ico: "justfile.png"
                            chck: "mark_grey.png"
                            clr: "#00000000"
                        }
                    }
                    delegate: Rectangle{
                        id: dlgt
                        height: setwnd.height/14
                        width: setwnd.width/25*24
                        color: "transparent"
                        anchors.margins: 20
                        MouseArea{
                            height: parent.height
                            width: parent.width - mark.width
                            anchors.left: mark.right
                            onClicked: {
                                list.currentIndex = index
                                if(listmod.get(list.currentIndex).ico === "folder.png")
                                {
                                    console.log("it's folder")
                                    curfolder = fb.folderDown(curfolder, listmod.get(list.currentIndex).nam)
                                    setCurDirectory(curfolder)
                                }
                                else if(listmod.get(list.currentIndex).ico === "audio.png")
                                {
                                    console.log("it's audio")
                                    aplayer.stop()
                                    timer.stop()
                                    tmpstr = curfolder+"/"
                                    if(fb.getOSVersion() === "android")
                                        tmpstr = "file://"+tmpstr+listmod.get(list.currentIndex).nam
                                    else tmpstr = tmpstr+listmod.get(list.currentIndex).nam
                                    //console.log(tmpstr)
                                    curTrackPos = 1
                                    generalTrackCount = 1
                                    setter.createZeroPL(tmpstr)
                                    setter.setCurrentTrack(".", curTrackPos)
                                    nameofplaylisttxt.text = ""
                                    setter.setCurrentPL(".")
                                    currentPL = "."
                                    aplayer.source = tmpstr
                                    stop_state = false
                                    pause_state = false
                                    setter.setStopState(stop_state, currentPL)
                                    setter.setPauseState(pause_state, currentPL)
                                    aplayer.play()
                                    play.visible = false
                                    pause.visible = true
                                    tmpstr = listmod.get(list.currentIndex).nam
                                    timer.start()
                                    titleani.stop()
                                    setTitleAnimatiom()
                                }
                                else if(listmod.get(list.currentIndex).ico === "return2.png")
                                {
                                    console.log("it's return")
                                    if(curfolder === "/storage/emulated/0" || curfolder === "/storage/"+setter.getSDCardName())setRootFolderFM("/storage")
                                    else{
                                        curfolder = fb.folderUp(curfolder)
                                        setCurDirectory(curfolder)
                                    }
                                }
                                else if(listmod.get(list.currentIndex).ico === "memory.png")
                                {
                                    curfolder = "/storage/emulated/0"
                                    setCurDirectory(curfolder)
                                }
                                else if(listmod.get(list.currentIndex).ico === "sdcard.png")
                                {
                                    curfolder = "/storage"
                                    setCurDirectory(curfolder+"/"+setter.getSDCardName())
                                }
                            }
                            onPressed: {
                                list.currentIndex = index
                            }
                        }
                        Rectangle{
                            id: mark
                            height: parent.height
                            width: height
                            anchors.left: parent.left
                            color: "transparent"
                            Image{
                                id: mark_icon
                                height: parent.height/2
                                width: height
                                source: chck
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                //anchors.verticalCenter: parent.verticalCenter
                                //anchors.left: parent.left
                                //anchors.margins: 30
                            }
                            MouseArea{
                                anchors.fill: parent
                                propagateComposedEvents: true
                                onClicked: {
                                    list.currentIndex = index
                                    console.log(listmod.get(index).chck)
                                    if(index === 0){
                                        if(listmod.get(0).chck === "mark_grey.png")
                                            for(var i = 0; i < list.count; i++)
                                                    listmod.set(i, {"chck": "mark_green.png"})
                                        else if(listmod.get(0).chck === "mark_green.png")
                                            for(var j = 0; j < list.count; j++)
                                                    listmod.set(j, {"chck": "mark_grey.png"})

                                        if(listmod.get(0).chck === "mark_green.png")
                                            add_to_pl_count = list.count-1
                                        else if(listmod.get(0).chck === "mark_grey.png")
                                            add_to_pl_count = 0
                                    }
                                    else{
                                        if(listmod.get(index).chck === "mark_grey.png"){
                                            listmod.set(index, {"chck": "mark_green.png"})
                                            ++add_to_pl_count
                                        }
                                        else if(listmod.get(index).chck === "mark_green.png"){
                                            listmod.set(index, {"chck": "mark_grey.png"})
                                            --add_to_pl_count
                                        }
                                    }
                                    console.log("add_to_pl - "+add_to_pl_count)
                                }
                            }
                        }
                        Image{
                            id: dicon
                            height: parent.height/2
                            width: height
                            source: ico
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: mark.right
                            anchors.margins: 30

                        }
                        Text{
                            id: dtxt
                            text: nam
                            color: "#acee48"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: dicon.right
                            anchors.margins: 20
                        }
                    }
                }
                ListView{
                    id: plists
                    width: root.width
                    height: root.height - tools.height
                    anchors.bottom: setwnd.bottom
                    clip: true
                    spacing: 25
                    maximumFlickVelocity: 16000
                    visible: false
                    ScrollBar.vertical: ScrollBar{active: true}
                    model: ListModel{
                        id: plistsmod
                        ListElement{
                            nam: "Создать плейлист"
                            ico: "newpl.png"
                            clr: "#00000000"
                        }
                    }
                    delegate: Rectangle{
                        id: plistsdlgt
                        height: setwnd.height/14
                        width: setwnd.width/25*24
                        color: clr
                        anchors.margins: 20
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                plists.currentIndex = index
                                console.log(plists.currentIndex)
                                if(index === 0/*plistsmod.get(index).ico === "newpl.png"*/){
                                    plists.visible = false
                                    setplname_dlg.visible = true
                                    setplname_inp.forceActiveFocus()
                                    play_pl_icon_state = false
                                    edit_pl_icon_state = false
                                    rn_pl_icon_state = false
                                    open_pl_icon_state = false
                                }
                                else {
                                    for(var i = 0; i < plists.count; i++)
                                    {
                                        if(i === index){
                                           plistsmod.setProperty(i, "clr", "#22acee48")
                                            console.log("i = "+i)
                                        }
                                        else {
                                            console.log("i = "+i)
                                            plistsmod.setProperty(i, "clr", "#00000000")
                                        }
                                    }
                                    play_pl_icon_state = true
                                    edit_pl_icon_state = true
                                    rn_pl_icon_state = true
                                    open_pl_icon_state = true
                                }


                            }
                        }
                        Image{
                            id: plistsdicon
                            height: parent.height*0.8
                            //width: height
                            source: ico
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 30

                        }
                        Text{
                            id: plistsdtxt
                            text: nam
                            color: "#acee48"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: plistsdicon.right
                            anchors.margins: 20
                        }
                    }
                }
                ListView{
                    id: currentlist
                    width: root.width
                    height: root.height - tools.height
                    anchors.bottom: setwnd.bottom
                    clip: true
                    maximumFlickVelocity: 160000
                    visible: playlist.visible === true ? true : false
                    highlightFollowsCurrentItem: true
                    highlightRangeMode: ListView.ApplyRange//StrictlyEnforceRange
                    highlightMoveDuration: 0
                    preferredHighlightBegin: currentlist.height/2-400
                    preferredHighlightEnd: { if(currentlist.currentIndex > 4 || currentlist.currentIndex < (currentlist.count+1)-6) currentlist.height/2-100 }
                    ScrollBar.vertical: ScrollBar{active: true}
                    model: cppmdl
                    //model: ListModel{
                    //    id: curlistmod
                    //    ListElement{
                    //        pth: ""
                    //        nmb: "0"
                    //        ico: "audio.png"
                    //        nam: "NAME1"
                    //        clr: "#00000000"
                    //        mrknmb: 0
                    //        mxt: "mark_next.png"
                    //        mxtvis: false
                    //    }
                    //}
                    delegate: Rectangle{
                        id: curdlgt
                        height: currentlist.height/10
                        width: currentlist.width
                        color: colorR//clr
                        anchors.margins: 20
                        clip: true
                        MouseArea{
                            height: parent.height
                            width: parent.width-curplicon.width
                            anchors.right: parent.right
                            pressAndHoldInterval: 300
                            onMouseXChanged: {currentlist.interactive = false}
                            onMouseYChanged: {currentlist.interactive = true}
                            onClicked:{
                                timer.stop()
                                aplayer.stop()
                                curtime.text = "00:00"
                                activeprogress.width = 0
                                //console.log("cur-1 ="+(curTrackPos-1))
                                aplayer.source = pathR
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#00000000")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "audio.png")

                                //здесь ниже неясно за что отвечает index

                                curTrackPos = cppmdl.data(index, 259)//curlistmod.get(index).nmb
                                //curlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                //curlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                cppmdl.setElementProperty(curTrackPos-1, 260, "#22acee48")
                                cppmdl.setElementProperty(curTrackPos-1, 258, "curplay.png")
                                aplayer.play()
                                pause_state = false
                                play.visible = false
                                pause.visible = true
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                timer.start()
                                setter.setCurrentTrack(currentPL, curTrackPos)
                                setWidthOfPLName()
                                setter.setPauseState(pause_state, currentPL)
                                setTitleAnimatiom()
                            }
                            onPressAndHold: {
                                if(markvR === false){
                                    //if(curlistmod.get(currentlist.currentIndex).nmb === (currentlist.currentIndex+1)+".")
                                    if(cppmdl.data(currentlist.currentIndex, 259) === (currentlist.currentIndex+1)+".")
                                        return
                                    else{
                                        markvR = true
                                        marknR = ++addnexttrack
                                        setter.addNextTrack(currentPL, pathR, addnexttrack)
                                        if(addnexttrack === 1){
                                            oldCurTrackPos = curTrackPos
                                            state_next_track = true
                                        }
                                    }
                                }
                                else if(markvR === true){
                                    setter.delNextTrack(currentPL, marknR)
                                    tmpint = marknR
                                    tmpint2 = tmpint
                                    for(var j = 0; j < generalTrackCount; j++){
                                        currentlist.currentIndex = j
                                        //if(cppmdl.data(j, cppmdl.roleNames(number)) === 0)//curlistmod.get(j).mrknmb === 0)
                                        if(cppmdl.data(j, 259) === 0)
                                            continue
                                        else{
                                            //if(curlistmod.get(j).mrknmb === tmpint){
                                            if(cppmdl.data(j, 263) === 0){
                                                //curlistmod.setProperty(j, "mrknmb", "0")
                                                cppmdl.setElementProperty(j, 263, "0")
                                                markvR = false
                                                tmpint += generalTrackCount
                                            }
                                            //if(curlistmod.get(j).mrknmb > tmpint2){
                                            if(cppmdl.data(j, 263) > tmpint2){
                                                //curlistmod.setProperty(j, "mrknmb", curlistmod.get(j).mrknmb - 1)
                                                cppmdl.setElementProperty(j, 263, cppmdl.data(j, 263)-1)
                                            }
                                        }
                                    }
                                    addnexttrack--
                                    if(addnexttrack === 0){
                                        curTrackPos = oldCurTrackPos
                                        state_next_track = false
                                    }
                                }
                            }
                        }
                        Rectangle{
                            id: curpliconrect
                            height: parent.height
                            width: height
                            anchors.left: parent.left
                            color: "transparent"
                            Image{
                                id: curplicon
                                height: parent.height*0.5
                                width: height
                                source: iconR//ico
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        //if(ico === "audio.png"){   //из source получаю картинку в виде == "qrc:/name.png"
                                        console.log(curplicon.source)
                                        console.log(iconR)
                                        if(iconR == "audio.png" || iconR === "qrc:/audio.png"){
                                            console.log(curplicon.source)
                                            console.log(iconR)
                                            return
                                        }
                                        else if(iconR == "curplay.png"){
                                            iconR = "curpause.png"
                                            curplicon.source = iconR
                                            console.log(curplicon.source)
                                            console.log(iconR)
                                            pause.visible = false
                                            play.visible = true
                                            aplayer.pause()
                                            timer.stop()
                                            pause_state = true
                                            stop_state = false
                                            //console.log("pause")
                                            setter.setPauseState(pause_state, currentPL)
                                            setter.setStopState(stop_state, currentPL)
                                        }
                                        else if(iconR == "curpause.png"){
                                            iconR = "curplay.png"
                                            curplicon.source = iconR
                                            console.log(curplicon.source)
                                            console.log(iconR)
                                            play.visible = false
                                            pause.visible = true
                                            aplayer.play()
                                            timer.start()
                                            pause_state = false
                                            stop_state = false
                                            //console.log("play")
                                            setter.setPauseState(pause_state, currentPL)
                                            setter.setStopState(stop_state, currentPL)
                                        }
                                        else if(iconR == "curstop.png"){
                                            iconR = "curplay.png"
                                            curplicon.source = iconR
                                            console.log(curplicon.source)
                                            console.log(iconR)
                                            play.visible = false
                                            pause.visible = true
                                            aplayer.play()
                                            timer.start()
                                            pause_state = false
                                            stop_state = true
                                            //console.log("play")
                                            setter.setPauseState(pause_state, currentPL)
                                            setter.setStopState(stop_state, currentPL)
                                        }
                                    }
                                }
                            }
                        }
                        Text{
                            id: curplnumber
                            text: numberR//nmb
                            color: "#acee48"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: curpliconrect.right
                            anchors.leftMargin: 15
                        }
                        Text{
                            id: curplname
                            text: nameR//nam
                            color: "#acee48"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: curplnumber.right
                            anchors.leftMargin: 5
                        }
                        Image{
                            id: nexttrackmark
                            height: parent.height*0.7
                            width: height
                            source: markR//mxt//"mark_green.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 5
                            visible: markvR//cppmdl.data(0, 264)
                            Text{
                                id: nexttracknumber
                                anchors.centerIn: nexttrackmark
                                color: "black"
                                font.bold: true
                                text: marknR
                                //visible: false
                            }
                        }
                        Text{
                            id: nexttrackpath
                            visible: false
                            text: pathR//pth
                        }
                    }
                }
                ListView{
                    id: fmlist
                    width: root.width
                    height: root.height - tools.height - fldr.height
                    anchors.bottom: setwnd.bottom
                    clip: true
                    spacing: 25
                    maximumFlickVelocity: 16000
                    visible: false
                    ScrollBar.vertical: ScrollBar{active: true}
                    model: ListModel{
                        id: fmlistmod
                        ListElement{
                            nam: "NAME1"
                            ico: "justfile.png"
                            chck: "mark_grey.png"
                            clr: "#00000000"
                        }
                    }
                    delegate: Rectangle{
                        id: fmdlgt
                        height: setwnd.height/14
                        width: setwnd.width/25*24
                        color: "transparent"
                        anchors.margins: 20
                        MouseArea{
                            height: parent.height
                            width: parent.width - fmmark.width
                            anchors.left: fmmark.right
                            onClicked: {
                                fmlist.currentIndex = index
                                if(fmlistmod.get(fmlist.currentIndex).ico === "gfolder.png")
                                {
                                    console.log("it's folder")
                                    curfolder = fb.folderDown(curfolder, fmlistmod.get(fmlist.currentIndex).nam)
                                    setCurDirectory(curfolder)
                                }
                                else if(fmlistmod.get(fmlist.currentIndex).ico === "audio.png")
                                {
                                    console.log("it's audio")
                                    aplayer.stop()
                                    timer.stop()
                                    tmpstr = curfolder+"/"
                                    if(fb.getOSVersion() === "android")
                                        tmpstr = "file://"+tmpstr+fmlistmod.get(fmlist.currentIndex).nam
                                    else tmpstr = tmpstr+fmlistmod.get(fmlist.currentIndex).nam
                                    //console.log(tmpstr)
                                    curTrackPos = 1
                                    generalTrackCount = 1
                                    setter.createZeroPL(tmpstr)
                                    setter.setCurrentTrack(".", curTrackPos)
                                    nameofplaylisttxt.text = ""
                                    setter.setCurrentPL(".")
                                    currentPL = "."
                                    aplayer.source = tmpstr
                                    stop_state = false
                                    pause_state = false
                                    setter.setStopState(stop_state, currentPL)
                                    setter.setPauseState(pause_state, currentPL)
                                    aplayer.play()
                                    play.visible = false
                                    pause.visible = true
                                    tmpstr = fmlistmod.get(fmlist.currentIndex).nam
                                    timer.start()
                                    titleani.stop()
                                    setTitleAnimatiom()
                                }
                                else if(fmlistmod.get(fmlist.currentIndex).ico === "return2.png")
                                {
                                    console.log("it's return")
                                    if(curfolder === "/storage/emulated/0" || curfolder === "/storage/"+setter.getSDCardName()) setRootFolderFM("/storage")
                                    else{
                                        curfolder = fb.folderUp(curfolder)
                                        setCurDirectory(curfolder)
                                    }
                                }
                                else if(fmlistmod.get(fmlist.currentIndex).ico === "memory.png")
                                {
                                    curfolder = "/storage/emulated/0"
                                    setCurDirectory(curfolder)
                                }
                                else if(fmlistmod.get(fmlist.currentIndex).ico === "sdcard.png")
                                {
                                    curfolder = "/storage"
                                    setCurDirectory(curfolder+"/"+setter.getSDCardName())
                                }
                            }
                            onPressed: {
                                fmlist.currentIndex = index
                            }
                        }
                        Rectangle{
                            id: fmmark
                            height: parent.height
                            width: height
                            anchors.left: parent.left
                            color: "transparent"
                            Image{
                                id: fmmark_icon
                                height: parent.height/2
                                width: height
                                source: chck
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                //anchors.verticalCenter: parent.verticalCenter
                                //anchors.left: parent.left
                                //anchors.margins: 30
                            }
                            MouseArea{
                                anchors.fill: parent
                                propagateComposedEvents: true
                                onClicked: {
                                    fmlist.currentIndex = index
                                    console.log(fmlistmod.get(index).chck)
                                    if(index === 0){
                                        if(fmlistmod.get(0).chck === "mark_grey.png")
                                            for(var i = 0; i < fmlist.count; i++)
                                                    fmlistmod.set(i, {"chck": "mark_green.png"})
                                        else if(fmlistmod.get(0).chck === "mark_green.png")
                                            for(var j = 0; j < fmlist.count; j++)
                                                    fmlistmod.set(j, {"chck": "mark_grey.png"})

                                        if(fmlistmod.get(0).chck === "mark_green.png")
                                            add_to_pl_count = fmlist.count-1
                                        else if(fmlistmod.get(0).chck === "mark_grey.png")
                                            add_to_pl_count = 0
                                    }
                                    else{
                                        if(fmlistmod.get(index).chck === "mark_grey.png"){
                                            fmlistmod.set(index, {"chck": "mark_green.png"})
                                            ++add_to_pl_count
                                        }
                                        else if(fmlistmod.get(index).chck === "mark_green.png"){
                                            fmlistmod.set(index, {"chck": "mark_grey.png"})
                                            --add_to_pl_count
                                        }
                                    }
                                    console.log("add_to_pl - "+add_to_pl_count)
                                }
                            }
                        }
                        Image{
                            id: fmdicon
                            height: parent.height/2
                            width: height
                            source: ico
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: fmmark.right
                            anchors.margins: 30

                        }
                        Text{
                            id: fmdtxt
                            text: nam
                            color: "#acee48"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: fmdicon.right
                            anchors.margins: 20
                        }
                    }
                }
                ListView{
                    id: searchlist
                    width: root.width
                    height: root.height - tools.height
                    anchors.bottom: setwnd.bottom
                    clip: true
                    visible: false
                    maximumFlickVelocity: 160000
                    //visible: playlist.visible === true ? true : false
                    highlightFollowsCurrentItem: true
                    highlightRangeMode: ListView.ApplyRange//StrictlyEnforceRange
                    highlightMoveDuration: 0
                    preferredHighlightBegin: searchlist.height/2-400
                    preferredHighlightEnd: { if(searchlist.currentIndex > 4 || searchlist.currentIndex < (searchlist.count+1)-6) searchlist.height/2-100 }
                    ScrollBar.vertical: ScrollBar{active: true}
                    model: ListModel{
                        id: searchlistmod
                        ListElement{
                            pth: ""
                            nmb: "0"
                            ico: "audio.png"
                            nam: "NAME+"
                            clr: "#00000000"
                            mrknmb: 0
                            mxt: "mark_next.png"
                            mxtvis: false
                        }
                    }
                    delegate: Rectangle{
                        id: searchdlgt
                        height: searchlist.height/10
                        width: searchlist.width//25*24
                        color: clr
                        anchors.margins: 20
                        clip: true
                        MouseArea{
                            height: parent.height
                            width: parent.width-searchplicon.width
                            anchors.right: parent.right
                            pressAndHoldInterval: 300
                            onMouseXChanged: {searchlist.interactive = false}
                            onMouseYChanged: {searchlist.interactive = true}
                            onClicked:{
                                timer.stop()
                                aplayer.stop()
                                curtime.text = "00:00"
                                activeprogress.width = 0
                                //console.log("cur-1 ="+(curTrackPos-1))
                                aplayer.source = pth
                                searchlistmod.setProperty(curTrackPos-1, "clr", "#00000000")
                                searchlistmod.setProperty(curTrackPos-1, "ico", "audio.png")
                                curTrackPos = searchlistmod.get(index).nmb
                                searchlistmod.setProperty(curTrackPos-1, "clr", "#22acee48")
                                searchlistmod.setProperty(curTrackPos-1, "ico", "curplay.png")
                                aplayer.play()
                                pause_state = false
                                play.visible = false
                                pause.visible = true
                                tmpstr = setter.loadnamefromPL(aplayer.source)
                                timer.start()
                                setter.setCurrentTrack(currentPL, curTrackPos)
                                setWidthOfPLName()
                                setter.setPauseState(pause_state, currentPL)
                                setTitleAnimatiom()
                            }
                            onPressAndHold: {
                                if(mxtvis === false){
                                    if(searchlistmod.get(searchlist.currentIndex).nmb === (searchlist.currentIndex+1)+".")
                                        return
                                    else{
                                        markvR = true
                                        marknR = ++addnexttrack
                                        setter.addNextTrack(currentPL, pth, addnexttrack)
                                        if(addnexttrack === 1){
                                            oldCurTrackPos = curTrackPos
                                            state_next_track = true
                                        }
                                    }
                                }
                                else if(mxtvis === true){
                                    setter.delNextTrack(currentPL, mrknmb)
                                    tmpint = mrknmb
                                    tmpint2 = tmpint
                                    for(var j = 0; j < generalTrackCount; j++){
                                        searchlist.currentIndex = j
                                        if(searchlistmod.get(j).mrknmb === 0)
                                            continue
                                        else{
                                            if(searchlistmod.get(j).mrknmb === tmpint){
                                                searchlistmod.setProperty(j, "mrknmb", "0")
                                                mxtvis = false
                                                tmpint += generalTrackCount
                                            }
                                            if(searchlistmod.get(j).mrknmb > tmpint2){
                                                searchlistmod.setProperty(j, "mrknmb", searchlistmod.get(j).mrknmb - 1)
                                            }
                                        }
                                    }
                                    addnexttrack--
                                    if(addnexttrack === 0){
                                        curTrackPos = oldCurTrackPos
                                        state_next_track = false
                                    }
                                }
                            }
                        }
                        Rectangle{
                            id: searchpliconrect
                            height: parent.height
                            width: height
                            anchors.left: parent.left
                            color: "transparent"
                            Image{
                                id: searchplicon
                                height: parent.height*0.5
                                width: height
                                source: ico
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log(searchplicon.source)
                                        if(ico === "audio.png"){   //из source получаю картинку в виде == "qrc:/name.png"
                                            return
                                        }
                                        else if(ico === "curplay.png"){
                                            ico = "curpause.png"
                                            pause.visible = false
                                            play.visible = true
                                            aplayer.pause()
                                            timer.stop()
                                            pause_state = true
                                            stop_state = false
                                            console.log("pause")
                                            setter.setPauseState(pause_state, currentPL)
                                            setter.setStopState(stop_state, currentPL)
                                        }
                                        else if(ico === "curpause.png"){
                                            ico = "curplay.png"
                                            play.visible = false
                                            pause.visible = true
                                            aplayer.play()
                                            timer.start()
                                            pause_state = false
                                            stop_state = false
                                            console.log("play")
                                            setter.setPauseState(pause_state, currentPL)
                                            setter.setStopState(stop_state, currentPL)
                                        }
                                        else if(ico === "curstop.png"){
                                            ico = "curplay.png"
                                            play.visible = false
                                            pause.visible = true
                                            aplayer.play()
                                            timer.start()
                                            pause_state = false
                                            stop_state = true
                                            console.log("play")
                                            setter.setPauseState(pause_state, currentPL)
                                            setter.setStopState(stop_state, currentPL)
                                        }
                                    }
                                }
                            }
                        }
                        Text{
                            id: searchplnumber
                            text: nmb
                            color: "#acee48"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: searchpliconrect.right
                            anchors.leftMargin: 15
                        }
                        Text{
                            id: searchplname
                            text: nam
                            color: "#acee48"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: searchplnumber.right
                            anchors.leftMargin: 5
                        }
                        Image{
                            id: searchnexttrackmark
                            height: parent.height*0.7
                            width: height
                            source: mxt//"mark_green.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 5
                            visible: mxtvis
                            Text{
                                id: searchnexttracknumber
                                anchors.centerIn: searchnexttrackmark
                                color: "black"
                                font.bold: true
                                text: mrknmb
                                //visible: false
                            }
                        }
                        Text{
                            id: searchnexttrackpath
                            visible: false
                            text: pth
                        }
                    }
                }
                Rectangle{
                    id: setplname_dlg
                    y: tools.y + tools.height*2
                    height: setwnd.height/4
                    width: setwnd.width*0.8
                    anchors.horizontalCenter: setwnd.horizontalCenter
                    anchors.margins: tools.height
                    color: "#e0000000"
                    border.color: "#acee48"
                    border.width: 3
                    radius: 8
                    visible: false
                    Text{
                        id: setplname_ttl
                        text: "Новый плейлист"
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#acee48"
                        anchors.top: parent.top
                        anchors.margins: height/2
                    }
                    Rectangle{
                        id: setplname_inprect
                        height: setplname_ttl.height * 2
                        width: setplname_dlg.width * 0.8
                        color: "transparent"
                        border.color: "#acee48"
                        border.width: 3
                        anchors.centerIn: parent
                        radius: 8
                        TextInput{
                            id: setplname_inp
                            width: setplname_inprect.width*0.95//-(setplname_inprect.border.width)*2//*0.95
                            height: setplname_ttl.height
                            clip: true
                            anchors.centerIn: parent
                            //anchors.fill: parent
                            color: "#acee48"
                            cursorVisible: true
                            horizontalAlignment: Text.AlignLeft
                            autoScroll: true
                            topPadding: 1
                            renderType: TextInput.NativeRendering
                            bottomPadding: 1
                            verticalAlignment: TextInput.AlignTop
                            inputMethodHints: Qt.ImhNoPredictiveText
                            wrapMode: TextInput.WrapAnywhere
                            onAccepted: {
                                if(setplname_inp.text === "") newplname = "Default"
                                else newplname = setplname_inp.text
                                console.log("New name pl = "+newplname)
                                setplname_dlg.visible = false
                                plists.visible = false
                                list.visible = true
                                setCurDirectory("/storage")
                                Qt.inputMethod.hide()
                                setplname_inp.clear()
                            }
                            onLengthChanged: {
                                setplname_inp.text === "" ? placeholdertxt.visible = true :  placeholdertxt.visible = false
                                console.log("length = "+setplname_inp.text.length)
                            }
                            onTextChanged: {
                                setplname_inp.text === "" ? placeholdertxt.visible = true :  placeholdertxt.visible = false
                                console.log("changed!")
                            }
                            onTextEdited: {
                                setplname_inp.text === "" ? placeholdertxt.visible = true :  placeholdertxt.visible = false
                                console.log("edited!")
                            }
                            Text{
                                id: placeholdertxt
                                text: "Введите имя плейлиста"
                                color: "#80acee48"
                                anchors.left: parent.left
                                anchors.leftMargin: setplname_inprect.width*0.03
                                //visible: {
                                //    //console.log(fb.getOSVersion())
                                //   /* if(fb.getOSVersion() === "android"){*/setplname_inp.text !== "" ? false : true
                                //    //else{setplname_inp.text.length === 0 ? true : false}
                                //}
                            }
                        }
                    }
                    Rectangle{
                        id: setplname_cncl
                        height: setplname_dlg.height/4
                        width: setplname_dlg.width/4
                        anchors.bottom: setplname_dlg.bottom
                        anchors.right: setplname_dlg.right
                        color: "transparent"
                        Text{
                            text: "Отмена"
                            anchors.centerIn: parent
                            color: "#acee48"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                setplname_dlg.visible = false
                                plists.visible = true
                                setplname_inp.clear()
                                Qt.inputMethod.hide()
                                for(var i = 0; i < plists.count; i++) plistsmod.setProperty(i, "clr", "#00000000")
                            }
                        }
                    }
                    Rectangle{
                        id: setplname_ok
                        height: setplname_dlg.height/4
                        width: setplname_dlg.width/4
                        anchors.bottom: setplname_dlg.bottom
                        anchors.right: setplname_cncl.left
                        color: "transparent"
                        Text{
                            text: "Готово"
                            anchors.centerIn: parent
                            color: "#acee48"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                setplname_dlg.visible = false
                                listmod.clear()
                                list.visible = true
                                if(fb.getOSVersion() === "android") setRootFolderFM("/storage")
                                else{
                                    curfolder = dPath
                                    setCurDirectory(curfolder)
                                }
                                if(setplname_inp.text === "") newplname = "Default"
                                else newplname = setplname_inp.text
                                console.log("New name pl = "+newplname)
                                setplname_inp.clear()
                                Qt.inputMethod.hide()
                                for(var i = 0; i < plists.count; i++) plistsmod.setProperty(i, "clr", "#00000000")
                            }
                        }
                    }
                }
            }
        }
    }

    function clearList(){
        //console.log("clear sum1 = "+sum)
        if(list.count === 0)
            return
        else if(list.count > 0)
        {
            for(var i = list.count-1; i >= 0; i--)
                listmod.remove(i)
        }


    }
    function defineIcon(name){
        tmpstr = name
        name = name.slice(-4)
        if(fb.checkIsFolder(curfolder, tmpstr) === true && name !== ".."){
            if(fmlist.visible === true)
                return "gfolder.png"
            else if(list.visible === true)
                return "folder.png"
        }
        else {
            if(name === "..")
                return "return2.png"
            else if(name === ".mp3" || name === ".m4a" || name === "flac" || name === ".wav")
                return "audio.png"
            else if(name === ".mov" || name === ".mp4")
                return "video.png"
            //else return "justfile.png"

        }
    }
    function setCurDirectory(path){
        curfolder = path
        console.log("PAth === "+path)
        if(list.visible === true){
            listmod.clear()
            sum = fb.getSumOfFiles(path)
            for(var i = 0; i < sum; i++)
            {
                tmpstr = fb.getFileName(path, i)
                if(i === 0)
                    continue
                else if(i > 0){
                    if(fb.checkIsFolder(path, tmpstr) === true || tmpstr.slice(-4) === ".mp3" || tmpstr.slice(-4) === ".m4a" || tmpstr.slice(-4) === ".wav" || tmpstr.slice(-4) === "flac")
                        listmod.append({"nam": fb.getFileName(path, i), "ico": defineIcon(fb.getFileName(path, i)), "chck": defineChecker(fb.getFileName(path, i))})
                    else continue
                }
            }
            tmpstr = setter.loadnamefromPL(aplayer.source)
        }
        else if(fmlist.visible === true){
            fmlistmod.clear()
            sum = fb.getSumOfFiles(path)
            for(var j = 0; j < sum; j++)
            {
                tmpstr = fb.getFileName(path, j)
                if(j === 0)
                    continue
                else if(j > 0){
                    if(fb.checkIsFolder(path, tmpstr) === true || tmpstr.slice(-4) === ".mp3" || tmpstr.slice(-4) === ".m4a" || tmpstr.slice(-4) === ".wav" || tmpstr.slice(-4) === "flac")
                        fmlistmod.append({"nam": fb.getFileName(path, j), "ico": defineIcon(fb.getFileName(path, j)), "chck": defineChecker(fb.getFileName(path, j))})
                    else continue
                }
            }
            tmpstr = setter.loadnamefromPL(aplayer.source)
        }
    }
    function msToTime(duration) {
        var seconds = parseInt((duration/1000)%60);
        var minutes = parseInt((duration/(1000*60))%60);
        var hours = parseInt((duration/(1000*60*60))%60);

        if(hours < 1)
        {
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;
            eltime.text = minutes + ":" + seconds;
        }
        else
        {
            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;
            eltime.text = hours + ":" + minutes + ":" + seconds;
        }

    }
    function msToTimeCurrent(position) {
        var seconds = parseInt((position/1000)%60);
        var minutes = parseInt((position/(1000*60))%60);
        var hours = parseInt((position/(1000*60*60))%60);

        if((aplayer.duration/(1000*60*60))%60 < 1)
        {
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;
            curtime.text = minutes + ":" + seconds;
        }
        else
        {
            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;
            curtime.text = hours + ":" + minutes + ":" + seconds;
        }
    }
    function msToProgress(position, duration){
        var prgrs = parseInt(position/1000)
        var elps = parseInt(duration/1000)
        activeprogress.width = progress.width * (prgrs / elps)

    }
    function defineChecker(name){
        //tmpstr = name
        //name = name.slice(-4)
        //if(name === "..")
            //return ""
       /* else*/ return "mark_grey.png"
    }
    function setWidthOfPLName(){
        nameofplaylist.width = mrect.width-(mrect.width/12.5)-trackcount.width
    }
    function setTitleAnimatiom(){
        timer2.start()
    }
    function setRootFolderFM(path){
        if(fmlist.visible === true){
            fmlistmod.clear()
            fmlistmod.append({"nam": "Внутренняя память", "ico": "memory.png", "chck": "mark_transparent.png"})
            sum = fb.getSumOfFiles(path)
            console.log(sum)
            for(var i = 0; i < sum; i++)
            {
                tmpstr = fb.getFileName(path, i)
                if(i === 0 || i === 1)
                    continue
                else if(i > 1){
                    if(fb.checkIsFolder(path, tmpstr) === true && (fb.getFileName(path, i) !== "self" && fb.getFileName(path, i) !== "emulated")){
                        fmlistmod.append({"nam": "Карта памяти", "ico": "sdcard.png", "chck": "mark_transparent.png"})
                        console.log("FLASH1 = "+fb.getFileName(path, i))
                        setter.setSDCardName(fb.getFileName(path, i))
                    }
                    else continue
                }
            }
        }
        else if(list.visible === true){
            listmod.clear()
            listmod.append({"nam": "Внутренняя память", "ico": "memory.png", "chck": "mark_transparent.png"})
            sum = fb.getSumOfFiles(path)
            console.log(sum)
            for(var j = 0; j < sum; j++)
            {
                tmpstr = fb.getFileName(path, j)
                if(j === 0 || j === 1)
                    continue
                else if(j > 1){
                    if(fb.checkIsFolder(path, tmpstr) === true && (fb.getFileName(path, j) !== "self" && fb.getFileName(path, j) !== "emulated")){
                        listmod.append({"nam": "Карта памяти", "ico": "sdcard.png", "chck": "mark_transparent.png"})
                        console.log("FLASH2 = "+fb.getFileName(path, j))
                        setter.setSDCardName(fb.getFileName(path, j))
                    }
                    else continue
                }
            }
        }
    }

    WorkerScript{
        id: worker
        source: "workerscript.js"
        onMessage:{
            //curlistmod.append({"nam": setter.viewPL(currentPL, messageObject.jsITR, shuffle_state),
            //                   "ico": setter.viewPL(currentPL, messageObject.jsITR, shuffle_state) === tmpstr ? (stop_state === true ? "curstop.png" : pause_state === false ? "curplay.png" : "curpause.png") : "audio.png",
            //                   "nmb": messageObject.jsITR+".",
            //                   "clr": setter.viewPL(currentPL, messageObject.jsITR, shuffle_state) === tmpstr ? "#22acee48" : "#00000000",
            //                   "pth": setter.getPathOfTrack(currentPL, messageObject.jsITR, shuffle_state),
            //                   "mxt": "mark_next.png"})
            if(messageObject.jsITR === setter.getPLTracksCount(currentPL)){
                currentlist.currentIndex = curTrackPos-1
                setTitleAnimatiom()
            }
            console.log(messageObject.jsITR)
        }
    }

    Component.onCompleted: {
        sum = list.count
        shuffle_state = setter.getShuffleState()
        repeat_state = setter.getRepeatState()
        pause_state = setter.getPauseState()
        stop_state = setter.getStopState()
        currentPL = setter.getCurrentPL()
        mute_state = setter.getMuteState()
        console.log(currentPL)
        if(currentPL === ".")
            nameofplaylisttxt.text = ""
        else nameofplaylisttxt.text = currentPL
        generalTrackCount = setter.getPLTracksCount(currentPL)
        aplayer.source = setter.setLastTrack(shuffle_state)
        aplayer.seek(setter.getCurrentProgress())
        if(stop_state === true)
            pause_state = true
        else
        {
            if(pause_state === false)
            {
                aplayer.play()
                play.visible = false
                pause.visible = true
                timer.start()
                if(mute_state === false)
                    aplayer.volume = setter.getVolume()
                else aplayer.volume = 0
            }
            else{
                aplayer.pause()
                pause.visible = false
                play.visible = true
                timer.start()
                if(mute_state === false)
                    aplayer.volume = setter.getVolume()
                else aplayer.volume = 0
            }
        }
        //Settings::loadnamefromPL(Settings::setLastTrack(Settings::getShuffleState()))
        tmpstr = setter.loadnamefromPL(aplayer.source)
        curTrackPos = setter.getCurrentTrack()
        //curlistmod.clear()
        cppmdl.clearModel()
        for(var i = 1; i <= setter.getPLTracksCount(currentPL); i++)
        {
            cppmdl.addElement(i, setter.viewPL(currentPL, i, shuffle_state),
                              setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? (stop_state === true ? "curstop.png" : pause_state === false ? "curplay.png" : "curpause.png") : "audio.png",
                              i+".",
                              setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? "#22acee48" : "#00000000",
                              setter.getPathOfTrack(currentPL, i, shuffle_state),
                              "mark_next.png",
                              "0",
                              "false")
        }

        //for(var i = 1; i <= setter.getPLTracksCount(currentPL); i++)
        //    curlistmod.append({"nam": setter.viewPL(currentPL, i, shuffle_state),
        //                       "ico": setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? (stop_state === true ? "curstop.png" : pause_state === false ? "curplay.png" : "curpause.png") : "audio.png",
        //                       "nmb": i+".",
        //                       "clr": setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? "#22acee48" : "#00000000",
        //                       "pth": setter.getPathOfTrack(currentPL, i, shuffle_state),
        //                       "mxt": "mark_next.png"})
        //}
        //for(var i = 1; i <= setter.getPLTracksCount(currentPL); i++)
        //{
        //    curlistmod.append({"nam": setter.viewPL(currentPL, i, shuffle_state),
        //                       "ico": setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? (stop_state === true ? "curstop.png" : pause_state === false ? "curplay.png" : "curpause.png") : "audio.png",
        //                       "nmb": i+".",
        //                       "clr": setter.viewPL(currentPL, i, shuffle_state) === tmpstr ? "#22acee48" : "#00000000",
        //                       "pth": setter.getPathOfTrack(currentPL, i, shuffle_state),
        //                       "mxt": "mark_next.png"})
        //}
        //tmpint2 = setter.getPLTracksCount(currentPL)
        //worker.sendMessage({'action': 'append',
        //                    'model': curlistmod,
        //                    'tracks_count': tmpint2,
        //                   'cppOBJ': setter,
        //                   'curPL': currentPL,
        //                   'shuffle': shuffle_state,
        //                   'stop': stop_state,
        //                   'pause': pause_state})
        //cppmdl.roleNames()
        currentlist.currentIndex = curTrackPos-1
        setTitleAnimatiom()
    }
}











WorkerScript.onMessage = function(msg) {
    for (var i = 1; i <= msg.tracks_count; i++) {
        //WorkerScript.sendMessage( { 'jsITR': i } );
        if(msg.action == 'append'){
            msg.model.append({"nam": msg.cppOBJ.viewPL(msg.curPL, i, msg.shuffle),
                               "ico": msg.cppOBJ.viewPL(msg.curPL, i, msg.shuffle) === tmpstr ? (msg.stop === true ? "curstop.png" : msg.pause === false ? "curplay.png" : "curpause.png") : "audio.png",
                               "nmb": i+".",
                               "clr": msg.cppOBJ.viewPL(msg.currentPL, i, msg.shuffle) === tmpstr ? "#22acee48" : "#00000000",
                               "pth": msg.cppOBJ.getPathOfTrack(msg.curPL, i, msg.shuffle),
                               "mxt": "mark_next.png"})
        }
    }
}

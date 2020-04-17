import QtQuick 2.0
import QtQuick.XmlListModel 2.0

Item {
    id: info
    property string artist
    property variant lastArtist: null
    XmlListModel{
        id: nfoFm
        source: "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist="+info.artist+"&api_key"
    }
}

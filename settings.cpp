#include "settings.h"
#include <browser.h>
#include <QDebug>
#include <cmath>
#include <time.h>

Settings::Settings(QObject *parent) : QObject(parent)
{
    setCountPL();
}

void Settings::createPL(QString namePL, QStringList listPL, QString OS_Version)
{
    qDebug() << "===CLASS=== createPL(QString namePL, QStringList listPL, QString OS_Version)";
    qDebug() << "createPL_listPL = " << listPL.count();

    setter = new QSettings("playlists", namePL);
    setter->beginGroup("TRACKLIST");
    setter2 = new QSettings("playlists", namePL);
    setter2->beginGroup("QUEUE");
    qDebug() << "STRT!";
    general_count = general_count + listPL.count();
    if(OS_Version == "android")
    {
        qDebug() << "OS Android";
        for(int i = 0; i < listPL.count()+1; i++) {
            if(i == 0){
                setter->setValue(QString("T%1").arg(i), listPL.count());
                setter2->setValue(QString("Q%1").arg(i), listPL.count());
            }
            else {
                setter->setValue(QString("T%1").arg(i), "file://"+listPL.at(i-1));
                setter2->setValue(QString("Q%1").arg(i), "file://"+listPL.at(i-1));
            }
        }
    }
    else
    {
        qDebug() << "OS Windows";
        for(int i = 0; i < listPL.count()+1; i++) {
            if(i == 0){
                setter->setValue(QString("T%1").arg(i), listPL.count());
                setter2->setValue(QString("Q%1").arg(i), listPL.count());
            }
            else {
                setter->setValue(QString("T%1").arg(i), listPL.at(i-1));
                setter2->setValue(QString("Q%1").arg(i), listPL.at(i-1));
            }
        }
    }
    setter->endGroup();
    setter2->endGroup();
    addCountPL(namePL);
    general_count = 0;
}
QString Settings::getPLName(int a)
{
    setter = new QSettings("plcount", "count");
    setter->beginGroup("PLNAMES");
    tempstr = setter->value(QString("PL%1").arg(a), "ERROR_GET_namePL").toString();
    setter->endGroup();

    return tempstr;
}
int Settings::setCountPL()
{
    bool b;
    setter = new QSettings("plcount", "count");
    setter->beginGroup("COUNTLISTS");
    plcount = setter->value(QString("Count"), 0).toInt(&b);
    setter->endGroup();
    qDebug() << "setPLCOUNT = " << plcount;
    return plcount;
}
void Settings::addCountPL(QString namePL)
{
    setter = new QSettings("plcount", "count");
    setter->beginGroup("COUNTLISTS");
    setter->setValue(QString("Count"), ++plcount);
    setter->endGroup();
    setter->beginGroup("PLNAMES");
    setter->setValue(QString("PL%1").arg(plcount), namePL);
    setter->endGroup();
    setCountPL();
    qDebug() << "+PLCOUNT = " << plcount;
}
void Settings::delCountPL(QString namePL, int pos)
{
    setter = new QSettings("plcount", "count");
    setter->beginGroup("COUNTLISTS");
    setter->setValue(QString("Count"), --plcount);
    setter->endGroup();
    setter->beginGroup("PLNAMES");
    setter->remove(QString("PL%1").arg(pos));
    for(int i = pos; i <= plcount; i++)
    {
        tempstr = setter->value(QString("PL%1").arg(i+1), "ERROR").toString();
        setter->setValue(QString("PL%1").arg(i), tempstr);
    }
    setter->remove(QString("PL%1").arg(plcount+1));
    setter->endGroup();
    setter->destroyed(nullptr);
    setter = new QSettings("playlists", namePL);
    //QStringList klist = setter->allKeys();
    setter->beginGroup("TRACKLIST");
    setter->remove("");
    setter->endGroup();
    setter->beginGroup("QUEUE");
    setter->remove("");
    setter->endGroup();
    setter->beginGroup("TRACK");
    setter->remove("");
    setter->endGroup();
    setter->beginGroup("PROGRESS");
    setter->remove("");
    setter->endGroup();
    setCountPL();
    qDebug() << "-PLCOUNT = " << plcount;
}
QString Settings::loadPL(QString namePL, bool shuffle, int gcount)
{
    qDebug() << "PL NAME = " << namePL;
    if(!shuffle){
        setter = new QSettings("playlists", namePL);
        setter->beginGroup("TRACKLIST");
        tempstr = setter->value(QString("T%1").arg(1), "ERROR_GETTING_1ST_FILENAME").toString();
        setter->endGroup();
    }
    else{
        int rnd;
        srand (time(NULL));
        rnd = rand() % gcount+1;
        setter = new QSettings("playlists", namePL);
        setter->beginGroup("QUEUE");
        tempstr = setter->value(QString("Q%1").arg(rnd), "ERROR_GETTING_1ST_FILENAME").toString();
        setter->endGroup();
    }

    qDebug() << tempstr;
    return tempstr;
}
QString Settings::loadnamefromPL(QString name)
{
    tempstr = name;
    QChar c = ' ';
    QString st1;
    QString st2;
    //qDebug() << tempstr.length();
    for(int i = tempstr.length()-1; c != '/'; i--)
    {
        c = tempstr.at(i);
        if(c == '/')
            break;
        else{
            st1.append(c);
        }
    }
    for(int j = st1.length()-1; j >= 0; j--)
        st2.append(st1.at(j));
    return st2;
}
QString Settings::nextTrack(QString namePL, int pos, bool shuffle)
{
    qDebug() << "position:"<<pos;
    qDebug() << "shuffle:"<<shuffle;
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("TRACKLIST");
    setter2 = new QSettings("playlists", namePL);
    setter2->beginGroup("QUEUE");
    if(!shuffle)
    {
        qDebug() << "DEBUG!";
        bool ok;
        int tmppos;
        tmppos = setter->value(QString("T%1").arg(0), "ERROR_GETTING_1ST_FILENAME").toInt(&ok);
        if(pos == tmppos) { tempstr = setter->value(QString("T%1").arg(1), "ERROR_GETTING_1ST_FILENAME").toString(); }
        else { tempstr = setter->value(QString("T%1").arg(pos+1), "ERROR_GETTING_1ST_FILENAME").toString(); }
    }
    else if(shuffle)
    {
        if(namePL == ".")
        {
            qDebug() << "DEBUG.";
            bool ok;
            int tmppos;
            tmppos = setter->value(QString("T%1").arg(0), "ERROR_GETTING_1ST_FILENAME").toInt(&ok);
            if(pos == tmppos) { tempstr = setter->value(QString("T%1").arg(1), "ERROR_GETTING_1ST_FILENAME").toString(); }
            else { tempstr = setter->value(QString("T%1").arg(pos+1), "ERROR_GETTING_1ST_FILENAME").toString(); }
        }
        else
        {
            qDebug() << "DEBUG";
            bool ok;
            int tmppos;
            tmppos = setter2->value(QString("Q%1").arg(0), "ERROR_GETTING_1ST_FILENAME").toInt(&ok);
            if(pos == tmppos) { tempstr = setter2->value(QString("Q%1").arg(1), "ERROR_GETTING_1ST_FILENAME").toString(); }
            else { tempstr = setter2->value(QString("Q%1").arg(pos+1), "ERROR_GETTING_1ST_FILENAME").toString(); }
        }
    }
    setter->endGroup();
    setter2->endGroup();

    return tempstr;
}
QString Settings::prewTrack(QString namePL, int pos, bool shuffle)
{
    qDebug() << "position:"<<pos;
    qDebug() << "shuffle:"<<shuffle;

    setter = new QSettings("playlists", namePL);
    setter->beginGroup("TRACKLIST");
    setter2 = new QSettings("playlists", namePL);
    setter2->beginGroup("QUEUE");
    if(!shuffle)
    {
        if(pos == 1)
        {
            bool ok;
            int pos = setter->value(QString("T%1").arg(0), "ERROR_GETTING_1ST_FILENAME").toInt(&ok);
            tempstr = setter->value(QString("T%1").arg(pos), "ERROR_GETTING_1ST_FILENAME").toString();
        }
        else { tempstr = setter->value(QString("T%1").arg(pos-1), "ERROR_GETTING_1ST_FILENAME").toString(); }
    }
    else if(shuffle)
    {
        if(pos == 1)
        {
            if(namePL == ".")
            {
                bool ok;
                int pos = setter->value(QString("T%1").arg(0), "ERROR_GETTING_1ST_FILENAME").toInt(&ok);
                tempstr = setter->value(QString("T%1").arg(pos), "ERROR_GETTING_1ST_FILENAME").toString();
            }
            else
            {
                bool ok;
                int pos = setter2->value(QString("Q%1").arg(0), "ERROR_GETTING_1ST_FILENAME").toInt(&ok);
                tempstr = setter2->value(QString("Q%1").arg(pos), "ERROR_GETTING_1ST_FILENAME").toString();
            }
        }
        else { tempstr = setter2->value(QString("Q%1").arg(pos-1), "ERROR_GETTING_1ST_FILENAME").toString(); }
    }
    setter->endGroup();
    setter2->endGroup();

    return tempstr;
}
int Settings::getPLTracksCount(QString namePL)
{
    bool b;
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("TRACKLIST");
    tempint = setter->value(QString("T%1").arg(0), 0).toInt(&b);
    setter->endGroup();

    return tempint;
}
void Settings::setShuffleQueue(QString namePL, int gcount)
{
    int rnd;
    srand (time(NULL));
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("QUEUE");
    for(int i = 1; i <= gcount; i++)
    {
        rnd = rand() % gcount+1;
        tempstr = setter->value(QString("Q%1").arg(i), 0).toString();
        tempstr2 = setter->value(QString("Q%1").arg(rnd), 0).toString();
        setter->setValue(QString("Q%1").arg(rnd), tempstr);
        setter->setValue(QString("Q%1").arg(i), tempstr2);
        qDebug() << i;
    }
    setter->endGroup();
}
int Settings::setCurrentPositionShuffleOn(QString namePL, QString curtrack, int gcount, QString OS_Version)
{
    if(OS_Version != "android")
        curtrack.replace(0,1,'C');
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("QUEUE");
    for(int i = 1; i <= gcount; i++)
    {
        tempstr = setter->value(QString("Q%1").arg(i), 0).toString();
        qDebug() << tempstr+" - "+curtrack;
        if(tempstr == curtrack)
        {
            qDebug() << "MATCH!";
            setter->endGroup();
            tempint = i;
            return tempint;
        }
    }
    setter->endGroup();
}
int Settings::setCurrentPositionShuffleOff(QString namePL, QString curtrack, int gcount, QString OS_Version)
{
    if(OS_Version != "android")
        curtrack.replace(0,1,'C');
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("TRACKLIST");
    for(int i = 1; i <= gcount; i++)
    {
        tempstr = setter->value(QString("T%1").arg(i), 0).toString();
        qDebug() << tempstr+" - "+curtrack;
        if(tempstr == curtrack)
        {
            qDebug() << "MATCH!";
            setter->endGroup();
            tempint = i;
            return tempint;
        }
    }
    setter->endGroup();
}
void Settings::setShuffleState(QString state)
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("SHUFFLE");
    setter->setValue(QString("state"), state);
    setter->endGroup();
}
bool Settings::getShuffleState()
{
    bool b;
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("SHUFFLE");
    b = setter->value(QString("state"), false).toBool();
    setter->endGroup();

    return b;
}
void Settings::setRepeatState(QString state)
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("REPEAT");
    setter->setValue(QString("state"), state);
    setter->endGroup();
}
QString Settings::getRepeatState()
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("REPEAT");
    tempstr = setter->value(QString("state"), 0).toString();
    setter->endGroup();

    return tempstr;
}
void Settings::setCurrentTrack(QString namePL, QString pos)
{
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("TRACK");
    setter->setValue(QString("current"), pos);
    setter->endGroup();
}
int Settings::getCurrentTrack()
{
    bool ok;
    setter = new QSettings("playlists", getCurrentPL());
    setter->beginGroup("TRACK");
    tempint = setter->value(QString("current"), 0).toInt(&ok);
    setter->endGroup();

    return tempint;
}
void Settings::setCurrentPL(QString pl)
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("PLAYLIST");
    setter->setValue(QString("current"), pl);
    setter->endGroup();
}
QString Settings::getCurrentPL()
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("PLAYLIST");
    tempstr = setter->value(QString("current"), 0).toString();
    setter->endGroup();

    return tempstr;
}
QString Settings::setLastTrack(bool shuffle)
{
    tempstr2 = getCurrentPL();
        if(!shuffle)
        {
            tempint = getCurrentTrack();
            qDebug() << "tempstr2 =" << tempstr2;
            setter = new QSettings("playlists", tempstr2);
            setter->beginGroup("TRACKLIST");
            tempstr = setter->value(QString("T%1").arg(tempint), tempint).toString();
            setter->endGroup();
            qDebug() << "tempstr =" << tempstr;
        }
        else if(shuffle)
        {
            if(tempstr2 == ".")
            {
                tempint = getCurrentTrack();
                qDebug() << "tempstr2 =" << tempstr2;
                setter = new QSettings("playlists", tempstr2);
                setter->beginGroup("TRACKLIST");
                tempstr = setter->value(QString("T%1").arg(tempint), tempint).toString();
                setter->endGroup();
                qDebug() << "tempstr =" << tempstr;
            }
            else
            {
                tempint = getCurrentTrack();
                qDebug() << "tempstr2 =" << tempstr2;
                setter = new QSettings("playlists", tempstr2);
                setter->beginGroup("QUEUE");
                tempstr = setter->value(QString("Q%1").arg(tempint), tempint).toString();
                setter->endGroup();
                qDebug() << "tempstr =" << tempstr;
            }
        }

    return tempstr;
}
void Settings::setCurrentProgress(int progress, QString namePL)
{
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("PROGRESS");
    setter->setValue(QString("current"), progress);
    setter->endGroup();
}
QString Settings::getCurrentProgress()
{
    setter = new QSettings("playlists", getCurrentPL());
    setter->beginGroup("PROGRESS");
    tempstr = setter->value(QString("current"), 0).toString();
    setter->endGroup();

    return tempstr;
}
void Settings::createZeroPL(QString name)
{
    setter = new QSettings("playlists", ".");
    setter->beginGroup("TRACKLIST");
    setter->setValue(QString("T%1").arg(0), 1);
    setter->setValue(QString("T%1").arg(1), name);
    setter->endGroup();
}
QString Settings::viewPL(QString namePL, int itr, bool shuffle)
{
    tempint = getPLTracksCount(namePL);
    setter = new QSettings("playlists", namePL);
    if(!shuffle){
        setter->beginGroup("TRACKLIST");
        tempstr = setter->value(QString("T%1").arg(itr), "ERROR_GETTING_1ST_FILENAME").toString();
        tempstr = loadnamefromPL(tempstr);
    }
    else{
        setter->beginGroup("QUEUE");
        tempstr = setter->value(QString("Q%1").arg(itr), "ERROR_GETTING_1ST_FILENAME").toString();
        tempstr = loadnamefromPL(tempstr);
    }
    setter->endGroup();
    //qDebug() << "NAMEOFPL = " << tempstr;
    return tempstr;
}
void Settings::setPauseState(QString state, QString namePL)
{
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("PAUSE");
    setter->setValue(QString("state"), state);
    setter->endGroup();
    //qDebug() << "PLN = " << namePL;
}
bool Settings::getPauseState()
{
    setter = new QSettings("playlists", getCurrentPL());
    setter->beginGroup("PAUSE");
    tempbool = setter->value(QString("state"), false).toBool();
    setter->endGroup();

    return tempbool;
}
void Settings::addNextTrack(QString namePL, QString name, int count)
{
    bool ok;
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("NEXTTRACK");
    tempint = setter->value(QString("T%1").arg(0), 0).toInt(&ok);
    tempint++;
    setter->setValue(QString("T%1").arg(0), tempint);
    setter->setValue(QString("T%1").arg(count), name);
    setter->endGroup();

}
QString Settings::playNextTrack(QString namePL)
{
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("NEXTTRACK");
    tempstr = setter->value(QString("T%1").arg(1), 0).toString();
    setter->endGroup();

    return tempstr;
}
void Settings::delNextTrack(QString namePL, int pos)
{
    bool ok;
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("NEXTTRACK");
    tempint = setter->value(QString("T%1").arg(0), 0).toInt(&ok);
    tempint--;
    setter->setValue(QString("T%1").arg(0), tempint);
    setter->remove(QString("T%1").arg(pos));
    for(int i = pos; i < tempint+1; i++)
    {
        tempstr = setter->value(QString("T%1").arg(i+1), "ErrO").toString();
        setter->setValue(QString("T%1").arg(i), tempstr);
        if(i == tempint)
            setter->remove(QString("T%1").arg(i+1));
    }
    setter->endGroup();
}
QString Settings::getPathOfTrack(QString namePL, int itr, bool shuffle)
{
    //tempint = getPLTracksCount(namePL);
    setter = new QSettings("playlists", namePL);
    if(!shuffle){
        setter->beginGroup("TRACKLIST");
        tempstr = setter->value(QString("T%1").arg(itr), "ERROR_GETTING_1ST_FILENAME").toString();
    }
    else{
        setter->beginGroup("QUEUE");
        tempstr = setter->value(QString("Q%1").arg(itr), "ERROR_GETTING_1ST_FILENAME").toString();
    }
    setter->endGroup();
    //qDebug() << "NAME = " << tempstr;
    return tempstr;
}
void Settings::setStopState(QString state, QString namePL)
{
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("STOP");
    setter->setValue(QString("state"), state);
    setter->endGroup();
}
bool Settings::getStopState()
{
    setter = new QSettings("playlists", getCurrentPL());
    setter->beginGroup("STOP");
    tempbool = setter->value(QString("state"), false).toBool();
    setter->endGroup();

    return tempbool;
}
void Settings::rmNextTrack(QString namePL)
{
    setter = new QSettings("playlists", namePL);
    setter->beginGroup("NEXTTRACK");
    setter->remove("");
    setter->endGroup();
}
void Settings::setMuteState(QString state)
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("MUTE");
    setter->setValue(QString("current"), state);
    setter->endGroup();
}
bool Settings::getMuteState()
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("MUTE");
    tempbool = setter->value(QString("current"), 0).toBool();
    setter->endGroup();

    return tempbool;
}
void Settings::setVolume(QString volume)
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("VOLUME");
    setter->setValue(QString("current"), volume);
    setter->endGroup();
}
QString Settings::getVolume()
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("VOLUME");
    tempstr = setter->value(QString("current"), 0).toString();
    setter->endGroup();

    return tempstr;
}
bool Settings::searchTrack(QString shape, QString track)
{
    qDebug() << "shape = "<< shape;
    qDebug() << "track = "<< track;
    tempbool = QString(track).contains(shape, Qt::CaseSensitive);
    qDebug() << "bool = " << tempbool;
    return tempbool;
}
void Settings::setSDCardName(QString folder)
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("SDCARD");
    setter->setValue(QString("current"), folder);
    setter->endGroup();
}
QString Settings::getSDCardName()
{
    setter = new QSettings("playersettings", "general");
    setter->beginGroup("SDCARD");
    tempstr = setter->value(QString("current"), "ErrorGetSDCardName").toString();
    setter->endGroup();

    return tempstr;
}













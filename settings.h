#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
//#include <browser.h>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = nullptr);
    Q_INVOKABLE int plcount;
    Q_INVOKABLE int general_count = 0;
signals:

public slots:
    void createPL(QString namePL, QStringList listPL, QString OS_Version);
    void addCountPL(QString namePL);
    void delCountPL(QString namePL, int pos);
    int setCountPL();
    QString getPLName(int a);
    QString loadPL(QString namePL, bool shuffle, int gcount);
    QString loadnamefromPL(QString name);
    QString nextTrack(QString namePL, int pos, bool shuffle);
    QString prewTrack(QString namePL, int pos, bool shuffle);
    int getPLTracksCount(QString namePL);
    void setShuffleQueue(QString namePL, int gcount);
    int setCurrentPositionShuffleOn(QString namePL, QString curtrack, int gcount, QString OS_Version);
    int setCurrentPositionShuffleOff(QString namePL, QString curtrack, int gcount, QString OS_Version);
    void setShuffleState(QString state);
    bool getShuffleState();
    void setRepeatState(QString state);
    QString getRepeatState();
    void setCurrentTrack(QString namePL, QString pos);
    int getCurrentTrack();
    void setCurrentPL(QString pl);
    QString getCurrentPL();
    QString setLastTrack(bool shuffle);
    void setCurrentProgress(int progress, QString namePL);
    QString getCurrentProgress();
    void createZeroPL(QString name);
    QString viewPL(QString namePL, int itr, bool shuffle);
    void setPauseState(QString state, QString namePL);
    bool getPauseState();
    void addNextTrack(QString namePL, QString name, int count);
    QString playNextTrack(QString namePL);
    void delNextTrack(QString namePL, int pos);
    QString getPathOfTrack(QString namePL, int itr, bool shuffle);
    void setStopState(QString state, QString namePL);
    bool getStopState();
    void rmNextTrack(QString namePL);
    void setMuteState(QString state);
    bool getMuteState();
    void setVolume(QString volume);
    QString getVolume();
    void setSDCardName(QString folder);
    QString getSDCardName();
    bool searchTrack(QString shape, QString track);
public:
    QSettings *setter;
    QSettings *setter2;
    QString tempstr;
    QString tempstr2;
    QStringList *playlist;
    int tempint;
    bool tempbool;
};

#endif // SETTINGS_H

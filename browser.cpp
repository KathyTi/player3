#include "browser.h"
#include <settings.h>
#include <QFile>
#include <QDir>
#include <QObject>
#include <QSettings>
#include <QList>
#include <QDebug>



Browser::Browser(QObject *parent) : QObject(parent)
{
    list = new QStringList;
    //setter = new QSettings;
}

int Browser::getSumOfFiles(QString path)
{
    //path = path.remove(0, 7);
    QDir mDir(path);
    int cnt;
    if(mDir.exists())
        cnt = mDir.count();
    else cnt = 0;
    return cnt;
}

void Browser::getFiles(QString path)
{
    qDebug() << "===CLASS=== getFiles(QString path)";
    qDebug() << list->count();
    QDir mDir(path/*.remove(0, 7)*/);
    int cnt = mDir.count();
    for(int i = 2; i < cnt; i++)
    {
        tempStr = path+'/'+mDir.entryList().at(i);
        qDebug() << "tempStr === " << tempStr;
        if(checkIsFolder(path, setter.loadnamefromPL(tempStr)))
            getFiles(tempStr);
        else list->append(tempStr);
    }
    qDebug() << list->count();
    //return "";
}

QString Browser::getFileName(QString path, int number)
{
    QDir mDir(path/*.remove(0, 7)*/);
    //qDebug() << mDir.entryList().at(number);
    mDir.setSorting(QDir::DirsFirst);
    return mDir.entryList().at(number);
}

QString Browser::folderUp(QString path)
{
    //qDebug() << "start UP!";
    QString c;
    for(int i = 0; ; i++)
    {
        c = path.right(1);
        //qDebug() << "symbol = " << c;
        if(c != '/')
            path.remove(-1, 1);
        else {
            path.remove(-1, 1);
            break;
        }
    }
    //qDebug() << path;
    //qDebug() << "Done!";
    return path;
}

QString Browser::folderDown(QString path, QString folder)
{
    //qDebug() << "start DOWN!";
    path = path + "/" + folder;
    //qDebug() << path;
    //qDebug() << "Done!";
    return path;
}

bool Browser::checkIsFolder(QString path, QString name)
{
    //qDebug() << "isDir?";
    tempStr = path+"/"+name;
    //qDebug() << str;
    QFileInfo info(tempStr);
    //qDebug() << info.isDir();
    return info.isDir();
}

void Browser::createPlayList(QString path, QString name)
{
    //qDebug() << path;
    //qDebug() << name;
    tempStr = path+'/'+name;
    //qDebug() << "createPlayList = " << tempStr;
    if(!checkIsFolder(path, name))
        list->append(tempStr);
    else getFiles(tempStr);
}

QString Browser::getOSVersion() { return sysinfo.productType(); }

QStringList Browser::getList() { return *list; }

void Browser::clearList(){list->clear();}

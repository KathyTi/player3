#ifndef BROWSER_H
#define BROWSER_H

#include <QObject>
#include <settings.h>

class Browser : public QObject
{
    Q_OBJECT
public:
    explicit Browser(QObject *parent = nullptr);

signals:

public slots:
    int getSumOfFiles(QString path);
    void getFiles(QString path);
    QString getFileName(QString path, int number);
    QString folderUp(QString path);
    QString folderDown(QString path, QString folder);
    bool checkIsFolder(QString path, QString name);
    void createPlayList(QString path, QString name);
    QString getOSVersion();
    QStringList getList();
    void clearList();
public:
    QStringList *list;
    QString tempStr;
    static QString STATE_FOR_LIST;
    QSysInfo sysinfo;
    Settings setter;
};

#endif // BROWSER_H

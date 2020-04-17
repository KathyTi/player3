#ifndef CPPMODEL_H
#define CPPMODEL_H
#include <QString>
#include <QModelIndex>
#include <QAbstractListModel>

class CppModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit CppModel(QAbstractListModel *parent = nullptr);
    enum Roles{
        nameRole = Qt::UserRole+1,
        iconRole,
        numberRole,
        colorRole,
        pathRole,
        markRole
    };
    struct elementData
    {
        QString m_name;
        QString m_icon;
        QString m_number;
        QString m_color;
        QString m_path;
        QString m_mark;
        elementData(const QString& name, const QString& icon, const QString& number, const QString& color, const QString& path, const QString& mark)
            :m_name(name), m_icon(icon), m_number(number), m_color(color), m_path(path), m_mark(mark){}
    };
    CppModel();
public slots:
    //rowCount, data, roles и в твоем случае canFetchMore и FetchMore.
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;
    void addElement(const QString &name, const QString &icon, const QString &number, const QString &color, const QString &path, const QString &mark);
    void appendElement(const QString& name, const QString& icon, const QString& number, const QString& color, const QString& path, const QString& mark);
    void clearModel();
private:
    QString tmpstr;
    QList <elementData> dataList;
};

#endif // CPPMODEL_H

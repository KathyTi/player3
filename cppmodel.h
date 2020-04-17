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
        markRole,
        mark_numberRole,
        mark_visibleRole
    };
    struct ElementData
    {
        QString m_name = "name";
        QString m_icon = "audio.png";
        QString m_number = "1.";
        QString m_color = "#00000000";
        QString m_path = "";
        QString m_mark = "mark_green.png";
        QString m_mark_number = "0";
        QString m_mark_visible = "false";
        ElementData(const QString& name, const QString& icon, const QString& number, const QString& color, const QString& path, const QString& mark, const QString& mark_number, const QString& mark_visible)
            :m_name(name), m_icon(icon), m_number(number), m_color(color), m_path(path), m_mark(mark), m_mark_number(mark_number), m_mark_visible(mark_visible){}
    };
    CppModel();
public slots:
    //rowCount, data, roles и в твоем случае canFetchMore и FetchMore.
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;
    void addElement(const QString &name, const QString &icon, const QString &number, const QString &color, const QString &path, const QString &mark, const QString& mark_number, const QString& mark_visible);
    void appendElement(const QString& name, const QString& icon, const QString& number, const QString& color, const QString& path, const QString& mark, const QString& mark_number, const QString& mark_visible);
    void clearModel();
    void setElementProperty(const QModelIndex &index, int role, QVariant data);
private:
    QString tmpstr;
    QList <ElementData> dataList;
};

#endif // CPPMODEL_H

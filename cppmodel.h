#ifndef CPPMODEL_H
#define CPPMODEL_H
#include <QAbstractListModel>
#include <QModelIndex>
#include <QString>

class CppModel : public QAbstractListModel {
    Q_OBJECT
public:
    explicit CppModel();
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
        ElementData(const QString& name, const QString& icon, const QString& number,
                    const QString& color, const QString& path, const QString& mark,
                    const QString& mark_number, const QString& mark_visible)
            :m_name(name), m_icon(icon), m_number(number),
              m_color(color), m_path(path), m_mark(mark),
              m_mark_number(mark_number), m_mark_visible(mark_visible) {}
    };
signals:
    void numberPopulated(int number);
public slots:
    //rowCount, data, roles и в твоем случае canFetchMore и FetchMore.
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool canFetchMore(const QModelIndex &parent) const override;
    void fetchMore(const QModelIndex &parent) override;


    void addElement(int index, const QString &name, const QString &icon, const QString &number,
                    const QString &color, const QString &path, const QString &mark,
                    const QString& mark_number, const QString& mark_visible);
    void appendElement(int index, const QString& name, const QString& icon, const QString& number,
                       const QString& color, const QString& path, const QString& mark,
                       const QString& mark_number, const QString& mark_visible);
    void clearModel();
    void setElementProperty(int index, int role, QString data);
private:
    QString tmpstr;
    QList <ElementData> dataList;
    int fileCount;
};

#endif // CPPMODEL_H

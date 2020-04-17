#ifndef CPPMODEL_H
#define CPPMODEL_H
#include <QAbstractListModel>
#include <QModelIndex>
#include <QString>

class CppModel : public QAbstractListModel {
  Q_OBJECT
public:
  explicit CppModel();
  enum Roles {
    nameRole = Qt::UserRole + 1,
    iconRole,
    numberRole,
    colorRole,
    pathRole,
    markRole,
    mark_numberRole,
    mark_visibleRole
  };
  struct ElementData {
    QString m_name;
    QString m_icon;
    QString m_number;
    QString m_color;
    QString m_path;
    QString m_mark;
    QString m_mark_number;
    QString m_mark_visible;
    ElementData(const QString &name, const QString &icon, const QString &number,
                const QString &color, const QString &path, const QString &mark,
                const QString &mark_number, const QString &mark_visible)
        : m_name(name), m_icon(icon), m_number(number), m_color(color),
          m_path(path), m_mark(mark), m_mark_number(mark_number),
          m_mark_visible(mark_visible) {}
  };
public slots:
  // rowCount, data, roles и в твоем случае canFetchMore и FetchMore.
  int rowCount(const QModelIndex &parent) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;
  void addElement(const QString &name, const QString &icon,
                  const QString &number, const QString &color,
                  const QString &path, const QString &mark,
                  const QString &mark_number, const QString &mark_visible);
  void appendElement(const QString &name, const QString &icon,
                     const QString &number, const QString &color,
                     const QString &path, const QString &mark,
                     const QString &mark_number, const QString &mark_visible);
  void clearModel();
  void setElementProperty(const QModelIndex &index, int role, QString data);

private:
  QString tmpstr;
  QList<ElementData> dataList;
};

#endif // CPPMODEL_H

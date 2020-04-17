#include "cppmodel.h"
#include "settings.h"

CppModel::CppModel() {}
//переопределим возврат количества строк листа
int CppModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid()) {
    return 0;
  }

  return dataList.size();
}
//определим возврат данных о ролях элемента
QVariant CppModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid()) {
    return QVariant();
  }

  switch (role) {
  case nameRole:
    return dataList.at(index.row()).m_name;
  case colorRole:
    return dataList.at(index.row()).m_color;
  case numberRole:
    return dataList.at(index.row()).m_number;
  case iconRole:
    return dataList.at(index.row()).m_icon;
  case pathRole:
    return dataList.at(index.row()).m_path;
  case markRole:
    return dataList.at(index.row()).m_mark;
  case mark_numberRole:
    return dataList.at(index.row()).m_mark_number;
  case mark_visibleRole:
    return dataList.at(index.row()).m_mark_visible;
  default:
    return QVariant();
  }
}
// roleNames хранит список имён ролей доступных из делегата. Переопредилим их
// имена в более удобные
QHash<int, QByteArray> CppModel::roleNames() const {
  QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
  roles[nameRole] = "name";
  roles[iconRole] = "icon";
  roles[numberRole] = "number";
  roles[colorRole] = "color";
  roles[pathRole] = "path";
  roles[markRole] = "mark";
  roles[mark_numberRole] = "mark_number";
  roles[mark_visibleRole] = "mark_visible";

  return roles;
}
void CppModel::addElement(const QString &name, const QString &icon,
                          const QString &number, const QString &color,
                          const QString &path, const QString &mark,
                          const QString &mark_number,
                          const QString &mark_visible) {
  beginInsertRows(QModelIndex(), dataList.size(), dataList.size());
  appendElement(name, icon, number, color, path, mark, mark_number,
                mark_visible);
  endInsertRows();
}

void CppModel::appendElement(const QString &name, const QString &icon,
                             const QString &number, const QString &color,
                             const QString &path, const QString &mark,
                             const QString &mark_number,
                             const QString &mark_visible) {
  emit QAbstractListModel::layoutAboutToBeChanged();
  dataList.append(ElementData(name, icon, number, color, path, mark,
                              mark_number, mark_visible));
  emit QAbstractListModel::layoutChanged();
}

void CppModel::clearModel() {
  beginResetModel();
  dataList.clear();
  endResetModel();
}

void CppModel::setElementProperty(const QModelIndex &index, int role,
                                  QString data) {

  switch (role) {
  case nameRole:
    dataList[index.row()].m_name = data;
    break;
  case colorRole:
    dataList[index.row()].m_color = data;
    break;
  case numberRole:
    dataList[index.row()].m_number = data;
    break;
  case iconRole:
    dataList[index.row()].m_icon = data;
    break;
  case pathRole:
    dataList[index.row()].m_path = data;
    break;
  case markRole:
    dataList[index.row()].m_mark = data;
    break;
  case mark_numberRole:
    dataList[index.row()].m_mark_number = data;
    break;
  case mark_visibleRole:
    dataList[index.row()].m_mark_visible = data;
    break;
  }
}
// currentPL, i, shuffle_state

#include "cppmodel.h"
#include "settings.h"

CppModel::CppModel()
{

}
//переопределим возврат количества строк листа
int CppModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {return 0;}

    return dataList.size();
}
//определим возврат данных о ролях элемента
QVariant CppModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {return QVariant();}

    switch (role) {
    case nameRole:
        return dataList.at(index.row()).m_name;//m_name.at(index.row());
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
    default:
        return QVariant();
    }
}
//roleNames хранит список имён ролей доступных из делегата. Переопредилим их имена в более удобные
QHash<int, QByteArray> CppModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[nameRole] = "name";
    roles[iconRole] = "icon";
    roles[numberRole] = "number";
    roles[colorRole] = "color";
    roles[pathRole] = "path";
    roles[markRole] = "mark";

    return roles;
}
void CppModel::addElement(const QString& name, const QString& icon, const QString& number, const QString& color, const QString& path, const QString& mark)
{
    beginInsertRows(QModelIndex(), dataList.size(), dataList.size());
    appendElement(name, icon, number, color, path, mark);
    endInsertRows();
}

void CppModel::appendElement(const QString& name, const QString& icon, const QString& number, const QString& color, const QString& path, const QString& mark) {
    emit QAbstractListModel::layoutAboutToBeChanged();
    dataList.append(elementData(name, icon, number, color, path, mark));
    emit QAbstractListModel::layoutChanged();
}

void CppModel::clearModel()
{

}
//currentPL, i, shuffle_state





















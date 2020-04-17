#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardPaths>
#include <QString>

#include "browser.h"
#include "settings.h"
#include "cppmodel.h"

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<Browser>("cppbrowser", 1, 0, "FileBrowser");
    qmlRegisterType<Settings>("cppsettings", 1, 0, "Setter");
    qmlRegisterType<CppModel>("cppmodel", 1, 0, "Cppmodel");
    engine.rootContext()->setContextProperty("dPath", QStandardPaths::standardLocations(QStandardPaths::MusicLocation).at(0)/*"file:///storage/emulated/0/Music"*/);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

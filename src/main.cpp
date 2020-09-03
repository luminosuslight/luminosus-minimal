#include "core/helpers/application_setup.h"
#include "core/CoreController.h"

#include <QApplication>
#include <QQmlApplicationEngine>

void addFonts() {
    QFontDatabase::addApplicationFont(":/fonts/BPmono.ttf");
    QFontDatabase::addApplicationFont(":/fonts/BPmonoBold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/BPmonoItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/breeze-icons.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Quicksand-Regular.otf");
    QFontDatabase::addApplicationFont(":/fonts/Quicksand-Italic.otf");
    QFontDatabase::addApplicationFont(":/fonts/Quicksand-Light.otf");
    QFontDatabase::addApplicationFont(":/fonts/Quicksand-LightItalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/Quicksand-Bold.otf");
    QFontDatabase::addApplicationFont(":/fonts/Quicksand-BoldItalic.otf");
}

int main(int argc, char *argv[])
{
    Luminosus::preQApplicationCreation();

    QApplication app(argc, argv);
    addFonts();

    QQmlApplicationEngine* engine = new QQmlApplicationEngine();

    Luminosus::prepareQmlEngine(*engine);
    Luminosus::registerQtQuickItems();

    CoreController controller(engine);
    // load custom managers here...
    controller.finishLoading(QUrl(QStringLiteral("qrc:/ui/main.qml")));

    Luminosus::preparePauseAndShutdown(app, *engine, controller);

    return app.exec();
}

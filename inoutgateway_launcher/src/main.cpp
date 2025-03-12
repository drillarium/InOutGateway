#include "launcher.h"
#include "config_manager.h"
#include "webserver.h"
#include "custom_message_handler.h"
#include "version_manager.h"
#include <QtWidgets/QApplication>

void logApplicationEnd()
{
  qInfo() << "Application ends";
}

int main(int _argc, char *_argv[])
{
  QApplication a(_argc, _argv);

  // Connect the aboutToQuit signal to the logging function
  QObject::connect(&a, &QCoreApplication::aboutToQuit, &logApplicationEnd);

  // Register custom message handler
  qInstallMessageHandler(customMessageHandler);

  qInfo() << "Application started:" << QCoreApplication::applicationName() << "Version:" << VersionManager::getAppVersion();

  // load configuration
  ConfigManager::instance().loadConfig();

  QString iface = ConfigManager::instance().getIface();
  int port = ConfigManager::instance().getPort();

  // Start the web server
  if(!WebServer::instance().startServer(iface, port))
  {
    return -1;  // Exit if the server fails
  }

  Launcher w;
  w.show();
  return a.exec();
}

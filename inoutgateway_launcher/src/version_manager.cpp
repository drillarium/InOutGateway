#include "version_manager.h"

const QString VersionManager::APP_VERSION = "1.0.0"; // The current app version

// A list of changes, with version as the first element and change description as the second
const QList<QPair<QString, QString>> VersionManager::CHANGELOG = 
{
    qMakePair(QString("1.0.0"), QString("Initial release. Added WebSocket and REST API server.")),
    qMakePair(QString("0.9.0"), QString("Initial development. Core WebSocket functionality.")),
};

QString VersionManager::getAppVersion()
{
  return APP_VERSION;
}

QList<QPair<QString, QString>> VersionManager::getChangeLog()
{
  return CHANGELOG;
}

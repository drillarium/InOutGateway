#pragma once

#include <QString>
#include <QList>
#include <QPair>

class VersionManager
{
public:
  static const QString APP_VERSION;
  static const QList<QPair<QString, QString>> CHANGELOG;

  static QString getAppVersion();
  static QList<QPair<QString, QString>> getChangeLog();
};


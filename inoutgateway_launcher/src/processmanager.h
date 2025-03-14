#pragma once

#include <QObject>
#include <QMap>
#include "engineprocess.h"

class ProcessManager  : public QObject
{
  Q_OBJECT

public:
  static ProcessManager& instance();  // Singleton accessor
  QStringList availableEngines();
  QString configFile(const QString _engine);
  void loadEngine(const QString &_type, const QString &_config);
  void unloadEngine(int _id);
  QString processName(int _id);

signals:
  void engineRunning(int _id);
  void engineStopped(int _id);

private:
  explicit ProcessManager(QObject *_parent = nullptr);
  ProcessManager(const ProcessManager&) = delete;
  ProcessManager& operator=(const ProcessManager&) = delete;

protected:
  QMap<int, EngineProcess *> engines_;
};

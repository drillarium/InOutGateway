#pragma once

#include <QObject>
#include <QJsonDocument>

class EngineProcess  : public QObject
{
  Q_OBJECT

public:
  EngineProcess(QString _type, int _id, const QString &_config, QObject *_parent = nullptr);
  ~EngineProcess();
  
  QString name() { return name_; }
  bool start() { return true; }
  bool stop() { return true; }

protected:
  QString type_;
  int id_ = -1;
  QString config_;
  QString name_;
  QJsonDocument jconfig_;
};

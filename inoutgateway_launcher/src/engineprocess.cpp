#include "engineprocess.h"
#include <QJsonObject>

EngineProcess::EngineProcess(QString _type, int _id, const QString& _config, QObject* _parent)
:QObject(_parent)
,type_(_type)
,id_(_id)
,config_(_config)
{
  jconfig_ = QJsonDocument::fromJson(config_.toUtf8());

  QJsonObject jsonObj = jconfig_.object();
  
  // name
  if(jsonObj.contains("name") && jsonObj["name"].isString())
  {
    name_ = jsonObj["name"].toString();
  }
  else
  {
    name_ = QString("%1_%2").arg(type_).arg(id_);
  }
}

EngineProcess::~EngineProcess()
{
}

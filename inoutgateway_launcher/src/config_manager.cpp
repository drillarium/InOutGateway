#include "config_manager.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

#define CONFIG_FILE "./config.json"

ConfigManager::ConfigManager()
{

}

ConfigManager& ConfigManager::instance()
{
  static ConfigManager instance;
  return instance;
}

bool ConfigManager::loadConfig()
{
  QString configFilePath = CONFIG_FILE; // Config file path
  QFile file(configFilePath);

  if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
  {
    qWarning() << "Failed to open config file:" << configFilePath;

    // Create a new JSON file with default values
    QJsonObject defaultConfig;
    defaultConfig["iface"] = iface_;
    defaultConfig["port"] = port_;
    defaultConfig["enginesPath"] = enginesPath_;

    QJsonDocument jsonDoc(defaultConfig);

    QFile newFile(configFilePath);
    if(newFile.open(QIODevice::WriteOnly | QIODevice::Text))
    {
      newFile.write(jsonDoc.toJson(QJsonDocument::Indented));
      newFile.close();
      qDebug() << "Default config file created at" << configFilePath;
    }
    else
    {
      qWarning() << "Failed to create config file!";
      return false;
    }

    return true;
  }

  QByteArray jsonData = file.readAll();
  file.close();

  QJsonDocument doc = QJsonDocument::fromJson(jsonData);
  if(doc.isNull() || !doc.isObject())
  {
    qWarning() << "Invalid JSON format in config file.";
    return false;
  }

  QJsonObject jsonObj = doc.object();

  // Read values
  iface_ = jsonObj.value("iface").toString(iface_);
  port_ = jsonObj.value("port").toInt(port_);
  enginesPath_ = jsonObj.value("enginesPath").toString(enginesPath_);

  return true;
}

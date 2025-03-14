#include "processmanager.h"
#include "config_manager.h"
#include <QDir>
#include <QRandomGenerator>

ProcessManager::ProcessManager(QObject *_parent)
:QObject(_parent)
{

}

ProcessManager& ProcessManager::instance()
{
  static ProcessManager instance;
  return instance;
}

QStringList getSubfoldersWithConfigJson(const QString& folderPath)
{
  QStringList subfolders;
  QDir dir(folderPath);

  if(!dir.exists())
  {
    return subfolders; // Return empty if folder doesn't exist
  }

  dir.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
  QFileInfoList subDirs = dir.entryInfoList();

  for(const QFileInfo& subDir : subDirs)
  {
    QDir subDirPath(subDir.filePath());
    if(subDirPath.exists("config.json"))
    {
      subfolders.append(subDir.fileName());
    }
  }

  return subfolders;
}

QStringList ProcessManager::availableEngines()
{
  QString enginesPath = ConfigManager::instance().getEnginesPath();

  return getSubfoldersWithConfigJson(enginesPath);
}

QString readConfigJson(const QString &_folderPath, const QString &_subfolder)
{
  QString configPath = _folderPath + QDir::separator() + _subfolder + QDir::separator() + "config.json";
  QFile file(configPath);

  if(!file.exists() || !file.open(QIODevice::ReadOnly | QIODevice::Text))
  {
    return QString(); // Return empty if file doesn't exist or can't be opened
  }

  QTextStream in(&file);
  QString content = in.readAll();
  file.close();

  return content;
}

QString ProcessManager::configFile(const QString _engine)
{
  QString enginesPath = ConfigManager::instance().getEnginesPath();
  return readConfigJson(enginesPath, _engine);
}

int getRandomInt(int min, int max)
{
  return QRandomGenerator::global()->bounded(min, max + 1);
}

void ProcessManager::loadEngine(const QString &_type, const QString & _config)
{
  // TODO

  int id = 0;
  while(true)
  {
    id = getRandomInt(1, 9999);
    if(!engines_.contains(id))
    {
      break;
    }
  }

  engines_[id] = new EngineProcess(_type, id, _config, this);
  engines_[id]->start();

  emit engineRunning(id);
}

void ProcessManager::unloadEngine(int _id)
{
  if(!engines_.contains(_id)) return;
  engines_[_id]->stop();
  engines_[_id]->deleteLater();
  engines_.remove(_id);

  emit engineStopped(_id);
}

QString ProcessManager::processName(int _id)
{
  if(!engines_.contains(_id))
  {
    return "";
  }

  return engines_[_id]->name();
}
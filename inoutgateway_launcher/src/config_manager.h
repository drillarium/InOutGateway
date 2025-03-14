#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QString>
#include <QJsonObject>

class ConfigManager {
public:
  static ConfigManager& instance(); // Singleton accessor

  bool loadConfig();

  QString getIface() const { return iface_; }
  int getPort() const { return port_; }
  QString getEnginesPath() const { return enginesPath_; }

private:
  ConfigManager(); // Private constructor
  ConfigManager(const ConfigManager&) = delete; // No copy
  ConfigManager& operator=(const ConfigManager&) = delete; // No assignment

  QString iface_ = "0.0.0.0";
  int port_ = 5533;
  QString enginesPath_ = "./engines";
};

#endif // CONFIGMANAGER_H

#pragma once

#include <QtWidgets/QMainWindow>
#include <QSystemTrayIcon>
#include "ui_launcher.h"

class Launcher : public QMainWindow
{
  Q_OBJECT

public:
  Launcher(QWidget *_parent = nullptr);
  ~Launcher();

protected:
  void closeEvent(QCloseEvent *_event) override;
  void saveWindowSettings();
  void loadWindowSettings();
  void checkAndMoveWindow();

private slots:
  void confirmExit();
  void restoreWindow();
  void onTrayIconActivated(QSystemTrayIcon::ActivationReason _reason);

protected:
  QSystemTrayIcon *trayIcon_ = nullptr;

private:
  Ui::LauncherClass ui;
};

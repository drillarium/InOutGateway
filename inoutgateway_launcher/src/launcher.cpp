#include <QCloseEvent>
#include <QMessageBox>
#include <QSettings>
#include "launcher.h"

Launcher::Launcher(QWidget *_parent)
:QMainWindow(_parent)
{
  ui.setupUi(this);

  // Restore window geometry and state
  loadWindowSettings();

  // ensure visible
  checkAndMoveWindow();

  // Create tray icon
  trayIcon_ = new QSystemTrayIcon(QIcon(":/Launcher.ico"), this);

  // Create tray menu
  QMenu *trayMenu = new QMenu();
  QAction *restoreAction = new QAction("Show Window", this);
  QAction *quitAction = new QAction("Quit Application", this);
  trayMenu->addAction(restoreAction);
  trayMenu->addAction(quitAction);

  // Connect quit action to exit function
  connect(restoreAction, &QAction::triggered, this, &Launcher::restoreWindow);
  connect(quitAction, &QAction::triggered, this, &Launcher::confirmExit);
  connect(trayIcon_, &QSystemTrayIcon::activated, this, &Launcher::onTrayIconActivated);

  // Assign menu to tray icon
  trayIcon_->setContextMenu(trayMenu);
  trayIcon_->show();
}

Launcher::~Launcher()
{

}

void Launcher::closeEvent(QCloseEvent *_event)
{
  _event->ignore(); // Prevent closing
  hide();           // Hide the window instead
  trayIcon_->showMessage("Running in background", "Application is minimized to tray.");
}

void Launcher::confirmExit()
{
  QMessageBox::StandardButton reply = QMessageBox::question(nullptr, "Exit Confirmation", "Are you sure you want to quit?", QMessageBox::Yes | QMessageBox::No);
  if(reply == QMessageBox::Yes)
  {
    saveWindowSettings(); // Save position and state before exiting
    QApplication::quit();
  }
}

void Launcher::saveWindowSettings()
{
  QSettings settings("MyCompany", "MyApp");
  settings.setValue("geometry", saveGeometry());
  settings.setValue("windowState", saveState());
}

void Launcher::loadWindowSettings()
{
  QSettings settings("MyCompany", "MyApp");
  restoreGeometry(settings.value("geometry").toByteArray());
  restoreState(settings.value("windowState").toByteArray());
}

void Launcher::restoreWindow()
{
  if(!isVisible())
  {
    checkAndMoveWindow(); // Ensure the window is visible
    showNormal();         // Restore from minimized/maximized state
    activateWindow();
    raise();
  }
}

void Launcher::onTrayIconActivated(QSystemTrayIcon::ActivationReason _reason)
{
  if(_reason == QSystemTrayIcon::DoubleClick)
  {
    restoreWindow();
  }
}

void Launcher::checkAndMoveWindow()
{
  QRect windowRect = geometry();
  bool visible = false;

  // Check if the window is visible on any screen
  for(QScreen* screen : QApplication::screens())
  {
    if(screen->geometry().intersects(windowRect))
    {
      visible = true;
      break;
    }
  }

  // If the window is off-screen, move it to the center of the primary screen
  if(!visible)
  {
    QScreen* primaryScreen = QApplication::primaryScreen();
    QRect screenGeometry = primaryScreen->geometry();
    int newX = screenGeometry.x() + (screenGeometry.width() - width()) / 2;
    int newY = screenGeometry.y() + (screenGeometry.height() - height()) / 2;
    move(newX, newY);
  }
}
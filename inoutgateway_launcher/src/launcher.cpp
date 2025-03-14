#include <QCloseEvent>
#include <QMessageBox>
#include <QSettings>
#include <QMenu>
#include <QTimer>
#include <QProcess>
#include <QStorageInfo>
#include <QStandardItemModel>
#include "launcher.h"
#include "jsoneditor.h"
#include "config_manager.h"
#include "processmanager.h"
#include "process.h"

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

  // Timer to update CPU usage
  /* QTimer* CPUTimer = new QTimer(this);
  connect(CPUTimer, &QTimer::timeout, this, &Launcher::updateCPUUsage);
  CPUTimer->start(500);

  QTimer *memTimer = new QTimer(this);
  connect(memTimer, &QTimer::timeout, this, &Launcher::updateMemUsage);
  memTimer->start(500);

  QTimer *GPUTimer = new QTimer(this);
  connect(GPUTimer, &QTimer::timeout, this, &Launcher::updateGPUUsage);
  GPUTimer->start(500); */

  QTimer *diskTimer = new QTimer(this);
  connect(diskTimer, &QTimer::timeout, this, &Launcher::updateDiskUsage);
  diskTimer->start(500);

  refreshEngines();

  ProcessManager &pm = ProcessManager::instance();
  connect(&pm, &ProcessManager::engineRunning, this, &Launcher::engineRunning);
  connect(&pm, &ProcessManager::engineStopped, this, &Launcher::engineStopped);

  // Create the model with 2 columns
  QStandardItemModel *model = new QStandardItemModel();
  model->setColumnCount(2);
  model->setHeaderData(0, Qt::Horizontal, "Process ID");
  model->setHeaderData(1, Qt::Horizontal, "Process Name");
  ui.processesTableView->setModel(model);

  // Connect selection change signal to update button state
  connect(ui.processesTableView->selectionModel(), &QItemSelectionModel::selectionChanged, this, &Launcher::updateEndTaskButtonStatus);
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

double getCPUUsage()
{
#if defined(Q_OS_WIN)
  QProcess process;
  process.start("cmd.exe", QStringList() << "/c" << "wmic cpu get loadpercentage");
  process.waitForFinished();
  QString output = process.readAllStandardOutput();
  QStringList lines = output.split("\n", Qt::SkipEmptyParts);

  if(lines.size() > 1)
  {
    bool ok;
    double cpuUsage = lines[1].trimmed().toDouble(&ok);
    return ok ? cpuUsage : -1.0;
  }

#elif defined(Q_OS_LINUX) || defined(Q_OS_MAC)
  QProcess process;
  process.start("top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'");
  process.waitForFinished();
  QString output = process.readAllStandardOutput();
  return output.trimmed().toDouble();
#endif

  return -1.0;
}

void Launcher::updateCPUUsage()
{
  double cpuUsage = getCPUUsage();
  if(cpuUsage >= 0)
  {
    ui.cpuProgressBar->setValue(static_cast<int>(cpuUsage));
  }
}

double getMemoryUsage()
{
  QProcess process;
  process.start("cmd.exe", QStringList() << "/c" << "wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /VALUE");
  process.waitForFinished();

  QString output = process.readAllStandardOutput().trimmed();
  qDebug() << "Raw Output:" << output;  // Debugging

  QStringList lines = output.split("\n", Qt::SkipEmptyParts);
  double totalMem = 0, freeMem = 0;

  for(const QString& line : lines)
  {
    QStringList parts = line.split("=", Qt::SkipEmptyParts);
    if(parts.size() == 2)
    {
      if(parts[0].trimmed() == "TotalVisibleMemorySize")
      {
        totalMem = parts[1].trimmed().toDouble();
      }
      else if(parts[0].trimmed() == "FreePhysicalMemory")
      {
        freeMem = parts[1].trimmed().toDouble();
      }
    }
  }

  if(totalMem > 0)
  {
    double usedMemPercent = ((totalMem - freeMem) / totalMem) * 100;
    return usedMemPercent;
  }

  return -1.0; // Error case
}

void Launcher::updateMemUsage()
{
  double memUsage = getMemoryUsage();
  if(memUsage >= 0)
  {
    ui.memProgressBar->setValue(static_cast<int>(memUsage));
  }
}

double getGPUUsage()
{
  QProcess process;
  process.start("cmd.exe", QStringList() << "/c" << "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits");
  process.waitForFinished();

  QString output = process.readAllStandardOutput().trimmed();
  qDebug() << "GPU Output:" << output; // Debugging

  bool ok;
  double gpuUsage = output.toDouble(&ok);
  return ok ? gpuUsage : -1.0;
}

void Launcher::updateGPUUsage()
{
  double gpuUsage = getGPUUsage();
  if(gpuUsage >= 0)
  {
    ui.gpuProgressBar->setValue(static_cast<int>(gpuUsage));
  }
}

QMap<QString, double> getDiskUsages()
{
  QMap<QString, double> diskUsages;

  foreach(const QStorageInfo & storage, QStorageInfo::mountedVolumes())
  {
    if(storage.isValid() && storage.isReady())
    {
      QString name = storage.displayName();
      qint64 bytesTotal = storage.bytesTotal();
      qint64 bytesAvailable = storage.bytesAvailable();
      diskUsages[name] = (bytesAvailable * 100.) / bytesTotal;     
    }
  }
  return diskUsages;
}

void Launcher::updateDiskUsage()
{
  QString text;
  QMap<QString, double> diskUsages = getDiskUsages();
  for(auto it = diskUsages.begin(); it != diskUsages.end(); ++it)
  {
    text += QString("%1 - %2% available ").arg(it.key()).arg(QString::number(it.value(), 'f', 2));
  }
  ui.diskUsageLabel->setText(text);
}

void Launcher::executeTask()
{
  QString engine = ui.taskComboBox->currentText();
  QString config= ProcessManager::instance().configFile(engine);

  JSONEditor dialog;
  dialog.setJson(config);
  if(dialog.exec() == QDialog::Accepted)
  {
    QString json = dialog.getJson();
    ProcessManager::instance().loadEngine(engine, json);
  }
}

void Launcher::endTask()
{
  QModelIndexList selectedRows = ui.processesTableView->selectionModel()->selectedRows();
  if(selectedRows.isEmpty()) return;

  int row = selectedRows.first().row();

  // Confirmation dialog
  QMessageBox::StandardButton reply = QMessageBox::question(ui.processesTableView, "Confirm Deletion", "Are you sure you want to remove this process?", QMessageBox::Yes | QMessageBox::No);
  if(reply != QMessageBox::Yes) return;

  QStandardItemModel* model = static_cast<QStandardItemModel*>(ui.processesTableView->model());
  int id = model->data(model->index(row, 0)).toInt();

  ProcessManager::instance().unloadEngine(id);
}

void Launcher::refreshEngines()
{
  ui.taskComboBox->clear();
  QStringList engines = ProcessManager::instance().availableEngines();
  ui.taskComboBox->addItems(engines);
}

void Launcher::engineRunning(int _id)
{
  QString processName = ProcessManager::instance().processName(_id);

  // new item in processes list
  QStandardItemModel *model = static_cast<QStandardItemModel *>(ui.processesTableView->model());
  QList<QStandardItem*> rowItems;
  rowItems.append(new QStandardItem(QString::number(_id)));
  rowItems.append(new QStandardItem(processName));
  model->appendRow(rowItems);

  // new tab to monitor
  ProcessWidget *pw = new ProcessWidget(_id, this);
  ui.tabWidget->addTab(pw, processName);
}

void Launcher::engineStopped(int _id)
{
  // remove from processes list
  QStandardItemModel* model = static_cast<QStandardItemModel*>(ui.processesTableView->model());
  for(int row = 0; row < model->rowCount(); row++)
  {
    int id = model->data(model->index(row, 0)).toInt();
    if(id == _id)
    {
      model->removeRow(row);
      break;
    }
  }

  // remove tab
  for(int tab = 1; tab < ui.tabWidget->count(); tab++)
  {
    ProcessWidget *pw = static_cast<ProcessWidget *>(ui.tabWidget->widget(tab));
    if(pw->id() == _id)
    {
      ui.tabWidget->widget(tab)->deleteLater();
      ui.tabWidget->removeTab(tab);
      break;
    }
  }

  updateEndTaskButtonStatus();
}

void Launcher::updateEndTaskButtonStatus()
{
  ui.endTaskButton->setEnabled(!ui.processesTableView->selectionModel()->selectedRows().isEmpty());
}

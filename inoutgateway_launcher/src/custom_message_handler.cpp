#include "custom_message_handler.h"
#include <QFile>
#include <QDateTime>
#include <QDir>

void customMessageHandler(QtMsgType type, const QMessageLogContext& context, const QString& message)
{
  // Define the log directory and file path
  QString logDir = "./logs";
  QString logFilePath = logDir + "/application.log";

  // Ensure the log directory exists
  QDir dir;
  if(!dir.exists(logDir))
  {
    dir.mkpath(logDir); // Create the logs directory if it doesn't exist
  }

  // Create or open the log file
  QFile logFile(logFilePath);
  if(!logFile.open(QIODevice::Append | QIODevice::Text))
  {
    return; // Unable to open file, exit the handler
  }

  QTextStream out(&logFile);

  // Get current date and time
  QString currentDateTime = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");

  // Determine the log level
  QString logLevel;
  switch(type)
  {
    case QtDebugMsg:
      logLevel = "DEBUG";
    break;
    case QtInfoMsg:
      logLevel = "INFO";
    break;
    case QtWarningMsg:
      logLevel = "WARNING";
    break;
    case QtCriticalMsg:
      logLevel = "CRITICAL";
    break;
    case QtFatalMsg:
      logLevel = "FATAL";
    break;
  }

  // Write the message to the file
  out << currentDateTime << " [" << logLevel << "] " << context.category << ": " << message << "\n";

  logFile.close();

  // For fatal errors, we might also want to abort the application
  if(type == QtFatalMsg)
  {
    abort();
  }
}

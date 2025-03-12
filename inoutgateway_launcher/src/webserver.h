#pragma once

#include <QTcpServer>
#include <QTcpSocket>

class WebServer  : public QTcpServer
{
  Q_OBJECT

public:
  static WebServer& instance();  // Singleton accessor
  bool startServer(const QString &_iface, int _port);

protected:
  void incomingConnection(qintptr _socketDescriptor) override;

private:
  explicit WebServer(QObject* parent = nullptr);
  WebServer(const WebServer&) = delete;
  WebServer& operator=(const WebServer&) = delete;

  void handleRequest(QTcpSocket *_socket, const QByteArray &_requestData);
  void sendResponse(QTcpSocket *_socket, int statusCode, const QByteArray &_body);
};

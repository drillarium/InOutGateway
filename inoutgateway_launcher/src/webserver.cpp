#include "webserver.h"
#include <QHostAddress>
#include <QDebug>
#include <QRegularExpression>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>

WebServer::WebServer(QObject *_parent)
:QTcpServer(_parent)
{

}

WebServer& WebServer::instance()
{
  static WebServer instance;
  return instance;
}

bool WebServer::startServer(const QString &_iface, int _port)
{
  if(!listen(QHostAddress(_iface), _port))
  {
    qWarning() << "Failed to start server on" << _iface << ":" << _port;
    return false;
  }
  qDebug() << "Server started on" << _iface << ":" << _port;
  return true;
}

void WebServer::incomingConnection(qintptr socketDescriptor)
{
  QTcpSocket* socket = new QTcpSocket(this);
  socket->setSocketDescriptor(socketDescriptor);

  connect(socket, &QTcpSocket::readyRead, [this, socket]() {
    QByteArray requestData = socket->readAll();
    handleRequest(socket, requestData);
    });

  connect(socket, &QTcpSocket::disconnected, socket, &QTcpSocket::deleteLater);
}

void WebServer::handleRequest(QTcpSocket *_socket, const QByteArray &_requestData)
{
  QString requestString = QString::fromUtf8(_requestData);
  qDebug() << "Received request:" << requestString;

  // Extract request line (first line)
  QStringList lines = requestString.split("\r\n");
  if(lines.isEmpty())
  {
    sendResponse(_socket, 400, "{\"error\": \"Invalid request\"}");
    return;
  }

  // Parse method and path
  QStringList requestLine = lines[0].split(" ");
  if(requestLine.size() < 2)
  {
    sendResponse(_socket, 400, "{\"error\": \"Invalid request\"}");
    return;
  }

  QString method = requestLine[0];
  QString path = requestLine[1];

  // Handle `/api/hosts`
  if(method == "GET" && path == "/api/hosts")
  {
    // Retrieve host list (Mock data for now)
    QJsonArray hostsArray;
    QJsonObject host1;
    host1["id"] = 1;
    host1["name"] = "Host 1";
    host1["address"] = "192.168.1.10";
    hostsArray.append(host1);

    QJsonObject response;
    response["hosts"] = hostsArray;

    sendResponse(_socket, 200, QJsonDocument(response).toJson());
    return;
  }

  // Handle `/api/hosts/:id`
  QRegularExpression regex("^/api/hosts/(\\d+)$");
  QRegularExpressionMatch match = regex.match(path);
  if(method == "GET" && match.hasMatch()) {
    int hostId = match.captured(1).toInt();

    QJsonObject host;
    host["id"] = hostId;
    host["name"] = QString("Host %1").arg(hostId);
    host["address"] = "192.168.1.20";

    sendResponse(_socket, 200, QJsonDocument(host).toJson());
    return;
  }

  // Unknown route
  sendResponse(_socket, 404, "{\"error\": \"Not found\"}");
}

void WebServer::sendResponse(QTcpSocket *_socket, int _statusCode, const QByteArray &_body)
{
  QByteArray response = QString("HTTP/1.1 %1 OK\r\n"
    "Content-Type: application/json\r\n"
    "Content-Length: %2\r\n"
    "Connection: close\r\n\r\n")
    .arg(_statusCode)
    .arg(_body.size())
    .toUtf8();

  response.append(_body);
  _socket->write(response);
  _socket->flush();
  _socket->waitForBytesWritten();
  _socket->close();
}
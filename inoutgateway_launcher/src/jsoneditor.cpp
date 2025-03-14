#include "jsoneditor.h"
#include <QJsonDocument>
#include <QMessageBox>

JSONEditor::JSONEditor(QWidget *_parent)
:QDialog(_parent)
{
  ui.setupUi(this);
}

JSONEditor::~JSONEditor()
{

}

void JSONEditor::validateJson()
{
  QJsonParseError error;
  QJsonDocument::fromJson(ui.jsonTextEdit->toPlainText().toUtf8(), &error);
  if(error.error == QJsonParseError::NoError)
  {
    accept();
  }
  else
  {
    QMessageBox::critical(this, "Invalid JSON", "Error: " + error.errorString());
  }
}

void JSONEditor::setJson(const QString &_json)
{
  ui.jsonTextEdit->setText(_json);
}

QString JSONEditor::getJson() const
{
  return ui.jsonTextEdit->toPlainText();
}
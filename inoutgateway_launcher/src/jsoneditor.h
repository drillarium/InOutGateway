#pragma once

#include <QDialog>
#include "ui_jsoneditor.h"

class JSONEditor : public QDialog
{
  Q_OBJECT

public:
  JSONEditor(QWidget *_parent = nullptr);
  ~JSONEditor();
  
  void setJson(const QString& _json);
  QString getJson() const;

private slots:
  void validateJson();

private:
  Ui::JSONEditorClass ui;
};

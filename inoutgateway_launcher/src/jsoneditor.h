#pragma once

#include <QWidget>
#include "ui_jsoneditor.h"

class JSONEditor : public QWidget
{
  Q_OBJECT

public:
  JSONEditor(QWidget *_parent = nullptr);
  ~JSONEditor();

private:
  Ui::JSONEditorClass ui;
};

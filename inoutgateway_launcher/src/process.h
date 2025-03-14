#pragma once

#include <QWidget>
#include "ui_process.h"

class ProcessWidget : public QWidget
{
  Q_OBJECT

public:
  ProcessWidget(int _id, QWidget *_parent = nullptr);
  ~ProcessWidget();

  int id() { return id_; }

protected:
  int id_ = -1;

private:
  Ui::processClass ui;
};

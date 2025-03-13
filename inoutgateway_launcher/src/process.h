#pragma once

#include <QWidget>
#include "ui_process.h"

class ProcessWidget : public QWidget
{
  Q_OBJECT

public:
  ProcessWidget(QWidget *_parent = nullptr);
  ~ProcessWidget();

private:
  Ui::processClass ui;
};

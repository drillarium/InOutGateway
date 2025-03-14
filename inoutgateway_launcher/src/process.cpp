#include "process.h"

ProcessWidget::ProcessWidget(int _id, QWidget *_parent)
:QWidget(_parent)
,id_(_id)
{
  ui.setupUi(this);
}

ProcessWidget::~ProcessWidget()
{

}

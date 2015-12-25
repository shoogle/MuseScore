#include "musescore.h"
#include "lyricseditor.h"

namespace Ms {

//---------------------------------------------------------
//   showLyricsEditor
//---------------------------------------------------------

void MuseScore::showLyricsEditor(bool visible)
      {
      QAction* a = getAction("toggle-lyricseditor");
      if (!_lyricsEditor) {
            _lyricsEditor = new LyricsEditor();
            connect(_lyricsEditor, SIGNAL(visibilityChanged(bool)), a, SLOT(setChecked(bool)));
            addDockWidget(Qt::RightDockWidgetArea, _lyricsEditor);
            updateLyricsEditor();
            }
//      if (visible) {
//            updateLyricsEditor();
//            }
      if (_lyricsEditor)
            updateLyricsEditor();
            _lyricsEditor->setVisible(visible);
      }

//---------------------------------------------------------
//   LyricsEditor
//---------------------------------------------------------

//LyricsEditor::LyricsEditor(QWidget *parent) : QWidget(parent)
//    {

//    }

//---------------------------------------------------------
//   LyricsEditor
//---------------------------------------------------------

LyricsEditor::LyricsEditor(QWidget* parent)
   : QDockWidget(tr("Lyrics Editor"), parent)
      {
      setObjectName("LyricsEditor");
      setAllowedAreas(Qt::DockWidgetAreas(Qt::LeftDockWidgetArea | Qt::RightDockWidgetArea));
      sa = new QScrollArea;
      sa->setAccessibleName(tr("Lyrics Editor Subwindow"));
      sa->setFrameShape(QFrame::NoFrame);
      sa->setWidgetResizable(true);
      setWidget(sa);
      sa->setFocusPolicy(Qt::NoFocus);

      le.setupUi(sa);
      le.textEdit->setText("Hello world!");

//      _LyricsEditorEdit = false;
//      ie             = 0;
//      _element       = 0;
      }

//---------------------------------------------------------
//   sizeHint
//---------------------------------------------------------

QSize LyricsEditorEmpty::sizeHint() const
      {
      return QSize(255 * guiScaling, 170 * guiScaling);
      }

//---------------------------------------------------------
//   reset
//---------------------------------------------------------

void LyricsEditor::reset()
      {
//      if (ie)
//            ie->setElement();
      }

//---------------------------------------------------------
//   setElement
//---------------------------------------------------------

void LyricsEditor::setLyrics(QString s)
      {
      le.textEdit->setText(s);
      }

//---------------------------------------------------------
//   LyricsEditorEmpty
//---------------------------------------------------------
//LyricsEditorEmpty::LyricsEditorEmpty(QWidget* parent)
//      :LyricsEditorBase(parent)
//      {
//      e.setupUi(addWidget());
//      }

////---------------------------------------------------------
////   Navigator
////---------------------------------------------------------

//Navigator::Navigator(NScrollArea* sa, QWidget* parent)
//  : QWidget(parent)
//      {
//      setAttribute(Qt::WA_NoBackground);
//      _score         = 0;
//      scrollArea     = sa;
//      scrollArea->setWidgetResizable(true);
//      _cv            = 0;
//      viewRect       = new ViewRect(this);
//      setSizePolicy(QSizePolicy::Ignored, QSizePolicy::Ignored);
//      sa->setWidget(this);
//      sa->setWidgetResizable(false);
//      }

}


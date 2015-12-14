#ifndef LYRICSEDITOR_H
#define LYRICSEDITOR_H

#include "ui_lyricseditor.h"

namespace Ms {

//---------------------------------------------------------
//   LyricsEditor
//---------------------------------------------------------

class LyricsEditor : public QDockWidget {
      Q_OBJECT

      QScrollArea* sa;
      //LyricsEditorBase* ie;
      QList<Element*> _el;
      Element* _element;      // currently displayed element
      bool _lyricsEditorEdit; // set to true when an edit originates from
                              // within the lyrics editor itself

   public slots:
      void reset();

   public:
      LyricsEditor(QWidget* parent = 0);
      void setElement(Element*);
      void setElements(const QList<Element*>&);
      Element* element() const            { return _element;       }
      const QList<Element*>& el() const   { return _el;            }
      void setLyricsEditorEdit(bool val)     { _lyricsEditorEdit = val;  }
      };

////---------------------------------------------------------
////   LyricsEditor
////---------------------------------------------------------

//class LyricsEditorEmpty : public QWidget {
//      Q_OBJECT

//      Ui::LyricsEditor e;

//   public:
//      LyricsEditorEmpty(QWidget* parent);
//      virtual QSize sizeHint() const override;
//      };

} // namespace Ms
#endif // LYRICSEDITOR_H

# -*- coding: utf-8 -*-

module Plugin::Portal
  class TiltPhoto < Diva::Model
    include Diva::Model::PhotoMixin

    field.has :head, Diva::Model
    field.has :tail, Diva::Model

    # tiltしたpixbufを作成するDeferredを返す
    def download_pixbuf(width:, height:)
      canvas = Gdk::Rectangle.new(0, 0, width, height)
      head_rect = Gdk::Rectangle.new(0, 0, canvas.width * 0.9, canvas.height * 0.9)
      tail_rect = Gdk::Rectangle.new(0, 0, canvas.width * 0.65, canvas.height * 0.65)
      head_rect.x = canvas.width - head_rect.width
      head_rect.y = canvas.height - head_rect.height

      Delayer::Deferred.when(
        head.download_pixbuf(width: head_rect.width, height: head_rect.height),
        tail.download_pixbuf(width: tail_rect.width, height: tail_rect.height)
      ).next{|head_pixbuf, tail_pixbuf|
        pm = Gdk::Pixmap.new(nil, width, height, Gdk::Visual.system.depth)
        context = pm.create_cairo_context
        # 背景色
        context.save do
          context.set_source_rgb(1.0, 1.0, 1.0)
          context.rectangle(0,0,width,height)
          context.fill
        end
        # 2つ目以降のアカウントのアイコン
        context.save do
          context.translate(tail_rect.x, tail_rect.y)
          context.set_source_pixbuf(tail_pixbuf)
          context.paint
        end
        # 1つめのアカウントのアイコン
        # 正方形の左上が少し欠けた五角形で切り取る
        context.save do
          context.translate(head_rect.x, head_rect.y)
          context.append_path(
            Cairo::Path.new.tap{|path|
              path.line_to(head_rect.x + head_rect.width * 0.25,
                           head_rect.y)
              path.line_to(head_rect.width,
                           head_rect.y)
              path.line_to(head_rect.width,
                           head_rect.height)
              path.line_to(head_rect.x,
                           head_rect.height)
              path.line_to(head_rect.x,
                           head_rect.y + head_rect.height * 0.25)
            })
          context.set_source_pixbuf(head_pixbuf)
          context.fill
        end
        GdkPixbuf::Pixbuf.from_drawable(nil, pm, 0, 0, width, height)
      }
    end

    def download(*rest, &proc)
      head.download(*rest, &proc)
    end

    def completed?(*rest, &proc)
      head.completed?(*rest, &proc)
    end

    def downloading?(*rest, &proc)
      head.downloading?(*rest, &proc)
    end

    def ready?(*rest, &proc)
      head.ready?(*rest, &proc)
    end

    def local?
      false
    end
  end
end

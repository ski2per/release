#!/usr/bin/env python

import tornado.httpserver
import tornado.ioloop
import tornado.options

from tornado.options import define, options
from engine.Handler import *

define("port", default=8000, help="run on the given port", type=int)


class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", IndexHandler),
            (r"/log", LogIndexHandler),  # for ajax
            (r"/log_list", LogListHandler),
            (r"/delete/(.*)/(.*)", DeleteHandler),  # for ajax
            (r"/upload", UploadHandler),
            (r"/extract/(.*)/(.*)", ExtractHandler),  # for ajax
            (r"/analysis", AnalysisHandler),
            (r"/cache_list/(.*)", CacheListHandler),  # for ajax
            (r"/render/(.*)/(.*)", RenderHandler),
            (r"/chart/(.*)/(.*)", ChartAjaxHandler),
        ]

        settings = dict(
                template_path=os.path.join(os.path.dirname(__file__), "templates"),
                static_path=os.path.join(os.path.dirname(__file__), "static"),
                data_path=os.path.join(os.path.dirname(__file__), "data"),
                xsrf_cookies=True,
                cookie_secret="__TODO:_GENERATE_YOUR_OWN_RANDOM_VALUE_HERE__",
                debug=True,
        )

        super(Application, self).__init__(handlers, **settings)


def main():
    http_server = tornado.httpserver.HTTPServer(Application())
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.current().start()


if __name__ == "__main__":
    main()

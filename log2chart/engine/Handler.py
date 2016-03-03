import os
import tornado.web

from .Util import *
from .Core import *


class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.render("index.html", people="skipper")


class LogIndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.render("log/log_index.html")


class LogListHandler(tornado.web.RequestHandler):
    def get(self):
        files = os.listdir(self.settings['data_path'] + "/log")
        self.render('log/log_list.html', rawList=sorted(files))


class DeleteHandler(tornado.web.RequestHandler):
    def get(self, dtype, filename):
        dataPath = self.settings['data_path']
        if dtype == 'log':
            os.remove(dataPath + '/log/' + filename)
        else:
            #os.remove(dataPath + '/cache/' + dtype + '/' + filename)
            os.remove(dataPath + '/cache/' + filename)

        #self.redirect("/log")


class UploadHandler(tornado.web.RequestHandler):
    def post(self):
        uploadPath = os.path.join(self.settings['data_path'], "log")
        multiFile = self.request.files['fileUploader']
        for f in multiFile:
            filename = f['filename']
            filePath = os.path.join(uploadPath, filename)
            with open(filePath, 'wb') as upfile:
                upfile.write(f['body'])
        self.redirect("/log")


class ExtractHandler(tornado.web.RequestHandler):
    def get(self, etype, filename):
        data = {}
        cachePath = self.settings['data_path'] + "/cache/"
        rawFile = self.settings['data_path'] + "/log/" + filename
        if etype == 'nginx':
            data = log2cache(rawFile)
            filename = filename + "_nginx"
        elif etype == 'apache':
            data = log2cache(rawFile)
            filename = filename + "_apache"

        json2file(cachePath, data, filename)
        self.write("Extract Completed")



class AnalysisHandler(tornado.web.RequestHandler):
    def get(self):
        #self.render('analysis/analysis_index.html', headLine="Access Log")
        self.render('analysis/analysis_index.html')


class CacheListHandler(tornado.web.RequestHandler):
    def get(self, ctype):
        #cachePath = self.settings['data_path'] + "/cache/" + ctype
        cachePath = self.settings['data_path'] + "/cache/"
        caches = os.listdir(cachePath)
        #self.render('analysis/cache_list.html', cacheList=sorted(caches), cacheType=ctype)
        self.render('analysis/cache_list.html', cacheList=sorted(caches), cacheType=ctype)

class RenderHandler(tornado.web.RequestHandler):
    # "aType" and "filename" will be used in JS(window.location.href)
    def get(self, aType, filename):
        #url = ""
        #if aType in ['per_hour', 'req_method', 'status_code', 'top_ip']:
        #    url = "/analysis"
        #self.render('analysis/render.html', backLink=url)
        self.render('analysis/render.html')


class ChartAjaxHandler(tornado.web.RequestHandler):
    def get(self, aType, filename):

        data = get_log_analysis(self.settings['data_path'], aType, filename)

        self.render('analysis/atype/' + aType + '.html', data=data, filename=filename)
        # data - contains data which highchart needs to build chart
        # filename - filename displays on top of chart in red

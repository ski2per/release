package main

import (
    "net/http"
    "os"
    "log"
)

const DefaultPort = "10086"
const DefaultDir = "."

func getServerPort() (string) {
    port := os.Getenv("SERVER_PORT")
    if port != "" {
        return port;
    }

    return DefaultPort;
}

func getTargetDir() (string) {
    dir := os.Getenv("TARGET_DIR")
    if dir != "" {
        return dir
    }
    return DefaultDir
}

// EchoHandler echos back the request as a response
func EchoHandler(writer http.ResponseWriter, request *http.Request) {

    //log.Println("Echoing back request to client " + request.URL.Path + " to client (" + request.RemoteAddr + ")")
    log.Printf("Echoing back request to client(%s): %s\n", request.RemoteAddr, request.URL.Path)

    writer.Header().Set("Access-Control-Allow-Origin", "*")
    writer.Header().Set("Access-Control-Allow-Headers", "Content-Range, Content-Disposition, Content-Type, ETag")
    request.Write(writer)
}

func main() {

    log.Println("Starting server, listening on port " + getServerPort())

    http.Handle("/", http.FileServer(http.Dir(getTargetDir())))
    http.ListenAndServe(":" + getServerPort(), nil)
}

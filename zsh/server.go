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
	http.Handle("/", http.FileServer(http.Dir(config.directory)))
	http.HandleFunc("/upload", makeUploadHandler(config.directory))

	addr := fmt.Sprintf(":%d", config.port)
	log.Printf("Serving %s on HTTP port: %d\n", config.directory, config.port)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

func makeUploadHandler(dir string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
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
